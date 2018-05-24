function s = internalsettings(q)
%INTERNALSETTINGS Returns the fixed-point settings viewed by the algorithm.  

%   Author(s): V. Pellissier
%   Copyright 1988-2003 The MathWorks, Inc.

s.CoeffWordLength = q.privcoeffwl;
s.NumFracLength = q.privcoefffl;
s.DenFracLength = q.privcoefffl2;
s.ScaleValueFracLength = q.privcoefffl3;
s.Signed = q.privsigned;
s.InputWordLength = q.InputWordLength;
s.InputFracLength = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.privoutfl;
if strcmpi(q.OutputMode, 'BestPrecision'),
    s.OutputFracLength = NaN;
end
s.NumStateWordLength = q.NumStateWordLength;
s.NumStateFracLength = q.NumStateFracLength;
s.DenStateWordLength = q.DenStateWordLength;
s.DenStateFracLength = q.DenStateFracLength;
s.ProductWordLength = q.fimath.ProductWordLength;
s.NumProdFracLength = q.fimath.ProductFractionLength;
s.DenProdFracLength = q.fimath2.ProductFractionLength;
s.AccumWordLength = q.fimath.SumWordLength;
s.NumAccumFracLength = q.fimath.SumFractionLength;
s.DenAccumFracLength = q.fimath2.SumFractionLength;
s.CastBeforeSum = q.fimath.CastBeforeSum;

% [EOF]
