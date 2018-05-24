function this = cheby2peakbw
%CHEBY2PEAKBW   Construct a CHEBY2PEAKBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby2peakbw;

set(this,'DesignAlgorithm','Chebyshev type II');

% [EOF]
