function this = eqriplpastopisinc
%EQRIPLPASTOPISINC   Construct an EQRIPLPASTOPISINC object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpastopisinc;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
