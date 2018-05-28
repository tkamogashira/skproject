function x = raylinv(p,b)
%RAYLINV  Inverse of the Rayleigh cumulative distribution function (cdf).
%   X = RAYLINV(P,B) returns the Rayleigh cumulative distribution 
%   function with parameter B at the probabilities in P.

%   The size of X is the common size of P and B. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 134-136.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:33 $

if nargin <  1, 
    error('Requires at least one input argument.'); 
end

[errorcode p b] = distchck(2,p,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize x to zero.
x = zeros(size(p));

% Return NaN if the arguments are outside their respective limits.
k1 = find(b <= 0| p < 0 | p > 1);
if any(k1) 
    tmp   = NaN;
    x(k1) = tmp(ones(size(k1)));
end

% Put in the correct values when P is 1.
k = find(p == 1);
if any(k)
    tmp  = Inf;
    x(k) = tmp(ones(size(k))); 
end

k=find(b > 0 & p > 0  &  p < 1);
if any(k),
    pk = p(k);
    bk = b(k);
    x(k) = sqrt((-2*bk .^ 2) .* log(1 - pk));
end
