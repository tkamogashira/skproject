function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designbwparameq(this,hs.FilterOrder,hs.Gref,hs.G0,hs.Gstop,...
    hs.GBW,hs.F0*pi,hs.BW*pi,2);

coeffs = {s,g};

% [EOF]
