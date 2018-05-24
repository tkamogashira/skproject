function stageoutfl = set_stageoutfl(this, stageoutfl)
%SET_STAGEOUTFL   PreSet function for the 'StageOutputFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstageoutfl = stageoutfl;
catch
    error(message('dsp:quantum:abstractfixedsos2filterq:set_stageoutfl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Don't store to avoid duplication.
stageoutfl = [];

% [EOF]
