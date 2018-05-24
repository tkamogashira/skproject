function this = eqripbp
%EQRIPBP   Construct an EQRIPBP object

%   Copyright 2008 The MathWorks, Inc.

this = fdfmethod.eqripbp;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
