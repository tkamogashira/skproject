function Hm = tofirtdecim(this)
%TOFIRTDECIM   Convert to an FIR Transposed Decimator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.RateChangeFactors(1) ~= 1
    error(message('dsp:mfilt:abstractsrc:tofirtdecim:MFILTErr'));
end

Hm = mfilt.firtdecim(this.RateChangeFactors(2), this.Numerator);

% [EOF]
