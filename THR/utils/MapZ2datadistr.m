function [Sig, SigInv]=MapZ2datadistr(X, Nbin);
% MapZ2datadistr - create mapping from normal data to distr of given data
%   [Sig, SigInv]=MapZ2datadistr(X) evaluates the amplitude distribution of
%   sample data X and and computes function Sigma that maps normally-
%   distributed variables onto variable that has same amplitude 
%   distribution as X. SigmaInv is the inverse function of Sigma.
%
%   MappingFromRuedata(X, Nbin) uses Nbin bins to compute the PDF of X.
%   Default Nbin=1000.
%
%   See also RANDN.


if nargin<2, Nbin=1000; end;

% read data & obtain amplitude histogram
MX = max(X); MN = min(X);
[N, X]=hist(X, linspace(MN,MX+(MX-MN)/2/Nbin),Nbin);
% cumulative distr
CDF = cumsum(N);
CDF = CDF/CDF(end);
Qfun = sqrt(2)*erfinv((1-1e-12)*(2*CDF-1)); % avoid inf
% remove identical entries in Qfun (cannot be inverted)
iflat = (diff(Qfun)==0);
X(iflat)=[]; Qfun(iflat)=[];
Sig = @(z)local_Sigma(X,Qfun,z);
SigInv = @(x)local_SigmaInv(X,Qfun,x);

%===================
function x = local_Sigma(X,Qfun,z);
%plot(Qfun,X); grid on;
z = clip(z,min(Qfun), max(Qfun)-0.001*(max(Qfun)-max(Qfun)));
x = interp1(Qfun, X, z);

function z = local_SigmaInv(X,Qfun,x);
%plot(X, Qfun); grid on;
x = clip(x,min(X), max(X)-0.001*(max(X)-max(X)));
z = interp1(X, Qfun, x);




