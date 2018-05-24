function accummode = set_accummode(q, accummode)
%SET_ACCUMMODE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privAccumMode = accummode;

updateinternalsettings(q);

% [EOF]
