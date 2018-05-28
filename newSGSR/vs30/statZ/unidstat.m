function [m,v]= unidstat(n);
%UNIDSTAT Mean and variance for uniform (discrete) distribution.
%   [M,V] = UNIDSTAT(N) returns the mean and variance of
%   the (discrete) uniform distribution on {1,2,...,N}

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:58 $

if nargin < 1, 
    error('Requires one input argument.');   
end

%   Initialize the mean and variance to zero.
m = zeros(size(n));
v = m;

k = find(n > 0 & round(n) == n);
m(k) = (n(k) + 1) / 2;
v(k) = (n(k) .^ 2 - 1) / 12;

k1 = find(n <= 0 | round(n) ~= n);
if any(k1)
    tmp   = NaN;
    m(k1) = tmp(ones(size(k1)));
    v(k1) = m(k1);
end
