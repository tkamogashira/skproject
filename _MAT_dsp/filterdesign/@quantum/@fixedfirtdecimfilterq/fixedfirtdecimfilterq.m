function q = fixedfirtdecimfilterq
%FIXEDFIRTDECIMFILTERQ   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q = quantum.fixedfirtdecimfilterq;

% Force Sum and ProductMode to SpecifyPrecision
q.fimath.ProductMode = 'SpecifyPrecision';
q.fimath.SumMode = 'SpecifyPrecision';

% Force CastBeforeSum false
q.fimath.CastBeforeSum = false;
q.PolyAccfimath.CastBeforeSum = false;

% [EOF]
