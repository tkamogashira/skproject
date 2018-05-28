function [m,v] = betastat(a,b)
%BETASTAT Mean and variance for the beta distribution.
%   [M,V] = BETASTAT(A,B) returns the mean and variance 
%   of the beta distribution with parameters A and B.
    
%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.33.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:44:53 $

if nargin < 2, 
    error('Requires two input arguments.');
end

[errorcode a b] = distchck(2,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m = zeros(size(a));
v = m;

%   Return NaN if the parameter values are outside their respective limits.
k = find(a <= 0 | b <= 0);
if any(k) 
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end

k1 = find(a > 0 & b > 0);
if any(k1)
    m(k1) = a(k1) ./ (a(k1) + b(k1));
    v(k1) = m(k1) .* b(k1) ./ ((a(k1) + b(k1)) .* (a(k1) + b(k1) + 1));
end

