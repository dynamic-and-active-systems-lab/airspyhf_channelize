function complexData = udpReceiverClear(udpReceiver)
	%#codegen
	if coder.target('MATLAB')
		complexData = udpReceiver();
		while ~isempty(complexData)
			complexData = udpReceiver();
		end
		complexData = [];
	else
		coder.cinclude('udp.h');
		coder.updateBuildInfo('addSourceFiles', 'udp.cpp');
		coder.ceval('udpReceiverClear', udpReceiver);
	end	
end
