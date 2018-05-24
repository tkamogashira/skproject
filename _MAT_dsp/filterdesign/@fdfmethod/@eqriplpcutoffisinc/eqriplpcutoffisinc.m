function this = eqriplpcutoffisinc
%EQRIPLPCUTOFFISINC   Construct an EQRIPLPCUTOFFISINC object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpcutoffisinc;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
