function this = cheby1parameq
%CHEBY1PARAMEQ   Construct a CHEBY1PARAMEQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby1parameq;

set(this,'DesignAlgorithm','Chebyshev type I');

% [EOF]
