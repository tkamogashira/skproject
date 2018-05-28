function [m,v] = geostat(p)
%GEOSTAT Mean and variance of the geometric distribution.
%   [M,V] = GEOSTAT(P) returns the mean and variance 
%   of the geometric distribution with parameter P.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.24.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:33 $

if nargin < 1,   
    error('Requires one input argument.');  
end

% Initialize mean and variance to zero.
m = zeros(size(p));
v = m;

k = find(p > 0 & p < 1);
if any(k)
    m(k) = (1 - p(k)) ./ p(k);
    v(k) = m(k) ./ p(k);
end

% Return NaN for P outside the range from 0 to 1.
k1 = find(p <= 0 | p > 1);
if any(k1)
    tmp = NaN;
    m(k1) = tmp(ones(size(k1)));
    v(k1) = m(k1);
end
