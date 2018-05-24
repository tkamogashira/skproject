function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractrls_thisloadobj(this, s);

set(this, 'SqrtCov', s.SqrtCov);

% [EOF]
