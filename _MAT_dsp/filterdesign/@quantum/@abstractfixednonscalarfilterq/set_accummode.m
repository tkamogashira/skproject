function accummode = set_accummode(this, accummode)
%SET_ACCUMMODE   PreSet function for the 'AccumMode' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privAccumMode = accummode;

% Remove dynamic properties
updateinternalsettings(this);

% [EOF]
