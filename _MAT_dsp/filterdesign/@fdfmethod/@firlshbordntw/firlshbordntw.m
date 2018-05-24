function h = firlshbordntw
%FIRLSHBORDNTW   Construct a FIRLSHBORDNTW object.

%   Copyright 1999-2006 The MathWorks, Inc.

h = fdfmethod.firlshbordntw;
h.DesignAlgorithm = 'FIR least-squares';

% [EOF]
