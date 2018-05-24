function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designbwparameq(this,hs.FilterOrder,hs.Gref,hs.G0,hs.Gpass,...
    hs.GBW,hs.F0*pi,hs.BW*pi,3,hs.Gstop);

coeffs = {s,g};

% [EOF]
