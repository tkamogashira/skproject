function b = actualdesign(h,hs)
%ACTUALDESIGN   

%   Copyright 1999-2004 The MathWorks, Inc.

Wc = 0.5;
htw = hs.TransitionWidth/2;

% Make weights the same
b = firls(hs.FilterOrder,[0 Wc-htw Wc+htw 1],[1 1 0 0],[1 1]);

% Force exact zeros and exact 0.5 in the middle. For large order (e.g. 180)
% this makes a difference
indx = ceil(length(b)/2);
b(indx+2:2:end) = 0;
b(indx-2:-2:1) = 0;
b(indx) = 0.5;

b = {b};

% [EOF]
