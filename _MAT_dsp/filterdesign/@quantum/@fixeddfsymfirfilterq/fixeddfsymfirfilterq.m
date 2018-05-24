function this = fixeddfsymfirfilterq
%FIXEDDFSYMFIRFILTERQ   Construct a FIXEDDFSYMFIRFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixeddfsymfirfilterq;

% Force Sum and ProductMode to SpecifyPrecision
this.fimath.ProductMode = 'SpecifyPrecision';
this.fimath.SumMode = 'SpecifyPrecision';
this.TapSumfimath.ProductMode = 'SpecifyPrecision';
this.TapSumfimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
this.fimath.CastBeforeSum = false;
this.TapSumfimath.CastBeforeSum = false;

% [EOF]
