function statewl = set_statewl(q, statewl)
%SET_STATEWL   PreSet function for the 'StateWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privStatewl = statewl;
catch
    error(message('dsp:quantum:abstractfixedlatticefilterq:set_statewl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% Store nothing here to avoid duplication.
statewl = [];

% [EOF]
