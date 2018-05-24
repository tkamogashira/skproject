function this = fixedlinearfdfilterq
%FIXEDLINEARFDFILTERQ   Construct a FIXEDLINEARFDFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

this = quantum.fixedlinearfdfilterq;

% Force Sum and ProductMode to SpecifyPrecision
this.fimath.ProductMode = 'SpecifyPrecision';
this.fimath.SumMode = 'SpecifyPrecision';
this.fdfimath.ProductMode = 'SpecifyPrecision';
this.fdfimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
this.fimath.CastBeforeSum = false;
this.fdfimath.CastBeforeSum = false;

% [EOF]
