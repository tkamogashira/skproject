function thisreset(Hm)
%THISRESET Reset the private "memory" of the firfracdecim filter.

% This should be a private method - do not use!

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

Hm.InputOffset = 0;
Hm.TapIndex = 0;

% [EOF]
