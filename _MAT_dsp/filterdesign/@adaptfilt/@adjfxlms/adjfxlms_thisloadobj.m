function adjfxlms_thisloadobj(this, s)
%ADJFXLMS_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, ...
    'pathord',    s.pathord, ...
    'pathestord', s.pathestord);

lms_thisloadobj(this, s);

set(this, ...
    'SecondaryPathCoeffs',   s.SecondaryPathCoeffs, ...
    'SecondaryPathEstimate', s.SecondaryPathEstimate, ...
    'SecondaryPathStates',   s.SecondaryPathStates);

% [EOF]
