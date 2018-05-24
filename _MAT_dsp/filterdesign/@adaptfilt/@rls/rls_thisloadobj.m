function rls_thisloadobj(this, s)
%RLS_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rlswkalman_thisloadobj(this, s);

set(this, 'InvCov', s.InvCov);

% [EOF]
