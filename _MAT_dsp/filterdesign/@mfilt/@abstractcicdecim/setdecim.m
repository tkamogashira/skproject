function M = setdecim(Hm,M)
%SETDECIM Overloaded set for the RateChangeFactor property.

%   Author: P. Costa
%   Copyright 1999-2006 The MathWorks, Inc.

set(Hm, 'privRateChangeFactor',[1 M]);

% Flush out the stored filter since this property affects the contained
% filter.  The dispatch method will create the updated filter.
Hm.Filters = [];

% Update the internal settings of the filter
updatefilterinternals(Hm,true);

M = []; % Make "phantom"

validatestates(Hm);

% [EOF]
