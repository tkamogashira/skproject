function inwl = set_inwl(this, inwl)
%SET_INWL   PreSet function for the 'InputWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privinwl = inwl;
catch
    error(message('dsp:quantum:abstractfixedlatticefilterq:set_inwl:MustBePosInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
inwl = [];

% [EOF]
