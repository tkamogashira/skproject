function p = unidcdf(x,n);
%UNIDCDF Uniform (discrete) cumulative distribution function.
%   P = UNIDCDF(X,N) returns the cumulative distribution function
%   for a random variable uniform on (1,2,...,N), at the values in X.
%
%   The size of P is the common size of X and N. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:55 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode x n] = distchck(2,x,n);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p = zeros(size(x));

% P = 1 when X >= N
k2 = find(x >= n);
if any(k2);
    p(k2) = ones(size(k2));
end

xx=floor(x);

k = find(xx >= 1 & xx <= n);
if any(k),
    p(k) = xx(k) ./ n(k);
end

k1 = find(n < 1 | round(n) ~= n);
if any(k1)
    tmp   = NaN;
    p(k1) = tmp(ones(size(k1)));
end
