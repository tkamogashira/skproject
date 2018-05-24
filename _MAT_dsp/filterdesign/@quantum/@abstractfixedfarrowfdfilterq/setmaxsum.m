function setmaxsum(this, Hd)
%SETMAXSUM   Set the maxsum.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

c = Hd.Coefficients;
this.maxsum = sum(abs(c(:)));
updateinternalsettings(this);


% [EOF]
