function udpReceiverReset(udpReceiver)
	%#codegen
	if coder.target('MATLAB')
		reset(udpReceiver);
	end
end
