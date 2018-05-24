function this = cheby1notchq
%CHEBY1NOTCHQ   Construct a CHEBY1NOTCHQ object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby1notchq;

set(this,'DesignAlgorithm','Chebyshev type I');

% [EOF]
