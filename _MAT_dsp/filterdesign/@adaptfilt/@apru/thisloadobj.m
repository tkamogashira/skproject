function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractapwcorr_thisloadobj(this, s);

set(this, 'InvOffsetCov', s.InvOffsetCov);

% [EOF]
