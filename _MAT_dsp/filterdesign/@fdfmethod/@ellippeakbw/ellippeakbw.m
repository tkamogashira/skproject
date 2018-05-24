function this = ellippeakbw
%ELLIPPEAKBW   Construct an ELLIPPEAKBW object.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

this = fdfmethod.ellippeakbw;

set(this,'DesignAlgorithm','Elliptic');

% [EOF]
