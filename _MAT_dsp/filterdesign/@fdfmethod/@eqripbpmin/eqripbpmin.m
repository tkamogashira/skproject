function this = eqripbpmin
%EQRIPBPMIN   Construct an EQRIPBPMIN object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqripbpmin;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
