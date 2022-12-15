function channelizer = selectChannelizer(numFrequencyBands)

if numFrequencyBands == 2
    channelizer = dsp.Channelizer('NumFrequencyBands', 2);
elseif numFrequencyBands == 4
    channelizer = dsp.Channelizer('NumFrequencyBands', 4);
elseif numFrequencyBands == 10
    channelizer = dsp.Channelizer('NumFrequencyBands', 10);
elseif numFrequencyBands == 12
    channelizer = dsp.Channelizer('NumFrequencyBands', 12);
elseif numFrequencyBands == 16
    channelizer = dsp.Channelizer('NumFrequencyBands', 16);
elseif numFrequencyBands == 24
    channelizer = dsp.Channelizer('NumFrequencyBands', 24);
elseif numFrequencyBands == 32
    channelizer = dsp.Channelizer('NumFrequencyBands', 32);
elseif numFrequencyBands == 48
    channelizer = dsp.Channelizer('NumFrequencyBands', 48);
elseif numFrequencyBands == 64
    channelizer = dsp.Channelizer('NumFrequencyBands', 64);
elseif numFrequencyBands == 80
    channelizer = dsp.Channelizer('NumFrequencyBands', 80);
elseif numFrequencyBands == 96
    channelizer = dsp.Channelizer('NumFrequencyBands', 96);
elseif numFrequencyBands == 100
    channelizer = dsp.Channelizer('NumFrequencyBands', 100);
elseif numFrequencyBands == 120
    channelizer = dsp.Channelizer('NumFrequencyBands', 120);
elseif numFrequencyBands == 128
   channelizer = dsp.Channelizer('NumFrequencyBands', 128);
elseif numFrequencyBands == 192
    channelizer = dsp.Channelizer('NumFrequencyBands', 192);
elseif numFrequencyBands == 256
    channelizer = dsp.Channelizer('NumFrequencyBands', 256);
else
    error("Unsupported numFrequencyBands: %d", int(numFrequencyBands))
end

end