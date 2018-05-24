function s = thissaveobj(this)
%THISSAVEOBJ   Save this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s.pathord    = get(this, 'pathord');
s.pathestord = get(this, 'pathestord');

% [EOF]
