function s = set_states(h,s)
%SET_STATES Set the States.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(s) ~= L-1,
    error(message('dsp:adaptfilt:adaptdffir:set_states:InvalidDimensions'));
end

% Always store as a column
s = s(:);

% Set the private States
h.privStates = s;

% Don't store the States in two places
s = [];

warnifreset(h,'States');

