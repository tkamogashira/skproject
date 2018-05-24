function N = nmult(this,optimones,optimnegones)
%NMULT   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

N = 0;

for k = 1:length(this.privphase),
    N = N + nmult(this.privphase(k),optimones,optimnegones);
end

% [EOF]
