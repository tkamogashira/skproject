function c = set_fftcoeffs(h,c)
%SET_FFTCOEFFS Set the FFT coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');
N = get(h,'BlockLength');

if (size(c,1) ~= L/N) | (size(c,2) ~= 2*N),
    error(message('dsp:adaptfilt:pbfdaf:set_fftcoeffs:InvalidDimensions'));
end

warnifreset(h,'FFTCoefficients');
