function this = ifirlpmin
%IFIRLPMIN   Construct an IFIRLPMIN object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.ifirlpmin;

set(this, 'DesignAlgorithm', 'Interpolated FIR');

% [EOF]
