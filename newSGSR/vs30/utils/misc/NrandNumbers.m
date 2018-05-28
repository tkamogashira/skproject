function rn = NrandNumbers(N, Rseed);
% NrandNumbers - returns N quasi-random integers which are uniquely determined by given seed
% Rseed is integer as returned by SetRandState; return arg elements are also in that range
% SYNTAX
%  rn = NrandNumbers(N, Rseed);
% rn is row vector of length N

if nargin<1, N=1; end;
if nargin<2, Rseed = []; end;

[dummy, Nmax] = SetRandState(Rseed);
rn = round(Nmax*rand(1,N));


