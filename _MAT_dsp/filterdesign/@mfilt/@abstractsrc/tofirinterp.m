function Hm = tofirinterp(this)
%TOFIRINTERP   Convert to an FIR interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.RateChangeFactors(2) ~= 1
    error(message('dsp:mfilt:abstractsrc:tofirinterp:MFILTErr'));
end

Hm = mfilt.firinterp(this.RateChangeFactors(1), this.Numerator);

% [EOF]
