function ic = set_sqrtinvcov(h,ic)
%SET_SQRTINVCOV Set the square-root inverse covariance matrix.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


% Check for right dimensions
L = get(h,'FilterLength');

if any(size(ic) ~= L),
    error(message('dsp:adaptfilt:hrls:set_sqrtinvcov:InvalidDimensions'));
end

warnifreset(h, 'SqrtInvCov');

