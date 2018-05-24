function infl = set_infl(q, infl)
%SET_INFL   PreSet function for the 'InputFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privinfl = infl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_infl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% Store nothing here to avoid duplication.
infl = [];

% [EOF]
