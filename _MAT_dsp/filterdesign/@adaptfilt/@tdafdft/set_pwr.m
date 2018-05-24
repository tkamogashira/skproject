function p = set_pwr(h,p)
%SET_PWR Set the sliding DFT powers.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(p) ~= L,
    error(message('dsp:adaptfilt:tdafdft:set_pwr:InvalidDimensions'));
end

% Always store as a column
p = p(:);

warnifreset(h,'Power');
