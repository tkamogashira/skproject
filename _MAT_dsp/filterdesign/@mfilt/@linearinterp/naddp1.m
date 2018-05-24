function n = naddp1(h)
%NADDP1   Returns the number of additions + 1.
% This value is used to compute the number of guard bits in fixed-point.

%   Author(s): R. Losada
%   Copyright 2004 The MathWorks, Inc.

n = ceil(h.ncoeffs/h.InterpolationFactor);
if isempty(n),
    n = 1;
end

% [EOF]
