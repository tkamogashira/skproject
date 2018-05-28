function x = geoinv(y,p)
%GEOINV Inverse of the geometric cumulative distribution function.
%   X = GEOINV(Y,P) returns the inverse of the geometric cdf with  
%   parameter P. Since the geometric distribution is discrete, 
%   GEOINV returns the smallest integer X, such that the value of the 
%   cdf at X, equals or exceeds Y.
%
%   The size of X is the common size of Y and P. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:30 $

if nargin < 2, 
    error('Requires two input arguments.');
end

[errorcode y p] = distchck(2,y,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize X to zero.
x = zeros(size(y));

k1 = find(y < 0 | y > 1 | p <= 0 | p >= 1 | isnan(y));
if any(k1),
    tmp   = NaN;
    x(k1) = tmp(ones(size(k1)));
end

k = find(y >= 0 & y < 1 & p > 0 & p < 1);
if any(k)
    x(k) = floor(log(1 - y(k)) ./ log(1 - p(k)));
end

k2 = find(y == 1);
if any(k2)
    tmp   = Inf;
    x(k2) = tmp(ones(size(k2)));
end
