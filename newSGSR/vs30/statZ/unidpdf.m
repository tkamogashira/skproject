function y = unidpdf(x,n)
%UNIDPDF Uniform (discrete) probability density function (pdf).
%   Y = UNIDPDF(X,N) returns the (discrete) uniform probability 
%   density function on (1,2,...,N) at the values in X.
%
%   The size of Y is the common size of X and N. A scalar input   
%   functions as a constant matrix of the same size as the other input.    
%
%   Y is zero (or NaN) unless X is an integer between 1 and N.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:57 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode x n] = distchck(2,x,n);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y = zeros(size(x));

k = find(round(x) == x & x >= 1 & x <= n & n ~= 0);
if any(k),
    y(k) = 1 ./ n(k);
end

k1 = find(n < 1 | round(n) ~= n);
if any(k1)
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1)));
end
