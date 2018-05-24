function rlswkalman_thisloadobj(this, s)
%RLSWKALMAN_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractrls_thisloadobj(this, s);

set(this, 'KalmanGain', s.KalmanGain);

% [EOF]
