function this = eqriphpmin
%EQRIPHPMIN   Construct an EQRIPHPMIN object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriphpmin;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
