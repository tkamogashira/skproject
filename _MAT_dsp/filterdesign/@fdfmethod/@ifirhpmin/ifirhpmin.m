function this = ifirhpmin
%IFIRHPMIN   Construct an IFIRHPMIN object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.ifirhpmin;

set(this, 'DesignAlgorithm', 'Interpolated FIR');

% [EOF]
