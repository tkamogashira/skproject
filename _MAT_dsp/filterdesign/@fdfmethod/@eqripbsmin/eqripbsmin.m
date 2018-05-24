function this = eqripbsmin
%EQRIPBSMIN   Construct an EQRIPBSMIN object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqripbsmin;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
