function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

G0 = hs.Gref;
G  = hs.G0;

% Although there is no ripple, the notused value must be finite and between
% G and G0 
if isinf(G0),    
    notused = G-10;
else
    notused = (G0+G)/2;
end

[s,g] = designflfhparameq(this,hs.FilterOrder,G0,G,notused,hs.GBW,...
    hs.Flow,hs.Fhigh,0);

coeffs = {s,g};

% [EOF]
