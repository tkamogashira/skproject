function s = set_errstates(h,s)
%SET_ERRSTATES Set the error States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));
po = get(h,'ProjectionOrder');

if length(s) ~= po-1,
    error(message('dsp:adaptfilt:abstractapwcorr:set_errstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

