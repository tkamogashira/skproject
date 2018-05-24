function s = set_states(h,s)
%SET_STATES Set the states.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');
N = get(h,'SwBlockLength');

if (N ~= 0) & (length(s) ~= L+N-2),
    error(message('dsp:adaptfilt:swrls:set_states:InvalidDimensions'));
end

% Always store as a column
s = s(:);

h.privStates = s;
s = [];
