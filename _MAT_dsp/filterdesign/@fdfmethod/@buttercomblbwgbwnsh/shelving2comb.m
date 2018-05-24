function coeffs = shelving2comb(this,L,s,g)
%SHELVING2COMB   
%Convert shelving filter to a comb filter

%   Copyright 2008 The MathWorks, Inc.

[B,A] = sos2tf(s,g);

bc =size(B,2);
NumTmp = zeros(L, bc-2);
NumTmp(1,:) = B(1:bc-2);
Num =[ NumTmp(:)' B(bc-1)];
if B(bc) ~= 0
    Num = [Num zeros(1,L-1) B(bc)];
end

ac =size(A,2);
DenTmp = zeros(L, ac-2);
DenTmp(1,:) = A(1:ac-2);
Den =[ DenTmp(:)' A(ac-1)];
if A(ac) ~= 0
    Den = [Den zeros(1,L-1) A(ac)];
end

coeffs = {Num;Den};
