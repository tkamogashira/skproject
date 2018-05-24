function s = internalsettings(q)
%INTERNALSETTINGS   Returns fixed-point settings as viewed by the algorithm.  

%   Author(s): P. Costa
%   Copyright 1999-2003 The MathWorks, Inc.

% Coefficients
s.CoeffWordLength = q.privcoeffwl;
s.NumFracLength   = q.privcoefffl;
s.DenFracLength   = q.privcoefffl2;
s.Signed          = q.privsigned;

% Input/Output
s.InputWordLength  = q.InputWordLength;
s.InputFracLength  = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.OutputFracLength;

% Products
s.ProductWordLength = q.fimath.ProductWordLength;
s.NumProdFracLength = q.fimath.ProductFractionLength;
s.DenProdFracLength = q.fimath2.ProductFractionLength;

% Accumulators
s.AccumWordLength    = q.fimath.SumWordLength;
s.NumAccumFracLength = q.fimath.SumFractionLength;
s.DenAccumFracLength = q.fimath2.SumFractionLength;
s.CastBeforeSum      = q.fimath.CastBeforeSum;

% State format
s.StateWordLength  = q.StateWordLength;
s.StateFracLength  = q.privstatefl;

% [EOF]
