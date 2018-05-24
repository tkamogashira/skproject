function s = set_errstates(h,s)
%SET_ERRSTATES Set the error states.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

D = get(h,'Delay');

if length(s) ~= D,
    error(message('dsp:adaptfilt:dlms:set_errstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

warnifreset(h, 'ErrorStates');
