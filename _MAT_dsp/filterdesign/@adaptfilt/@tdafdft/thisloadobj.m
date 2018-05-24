function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

nlms_thisloadobj(this, s);

set(this, ...
    'Power',     s.Power, ...
    'AvgFactor', s.AvgFactor);

% [EOF]
