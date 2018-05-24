function ic = set_invcov(h,ic)
%SET_INVCOV Set the inverse covariance matrix.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


% Check for right dimensions
L = get(h,'FilterLength');

if any(size(ic) ~= L),
    error(message('dsp:adaptfilt:rls:set_invcov:InvalidDimensions'));
end

warnifreset(h, 'InvCov');

