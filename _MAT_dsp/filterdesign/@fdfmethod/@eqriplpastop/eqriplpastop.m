function this = eqriplpastop
%EQRIPLPASTOP   Construct an EQRIPLPASTOP object.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpastop;

set(this, 'DesignAlgorithm', 'Equiripple');

if nargin
    set(this, 'DensityFactor', DensityFactor);
end

% [EOF]
