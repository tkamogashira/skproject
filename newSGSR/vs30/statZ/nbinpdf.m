function y = nbinpdf(x,r,p)
% NBINPDF Negative binomial probability density function.
%   Y = NBINPDF(X,R,P) returns the negative binomial probability density 
%   function with parameters R and P at the values in X.
%   Note that the density function is zero unless X is an integer.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:58 $
%   B.A. Jones 1-24-95.

if nargin < 3, 
    error('Requires three input arguments');
end

[errorcode x r p] = distchck(3,x,r,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y = zeros(size(x));
 
% Negative binomial distribution is defined on positive integers.
k = find(x >= 0  &  x == round(x));
if any(k),
 nk = round(exp(gammaln(r(k) + x(k)) - gammaln(x(k) + 1) - gammaln(r(k))));
 y(k) = nk .* (p(k) .^ r(k)) .* (1 - p(k)) .^ x(k);
end

k1 = find(r < 1 | p < 0 | p > 1 | round(r) ~= r); 
if any(k1)
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1))); 
end
