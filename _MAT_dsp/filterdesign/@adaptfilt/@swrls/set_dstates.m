function s = set_dstates(h,s)
%SET_DSTATES Set the desired signal states.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


N = get(h,'SwBlockLength');

if length(s) ~= N-1,
    error(message('dsp:adaptfilt:swrls:set_dstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

warnifreset(h, 'DesiredSignalStates');


