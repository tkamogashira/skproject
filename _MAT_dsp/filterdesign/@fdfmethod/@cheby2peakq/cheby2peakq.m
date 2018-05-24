function this = cheby2peakq
%CHEBY2PEAKQ   Construct a CHEBY2PEAKQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby2peakq;

set(this,'DesignAlgorithm','Chebyshev type II');

% [EOF]
