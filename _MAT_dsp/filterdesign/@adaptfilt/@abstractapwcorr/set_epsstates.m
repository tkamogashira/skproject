function s = set_epsstates(h,s)
%SET_EPSSTATES Set the epsilon States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

po = get(h,'ProjectionOrder');

if length(s) ~= po-1,
    error(message('dsp:adaptfilt:abstractapwcorr:set_epsstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

