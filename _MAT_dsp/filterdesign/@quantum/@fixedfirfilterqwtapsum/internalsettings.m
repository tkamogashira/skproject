function s = internalsettings(q)
%INTERNALSETTINGS Returns the fixed-point settings viewed by the algorithm.  

%   Author(s): V. Pellissier
%   Copyright 1988-2003 The MathWorks, Inc.

s.CoeffWordLength = q.privcoeffwl;
s.NumFracLength = q.privcoefffl;
s.Signed = q.privsigned;
s.InputWordLength = q.InputWordLength;
s.InputFracLength = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.privoutfl;
if strcmpi(q.OutputMode, 'BestPrecision'),
    s.OutputFracLength = NaN;
end
s.TapSumWordLength = q.TapSumfimath.SumWordLength;
s.TapSumFracLength = q.TapSumfimath.SumFractionLength;
s.ProductWordLength = q.fimath.ProductWordLength;
s.ProductFracLength = q.fimath.ProductFractionLength;
s.AccumWordLength = q.fimath.SumWordLength;
s.AccumFracLength = q.fimath.SumFractionLength;
s.CastBeforeSum = q.fimath.CastBeforeSum;

% [EOF]
