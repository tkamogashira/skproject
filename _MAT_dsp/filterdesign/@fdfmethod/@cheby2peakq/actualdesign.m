function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

F0 = hs.F0;
Q =  hs.Q;
BW = F0/Q;

[s,g] = designbwparameq(this,hs.FilterOrder,-Inf,0,-hs.Astop,...
    10*log10(.5),F0*pi,BW*pi,2);

coeffs = {s,g};

% [EOF]
