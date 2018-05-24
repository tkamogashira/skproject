function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designbwparameq(this,hs.FilterOrder,-Inf,0,-hs.Astop,...
    10*log10(.5),hs.F0*pi,hs.BW*pi,2);

coeffs = {s,g};

% [EOF]
