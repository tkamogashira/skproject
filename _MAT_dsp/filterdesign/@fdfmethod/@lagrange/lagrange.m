function this = lagrange
%LAGRANGE   Construct a LAGRANGE object.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.lagrange;
this.DesignAlgorithm = 'Lagrange interpolation';

% [EOF]
