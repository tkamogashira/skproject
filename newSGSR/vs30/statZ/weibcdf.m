function p = weibcdf(x,a,b)
%WEIBCDF Weibull cumulative distribution function (cdf).
%   P = WEIBCDF(X,A,B) returns the Weibull cdf with parameters A and B
%   at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input
%   functions as a constant matrix of the same size as the other inputs.    
%
%   Some references refer to the Weibull distribution with a 
%   single parameter. This corresponds to WEIBCDF with A = 1.

%   References:
%      [1] J. K. Patel, C. H. Kapadia, and D. B. Owen, "Handbook
%      of Statistical Distributions", Marcel-Dekker, 1976.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:47:04 $

if nargin < 3, 
    error('Requires three input arguments.'); 
end

[errorcode x a b] = distchck(3,x,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p = zeros(size(x));

k1 = find(a <= 0 | b <= 0);
if any(k1)
   tmp   = NaN;
   y(k1) = tmp(ones(size(k1)));
end

% The domain of the weibull distribution is the positive real axis.
k = find(x >= 0 & a > 0 & b > 0);
if any(k),
    p(k) = 1 - exp(-a(k) .* (x(k) .^ b(k)));
end
