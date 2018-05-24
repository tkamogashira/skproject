function infl = set_infl(q, infl)
%SET_INFL   PreSet function for the 'InputFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privinfl = infl;
catch
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_infl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(q);

% Store nothing to avoid duplication.
infl = [];

% [EOF]
