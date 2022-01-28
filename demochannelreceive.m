%% HARDCODED ARGUMENTS
rawSampleRate     = 192000;
decimationFactor  = 48;
channelSelected   = 1;

%supportedSampleRates      = [192, 256, 384, 456 768, or 912]*1000;
%supportedDecimateFactors  = [2, 4, 10, 12, 16, 24, 32, 48, 64, 80, 96, 100, 120, 128, 192, 256];

%% INITIALIZE VARIABLES
samplesPerChannelFrame = 1024;
channelSampleRate = rawSampleRate/decimationFactor;

if mod(decimationFactor,2)==0
  centerFreqs = [-Fs/2 : Fs/decimationFactor : Fs/decimationFactor*floor(nc/2)]
else 
  centerFreqs = [-Fs/decimationFactor*floor(decimationFactor/2) :...
                  Fs/decimationFactor :...
                  Fs/decimationFactor*floor(decimationFactor/2)];
end

channelFrequency = centerFreqs(channelSelected);

%% SETUP UDP RECEIVER OBJECT
udpReceivePort = 20000+channelSelected-1;
obj.udpReceive = dsp.UDPReceiver('RemoteIPAddress','0.0.0.0',...
                                 'LocalIPPort',udpReceivePort,...
                                 'ReceiveBufferSize',2^18,...
                                 'MaximumMessageLength',1025,...
                                 'MessageDataType','single',...
                                 'IsMessageComplex',true); 
setup(obj.udpReceive);

%%SETUP SPECTRUM ANALYZER
scope           = dsp.SpectrumAnalyzer('SampleRate',channelSampleRate,...
                                       'PlotAsTwoSidedSpectrum',true,...
                                       'ViewType','Spectrogram');
scope.ViewType      = 'Spectrogram';
scope.FFTLength     = samplesPerChannelFrame;
scope.WindowLength  = samplesPerChannelFrame;
scope.FrequencyResolutionMethod = 'WindowLength';
scope.CenterFrequency = channelFrequency;
scope.FrequencySpan   = 'Span and center frequency';
scope.TimeSpanSource  = 'Property';
scope.TimeSpan        = 10;


%% RECEIVE THE DATA
scope([]); %Open the scope
while 1
  x = obj.udpReceive();

  if ~isempty(x1)
    theTimePosix  = singlecomplex2double(x(1));
    currTime      = datetime(theTimePosix,'ConvertFrom','posixtime','Format','hh:m:ss.SSSSSS');
    x(1)          = []; %Remove timestamp
    scope(x)
  end
  
end             
                
release(scope)  