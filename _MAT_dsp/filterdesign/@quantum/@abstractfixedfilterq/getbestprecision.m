function s = getbestprecision(q)
%GETBESTPRECISION Return best precision for Product and Accumulator

%   Author(s): V. Pellissier
%   Copyright 1988-2003 The MathWorks, Inc.

qc = copy(q);
qc.ProductMode = 'FullPrecision';
qc.AccumMode = 'FullPrecision';
s = internalsettings(qc);



% [EOF]
