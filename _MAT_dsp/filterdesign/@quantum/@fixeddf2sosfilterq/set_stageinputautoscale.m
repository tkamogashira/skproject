function stageinputautoscale = set_stageinputautoscale(this, stageinputautoscale)
%SET_STAGEINPUTAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privSectionInputAutoScale = stageinputautoscale;

% Update downstream automagic.
updateinternalsettings(this);

% Save nothing to avoid duplication.
stageinputautoscale = [];

% [EOF]
