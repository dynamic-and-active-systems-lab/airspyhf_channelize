function complexData = udpReceiverRead(udpReceiver, receiveBufferSize)
	%#codegen
	if coder.target('MATLAB')
		complexData 	= udpReceiver();
	else
		cComplexRead	= int32(0);
		complexBuffer 	= complex(zeros(1, receiveBufferSize, 'single'), zeros(1, receiveBufferSize, 'single'));

		coder.cinclude('udp.h');
		coder.updateBuildInfo('addSourceFiles', 'udp.cpp');
		cComplexRead = coder.ceval('udpReceiverRead', udpReceiver, coder.wref(complexBuffer), receiveBufferSize);
		complexData	= complexBuffer(:);
	end	
end
