function inwl = set_inwl(q, inwl)
%SET_INWL   PreSet function for the 'InputWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privinwl = inwl;
catch
    error(message('dsp:quantum:abstractfixedfilterq:set_inwl:MustBePosInteger'));
end

% Update any downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% Store nothing here to avoid duplication.
inwl = [];

% [EOF]
