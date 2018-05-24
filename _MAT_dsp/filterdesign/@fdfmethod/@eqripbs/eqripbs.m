function this = eqripbs
%EQRIPBS   Construct an EQRIPBS object

%   Copyright 2008 The MathWorks, Inc.

this = fdfmethod.eqripbs;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
