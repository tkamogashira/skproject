function inwl = set_inwl(q, inwl)
%SET_INWL   PreSet function for the 'InputWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    q.privinwl = inwl;
catch
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_inwl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(q);

% Store nothing to avoid duplication.
inwl = [];

% [EOF]
