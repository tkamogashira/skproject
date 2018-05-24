function c = set_fftcoeffs(h,c)
%SET_FFTCOEFFS Set the FFT coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L= get(h,'FilterLength');
N = get(h,'BlockLength');

% Always store as a row (do this before checking the length as a
% cheap way of checking for a vector)
c = c(:).';

if length(c) ~= N+L,
    error(message('dsp:adaptfilt:fdaf:set_fftcoeffs:InvalidDimensions'));
end

warnifreset(h,'FFTCoefficients');



