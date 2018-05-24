function this = eqripbsconstrained
%EQRIPBSCONSTRAINED Construct an EQRIPBSCONSTRAINED object

%   Copyright 2011 The MathWorks, Inc.

this = fdfmethod.eqripbsconstrained;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
