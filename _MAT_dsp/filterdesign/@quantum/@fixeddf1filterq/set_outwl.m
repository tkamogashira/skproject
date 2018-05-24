function outwl = set_outwl(q, outwl)
%SET_OUTWL   PreSet function for the 'OutputWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privoutwl = outwl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_outwl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% Store nothing to avoid duplication.
outwl = [];

% [EOF]
