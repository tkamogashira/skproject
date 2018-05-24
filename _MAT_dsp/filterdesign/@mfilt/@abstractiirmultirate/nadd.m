function N = nadd(this)
%NADD   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


N = 0;

for k = 1:length(this.privphase),
    N = N + nadd(this.privphase(k));
end

% [EOF]
