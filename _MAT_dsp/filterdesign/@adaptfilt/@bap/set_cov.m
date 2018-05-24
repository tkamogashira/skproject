function C = set_cov(h,C)
%SET_cov Set covariance matrix.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

po = get(h,'ProjectionOrder');

if any(size(C)~=po)
    error(message('dsp:adaptfilt:bap:set_cov:InvalidDimensions'));
end

warnifreset(h, 'OffsetCov');
