function Hm = tofftfirinterp(this)
%TOFFTFIRINTERP   Convert to an Overlap-Add interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.RateChangeFactors(2) ~= 1
    error(message('dsp:mfilt:abstractsrc:tofftfirinterp:MFILTErr'));
end

Hm = mfilt.fftfirinterp(this.RateChangeFactors(1), this.Numerator);

% [EOF]
