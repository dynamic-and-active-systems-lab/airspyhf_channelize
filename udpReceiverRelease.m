function udpReceiverRelease(udpReceiver)
	%#codegen
	if coder.target('MATLAB')
		release(udpReceiver);
	else
		coder.updateBuildInfo('addSourceFiles', 'udp.cpp');
		coder.ceval('udpSocketRelease', udpReceiver);
	end
end
