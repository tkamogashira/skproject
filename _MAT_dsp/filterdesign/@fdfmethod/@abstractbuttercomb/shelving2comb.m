function coeffs = shelving2comb(this,L,s,g)
%SHELVING2COMB  Convert shelving filter to a comb filter

%   Copyright 2008 The MathWorks, Inc.

s(1:2) = s(1:2)*prod(g);
Num = [s(1) zeros(1,L-1) s(2)];
Den = [s(4) zeros(1,L-1) s(5)];
coeffs = {Num; Den};
