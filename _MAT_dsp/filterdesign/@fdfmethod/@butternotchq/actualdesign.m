function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

G0 = 0;
G  = -200; 
GBW = 10*log10(.5);
notused = G+10;

F0 = hs.F0;
Q =  hs.Q;
BW = F0/Q;


[s,g] = designbwparameq(this,hs.FilterOrder,G0,G,notused,GBW,...
    F0*pi,BW*pi,0);

coeffs = {s,g};

% [EOF]
