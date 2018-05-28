function [m, v] = nbinstat(r,p)
%NBINSTAT Mean and variance of the negative binomial distribution.
%   [M, V] = NBINSTAT(R,P) returns the mean and variance of the
%   negative binomial distibution with parameters R and P.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:59 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode r p] = distchck(2,r,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

q = 1 - p;
m = r .* q ./ p;
v = r .* q ./ (p .* p);

% Return NaN for parameter values outside their respective limits.
k = find(p<0 | p>1 | r<1 | round(r)~=r);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end
