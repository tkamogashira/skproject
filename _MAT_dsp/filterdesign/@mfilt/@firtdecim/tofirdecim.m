function Hm = tofirdecim(this)
%TOFIRDECIM   Convert to an FIRDECIM object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.firdecim(this.DecimationFactor, this.Numerator);

% [EOF]
