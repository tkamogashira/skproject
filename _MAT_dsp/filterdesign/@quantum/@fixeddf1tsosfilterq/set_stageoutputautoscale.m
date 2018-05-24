function stageoutputautoscale = set_stageoutputautoscale(q, stageoutputautoscale)
%SET_STAGEOUTPUTAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privSectionOutputAutoScale = stageoutputautoscale;

updateinternalsettings(q);

% [EOF]
