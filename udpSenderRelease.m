function udpSenderRelease(udpSender)
	%#codegen
	if coder.target('MATLAB')
		release(udpSender);
	else
		coder.updateBuildInfo('addSourceFiles', 'udp.cpp');
		coder.ceval('udpSocketRelease', udpSender);
	end
end
