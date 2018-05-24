function thisreset(Hm)
%THISRESET Reset the private "memory" of the firtdecim filter.

% This should be a private method - do not use!

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

p = polyphase(Hm);
Hm.PolyphaseAccum=zeros(size(p,2),1);
Hm.InputOffset = 0;

% [EOF]
