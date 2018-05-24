function phaseindex = set_phaseindex(h, phaseindex)
%SET_PHASEINDEX   PreSet function for the 'phaseindex' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if (phaseindex>h.DecimationFactor),
    error(message('dsp:mfilt:abstractfirdecim:set_phaseindex:InvalidPhaseIndex'));
end

% [EOF]
