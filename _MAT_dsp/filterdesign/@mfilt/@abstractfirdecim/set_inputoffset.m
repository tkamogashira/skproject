function inputoffset = set_inputoffset(h, inputoffset)
%SET_INPUTOFFSET   PreSet function for the 'inputoffset' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if (inputoffset>h.DecimationFactor-1),
    error(message('dsp:mfilt:abstractfirdecim:set_inputoffset:InvalidInputOffset'));
end

% [EOF]
