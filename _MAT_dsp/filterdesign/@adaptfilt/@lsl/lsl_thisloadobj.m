function lsl_thisloadobj(this, s)
%LSL_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractrls_thisloadobj(this, s);

set(this, ...
    'InitFactor',     s.InitFactor, ...
    'FwdPrediction',  s.FwdPrediction, ...
    'BkwdPrediction', s.BkwdPrediction);

% [EOF]
