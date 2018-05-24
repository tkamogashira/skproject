function examples = getexamples(this)
%GETEXAMPLES   Get the examples.

%   Author(s): J. Schickler
%   Copyright 2006 The MathWorks, Inc.

examples = {{ ...
    'Design a Butterworth parametric equalizer using cascaded allpass filters.', ...
    'h  = fdesign.parameq(''N,Flow,Fhigh,Gref,G0,GBW'');', ...
    'Hd = design(h, ''butter'');'}};

% [EOF]
