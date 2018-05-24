function stageoutputautoscale = set_stageoutputautoscale(this, stageoutputautoscale)
%SET_STAGEOUTPUTAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privSectionOutputAutoScale = stageoutputautoscale;

% Update the downstream automagic.
updateinternalsettings(this);

% Save nothing to avoid duplication.
stageoutputautoscale = [];

% [EOF]
