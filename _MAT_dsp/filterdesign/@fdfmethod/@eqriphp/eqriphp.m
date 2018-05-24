function this = eqriphp
%EQRIPLP   Construct an EQRIPHP object.

%   Author(s): J. Schickler
%   Copyright 2004-2006 The MathWorks, Inc.

this = fdfmethod.eqriphp;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
