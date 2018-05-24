function dev = computedev(h,hs)
%COMPUTEDEV   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Convert Astop to dev
dev = 10^(-hs.Astop/20);

% [EOF]
