function y = poisspdf(x,lambda)
%POISSPDF Poisson probability density function.
%   Y = POISSPDF(X,LAMBDA) returns the Poisson probability density 
%   function with parameter LAMBDA at the values in X.
%
%   The size of Y is the common size of X and LAMBDA. A scalar input   
%   functions as a constant matrix of the same size as the other input.    
%
%   Note that the density function is zero unless X is an integer.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.22.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:24 $

if nargin <  2, 
    error('Requires two input arguments.'); 
end

[errorcode x lambda] = distchck(2,x,lambda);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

y = zeros(size(x));

k1 = find(lambda <= 0);
if any(k1) 
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1)));
end 

k = find(x >= 0 & x == round(x) & lambda > 0);
if any(k)
    y(k) = exp(-lambda(k) + x(k) .* log(lambda(k)) - gammaln(x(k) + 1));
end
