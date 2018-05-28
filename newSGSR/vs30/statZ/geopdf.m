function y = geopdf(x,p)
%GEOPDF Geometric probability density function (pdf).
%   Y = GEOPDF(X,P) returns the geometric pdf with probability, P, 
%   at the values in X.
%
%   The size of Y is the common size of X and P. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.24.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:32 $

if nargin < 2, 
   error('Requires two input arguments.'); 
end

[errorcode x p] = distchck(2,x,p);

if errorcode > 0
   error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y = zeros(size(x));

k = find(x >= 0 & x == round(x) & p > 0 & p <= 1);
if any(k),
   y(k) = p(k) .* (1 - p(k)) .^ x(k);
end

k1 = find(p <= 0 | p > 1);
if any(k1)
   tmp = NaN;
   y(k1) = tmp(ones(size(k1))); 
end
