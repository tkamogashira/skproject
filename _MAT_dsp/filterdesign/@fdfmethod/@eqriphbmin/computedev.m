function dev = computedev(h,hs)
%COMPUTEDEV   

%   Copyright 2009 The MathWorks, Inc.

% Convert Astop to dev
dev = 10^(-hs.Astop/20);

% [EOF]
