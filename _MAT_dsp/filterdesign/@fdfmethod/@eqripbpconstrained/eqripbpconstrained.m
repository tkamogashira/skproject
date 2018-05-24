function this = eqripbpconstrained
%EQRIPBPCONSTRAINED Construct an EQRIPBPCONSTRAINED object

%   Copyright 2011 The MathWorks, Inc.

this = fdfmethod.eqripbpconstrained;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
