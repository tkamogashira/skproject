function S = getfdcomputefxpt(this,L,M)
%GETFDCOMPUTEFXPT Compute the constants and word sizes for the generation 
%   of the fixed-point fractional delay in full precision integer math
%   until the last scaling operation

%   Copyright 2007 The MathWorks, Inc.

% Constants 
S.L = L;
S.M = M;
S.K1 = L*(ceil(M/L)-1);
S.K2 = L*ceil(M/L);

% Scalar Precision
fl = this.FDFracLength;
temp = fi(1/L,0);
gFL = fl+1; % No need to carry more precision 
gWL = gFL+max(1,temp.WordLength-temp.FractionLength);

% Word Sizes
S.WL.K = ceil(log2(S.K2))+1;
S.WL.M = ceil(log2(M))+1;
S.WL.Diff = ceil(log2(max(L,M)))+2;
S.WL.Sum = ceil(log2(max(L)))+2;
S.WL.Gain = gWL;
S.WL.FD = this.FDWordLength;

S.FL.Gain = gFL;
S.FL.FD = fl;
S.RndMode = this.RoundMode;

% [EOF]
