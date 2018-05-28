function p = hygecdf(x,m,k,n)
%HYGECDF Hypergeometric cumulative distribution function.
%   P = HYGECDF(X,M,K,N) returns the hypergeometric cumulative 
%   distribution function with parameters M, K, and N 
%   at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   B.A. Jones 2-23-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:38 $

if nargin < 4, 
    error('Requires four input arguments.'); 
end

[errorcode x m k n] = distchck(4,x,m,k,n);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%Initialize P to zero.
p = zeros(size(x));

%   Return NaN for values of the parameters outside their respective limits.
k1 = find(m < 0 | k < 0 | n < 0 | x < 0 | round(m) ~= m | round(k) ~= k | ...
           round(n) ~= n | n > m | k > m | x > n | x > k);
if any(k1)
    tmp = NaN;
    p(k1) = tmp(ones(size(k1))); 
end

kc = (1:prod(size(x)))';
kc(k1) = [];

% Compute p when xx >= 0.
if any(kc)
    xx = floor(x);
    val = min([max(max(k(kc))) max(max(xx(kc))) max(max(n(kc)))]);
    i1 = [0:val]';
    compare = i1(:,ones(size(kc)));
    index = xx(kc);
	index = index(:);
    index = index(:,ones(size(i1)))';
    mbig = m(kc);
	mbig = mbig(:);
    mbig = mbig(:,ones(size(i1)))';
    kbig = k(kc);
	kbig = kbig(:);
    kbig = kbig(:,ones(size(i1)))';
    nbig = n(kc);
	nbig = nbig(:);
    nbig = nbig(:,ones(size(i1)))';
    p0 = hygepdf(compare,mbig,kbig,nbig);
    indicator = find(compare > index);
    p0(indicator) = zeros(size(indicator));
    p(kc) = sum(p0);
end

% Make sure that round-off errors never make P greater than 1.
k1 = find(p > 1);
if any(k1)
    p(k1) = ones(size(k1));
end
