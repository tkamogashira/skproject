function x = tinv(p,v);
%TINV   Inverse of Student's T cumulative distribution function (cdf).
%   X=TINV(P,V) returns the inverse of Student's T cdf with V degrees 
%   of freedom, at the values in P.
%
%   The size of X is the common size of P and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.2

%   B.A. Jones 1-18-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:51 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode p v] = distchck(2,p,v);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize X to zero.
x=zeros(size(p));

k = find(v < 0  | v ~= round(v));
if any(k)
    tmp  = NaN;
    x(k) = tmp(ones(size(k)));
end

k = find(v == 1);
if any(k)
  x(k) = tan(pi * (p(k) - 0.5));
end

% The inverse cdf of 0 is -Inf, and the inverse cdf of 1 is Inf.
k0 = find(p == 0);
if any(k0)
    tmp   = Inf;
    x(k0) = -tmp(ones(size(k0)));
end
k1 = find(p ==1);
if any(k1)
    tmp   = Inf;
    x(k1) = tmp(ones(size(k1)));
end

k = find(p >= 0.5 & p < 1);
if any(k)
    z = betainv(2*(1-p(k)),v(k)/2,0.5);
    x(k) = sqrt(v(k) ./ z - v(k));
end

k = find(p < 0.5 & p > 0);
if any(k)
    z = betainv(2*(p(k)),v(k)/2,0.5);
    x(k) = -sqrt(v(k) ./ z - v(k));
end

