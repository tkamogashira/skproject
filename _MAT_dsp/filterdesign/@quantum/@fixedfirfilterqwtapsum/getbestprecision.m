function s = getbestprecision(q)
%GETBESTPRECISION Return best precision for Product and Accumulator

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

qc = copy(q);
qc.TapSumMode = 'FullPrecision';
qc.ProductMode = 'FullPrecision';
qc.AccumMode = 'FullPrecision';
s = internalsettings(qc);



% [EOF]
