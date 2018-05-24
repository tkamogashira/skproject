function this = cheby2notchq
%CHEBY2NOTCHQ   Construct a CHEBY2NOTCHQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby2notchq;

set(this,'DesignAlgorithm','Chebyshev type II');

% [EOF]
