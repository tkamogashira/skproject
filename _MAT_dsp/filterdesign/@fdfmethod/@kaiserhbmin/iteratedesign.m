function b = iteratedesign(this,hs,b)
%ITERATEDESIGN Iterative design for kaiserwin

%   Copyright 2009 The MathWorks, Inc.

% Determine band
L = getband(hs);

% Determine the order
N = determineorder(this,hs);

% Iterate on Astop specification
oldb = b;
alpha = determinealpha(this,hs.Astop);
oldalpha = alpha;
Nm = 1;
while ~isspecmet(hs,b) && Nm < 100
    alpham = 1;
    while ~isspecmet(hs,b) && isdeltaalphavalid(hs,oldalpha,alpha)
        alpha = oldalpha * (1+alpham*.001);
        win = kaiser(N+1,alpha);
        b = lowpasslband(N,L,win);
        alpham = alpham + 1;
    end
    N = N+2;
    Nm = Nm + 1;
    alpha = oldalpha; % reset alpha to original value for next round iteration
end     

if ~isspecmet(hs,b)
    b = oldb;
end



% [EOF]
