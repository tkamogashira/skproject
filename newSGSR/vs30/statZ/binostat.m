function [m,v] = binostat(n,p)
% BINOSTAT Mean and variance of the binomial distribution.
%   [M, V] = BINOSTAT(N,P) returns the mean and variance of the
%   binomial distibution with parameters N and P.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.20.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:44:58 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode n p] = distchck(2,n,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m = n .* p;
v = n .* p .* (1 - p);

% Return NaN for parameter values outside their respective limits.
k = find(p<0 | p>1 | n<0 | round(n)~=n);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end
