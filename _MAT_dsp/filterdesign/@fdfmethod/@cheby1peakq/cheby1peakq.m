function this = cheby1peakq
%CHEBY1PEAKQ   Construct a CHEBY1PEAKQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby1peakq;

set(this,'DesignAlgorithm','Chebyshev type I');
% [EOF]
