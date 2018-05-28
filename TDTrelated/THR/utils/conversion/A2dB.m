function dB=A2dB(A);
% A2dB - convert amplitude ratio to dB
%    A2dB(X) is the dB value of the amplitude ratio X, which is 20*log(X)
%   
%    Note: to avoid 'log of zero' warnings, a tiny constant is added
%    to A, making A2dB(0) equal to -400 dB instead of -inf.

dB=20.*log10(A+1e-20); 
