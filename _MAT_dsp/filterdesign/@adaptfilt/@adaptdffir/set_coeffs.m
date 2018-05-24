function c = set_coeffs(h,c)
%SET_COEFFS Set the coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(c) ~= L,
    error(message('dsp:adaptfilt:adaptdffir:set_coeffs:InvalidDimensions'));
end

% Always store as a row
c = c(:).';

% Set private Coefficients
h.privCoefficients = c;

c = [];

warnifreset(h,'Coefficients');
