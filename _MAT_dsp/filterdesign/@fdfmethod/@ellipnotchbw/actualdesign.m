function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designbwparameq(this,hs.FilterOrder,0,-200,-hs.Astop,...
    10*log10(.5),hs.F0*pi,hs.BW*pi,3,-hs.Apass);

coeffs = {s,g};

% [EOF]
