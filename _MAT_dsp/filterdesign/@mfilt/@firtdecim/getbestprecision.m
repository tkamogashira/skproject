function s = getbestprecision(h)
%GETBESTPRECISION Return best precision for Product and Accumulator

%   Author(s): V. Pellissier
%   Copyright 1988-2005 The MathWorks, Inc.

s = getbestprecision(h.filterquantizer);

% [EOF]
