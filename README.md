# airspyhf_channelize
This code allows incoming SDR data to be channelized and provided to other processes via UDP. 

The inital goal of this development was to enable complex IQ data streaming from an AirspyHF+ SDR to be brought into Matlab for processing. The resulting code should work though for any process that needs to receive channelized data streams. This software sits between the incoming high sample rate data and processes running on a machine that might want access to one or more channels at a lower sample rate. This code was developed in Matlab and converted to C using Matlab Code. Some of the Matlab functions developed here has some interesting methods necessitated by the restrictions on system object in Matlab when using Matlab Code. 

The development of this code was funded via [National Science Foundation grant no. 2104570](https://nsf.gov/awardsearch/showAward?AWD_ID=2104570&HistoricalAwards=false).

## Basic Operation
### Starting the program
When compiled to an executable two arguments are needed: raw sample rate (from the SDR) and the desired decimation factor. The raw sample rate must be a supported sample rate from the AirspyHF+: 192, 256, 384, 456 768, or 912 KSPS. Supported decimation factors are 2, 4, 10, 12, 16, 24, 32, 48, 64, 80, 96, 100, 120, 128, 192, and 256. These were selected, as they are a subset of the unique divisors of the supported sample rates. An example call in terminal to start this program would be 

`airspyhfchannelizermain 192000 48`

### Starting the incoming SDR data
This would setup the program for incoming data and 192 KSPS that will be decimated by 48 to a sample rate of 4 KSPS. The output data will be served on local ports starting at 20000 and ending at one less than the number of channels (decimation factor). The data coming into the channelizer should be server on local port 10000. For example after starting the channelizer program, the folling terminal command would be issued. 

`/usr/local/bin/airspyhf_rx -f 91.7 -m on -a 192000 -r stdout -g on -l high -t 0 | netcat -u localhost 10000`

This requires the installation of [airspyhf](https://github.com/airspy/airspyhf). Installation instructions for this can be found 
[here](https://uavrt.nau.edu). This pipes data from airspyhf_rx to netcat, which then sends the data via UDP to port 10000. The `airspychannelizermain` function requires single precision complex data with frame lengths of 128 complex samples.

### Controlling opreration
After running these two commands the program will start up but will initially be in an idle stat. There are three states of operation: 1) Idle/Pause 2) Running 3)Dead/Killed. The program accepts commands to transition between states from local port 10001. Transmitting a 1 will start the channelization and output. Transmitting a 0 will pause the operation and put the program into a idle state. Transmitting a -1 will terminate the program. In a separate terminal window, transmit the start, pause, or kill commands with command with 

Start: `echo -e -n '\x01'| netcat -u localhost 10001`

Pause: `echo -e -n '\x00'| netcat -u localhost 10001`

Kill:  `echo -e -n '\xFF'| netcat -u localhost 10001`

### Receiving channelized data

Because the channelized data is served via UDP port, the outputs are can be used by any program capable of UDP data. The example code below is written in Matlab and provided in the codebase. Note that this function is pulling data from the first channel of the decimated output. Also, this function has a maximum message size of 1025, which is the IQ message length (1024) plus the frame timestamp (1). In the while loop, the time stamp is extracted and converted with the custome Matlab function singlecomplex2double().

Note about channel frequencies: Because the number of channels (`nc`) and decimation factor are the same, the center frequencies of the channels range from `[-Fs/nc*floor(nc/2), Fs/nc*floor(nc/2)]` if nc is odd and `[-Fs/2, , Fs/nc*floor(nc/2)]` if nc is even. In both cases the frequency steps are `Fs/nc`.

```
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
```
