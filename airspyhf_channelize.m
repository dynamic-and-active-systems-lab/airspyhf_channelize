function []= airspyhf_channelize(rawSampleRate,decimationFactor) %#codegen
%AIRSPYFHCHANNELIZER executes the correct channelizer function depending
%on the specified decimation factor
%   This function is designed specifically to channelize incoming UDP data
%   from an AirspyHF+ or AirspyHF+ Discovery, but could work for any
%   complex single precision UDP data sent in 128 sample frames. It calls
%   the appropriate channelizer function depending on the decimation factor
%   requested by the caller. Separate decimation functions have to be
%   created because of limitation in the channelizer objects in Matlab for
%   code generation. Specifically, the number of channels must be a
%   constant at compile time. A series of individual channelizer functions
%   was therefore developed. This function simply calls the appropriate
%   function depending on the decimation factor.
%
%   Data sent over the UDP output channels are single valued complex
%   frames. Each output frame contains 1024 complex values, or 2048
%   individual single precision values. Each frame also contains a
%   timestamp encoded into a complex number in the first element of the
%   frame. The received data frame therefore contains 1025 complex values.
%   The timestamp on each frame is associate with the time of arrival of
%   the first sample in the frame. 
%
%   The timestamp is a double precision posixtime value. The first (MSB)
%   8 bits of this number is cast to a uint32 value and set as the real
%   part of the encoded time. The second (LSB) 8 bits of this double
%   presition posixtime value are also cast to a uint32 value and set as
%   the complex part of the encoded time. To encode and decode these times,
%   use the double2singlecomplex.m and the singlecomplex2double.m
%   functions, respectively. 
%
%   The incoming and outgoing data and function controls in the individual
%   channelizer functions are standardized:
%
%   PORT LISTING
%       10000       Receive port for airspy data
%                      Complex single precision data
%                      Maximum message size 1024 bytes
%       20000:20*** Send ports for serving channelized UDP data. The
%                   center frequency of the channel for port 20000 is the
%                   center frequency of the incoming data. Subsequent port
%                   correspond to the increasing channel numbers and
%                   frequency, eventually wrapping to negative frequencies
%                   above Fs/2. See notes about channel center frequencies
%                   below.The max port number is equal to 
%                   20000+numberofchannels-1

%
%
%INPUTS:
%	rawSampleRate   A single integer sample rate. Valid entries
%                       correspond to those available for the Airspy HF+
%                       radio: [912 768 456 384 256 192] kS/s
%	decimationFactor	A single integer that is one of the following:
%                       [2; 4; 10; 12; 16; 24; 32; 48; 64; 80; 96; 100; 
%                        120; 128; 192; 256]
%
%
%OUTPUTS:
%	none
%
%
%
%
%Notes: 
%       ABOUT CHANNEL CENTER FREQUENCIES:
%       Matlab provides the centerFrequencies function that accepts a
%       channelizer object and a sample rate, and then specifies the
%       center frequencies of the associated channel. This list however is
%       centered at zero and provides negative frequencies. For example a
%       channelizer with Fs = 48000 and a decimation factor of 3 would
%       report center frequencies [-24000 -12000 0 12000]. If the fvtool is
%       used on this channelizer (with the legend turned on) the center
%       frequencies would be [0 12000 -24000 -12000] for filteres 1-4. The
%       shifting here reflects a inconsistency in Matlab's channel
%       reporting. The channelizer outputs follow the latter order, and as
%       such, so to do the UDP port outputs in this function. 
%       Because the  number of chanels and the decimation are the same, 
%       the frequency of these channels are -Fs/nc*floor(nc/2)<fc<Fs/2, 
%       (where nc is the number of channels), if nc is odd. For even nc
%       -Fs/2 < fc < Fs/2-Fs/nc. In both cases the frequency steps are 
%       Fs/nc. This was determined by using the centerFrequencies.m 
%       function on example channelizer objects. If using the
%       centerFrequencies output the circshift command can be used to get
%       the correct order of channel frequency. For example:
%       circshift(centerFrequencies(channizerObject,48000),ceil(numChannels/2))
%
%       ABOUT INCOMING DATA:
%       An Airspy HF+ connected to the machine via USB is received using
%       the airspyhf_rx executable. Using the program with the '-r stdout'
%       option allows the data to be piped to another program with the |
%       character. Netcat can then be use to provide the data to this
%       function via UDP. An example commandline input would be
%
%       /usr/local/bin/airspyhf_rx -f 91.7 -m on -a 912000 -n 9120000 -r
%       stdout -g on -l high -t 0 | netcat -u localhost 10000
%
%       Note that this system call must executed after this function is
%       already running or a 'Connection refused' error will occur in
%       terminal.
%
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-01-18
%-------------------------------------------------------------------------

supportedSampleRates = [912 768 456 384 256 192]*1000;
%The divisors function does not support code generation. This function was
%run in the command line to develop the valid decimation factors
%allDivisors         = unique([divisors(192000),divisors(256000),divisors(384000),divisors(456000),divisors(768000),divisors(912000)]);
%allDivisors256Max   = allDivisors( allDivisors~=1 & allDivisors<=256 );
%These values were then down-selected to a more common set of factors
%allDivisors256Max = [2; 3; 4; 5; 6; 8; 10; 12; 15; 16; 19; 20; 24; 25; 30; 32; 38; 40; 48; 50; 57; 60; 64; 75; 76; 80; 95; 96; 100; 114; 120; 125; 128; 150; 152; 160; 190; 192; 200; 228; 240; 250; 256];
allDivisors256Max  =  [2; 4; 10; 12; 16; 24; 32; 48; 64; 80; 96; 100; 120; 128; 192; 256];

if ~any(rawSampleRate == supportedSampleRates)
    error(['UAV-RT: Unsupported sample rate requested. Available rates are [',num2str(supportedSampleRates/1000),'] kS/s.'])
end

if ~mod(decimationFactor,1) == 0 %Integer check
   error('UAV-RT: Decimation factor (Raw rate/decimated rate) must be an integer.') 
end

if ~ismember(decimationFactor,allDivisors256Max)
    error(['UAV-RT: Decimation factor not supported. Valid values are: ', num2str(allDivisors256Max.')] ) 
end

fprintf('Channelizer: Starting up...\n')

%Channelization Settings
maxNumChannels      = 256;
nChannels           = decimationFactor; %Decimation is currently set to equal nChannels. Must be a factor of rawFrameLength
pauseWhenIdleTime   = 0.25;

%UDP Settings
udpReceivePort      = 10000;
udpServePorts       = 20000:20000+maxNumChannels-1;%10000:10039;

%Incoming Data Variables
rawFrameLength  = 128;

rawFrameTime        = rawFrameLength/rawSampleRate;
bytesPerSample      = 8;
supportedSampleRates = [912 768 456 384 256 192]*1000;

if ~any(rawSampleRate == supportedSampleRates)
    error(['UAV-RT: Unsupported sample rate requested. Available rates are [',num2str(supportedSampleRates/1000),'] kS/s.'])
end

%% SETUP UDP DATA INPUT OBJECT
airspyFrameSamples      = 1024;                     % Airspy sends out 1024 complex samples in each udp packet
udpReceiveBufferSize    = 2^16;
udpReceive              = udpReceiverSetup('127.0.0.1', udpReceivePort, udpReceiveBufferSize, airspyFrameSamples);

%% SETUP UDP OUTPUT OBJECTS
fprintf('Channelizer: Setting up output channel UDP ports...\n')
samplesPerChannelMessage = 1024; % Must be a multiple of 128
samplesAtFlush           = samplesPerChannelMessage * decimationFactor;
bytesPerChannelMessage   = bytesPerSample * samplesPerChannelMessage+1;%Adding 1 for the time stamp items on the front of each message. 
sendBufferSize           = 2^nextpow2(bytesPerChannelMessage);
dataBufferFIFO           = dsp.AsyncBuffer(2*samplesAtFlush);
write(dataBufferFIFO,single(1+1i));%Write a single value so the number of channels is specified for coder. Specify complex single for airspy data
read(dataBufferFIFO);     %Read out that single sample to empty the buffer.

udps                     = udpsendercellforcoder('127.0.0.1',udpServePorts,sendBufferSize);

channelizer              = selectChannelizer(nChannels);

frameIndex = 1;

%Make initial call to udps. First call is very slow and can cause missed
%samples if left within the while loop
initialTimeStamp = round(10^3*posixtime(datetime('now')));
initialTimeStamp4Sending = int2singlecomplex(initialTimeStamp);
for i = 1:numel(nChannels)
    singleZeros = single(zeros(samplesPerChannelMessage,1));
    nullPacket = [initialTimeStamp4Sending; singleZeros];
    udps{i}(nullPacket);%Add one for blank time stamp
end

expectedFrameSize = rawFrameLength;
bufferTimeStamp4Sending = complex(single(0));
fprintf('Channelizer: Setup complete. Awaiting udp data...\n')
tic;

while true
    dataReceived = udpReceiverRead(udpReceive, udpReceiveBufferSize);

    if (~isempty(dataReceived))               
        if frameIndex == 1
            bufferTimeStamp = round(10^3*posixtime(datetime('now')));
            bufferTimeStamp4Sending = int2singlecomplex(bufferTimeStamp);
        end
        sampsReceived = numel(dataReceived);
        %Used to keep a running estimated of the expected frame
        %size to help identifiy subsize frames received. 
        if sampsReceived<expectedFrameSize
            disp('Subpacket received')
        end
        if sampsReceived~=expectedFrameSize
            expectedFrameSize = round(mean([sampsReceived, expectedFrameSize]));
        end
        write(dataBufferFIFO,dataReceived(:));%Call with (:) to help coder realize it is a single channel
        
        frameIndex = frameIndex+1;

        if dataBufferFIFO.NumUnreadSamples>=samplesAtFlush
            fprintf('Channelizer: Running - Buffer filled with %u samples. Flushing to channels. Currently receiving: %i samples per packet.\n',uint32(samplesAtFlush),int32(expectedFrameSize))
            fprintf('Actual time between buffer flushes: %6.6f.  Expected: %6.6f. \n', toc, samplesAtFlush/rawSampleRate)
            frameIndex = 1;
            tic;
            y = channelizer(read(dataBufferFIFO,samplesAtFlush));
            for i = 1:nChannels
                data = [bufferTimeStamp4Sending; y(:,i)];
                udpSenderSend(udps{i}, data);
            end
            time2Channelize = toc;
            fprintf('Time required to channelize: %6.6f \n', time2Channelize)
        end
    else
        pause(rawFrameTime/2);
    end
end

end
