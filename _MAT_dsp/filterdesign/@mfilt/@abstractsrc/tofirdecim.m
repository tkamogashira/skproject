function Hm = tofirdecim(this)
%TOFIRDECIM   Convert to an FIR decimator.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

if this.RateChangeFactors(1) ~= 1
    error(message('dsp:mfilt:abstractsrc:tofirdecim:MFILTErr'));
end

Hm = mfilt.firdecim(this.RateChangeFactors(2), this.Numerator);

% [EOF]
