function b = thisisreal(this)
%THISISREAL   True if the object is real.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

b = true;

for k = 1:length(this.privphase),
    b = b && isreal(this.privphase(k));
end

% [EOF]
