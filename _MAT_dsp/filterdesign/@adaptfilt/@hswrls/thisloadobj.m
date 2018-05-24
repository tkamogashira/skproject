function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

set(this, ...
    'SwBlockLength', s.SwBlockLength);

hrls_thisloadobj(this, s);

set(this, ...
    'DesiredSignalStates', s.DesiredSignalStates);

% [EOF]
