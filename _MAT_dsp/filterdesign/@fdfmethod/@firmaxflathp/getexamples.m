function examples = getexamples(this) %#ok<INUSD>
%GETEXAMPLES   Get the examples.

%   Copyright 2008 The MathWorks, Inc.

examples = {{ ...
    'Design a highpass maximally flat FIR filter.', ...
    'h  = fdesign.highpass(''N,F3dB'', 50, 0.7);', ...
    'Hd = design(h, ''maxflat'');'}};

% [EOF]
