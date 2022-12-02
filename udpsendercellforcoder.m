function [retUDPCell] = udpsendercellforcoder(remoteIPAddressIn,remoteIPPortIn,sendBufferSizeIn)
%UDPSENDERCELLFORCODER Generates a cell array of dsp.UDPSend objects in a 
% way that is compatible with Matlab Coder. 
%   This function receives a remote IP address and a column vector of
%   remote IP ports. The function generates a cell arrray with UDPSender
%   objects from the Matlab DSP Toolbox in a way that is compatible with
%   the cell array restrictions present in Matlab Coder. The function
%   generates 256 sender objects and then truncates the cell array to
%   output the same size cell array as the size of the remoteIPPortIn
%   argument. No more that 256 ports can be requested. 
%
%INPUTS:
%   remoteIPAddressIn  String containg the remote IP address to send data
%                      to. i.e. '127.0.0.1' or 'localhost'
%   remoteIPPortIn     [1xn] vector of port numbers. Must have no more than
%                      256 elements
%   sendBufferSizeIn   Size of the buffer for each of the UDP Senders. 
%
%
%OUTPUTS:
%   retUDPCell         [1xn] cell array containing the UDP sender objects. 
%
%
%
%Author: Michael W. Shafer
%Date:   2021-11-24
%-------------------------------------------------------------------------
maxNumofPorts = 256;
numOfPorts = numel(remoteIPPortIn);
if ~isstr(remoteIPAddressIn)
    error('UAV-RT: Remote IP address must be entered as a string')
end

if numel(sendBufferSizeIn)>1
    error('UAV-RT: This function only currently supports a single sendBufferSizeIn argurment. This will be applied to all senders.')
end

if numOfPorts>maxNumofPorts
    error('UAV-RT: This function only supports creation of up to 256 ports. If more are needed, consider running multiple instances of this functions and concatinating the outputs.')
end

sizeRemoteIPPortIn = size(remoteIPPortIn);
if min(sizeRemoteIPPortIn) ~= 1
    error('UAV-RT: remoteIPAddressIn must be a row vector.')
end

if size(sizeRemoteIPPortIn,1)~=1
    remoteIPPortInRow = transpose(remoteIPPortIn);
else
    remoteIPPortInRow = remoteIPPortIn;
end

dummyRemotePort    = 10000;
remoteIPPortFiller = dummyRemotePort*ones(1,maxNumofPorts-numOfPorts);
remoteIPPort       = [remoteIPPortInRow,remoteIPPortFiller];

udps1   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(1)  , sendBufferSizeIn  );
udps2   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(2)  , sendBufferSizeIn  );
udps3   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(3)  , sendBufferSizeIn  );
udps4   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(4)  , sendBufferSizeIn  );
udps5   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(5)  , sendBufferSizeIn  );
udps6   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(6)  , sendBufferSizeIn  );
udps7   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(7)  , sendBufferSizeIn  );
udps8   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(8)  , sendBufferSizeIn  );
udps9   = udpSenderSetup(remoteIPAddressIn, remoteIPPort(9)  , sendBufferSizeIn  );
udps10  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(10) , sendBufferSizeIn  );

udps11  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(11) , sendBufferSizeIn  );
udps12  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(12) , sendBufferSizeIn  );
udps13  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(13) , sendBufferSizeIn  );
udps14  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(14) , sendBufferSizeIn  );
udps15  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(15) , sendBufferSizeIn  );
udps16  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(16) , sendBufferSizeIn  );
udps17  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(17) , sendBufferSizeIn  );
udps18  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(18) , sendBufferSizeIn  );
udps19  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(19) , sendBufferSizeIn  );
udps20  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(20) , sendBufferSizeIn  );

udps21  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(21) , sendBufferSizeIn  );
udps22  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(22) , sendBufferSizeIn  );
udps23  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(23) , sendBufferSizeIn  );
udps24  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(24) , sendBufferSizeIn  );
udps25  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(25) , sendBufferSizeIn  );
udps26  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(26) , sendBufferSizeIn  );
udps27  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(27) , sendBufferSizeIn  );
udps28  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(28) , sendBufferSizeIn  );
udps29  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(29) , sendBufferSizeIn  );
udps30  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(30) , sendBufferSizeIn  );

udps31  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(31) , sendBufferSizeIn  );
udps32  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(32) , sendBufferSizeIn  );
udps33  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(33) , sendBufferSizeIn  );
udps34  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(34) , sendBufferSizeIn  );
udps35  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(35) , sendBufferSizeIn  );
udps36  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(36) , sendBufferSizeIn  );
udps37  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(37) , sendBufferSizeIn  );
udps38  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(38) , sendBufferSizeIn  );
udps39  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(39) , sendBufferSizeIn  );
udps40  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(40) , sendBufferSizeIn  );

udps41  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(41) , sendBufferSizeIn  );
udps42  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(42) , sendBufferSizeIn  );
udps43  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(43) , sendBufferSizeIn  );
udps44  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(44) , sendBufferSizeIn  );
udps45  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(45) , sendBufferSizeIn  );
udps46  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(46) , sendBufferSizeIn  );
udps47  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(47) , sendBufferSizeIn  );
udps48  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(48) , sendBufferSizeIn  );
udps49  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(49) , sendBufferSizeIn  );
udps50  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(50) , sendBufferSizeIn  );

udps51  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(51) , sendBufferSizeIn  );
udps52  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(52) , sendBufferSizeIn  );
udps53  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(53) , sendBufferSizeIn  );
udps54  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(54) , sendBufferSizeIn  );
udps55  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(55) , sendBufferSizeIn  );
udps56  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(56) , sendBufferSizeIn  );
udps57  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(57) , sendBufferSizeIn  );
udps58  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(58) , sendBufferSizeIn  );
udps59  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(59) , sendBufferSizeIn  );
udps60  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(60) , sendBufferSizeIn  );

udps61  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(61) , sendBufferSizeIn  );
udps62  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(62) , sendBufferSizeIn  );
udps63  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(63) , sendBufferSizeIn  );
udps64  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(64) , sendBufferSizeIn  );
udps65  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(65) , sendBufferSizeIn  );
udps66  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(66) , sendBufferSizeIn  );
udps67  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(67) , sendBufferSizeIn  );
udps68  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(68) , sendBufferSizeIn  );
udps69  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(69) , sendBufferSizeIn  );
udps70  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(70) , sendBufferSizeIn  );

udps71  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(71) , sendBufferSizeIn  );
udps72  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(72) , sendBufferSizeIn  );
udps73  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(73) , sendBufferSizeIn  );
udps74  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(74) , sendBufferSizeIn  );
udps75  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(75) , sendBufferSizeIn  );
udps76  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(76) , sendBufferSizeIn  );
udps77  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(77) , sendBufferSizeIn  );
udps78  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(78) , sendBufferSizeIn  );
udps79  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(79) , sendBufferSizeIn  );
udps80  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(80) , sendBufferSizeIn  );

udps81  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(81) , sendBufferSizeIn  );
udps82  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(82) , sendBufferSizeIn  );
udps83  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(83) , sendBufferSizeIn  );
udps84  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(84) , sendBufferSizeIn  );
udps85  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(85) , sendBufferSizeIn  );
udps86  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(86) , sendBufferSizeIn  );
udps87  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(87) , sendBufferSizeIn  );
udps88  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(88) , sendBufferSizeIn  );
udps89  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(89) , sendBufferSizeIn  );
udps90  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(90) , sendBufferSizeIn  );

udps91  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(91) , sendBufferSizeIn  );
udps92  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(92) , sendBufferSizeIn  );
udps93  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(93) , sendBufferSizeIn  );
udps94  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(94) , sendBufferSizeIn  );
udps95  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(95) , sendBufferSizeIn  );
udps96  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(96) , sendBufferSizeIn  );
udps97  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(97) , sendBufferSizeIn  );
udps98  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(98) , sendBufferSizeIn  );
udps99  = udpSenderSetup(remoteIPAddressIn, remoteIPPort(99) , sendBufferSizeIn  );
udps100 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(100), sendBufferSizeIn  );

udps101 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(101), sendBufferSizeIn  );
udps102 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(102), sendBufferSizeIn  );
udps103 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(103), sendBufferSizeIn  );
udps104 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(104), sendBufferSizeIn  );
udps105 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(105), sendBufferSizeIn  );
udps106 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(106), sendBufferSizeIn  );
udps107 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(107), sendBufferSizeIn  );
udps108 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(108), sendBufferSizeIn  );
udps109 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(109), sendBufferSizeIn  );
udps110 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(110), sendBufferSizeIn  );

udps111 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(111), sendBufferSizeIn  );
udps112 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(112), sendBufferSizeIn  );
udps113 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(113), sendBufferSizeIn  );
udps114 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(114), sendBufferSizeIn  );
udps115 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(115), sendBufferSizeIn  );
udps116 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(116), sendBufferSizeIn  );
udps117 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(117), sendBufferSizeIn  );
udps118 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(118), sendBufferSizeIn  );
udps119 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(119), sendBufferSizeIn  );
udps120 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(120), sendBufferSizeIn  );

udps121 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(121), sendBufferSizeIn  );
udps122 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(122), sendBufferSizeIn  );
udps123 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(123), sendBufferSizeIn  );
udps124 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(124), sendBufferSizeIn  );
udps125 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(125), sendBufferSizeIn  );
udps126 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(126), sendBufferSizeIn  );
udps127 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(127), sendBufferSizeIn  );
udps128 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(128), sendBufferSizeIn  );
udps129 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(129), sendBufferSizeIn  );
udps130 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(130), sendBufferSizeIn  );

udps131 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(131), sendBufferSizeIn  );
udps132 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(132), sendBufferSizeIn  );
udps133 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(133), sendBufferSizeIn  );
udps134 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(134), sendBufferSizeIn  );
udps135 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(135), sendBufferSizeIn  );
udps136 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(136), sendBufferSizeIn  );
udps137 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(137), sendBufferSizeIn  );
udps138 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(138), sendBufferSizeIn  );
udps139 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(139), sendBufferSizeIn  );
udps140 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(140), sendBufferSizeIn  );

udps141 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(141), sendBufferSizeIn  );
udps142 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(142), sendBufferSizeIn  );
udps143 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(143), sendBufferSizeIn  );
udps144 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(144), sendBufferSizeIn  );
udps145 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(145), sendBufferSizeIn  );
udps146 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(146), sendBufferSizeIn  );
udps147 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(147), sendBufferSizeIn  );
udps148 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(148), sendBufferSizeIn  );
udps149 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(149), sendBufferSizeIn  );
udps150 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(150), sendBufferSizeIn  );

udps151 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(151), sendBufferSizeIn  );
udps152 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(152), sendBufferSizeIn  );
udps153 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(153), sendBufferSizeIn  );
udps154 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(154), sendBufferSizeIn  );
udps155 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(155), sendBufferSizeIn  );
udps156 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(156), sendBufferSizeIn  );
udps157 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(157), sendBufferSizeIn  );
udps158 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(158), sendBufferSizeIn  );
udps159 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(159), sendBufferSizeIn  );
udps160 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(160), sendBufferSizeIn  );

udps161 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(161), sendBufferSizeIn  );
udps162 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(162), sendBufferSizeIn  );
udps163 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(163), sendBufferSizeIn  );
udps164 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(164), sendBufferSizeIn  );
udps165 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(165), sendBufferSizeIn  );
udps166 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(166), sendBufferSizeIn  );
udps167 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(167), sendBufferSizeIn  );
udps168 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(168), sendBufferSizeIn  );
udps169 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(169), sendBufferSizeIn  );
udps170 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(170), sendBufferSizeIn  );

udps171 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(171), sendBufferSizeIn  );
udps172 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(172), sendBufferSizeIn  );
udps173 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(173), sendBufferSizeIn  );
udps174 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(174), sendBufferSizeIn  );
udps175 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(175), sendBufferSizeIn  );
udps176 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(176), sendBufferSizeIn  );
udps177 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(177), sendBufferSizeIn  );
udps178 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(178), sendBufferSizeIn  );
udps179 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(179), sendBufferSizeIn  );
udps180 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(180), sendBufferSizeIn  );

udps181 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(181), sendBufferSizeIn  );
udps182 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(182), sendBufferSizeIn  );
udps183 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(183), sendBufferSizeIn  );
udps184 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(184), sendBufferSizeIn  );
udps185 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(185), sendBufferSizeIn  );
udps186 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(186), sendBufferSizeIn  );
udps187 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(187), sendBufferSizeIn  );
udps188 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(188), sendBufferSizeIn  );
udps189 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(189), sendBufferSizeIn  );
udps190 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(190), sendBufferSizeIn  );

udps191 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(191), sendBufferSizeIn  );
udps192 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(192), sendBufferSizeIn  );
udps193 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(193), sendBufferSizeIn  );
udps194 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(194), sendBufferSizeIn  );
udps195 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(195), sendBufferSizeIn  );
udps196 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(196), sendBufferSizeIn  );
udps197 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(197), sendBufferSizeIn  );
udps198 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(198), sendBufferSizeIn  );
udps199 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(199), sendBufferSizeIn  );
udps200 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(200), sendBufferSizeIn  );

udps201 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(201), sendBufferSizeIn  );
udps202 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(202), sendBufferSizeIn  );
udps203 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(203), sendBufferSizeIn  );
udps204 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(204), sendBufferSizeIn  );
udps205 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(205), sendBufferSizeIn  );
udps206 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(206), sendBufferSizeIn  );
udps207 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(207), sendBufferSizeIn  );
udps208 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(208), sendBufferSizeIn  );
udps209 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(209), sendBufferSizeIn  );
udps210 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(210), sendBufferSizeIn  );

udps211 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(211), sendBufferSizeIn  );
udps212 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(212), sendBufferSizeIn  );
udps213 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(213), sendBufferSizeIn  );
udps214 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(214), sendBufferSizeIn  );
udps215 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(215), sendBufferSizeIn  );
udps216 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(216), sendBufferSizeIn  );
udps217 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(217), sendBufferSizeIn  );
udps218 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(218), sendBufferSizeIn  );
udps219 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(219), sendBufferSizeIn  );
udps220 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(220), sendBufferSizeIn  );

udps221 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(221), sendBufferSizeIn  );
udps222 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(222), sendBufferSizeIn  );
udps223 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(223), sendBufferSizeIn  );
udps224 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(224), sendBufferSizeIn  );
udps225 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(225), sendBufferSizeIn  );
udps226 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(226), sendBufferSizeIn  );
udps227 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(227), sendBufferSizeIn  );
udps228 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(228), sendBufferSizeIn  );
udps229 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(229), sendBufferSizeIn  );
udps230 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(230), sendBufferSizeIn  );

udps231 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(231), sendBufferSizeIn  );
udps232 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(232), sendBufferSizeIn  );
udps233 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(233), sendBufferSizeIn  );
udps234 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(234), sendBufferSizeIn  );
udps235 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(235), sendBufferSizeIn  );
udps236 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(236), sendBufferSizeIn  );
udps237 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(237), sendBufferSizeIn  );
udps238 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(238), sendBufferSizeIn  );
udps239 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(239), sendBufferSizeIn  );
udps240 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(240), sendBufferSizeIn  );

udps241 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(241), sendBufferSizeIn  );
udps242 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(242), sendBufferSizeIn  );
udps243 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(243), sendBufferSizeIn  );
udps244 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(244), sendBufferSizeIn  );
udps245 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(245), sendBufferSizeIn  );
udps246 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(246), sendBufferSizeIn  );
udps247 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(247), sendBufferSizeIn  );
udps248 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(248), sendBufferSizeIn  );
udps249 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(249), sendBufferSizeIn  );
udps250 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(250), sendBufferSizeIn  );

udps251 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(251), sendBufferSizeIn  );
udps252 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(252), sendBufferSizeIn  );
udps253 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(253), sendBufferSizeIn  );
udps254 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(254), sendBufferSizeIn  );
udps255 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(255), sendBufferSizeIn  );
udps256 = udpSenderSetup(remoteIPAddressIn, remoteIPPort(256), sendBufferSizeIn  );


%   
udpsCellAll = { udps1   ; udps2   ; udps3   ; udps4   ; udps5   ; udps6   ; udps7   ; udps8   ; udps9   ; udps10  ;...
                udps11  ; udps12  ; udps13  ; udps14  ; udps15  ; udps16  ; udps17  ; udps18  ; udps19  ; udps20  ;...
                udps21  ; udps22  ; udps23  ; udps24  ; udps25  ; udps26  ; udps27  ; udps28  ; udps29  ; udps30  ;...
                udps31  ; udps32  ; udps33  ; udps34  ; udps35  ; udps36  ; udps37  ; udps38  ; udps39  ; udps40  ;...
                udps41  ; udps42  ; udps43  ; udps44  ; udps45  ; udps46  ; udps47  ; udps48  ; udps49  ; udps50  ;...
                udps51  ; udps52  ; udps53  ; udps54  ; udps55  ; udps56  ; udps57  ; udps58  ; udps59  ; udps60  ;...
                udps61  ; udps62  ; udps63  ; udps64  ; udps65  ; udps66  ; udps67  ; udps68  ; udps69  ; udps70  ;...
                udps71  ; udps72  ; udps73  ; udps74  ; udps75  ; udps76  ; udps77  ; udps78  ; udps79  ; udps80  ;...
                udps81  ; udps82  ; udps83  ; udps84  ; udps85  ; udps86  ; udps87  ; udps88  ; udps89  ; udps90  ;...
                udps91  ; udps92  ; udps93  ; udps94  ; udps95  ; udps96  ; udps97  ; udps98  ; udps99  ; udps100 ;...
                udps101 ; udps102 ; udps103 ; udps104 ; udps105 ; udps106 ; udps107 ; udps108 ; udps109 ; udps110 ;...
                udps111 ; udps112 ; udps113 ; udps114 ; udps115 ; udps116 ; udps117 ; udps118 ; udps119 ; udps120 ;...
                udps121 ; udps122 ; udps123 ; udps124 ; udps125 ; udps126 ; udps127 ; udps128 ; udps129 ; udps130 ;...
                udps131 ; udps132 ; udps133 ; udps134 ; udps135 ; udps136 ; udps137 ; udps138 ; udps139 ; udps140 ;...
                udps141 ; udps142 ; udps143 ; udps144 ; udps145 ; udps146 ; udps147 ; udps148 ; udps149 ; udps150 ;...
                udps151 ; udps152 ; udps153 ; udps154 ; udps155 ; udps156 ; udps157 ; udps158 ; udps159 ; udps160 ;...
                udps161 ; udps162 ; udps163 ; udps164 ; udps165 ; udps166 ; udps167 ; udps168 ; udps169 ; udps170 ;...
                udps171 ; udps172 ; udps173 ; udps174 ; udps175 ; udps176 ; udps177 ; udps178 ; udps179 ; udps180 ;...
                udps181 ; udps182 ; udps183 ; udps184 ; udps185 ; udps186 ; udps187 ; udps188 ; udps189 ; udps190 ;...
                udps191 ; udps192 ; udps193 ; udps194 ; udps195 ; udps196 ; udps197 ; udps198 ; udps199 ; udps200 ;...
                udps201 ; udps202 ; udps203 ; udps204 ; udps205 ; udps206 ; udps207 ; udps208 ; udps209 ; udps210 ;...
                udps211 ; udps212 ; udps213 ; udps214 ; udps215 ; udps216 ; udps217 ; udps218 ; udps219 ; udps220 ;...
                udps221 ; udps222 ; udps223 ; udps224 ; udps225 ; udps226 ; udps227 ; udps228 ; udps229 ; udps230 ;...
                udps231 ; udps232 ; udps233 ; udps234 ; udps235 ; udps236 ; udps237 ; udps238 ; udps239 ; udps240 ;...
                udps241 ; udps242 ; udps243 ; udps244 ; udps245 ; udps246 ; udps247 ; udps248 ; udps249 ; udps250 ;...
                udps251 ; udps252 ; udps253 ; udps254 ; udps255 ; udps256 };
            
%udpsCellAll = { udps1   ; udps2   ; udps3   ;udps4   };

%Coder doesn't support curly braces or this would be coded as
%udpsCellAll(1:numOfPorts)
retUDPCell = {udpsCellAll{1:numOfPorts}};

end

