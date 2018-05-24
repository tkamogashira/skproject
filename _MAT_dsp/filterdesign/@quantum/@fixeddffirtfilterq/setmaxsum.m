function setmaxsum(this, Hd)
%SETMAXSUM   Set the maxsum.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this.maxsum = norm(Hd, 'l1');
updateinternalsettings(this);

% [EOF]
