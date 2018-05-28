function [Hn, Xn] = UPBIN(H, N, X);
% UPBIN - obtain coarse histogram from finely spaced one.
%    UPBIN(H, N) is the histogram obtained by joining each N consecutive bins of H.
%    If length(H) is not an N-tuple, the remainder bins will be ignored.
% 
%    [Hn, Xn] = UPBIN(H, N, X) also returns the new bin centers if X are the old ones.

if rem(N,1) | (length(N)>1) | ~isreal(N) | (N<1)
   error('N must be single positive integer number.'), 
end;


M = length(H)
Mnew = floor(M/N)
Hn = sum(reshape(H(1:Mnew*N),N,Mnew));
if nargin>2, % bin centers must be averaged rather than summed
   Xn = mean(reshape(X(1:Mnew*N),N,Mnew));
end