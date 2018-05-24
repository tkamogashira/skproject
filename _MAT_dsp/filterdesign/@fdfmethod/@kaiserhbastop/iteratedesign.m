function b = iteratedesign(this,hs,b)
%ITERATEDESIGN Iterative design for kaiserwin

%   Copyright 2009 The MathWorks, Inc.

% Determine band
L = getband(hs);

% Determine order
N = hs.FilterOrder;

% Iterate on Astop
m = 1;
oldb = b;
alpha = determinealpha(this,hs.Astop);
oldalpha = alpha;
while ~isspecmet(hs,b) && isdeltaalphavalid(hs,oldalpha,alpha)
    alpha = oldalpha * (1+m*.001);
    win = kaiser(N+1,alpha);
    b = lowpasslband(N,L,win);
    m = m+1;
end      

if ~isspecmet(hs,b)
    b = oldb;
end

% [EOF]
