function s = saveobj(this)
%SAVEOBJ   Save this object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

s                       = get(this);
s.class                 = class(this);

% [EOF]
