function num = setnum(Hm, num)
%SETNUM Overloaded set for the Numerator property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Call alternate method
num = supersetnum(Hm, num);

% Set new fft coeffs:
quantizecoeffs(Hm);

