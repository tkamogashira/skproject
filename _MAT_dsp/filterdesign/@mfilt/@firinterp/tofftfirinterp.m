function Hm = tofftfirinterp(this)
%TOFFTFIRINTERP   Convert to an Overlap-Add Interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.fftfirinterp(this.InterpolationFactor, this.Numerator);

% [EOF]
