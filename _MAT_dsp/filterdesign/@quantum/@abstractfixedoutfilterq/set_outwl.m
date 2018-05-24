function outwl = set_outwl(this, outwl)
%SET_OUTWL   PreSet function for the 'OutputWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privoutwl = outwl;
catch 
    error(message('dsp:quantum:abstractfixedoutfilterq:set_outwl:MustBePosInteger'));
end

% Setup the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
outwl = [];

% [EOF]
