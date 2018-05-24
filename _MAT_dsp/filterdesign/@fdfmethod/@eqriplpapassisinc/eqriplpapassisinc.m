function this = eqriplpapassisinc
%EQRIPLPAPASSISINC   Construct an EQRIPLPAPASSISINC object.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.eqriplpapassisinc;

set(this, 'DesignAlgorithm', 'Equiripple');

% [EOF]
