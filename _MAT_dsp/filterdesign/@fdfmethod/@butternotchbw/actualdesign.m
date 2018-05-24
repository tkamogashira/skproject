function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

G0 = 0;
G  = -200; 
GBW = 10*log10(.5);
notused = G+10;

[s,g] = designbwparameq(this,hs.FilterOrder,G0,G,notused,GBW,...
    hs.F0*pi,hs.BW*pi,0);

coeffs = {s,g};

% [EOF]
