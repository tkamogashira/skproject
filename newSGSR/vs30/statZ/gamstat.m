function [m,v] = gamstat(a,b)
%GAMSTAT Mean and variance for the gamma distribution.
%   [M,V] = GAMSTAT(A,B) returns the mean and variance 
%   of the gamma distribution with parameters A and B. By default,
%   B = 1.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986, page 7.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:29 $

if nargin < 2,
    b = ones(size(a)); 
end

if nargin < 1,
    error('Requires at least one input argument.'); 
end

[errorcode a b] = distchck(2,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m = a .* b;
v = m .* b;

%   Return NaN if the arguments are outside their respective limits.
k1 = find(a <= 0 | b <= 0);     
if any(k1)
    tmp = NaN;
    m(k1) = tmp(ones(size(k1)));
    v(k1) = m(k1);
end
