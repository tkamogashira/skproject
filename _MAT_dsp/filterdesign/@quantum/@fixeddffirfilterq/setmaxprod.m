function setmaxprod(this, Hd)
%SETMAXPROD   Set the maxprod.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this.maxprod = norm(Hd, 'linf');
updateinternalsettings(this);

% [EOF]
