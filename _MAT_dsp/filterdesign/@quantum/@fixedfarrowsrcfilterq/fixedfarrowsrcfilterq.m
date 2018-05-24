function this = fixedfarrowsrcfilterq
%FIXEDFARROWSRCFILTERQ Construct a FIXEDFARROWSRCFILTERQ object
%   OUT = FIXEDFARROWSRCFILTERQ(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

this = quantum.fixedfarrowsrcfilterq;

% Force Sum and ProductMode to SpecifyPrecision
this.fimath.ProductMode = 'SpecifyPrecision';
this.fimath.SumMode = 'SpecifyPrecision';
this.fdfimath.ProductMode = 'SpecifyPrecision';
this.fdfimath.SumMode = 'SpecifyPrecision';

% Make CastBeforeSum false by default
this.fimath.CastBeforeSum = false;
this.fdfimath.CastBeforeSum = false;

updateinternalsettings(this);

% [EOF]
