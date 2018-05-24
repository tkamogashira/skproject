function this = fixeddffirfilterq
%FIXEDDFFIRFILTERQ   Construct a FIXEDDFFIRFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixeddffirfilterq;

% Force Sum and ProductMode to SpecifyPrecision
this.fimath.ProductMode = 'SpecifyPrecision';
this.fimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
this.fimath.CastBeforeSum = false;

% [EOF]
