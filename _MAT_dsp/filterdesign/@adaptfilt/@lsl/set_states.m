function s = set_states(h,s)
%SET_STATES Set the states.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');

if length(s) ~= L,
    error(message('dsp:adaptfilt:lsl:set_states:InvalidDimensions'));
end

% Always store as a column
s = s(:);

h.privStates = s;
s = [];
