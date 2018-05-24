function this = eqriplp
%EQRIPLP   Construct an EQRIPLP object.

%   Author(s): J. Schickler
%   Copyright 2004-2006 The MathWorks, Inc.

this = fdfmethod.eqriplp;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
