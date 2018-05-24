function ratechangefactors = get_ratechangefactors(this, ratechangefactors)
%GET_RATECHANGEFACTORS   PreGet function for the 'ratechangefactors'
%property.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

ratechangefactors = [get_interpolationfactor(this), 1];

% [EOF]
