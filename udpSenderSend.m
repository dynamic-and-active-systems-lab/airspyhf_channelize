function udpSenderSend(udpSender, complexData)
	%#codegen
	if coder.target('MATLAB')
		udpSender(complexData);
	else
		coder.cinclude('udp.h');
		coder.updateBuildInfo('addSourceFiles', 'udp.cpp');
		coder.ceval('udpSenderSend', udpSender, coder.rref(complexData), length(complexData));
	end
end
