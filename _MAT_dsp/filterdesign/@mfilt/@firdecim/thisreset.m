function thisreset(Hm)
%THISRESET Reset the private "memory" of the firdecim filter.

% This should be a private method - do not use!

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

Hm.InputOffset=0;
Hm.PolyphaseAccum=0;
try
    M = Hm.privRateChangeFactor(2);
catch
    M = 1;
end
Hm.TapIndex = zeros(M,1);

% [EOF]
