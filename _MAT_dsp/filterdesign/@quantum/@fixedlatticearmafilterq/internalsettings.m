function s = internalsettings(q)
%INTERNALSETTINGS Returns the fixed-point settings viewed by the algorithm.  

%   Author(s): V. Pellissier
%   Copyright 1988-2003 The MathWorks, Inc.

s.CoeffWordLength = q.privcoeffwl;
s.LatticeFracLength = q.privcoefffl;
s.LadderFracLength = q.privcoefffl2;
s.Signed = q.privsigned;
s.InputWordLength = q.InputWordLength;
s.InputFracLength = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.privoutfl;
if strcmpi(q.OutputMode, 'BestPrecision'),
    s.OutputFracLength = NaN;
end
s.StateWordLength = q.StateWordLength;
s.StateFracLength = q.StateFracLength;
s.ProductWordLength = q.fimath.ProductWordLength;
s.LatticeProdFracLength = q.fimath.ProductFractionLength;
s.LadderProdFracLength = q.fimath2.ProductFractionLength;
s.AccumWordLength = q.fimath.SumWordLength;
s.LatticeAccumFracLength = q.fimath.SumFractionLength;
s.LadderAccumFracLength = q.fimath2.SumFractionLength;
s.CastBeforeSum = q.fimath.CastBeforeSum;

% [EOF]
