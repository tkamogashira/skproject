function this = cheby1peakbw
%CHEBY1PEAKBW   Construct a CHEBY1PEAKBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby1peakbw;

set(this,'DesignAlgorithm','Chebyshev type I');

% [EOF]
