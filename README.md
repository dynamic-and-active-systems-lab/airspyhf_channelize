# airspyhf_channelize
This code allows incoming SDR data to be channelized and provided to other processes via UDP. 

The initial goal of this development was to enable complex IQ data streaming from an AirspyHF+ SDR to be brought into Matlab for processing. The resulting code should work though for any process that needs to receive channelized data streams. This software sits between the incoming high sample rate data and processes running on a machine that might want access to one or more channels at a lower sample rate. This code was developed in Matlab and converted to C using Matlab Coder. Some of the Matlab functions developed here has some interesting methods necessitated by the restrictions on system objects in Matlab when using Matlab Coder. 

The development of this code was funded via [National Science Foundation grant no. 2104570](https://nsf.gov/awardsearch/showAward?AWD_ID=2104570&HistoricalAwards=false).

## Basic Operation
### Starting the program
When compiled to an executable two arguments are needed: raw sample rate (from the SDR) and the desired decimation factor. The raw sample rate must be a supported sample rate from the AirspyHF+: 192, 256, 384, 456, 768, or 912 KSPS. Supported decimation factors are 2, 4, 10, 12, 16, 24, 32, 48, 64, 80, 96, 100, 120, 128, 192, and 256. These were selected, as they are a subset of the unique divisors of the supported sample rates. An example call in terminal to start this program would be 

`airspyhfchannelizermain 192000 48`

This would setup the program for incoming data and 192 KSPS that will be decimated by 48 to a sample rate of 4 KSPS. The output data will be served on local ports starting at 20000 and ending at one less than the number of channels (decimation factor). Once started, the program sits in an idle mode until it is commanded (see below) to begin processing data. It is critical that this program is started starting the stream of incoming data, otherwise 'Connection refused' messages will appear after the next step.

### Starting the incoming SDR data
The data coming into the channelizer progra  should be served on local port 10000. For example after starting the channelizer program, the folling terminal command would be issued. 

`/usr/local/bin/airspyhf_rx -f 91.7 -m on -a 192000 -r stdout -g on -l high -t 0 | netcat -u localhost 10000`

This requires the installation of [airspyhf](https://github.com/airspy/airspyhf). Installation instructions for this can be found [below](https://github.com/dynamic-and-active-systems-lab/airspyhf_channelize#installing-airspyhf_rx). This pipes data from airspyhf_rx to netcat, which then sends the data via UDP to port 10000. The `airspychannelizermain` function requires single precision complex data with frame lengths of 128 complex samples.

### Controlling opreration
After running these two commands the program will start up but will initially be in an idle stat. There are three states of operation: 1) Idle/Pause 2) Running 3) Dead/Killed. The program accepts commands to transition between states from local port 10001. Transmitting a 1 will start the channelization and output. Transmitting a 0 will pause the operation and put the program into a idle state. Transmitting a -1 will terminate the program. In a separate terminal window, transmit the start, pause, or kill commands with commands: 

Start: `echo -e -n '\x01'| netcat -u localhost 10001`

Pause: `echo -e -n '\x00'| netcat -u localhost 10001`

Kill:  `echo -e -n '\xFF'| netcat -u localhost 10001`

### Receiving channelized data

Because the channelized data is served via UDP ports, the outputs can be used by any program capable of UDP data. The example code below is written in Matlab and provided in the codebase. Note that this function is pulling data from the first channel of the decimated output. Also, this function has a maximum message size of 1025, which is the IQ message length (1024) plus the frame timestamp (1). In the while loop, the time stamp is extracted and converted with the custom Matlab function singlecomplex2double().

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

## Installing airspyhf_rx
[Airspyhf](https://airspy.com/airspy-hf-discovery/) is useful for manual control of the [AirspyHF+ Dual Port](https://airspy.com/airspy-hf-plus/) and [AirspyHF+ Discovery](https://airspy.com/airspy-hf-discovery/) software defined radios. To install this you'll to do a few things first:
1. [Ensure homebrew is installed](https://brew.sh/) and run brew doctor to see if any errors come up 
2. Ensure homebrew is updated by running the following command in a terminal window brew update 
3. Need wget: run the following command in a terminal window brew install wget 
4. Need cmake: run the following command in a terminal window brew install cmake 
5. Need libusb: run the following command in a terminal window brew install libusb

To install `airspyhf`, open a terminal directory where you want airspyhf-master directory downloaded to. You don't need to keep this directory after installing. Now, run the commands below for building and installing. 
```
wget https://github.com/airspy/airspyhf/archive/master.zip
unzip master.zip
cd airspyhf-master
mkdir build
cd build
export CMAKE_PREFIX_PATH=/usr/local/Cellar/libusb/1.0.24/include/libusb-1.0
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
```
That's it. It should be installed. 

All of the instructions here are the same as those found in the repo under "[How to build the host software on Linux](https://github.com/airspy/airspyhf#build-host-software-on-linux)" except for the export command. CMake doesn't know how to find libusb, so we run the export command to tell it where it is. It's a temp fix in that if you run CMake for this build process again, you'll have to do the same thing. But you would only need to run CMake once theoretically, since we are building/installing and then leaving it be. 
