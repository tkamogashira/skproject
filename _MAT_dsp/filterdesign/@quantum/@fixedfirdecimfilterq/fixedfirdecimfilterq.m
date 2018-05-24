function q = fixedfirdecimfilterq
%FIXEDFIRDECIMFILTERQ   Construct a FIXEDFIRDECIMFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

q = quantum.fixedfirdecimfilterq;

% Force Sum and ProductMode to SpecifyPrecision
q.fimath.ProductMode = 'SpecifyPrecision';
q.fimath.SumMode = 'SpecifyPrecision';

% Force CastBeforeSum false
q.fimath.CastBeforeSum = false;

% [EOF]
