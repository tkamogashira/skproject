function this = ellipnotchbw
%ELLIPNOTCHBW   Construct an ELLIPNOTCHBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.ellipnotchbw;

set(this,'DesignAlgorithm','Elliptic');

% [EOF]
