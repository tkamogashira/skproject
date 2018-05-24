function statefl = set_statefl(q, statefl)
%SET_STATEFL   PreSet function for the 'statefl' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privstatefl = statefl;
catch
    error(message('dsp:quantum:abstractfixedlatticefilterq:set_statefl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% Store nothing to avoid duplication.
statefl = [];

% [EOF]
