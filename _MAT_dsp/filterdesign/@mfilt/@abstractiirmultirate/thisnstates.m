function n = thisnstates(this)
%THISNSTATES   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

n = 0;

for k = 1:length(this.privphase),
    n = n + nstates(this.privphase(k));
end

% [EOF]
