function this = eqriplpisinc
%EQRIPLPISINC   Construct an EQRIPLPISINC object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpisinc;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
