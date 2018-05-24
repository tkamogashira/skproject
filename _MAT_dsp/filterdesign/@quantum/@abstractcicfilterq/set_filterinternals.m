function filterinternals = set_filterinternals(this, filterinternals)
%SET_FILTERINTERNALS   PreSet function for the 'filterinternals' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

% Make sure to set privFilterInternals first
this.privFilterInternals = filterinternals;

% Update all internals including states
sendupdate(this);

% [EOF]
