function val = midiread(h)
    % MIDIREAD Return the most recent value of MIDI controls.
    %   V=MIDIREAD(H) returns the most recent value of the MIDI controls
    %   associated with MIDICONTROLS object H.
    %
    %   H can only determine the values of its MIDI controls if they are
    %   moved after H is created.  Calling MIDIREAD(H) before the controls
    %   are moved will return the initial values specified to MIDICONTROLS
    %   when H was created (or 0 if no initial values were specified).
    %
    %   The output values depend on the OutputMode specified to
    %   MIDICONTROLS when H was created.  If the OutputMode was
    %   'normalized' then the output values are in the range [0 1].  Also,
    %   initial values are quantized and may be slightly different from
    %   those specified to MIDICONTROLS. If the mode was 'rawmidi' then the
    %   values are integers in the range [0 127], and no quantization is
    %   not required. If OutputMode was not specified, the default is
    %   'normalized'.
    %
    %   % Example of reading control values.
    %   v = midiread(h);
    %
    %   See also MIDIID, MIDICONTROLS, MIDISYNC, and MIDICALLBACK.

    %   Copyright 2013 The MathWorks, Inc.
    
    val = read(h);

end
