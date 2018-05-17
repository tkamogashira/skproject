function [f, ftest] = cochn(f, A, a, k, F)
%COCHN Normalized cochlear frequency 
%
%   F = COCHN(F, A, a, K, ANC) returns the cochlear normalized frequency on the
%   basis of the species-specific constants A, a, and K and frequency anchor ANC.
%
%   If ANC is a scalar value, cochlear distances will be normalized so that the
%   frequency specified by ANC is the same for both humans and the target species.
%   if ANC is a two element vector then the frequency specified by the first element
%   for humans will become the frequency in the second element for the target species.

%   Copyright (c) 2001 by Michael Kiefte.

if length(F) == 1
    Fa = F;
    Fb = F;
else
    Fa = F(1);
    Fb = F(2);
end

Ah = 165.4;
ah = 0.06;
kh = 1;


c = grnwd(Fa, Ah, ah, kh) - grnwd(Fb, A, a, k);
x = grnwd(f, Ah, ah, kh);
f = invgrnwd(x - c, A, a, k);
