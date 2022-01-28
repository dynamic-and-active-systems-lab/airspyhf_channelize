function []= airspyhfchannelize24(rawSampleRate) %#codegen
%AIRSPYFHCHANNELIZE24 receives complex (IQ) data over a UDP connection from 
%an Airspy HF+ or Airspy HF+ Discovery SDR, channelizes it, and servers it 
%up over 24 diferent UDP ports.
%   This function is designed specifically to receive incoming data that
%   has been passed to it via an interanl UDP connection. The parameters of
%   the incoming data are specific to the Airspy HF+. The program expects
%   128 sample frames of 8-byte complex samples (4 real, 4 imaginary) to be
%   sent over UDP. The program receives that data and fills a buffer until
%   enough samples have been received that 1024 samples will be generated
%   on the output channels at the decimated sample rate. 
%
%   Once the buffer fills, the data is channelized and
%   served via UDP to corresponding ports. The function opens a command
%   channel so that integers can be passed to enable basic control
%   authority over the program operation, enabling starting of data
%   processing, pausing, and termination of the program.
%
%   Note that all UDP ports have been hardcoded for this function because
%   they are used within the dsp.udpsender and dsp.udpreceiver system
%   objects. When deploying this code to C via Matlab coder, these system
%   object arguments must be constants, which limits the ability of this
%   function to receive ports as arguments and set them at run time. They
%   must be a constant at compile time.
%
%   Normal channelization allows for decimation rates and the number of
%   channels to be different. This function holds them equal. Therefore,
%   the decimated rate for each channel is equal to the raw airspy sample
%   rate divided by the number of channels. Additionally, the center
%   frequencies of each channel is therefore
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
%   PORT LISTING
%       10000       Receive port for airspy data
%                      Complex single precision data
%                      Maximum message size 1024 bytes
%       10001       Receive port for fucntion control commands
%                      Real int8 data
%                      Maximum message size 1024 bytes
%                      Valid inputs are
%                           1   Start data reception/transmission
%                           0   Stop (pause) data reception/transmission
%                               and flush the buffer
%                           -1  Terminate the function
%       20000:20*** Send ports for serving channelized UDP data. Port
%                   numbers increase with frequeny. Because the channel
%                   number and decimation are the same, the frequency
%                   ranges are +/-Fs/nc*floor(nc/2), where nc is the number
%                   of channels, if nc is odd and -Fs/2 < fc <
%                   Fs/nc*floor(nc/2) if nc is even. In each cse the
%                   frequency steps are Fs/nc. This was determined by using
%                   the centerFrequencies.m function on example channelizer
%                   objects. The max port number is equal to 
%                   20000+numberofchannels-1
%
%
%   INPUTS:
%       rawSampleRate   A single integer sample rate. Valid entries
%                       correspond to those available for the Airspy HF+
%                       radio: [912 768 456 384 256 192] kS/s
%
%   OUTPUTS:
%       none
%
%
%
%
%Notes:  An Airspy HF+ connected to the machine via USB is received using
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
%       Command signals send via UDP can be entered in the command line as
%       follows:
%           Start (send a 1): 
%               echo -e -n '\x01'| netcat -u localhost 10001
%           Pause (send a 0): 
%               echo -e -n '\x00'| netcat -u localhost 10001
%           Kill (send a -1): 
%               echo -e -n '\xFF'| netcat -u localhost 10001
%
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-01-18
%-------------------------------------------------------------------------

decimationFactor = 24;

coder.varsize('state')

%Channelization Settings
maxNumChannels      = 256;
decimatedSampleRate = rawSampleRate/decimationFactor;

nChannels           = decimationFactor; %Decimation is currently set to equal nChannels. Must be a factor of rawFrameLength
pauseWhenIdleTime   = 0.25;

%UDP Settings
udpReceivePort      = 10000;
udpCommandPort      = 10001;
udpServePorts       = 20000:20000+maxNumChannels-1;%10000:10039;

%Incoming Data Variables
rawFrameLength      = 128;
bytesPerSample      = 8;
supportedSampleRates = [912 768 456 384 256 192]*1000;

if ~any(rawSampleRate == supportedSampleRates)
    error(['UAV-RT: Unsupported sample rate requested. Available rates are [',num2str(supportedSampleRates/1000),'] kS/s.'])
end


%% SETUP UDP COMMAND INPUT OBJECT
udpCommand = dsp.UDPReceiver('RemoteIPAddress','0.0.0.0',...%127.0.0.1',...  %Accept all
    'LocalIPPort',udpCommandPort,...
    'ReceiveBufferSize',2^6,...%2^16 = 65536, 2^18
    'MaximumMessageLength',1024,...
    'MessageDataType','int8',...
    'IsMessageComplex',false);

setup(udpCommand);

%% SETUP UDP DATA INPUT OBJECT
udpReceive = dsp.UDPReceiver('RemoteIPAddress','0.0.0.0',...%127.0.0.1',... %Accept all
    'LocalIPPort',udpReceivePort,...
    'ReceiveBufferSize',2^18,...%2^16 = 65536, 2^18
    'MaximumMessageLength',1024,...
    'MessageDataType','single',...
    'IsMessageComplex',true);

setup(udpReceive);

%% SETUP UDP OUTPUT OBJECTS

samplesPerChannelMessage = 1024; % Must be a multiple of 128
bufferFrames             = samplesPerChannelMessage * decimationFactor / rawFrameLength;
samplesInBuffer          = bufferFrames * rawFrameLength;
bytesPerChannelMessage   = bytesPerSample * samplesPerChannelMessage+1;%Adding 1 for the time stamp items on the front of each message. 
sendBufferSize           = 2^nextpow2(bytesPerChannelMessage);
dataBuffer               = complex(single(zeros(rawFrameLength, bufferFrames)));

udps                     = udpsendercellforcoder('127.0.0.1',udpServePorts,sendBufferSize);

channelizer              = dsp.Channelizer('NumFrequencyBands', nChannels);

bytesReceived = 0;
sampsReceived = 0;
frameIndex = 1;

%Make initial call to udps. First call is very slow and can cause missed
%samples if left within the while loop
initialTimeStamp = posixtime(datetime('now'));
initialTimeStamp4Sending = double2singlecomplex(initialTimeStamp);
for i = 1:numel(nChannels)
    singleZeros = single(zeros(samplesPerChannelMessage,1));
    nullPacket = [initialTimeStamp4Sending; singleZeros];
    udps{i}(nullPacket);%Add one for blank time stamp
end

bufferTimeStamp = 0;
bufferTimeStamp4Sending = complex(single(0));
state = 'idle';
while 1 %<= %floor((recordingDurationSec-1)*rawSampleRate/rawFrameLength)
    switch state
        case 'run'
            state = 'run';
            tic
            dataReceived = udpReceive();
            if (~isempty(dataReceived))
                if frameIndex == 1
                    bufferTimeStamp = posixtime(datetime('now'));
                    bufferTimeStamp4Sending = double2singlecomplex(bufferTimeStamp);
                end
                sampsReceived = sampsReceived + length(dataReceived);
                dataBuffer(:,frameIndex) = dataReceived;
                frameIndex = frameIndex+1;
                if frameIndex>bufferFrames
                    frameIndex = 1;
                    tic
                    y = channelizer(dataBuffer(:));
                    dataBuffer(:,:) = 0;
                    for i = 1:nChannels
                    	data = [bufferTimeStamp4Sending; y(:,i)];
                        udps{i}(data)
                    end
                    toc
                end
            end
            
            cmdReceived  = udpCommand();
            state = checkcommand(cmdReceived,state);
            
        case 'idle'
            state = 'idle';
            dataBuffer(:,:) = 0; %Clear the buffer
            pause(pauseWhenIdleTime);%Wait a bit so to throttle idle execution
            cmdReceived  = udpCommand();
            state = checkcommand(cmdReceived,state);
            if strcmp(state,'run')
                reset(udpReceive);%Reset to clear buffer so data is fresh - in case state had been idle
            end
        case 'kill'
            state = 'dead';
            dataBuffer(:,:) = 0; %Clear the buffer
            release(udpReceive)
            release(udpCommand)
            break
        otherwise
            %Should never get to this case, but jump to idle if we get
            %here.
            state = 'idle';
    end

end


function state = checkcommand(cmdReceived,currentState)
%This function is designed to check the incoming command and decide what to
%do based on the received command and the current state
if ~isempty(cmdReceived)
    if cmdReceived == -1
        state = 'kill';
    elseif cmdReceived == 0
        state = 'idle';
    elseif cmdReceived == 1
        state = 'run';
    else
        %Invalid command. Continue with current state.
        state = currentState;
    end
else
    %Nothing received. Continue with current state.
    state = currentState;
end
end

end
