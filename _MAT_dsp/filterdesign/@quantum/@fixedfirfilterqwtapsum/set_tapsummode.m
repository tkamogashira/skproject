function tapsummode = set_tapsummode(q, tapsummode)
%SET_TAPSUMMODE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privTapSumMode = tapsummode;

% Update fimath
q.TapSumfimath.SumMode = tapsummode;

updateinternalsettings(q);

% [EOF]
