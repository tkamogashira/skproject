function b = thisisreal(this)
%THISISREAL   Returns true if the Numerator is real.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

b = isreal(this.Coefficients);

% [EOF]
