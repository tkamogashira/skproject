function q = fixedfirinterpfilterq
%FIXEDFIRINTERPFILTERQ   Construct a FIXEDFIRINTERPFILTERQ object.

%   Author(s): R. Losada
%   Copyright 1999-2006 The MathWorks, Inc.

q = quantum.fixedfirinterpfilterq;

% Force Sum and ProductMode to SpecifyPrecision
q.fimath.ProductMode = 'SpecifyPrecision';
q.fimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
q.fimath.CastBeforeSum = false;

% [EOF]
