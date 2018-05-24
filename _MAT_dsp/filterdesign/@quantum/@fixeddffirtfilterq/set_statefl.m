function statefl = set_statefl(q, statefl)
%SET_STATEFL   PreSet function for the 'statefl' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privstatefl = statefl;
    % Quantizer changed, send a quantizestates event
    send_quantizestates(q);
catch
    error(message('dsp:quantum:fixeddffirtfilterq:set_statefl:MustBeInteger'));
end

% [EOF]
