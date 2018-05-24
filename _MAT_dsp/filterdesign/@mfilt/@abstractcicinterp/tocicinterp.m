function Hm = tocicinterp(this)
%TOCICINTERP   Convert to a CIC Interpolator.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

Hm = mfilt.cicinterp(this.InterpolationFactor, this.DifferentialDelay, ...
    this.NumberOfStages, this.InputBitWidth, this.OutputBitWidth);

% [EOF]
