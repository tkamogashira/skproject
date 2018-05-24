function inputoffset = set_inputoffset(h, inputoffset)
%SET_INPUTOFFSET   PreSet function for the 'inputoffset' property.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

if (inputoffset>h.DecimationFactor-1),
    error(message('dsp:mfilt:abstractiirdecim:set_inputoffset:InvalidInputOffset'));
end

% [EOF]
