%This script received channelizer IQ data from airspyhf_channelizer and
%displays a spectrogram of the data. It also demodulates the FM
%broadcast within the channel. Demodulated audio is played over the defaul
%audio device. 

%% HARDCODED ARGUMENTS
rawSampleRate     = 912000;
decimationFactor  = 4;
numChannels       = decimationFactor;
channelSelected   = 1;

%supportedSampleRates      = [192, 256, 384, 456 768, or 912]*1000;
%supportedDecimateFactors  = [2, 4, 10, 12, 16, 24, 32, 48, 64, 80, 96, 100, 120, 128, 192, 256];

%% INITIALIZE VARIABLES
samplesPerChannelFrame = 1024;
channelSampleRate = rawSampleRate/decimationFactor;

if mod(decimationFactor,2)==0
  centerFreqs = -rawSampleRate/2:...
                 rawSampleRate/decimationFactor:...
                 rawSampleRate/2-rawSampleRate/decimationFactor;
                 %Easier to read:-Fs/2:Fs/DF:Fs/2-Fs/DF

else 
  centerFreqs = -rawSampleRate/(decimationFactor)*floor(decimationFactor/2):...
                 rawSampleRate/(decimationFactor):...
                 rawSampleRate/2;        
                 %Easier to read: [-Fs/(DF)*floor(DF/2):Fs/(DF):Fs/2]
end

%Account for channel order mismatch between channelizer ouptut and
%centerFrequencies function
centerFreqs = circshift(centerFreqs, ceil(decimationFactor/2));

channelFrequency = centerFreqs(channelSelected)

%% SETUP UDP RECEIVER OBJECT
udpReceivePort = 20000+channelSelected-1;
obj.udpReceive = dsp.UDPReceiver('RemoteIPAddress','0.0.0.0',...
                                 'LocalIPPort',udpReceivePort,...
                                 'ReceiveBufferSize',2^18,...
                                 'MaximumMessageLength',1025,...
                                 'MessageDataType','single',...
                                 'IsMessageComplex',true); 
setup(obj.udpReceive);

%% SETUP SPECTRUM ANALYZER AND DEMODULATOR
scope           = dsp.SpectrumAnalyzer('SampleRate',channelSampleRate,...
                                       'PlotAsTwoSidedSpectrum',true,...
                                       'ViewType','Spectrogram');
scope.ViewType      = 'Spectrogram';


targetAudioSampleRate = 48000; 
%This line help set the audio rate so that the audio decimation rate is a
%factor of the samplesPerChannelFrame. 
actualAudioSampleRate = 1/samplesPerChannelFrame*rawSampleRate*2*(floor(samplesPerChannelFrame/(rawSampleRate*2/targetAudioSampleRate)));
fmbDemod = comm.FMBroadcastDemodulator( ...
    'AudioSampleRate',actualAudioSampleRate, ...
    'SampleRate',channelSampleRate,'PlaySound',true);%,'FrequencyDeviation',channelSampleRate/3);

%% RECEIVE THE DATA

disp('ran scope')
while 1
  x = obj.udpReceive();

  if ~isempty(x)
      disp('got data')
    theTimePosix  = singlecomplex2double(x(1));
    currTime      = datetime(theTimePosix,'ConvertFrom','posixtime','Format','hh:m:ss.SSSSSS');
    x(1)          = []; %Remove timestamp
    scope(x)
    demodData = fmbDemod(x);
  end
  
end             
                
release(scope)  