function thisload(this, s)
%THISLOAD   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rlswkalman_thisloadobj(this, s);

set(this, 'SqrtInvCov', s.SqrtInvCov);

% [EOF]
