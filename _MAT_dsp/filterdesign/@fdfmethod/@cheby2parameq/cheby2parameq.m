function this = cheby2parameq
%CHEBY2PARAMEQ   Construct a CHEBY2PARAMEQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby2parameq;

set(this,'DesignAlgorithm','Chebyshev type II');

% [EOF]
