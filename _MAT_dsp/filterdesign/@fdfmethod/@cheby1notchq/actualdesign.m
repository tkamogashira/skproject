function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.


F0 = hs.F0;
Q =  hs.Q;
BW = F0/Q;

% Design a Cheby2 filter even though it looks like a Cheby1 given the
% passband ripple
[s,g] = designbwparameq(this,hs.FilterOrder,0,-200,-hs.Apass,...
    10*log10(.5),F0*pi,BW*pi,2);

coeffs = {s,g};

% [EOF]
