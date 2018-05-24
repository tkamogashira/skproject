function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designminordparameq(this,hs.Gref,hs.G0,hs.Gstop,hs.GBW,...
    hs.F0*pi,hs.BWstop*pi,hs.BW*pi,2);

coeffs = {s,g};

% [EOF]
