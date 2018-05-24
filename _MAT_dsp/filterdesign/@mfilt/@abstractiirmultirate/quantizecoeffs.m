function quantizecoeffs(this)
%QUANTIZECOEFFS   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

for n = 1:length(this.privphase),
    quantizecoeffs(this.privphase(n));
end

% [EOF]
