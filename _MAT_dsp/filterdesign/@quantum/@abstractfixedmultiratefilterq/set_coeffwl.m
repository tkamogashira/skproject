function coeffwl = set_coeffwl(q,coeffwl)
%SET_COEFFWL   Set function on 'CoeffWordLength' property

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

try
    q.privcoeffwl = coeffwl;
catch
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_coeffwl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(q);

% Store nothing to avoid duplication.
coeffwl = [];

% [EOF]
