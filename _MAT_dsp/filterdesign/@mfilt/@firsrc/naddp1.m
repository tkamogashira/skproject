function n = naddp1(h)
%NADDP1   Returns the number of additions + 1.
% This value is used to compute the number of guard bits in fixed-point.

%   Author(s): R. Losada
%   Copyright 2004 The MathWorks, Inc.

R = h.RateChangeFactors;
L = R(1); 
n = h.ncoeffs/L;
if isempty(n),
    n = 1;
end

% [EOF]
