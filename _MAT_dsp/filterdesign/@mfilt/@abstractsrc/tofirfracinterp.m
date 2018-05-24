function Hm = tofirfracinterp(this)
%TOFIRFRACINTERP   Convert to a fractional interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.firsrc(this.RateChangeFactors(1), this.RateChangeFactors(2), ...
    this.Numerator);

% [EOF]
