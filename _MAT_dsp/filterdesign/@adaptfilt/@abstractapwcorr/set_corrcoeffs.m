function c = set_corrcoeffs(h,c)
%SET_CORRCOEFFS Set the correlation coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

po = get(h,'ProjectionOrder');

if length(c) ~= po-1,
    error(message('dsp:adaptfilt:abstractapwcorr:set_corrcoeffs:InvalidDimensions'));
end

% Always store as a row
c = c(:).';

