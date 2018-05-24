function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Copyright 2009 The MathWorks, Inc.

Gref = hs.Gref;
G0  = hs.G0;

% Although there is no ripple, the notused value must be finite and between
% G0 and Gref
if isinf(Gref),    
    notused = G0-10;
else
    notused = (Gref+G0)/2;
end

[s,g] = designbwparameq(this,hs.FilterOrder,Gref,G0,notused,hs.GBW,...
    hs.F0*pi,hs.BW*pi,0);

coeffs = {s,g};

% [EOF]
