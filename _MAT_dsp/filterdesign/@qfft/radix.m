function r = radix(F)
%RADIX  Radix of a quantized FFT object.
%   RADIX(F) returns the radix of quantized FFT object F.
%
%   Example:
%     F = qfft;
%     radix(F)   %returns the default 2.
%
%   See also QFFT, QFFT/GET, QFFT/SET.

%   Thomas A. Bryan
%   Copyright 1999-2008 The MathWorks, Inc.

r = get(F,'radix');
