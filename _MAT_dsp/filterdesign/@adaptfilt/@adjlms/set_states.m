function s = set_states(h,s)
%SET_STATES Set the states.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');
Nest = get(h,'pathestord');

if Nest ~= 0 & length(s) ~= L+Nest-1,
    error(message('dsp:set_states:incorrectNumberOfOutputStates'));
end

% Always store as a column
s = s(:);

h.privStates = s;
s = [];
