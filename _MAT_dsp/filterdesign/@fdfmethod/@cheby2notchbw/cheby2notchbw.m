function this = cheby2notchbw
%CHEBY2NOTCHBW   Construct a CHEBY2NOTCHBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.cheby2notchbw;

set(this,'DesignAlgorithm','Chebyshev type II');

% [EOF]
