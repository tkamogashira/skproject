function y = geocdf(x,p)
%GEOCDF Geometric cumulative distribution function.
%   Y=GEOCDF(X,P) returns the geometric cumulative distribution
%   function with probability, P, at the values in X.
%
%   The size of Y is the common size of X and P. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.24.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:30 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode x p] = distchck(2,x,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y = zeros(size(x));

xx = floor(x);
k = find(xx >= 0 & p > 0 & p <= 1);
if any(k)
    y(k) = 1 - (1 - p(k)) .^ (xx(k) + 1);
end

k2 = find(p == 1 & x ~= 0);
if any(k2)
    y(k2) = zeros(size(k2));
end

k1 = find(p <= 0 | p > 1 | xx < 0);
if any(k1) 
    tmp = NaN;
    y(k1) = tmp(ones(size(k1)));
end
