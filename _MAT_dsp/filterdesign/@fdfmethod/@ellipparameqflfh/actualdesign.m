function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

[s,g] = designflfhparameq(this,hs.FilterOrder,hs.Gref,hs.G0,hs.Gpass,...
    hs.GBW,hs.Flow,hs.Fhigh,3,hs.Gstop);

coeffs = {s,g};

% [EOF]
