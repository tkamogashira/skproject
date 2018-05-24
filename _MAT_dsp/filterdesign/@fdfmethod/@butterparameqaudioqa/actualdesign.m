function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Copyright 2009 The MathWorks, Inc.

Gref = hs.Gref;
G0  = hs.G0;
w0 = pi*hs.F0;

if Gref == G0
    %This is to ensure that we design an all-pass filter whose coefficients
    %yield the correct Qa value.   
    alpha = sin(w0)/(2*hs.Qa);
    b0 =   1 + alpha;
    b1 =  -2*cos(w0);
    b2 =   1 - alpha;
    s = [b0, b1, b2 b0, b1, b2]/b0;
    g = 10^(G0/20);    
else
    %Set GBW to be the geometric mean of the magnitude squared reference and
    %center frequency gains (Gref, G0). In the biquad case this will cause the
    %resulting quality factor to be equal to hs.Qa /10^((hs.Gref - hs.G0)/40).
    %We choose this GBW since it will allow the design of complementary filters
    %for G0,Gref and -G0,-Gref. 
    GBW = 10*log10(sqrt(10^(hs.G0/10)* 10^(hs.Gref/10)));
    
    %mapping from Qa to BW
    BW = 2*atan(sin(w0)/(2*hs.Qa))/pi;
    
    
    % Although there is no ripple, the notused value must be finite and between
    % G0 and Gref
    if isinf(Gref),
        notused = G0-10;
    else
        notused = (Gref+G0)/2;
    end
    
    [s,g] = designbwparameq(this,hs.FilterOrder,Gref,G0,notused,GBW,...
        hs.F0*pi,BW*pi,0);
    
end
coeffs = {s,g};

% [EOF]
