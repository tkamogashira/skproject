function p = unifcdf(x,a,b);
%UNIFCDF Uniform (continuous) cumulative distribution function (cdf).
%   P = UNIFCDF(X,A,B) returns the cdf for the uniform distribution
%   on the interval [A,B] at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input
%   functions as a constant matrix of the same size as the other inputs.    
% 
%   By default, A = 0 and B = 1.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:46:59 $

if nargin < 1, 
    error('Requires at least one input argument.'); 
end

if nargin == 1
    a = 0;
    b = 1;
end

[errorcode x a b] = distchck(3,x,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p = zeros(size(x));

k1 = find(a >= b);
if any(k1)
    tmp   = NaN;
    p(k1) = tmp(ones(size(k1)));
end

% P = 1 when X >= B
k2 = find(x >= b);
if any(k2);
    p(k2) = ones(size(k2));
end

k = find(x > a & x < b & a < b);
if any(k),
    p(k) = (x(k) - a(k)) ./ (b(k) - a(k));
end
