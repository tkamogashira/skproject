function fmt = multiplicandformat(F)
%MULTIPLICANDFORMAT  Multiplicand format of a quantized FFT object.
%   Q = MULTIPLICANDFORMAT(F) returns the value of the MULTIPLICANDFORMAT property
%   of quantized FFT object F.  Quantized FFTs use the MULTIPLICANDFORMAT to
%   quantize their multiplicands.  The value is either a QUANTIZER object or a
%   UNITQUANTIZER object.  For more information on this property, see the help
%   for QUANTIZER and UNITQUANTIZER.
%
%   A multiplicand is defined as a number that is to be multiplied by an FFT
%   coefficient.  
%
%   The default is 
%     q = quantizer('fixed', 'floor', 'saturate', [16  15])
%
%   Example:
%     F = qfft
%     q = multiplicandformat(F)
%
%   See also QFFT, QFFT/GET, QFFT/SET, QUANTIZER, UNITQUANTIZER.

%   Thomas A. Bryan
%   Copyright 1999-2002 The MathWorks, Inc.

fmt = F.multiplicandformat;
