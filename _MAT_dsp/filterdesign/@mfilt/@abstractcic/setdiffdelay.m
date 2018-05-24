function D = setdiffdelay(Hm,D)
%SETDIFFDELAY Overloaded set for the DifferentialDelay property.

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2006 The MathWorks, Inc.

% Create a new cascaded filter 

set(Hm,'privDifferentialDelay',D);

% Update the internal settings of the filter before resetting
updatefilterinternals(Hm,true);

% Reset the filter because M affects the matrix of states.
reset(Hm);

% Flush out the stored filter since this property affects the contained
% filter.  The dispatch method will create the updated filter.
Hm.Filters = [];

D = [];

% [EOF]
