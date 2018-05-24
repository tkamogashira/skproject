function multwl = set_multwl(this, multwl)
%SET_MULTWL   PreSet function for the 'MultiplicandWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privmultwl = multwl;
catch
    error(message('dsp:quantum:fixeddf1tsosfilterq:set_multwl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
multwl = [];

% [EOF]
