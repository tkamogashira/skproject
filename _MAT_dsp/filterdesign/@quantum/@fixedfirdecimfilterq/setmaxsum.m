function setmaxsum(this, Hd)
%SETMAXSUM   Set the maxsum.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

p = polyphase(Hd);
this.maxsum = sum(abs(p(:)));
updateinternalsettings(this);

% [EOF]
