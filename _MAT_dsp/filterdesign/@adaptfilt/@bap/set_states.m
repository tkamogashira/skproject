function s = set_states(h,s)
%SET_STATES Set the States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');
po = get(h,'ProjectionOrder');

if length(s) ~= L+po-1,
    error(message('dsp:adaptfilt:bap:set_states:InvalidDimensions'));
end

% Always store as a column
s = s(:);

h.privStates = s;
s = [];

warnifreset(h, 'States');
