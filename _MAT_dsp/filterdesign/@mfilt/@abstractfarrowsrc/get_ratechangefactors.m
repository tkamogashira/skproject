function R = get_ratechangefactors(this, R)
%GET_RATECHANGEFACTORS PreGet function for the 'ratechangefactors' property

%   Copyright 2007 The MathWorks, Inc.

R = [this.Interpolationfactor this.DecimationFactor];

% [EOF]
