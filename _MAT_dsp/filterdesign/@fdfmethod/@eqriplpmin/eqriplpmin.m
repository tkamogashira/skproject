function this = eqriplpmin
%EQRIPLPMIN   Construct an EQRIPLPMIN object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpmin;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
