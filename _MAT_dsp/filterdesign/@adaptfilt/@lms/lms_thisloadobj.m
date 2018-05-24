function lms_thisloadobj(this, s)
%LMS_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

dffir_thisloadobj(this, s);

set(this, ...
    'StepSize', s.StepSize, ...
    'Leakage',  s.Leakage);

% [EOF]
