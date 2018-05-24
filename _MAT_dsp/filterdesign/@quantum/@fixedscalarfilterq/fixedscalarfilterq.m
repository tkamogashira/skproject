function this = fixedscalarfilterq
%FIXEDSCALARFILTERQ   Construct a FIXEDSCALARFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixedscalarfilterq;

% Force Sum and ProductMode to FullPrecision
this.fimath.ProductMode = 'FullPrecision';
this.fimath.SumMode = 'FullPrecision';

% [EOF]
