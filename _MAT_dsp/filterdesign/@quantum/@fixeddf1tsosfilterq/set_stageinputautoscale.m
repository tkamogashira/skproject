function stageinputautoscale = set_stageinputautoscale(q, stageinputautoscale)
%SET_STAGEINPUTAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privSectionInputAutoScale = stageinputautoscale;

updateinternalsettings(q);

% [EOF]
