function c = set_sqrtcov(h,c)
%SET_SQRTCOV Set the square-root covariance matrix.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


% Check for right dimensions
L = get(h,'FilterLength');

if any(size(c) ~= L),
    error(message('dsp:adaptfilt:qrdrls:set_sqrtcov:InvalidDimensions'));
end

warnifreset(h, 'SqrtCov');

