function L = setinterp(Hm,L)
%SETINTERP Overloaded set for the privRateChangeFactor property.

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2006 The MathWorks, Inc.

set(Hm,'privRateChangeFactor',[L 1]);

% Flush out the stored filter since this property affects the contained
% filter.  The dispatch method will create the updated filter.
Hm.Filters = [];

% Update the internal settings of the filter
updatefilterinternals(Hm,true);

L = []; % Make "phantom"

validatestates(Hm);

% [EOF]
