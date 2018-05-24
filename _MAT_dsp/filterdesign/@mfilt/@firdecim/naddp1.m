function n = naddp1(h)
%NADDP1 Returns the number of additions + 1.
% This value is used to compute the number of guard bits in fixed-point.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

n = h.ncoeffs/h.DecimationFactor;
if isempty(n),
    n = 1;
end

% [EOF]
