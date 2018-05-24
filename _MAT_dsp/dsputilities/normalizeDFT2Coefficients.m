function c = normalizeDFT2Coefficients(b,a,outputNum)
% normalizeDFT2Coefficients Normalize leading a coefficient

% Copyright 2013 The MathWorks, Inc.

if outputNum == 1 % b coefficient
    c = b ./ a(1);
else
    c = a ./ a(1); % a coefficient
end