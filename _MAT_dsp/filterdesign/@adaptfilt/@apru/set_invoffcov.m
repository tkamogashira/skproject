function A = set_invoffcov(h,A)
%SET_INVOFFCOV Set inverse Offset covariance matrix.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

po = get(h,'ProjectionOrder');

if size(A,1) ~= po | size(A,2) ~= po,
    error(message('dsp:adaptfilt:apru:set_invoffcov:InvalidDimensions'));
end

warnifreset(h, 'InvOffsetCov');
