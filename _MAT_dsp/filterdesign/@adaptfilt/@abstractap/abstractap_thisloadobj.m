function abstractap_thisloadobj(this, s)
%ABSTRACTAP_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, ...
    'ProjectionOrder', s.ProjectionOrder);

dffir_thisloadobj(this, s);

set(this, ...
    'StepSize', s.StepSize);

% [EOF]
