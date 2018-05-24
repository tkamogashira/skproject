function q = fixedlinearinterpfilterq
%FIXEDLINEARINTERPFILTERQ   Construct a FIXEDLINEARINTERPFILTERQ object.

%   Author(s): R. Losada
%   Copyright 1999-2006 The MathWorks, Inc.

q = quantum.fixedlinearinterpfilterq;

% Force Sum and ProductMode to SpecifyPrecision
q.fimath.ProductMode = 'SpecifyPrecision';
q.fimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
q.fimath.CastBeforeSum = false;

% [EOF]
