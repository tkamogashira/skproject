function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

% Design a Cheby1 filter even though it looks like a Cheby2 given the
% stopband ripple
[s,g] = designbwparameq(this,hs.FilterOrder,0,-200,-hs.Astop,...
    10*log10(.5),hs.F0*pi,hs.BW*pi,1);

coeffs = {s,g};

% [EOF]
