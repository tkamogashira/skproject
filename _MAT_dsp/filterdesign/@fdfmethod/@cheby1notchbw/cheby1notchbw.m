function this = cheby1notchbw
%CHEBY1NOTCHBW   Construct a CHEBY1NOTCHBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby1notchbw;

set(this,'DesignAlgorithm','Chebyshev type I');

% [EOF]
