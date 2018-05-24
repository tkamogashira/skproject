function setmaxprod(this, Hd)
%SETMAXPROD   Set the maxprod.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

c = Hd.Coefficients;
this.maxprod = max(abs(c(:)));
updateinternalsettings(this);


% [EOF]
