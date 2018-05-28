function x = hygeinv(p,m,k,n)
%HYGEINV Inverse of the hypergeometric cumulative distribution function (cdf).
%   X = HYGEINV(P,M,K,N) returns the inverse of the hypergeometric 
%   cdf with parameters M, K, and N. Since the hypergeometric 
%   distribution is discrete, HYGEINV returns the smallest integer X, 
%   such that the hypergeometric cdf evaluated at X, equals or exceeds P.   
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:39 $

if nargin < 4, 
    error('Requires four input arguments.'); 
end

[errorcode p m k n] = distchck(4,p,m,k,n);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize X to zero.
x = zeros(size(p));

%   Return NaN for values of the parameters outside their respective limits.
k1 = find(m < 0 | k < 0 | n < 0 | round(m) ~= m | round(k) ~= k | ...
           round(n) ~= n | n > m | k > m | x > n | p < 0 | p > 1 | isnan(p));
if any(k1)
    tmp = NaN;
    x(k1) = tmp(ones(size(k1))); 
end

cumdist = hygepdf(x,m,k,n);
count = zeros(size(p));

% Compare P to the hypergeometric distribution for each value of N.
while any(any(p > cumdist)) & count(1) < max(max(n)) & count(1) < max(max(k))
    count = count + 1;
    idx = find(cumdist < p - eps);
    x(idx) = x(idx) + 1;
    cumdist(idx) = cumdist(idx) + hygepdf(count(idx),m(idx),k(idx),n(idx));
end
