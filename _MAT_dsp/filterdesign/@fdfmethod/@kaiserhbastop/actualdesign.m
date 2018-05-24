function b = actualdesign(h,hs)
%ACTUALDESIGN   Design the filter and return the Numerator.

%   Author(s): R. Losada
%   Copyright 1999-2009 The MathWorks, Inc.

% Determine Astop, alpha, and order
Astop = determineastop(h,hs);
alpha = determinealpha(h,Astop);
N = determineorder(h,hs);

% Determine band
L = getband(hs);

win = kaiser(N+1,alpha);
b = lowpasslband(N,L,win);

b = {iteratedesign(h,hs,b)};

end


% [EOF]
