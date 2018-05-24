function this = eqriplpminisinc
%EQRIPLPMINISINC   Construct an EQRIPLPMINISINC object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpminisinc;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
