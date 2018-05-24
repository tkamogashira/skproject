function setmaxprod(this, Hd)
%SETMAXPROD   Set the maxprod.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

p = polyphase(Hd);
this.maxprod = max(abs(p(:)));
updateinternalsettings(this);

% [EOF]
