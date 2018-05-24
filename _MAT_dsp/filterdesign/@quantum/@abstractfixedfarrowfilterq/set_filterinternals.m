function filterinternals = set_filterinternals(q, filterinternals)
%SET_FILTERINTERNALS   PreSet function for the 'filterinternals' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

q.privFilterInternals = filterinternals;
updateinternalsettings(q);


% [EOF]
