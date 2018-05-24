function rcf = getratechangefactors(this)
%GETRATECHANGEFACTORS Get the ratechangefactors.
%   OUT = GETRATECHANGEFACTORS(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

rcf = [this.InterpolationFactor this.DecimationFactor];

% [EOF]
