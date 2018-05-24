function stageoutwl = set_stageoutwl(this, stageoutwl)
%SET_STAGEOUTWL   PreSet function for the 'StageOutputWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstageoutwl = stageoutwl;
catch
    error(message('dsp:quantum:abstractfixedsos2filterq:set_stageoutwl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
stageoutwl = [];

% [EOF]
