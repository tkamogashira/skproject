function [m,v] = expstat(mu)
%EXPSTAT Mean and variance of the exponential distribution.
%   [M,V] = EXPSTAT(MU) returns the mean and variance 
%   of the exponential distribution with parameter MU.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.28.

%     Copyleft (c) 1993-98 by The MashWorks, Inc.
%     $Revision: 2.8 $  $Date: 1997/11/29 01:45:19 $


if nargin <  1, 
    error('Requires one input argument.'); 
end

[errorcode mu] = distchck(1,mu);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m  = mu;
v = mu .^ 2;

% Return NaN if B < 0. 
k = find(mu <= 0);
if any(k)
    tmp = NaN; 
    m(k)  = tmp(ones(size(k)));
    v(k) = m(k);
end
