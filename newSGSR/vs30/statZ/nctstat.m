function [m,v]= nctstat(nu,delta)
%NCTSTAT Mean and variance for the noncentral t distribution.
%   [M,V] = NCTSTAT(NU,DELTA) returns the mean and variance
%   of the noncentral t pdf with NU degrees of freedom and
%   noncentrality parameter, DELTA.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 147-148.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:06 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode, nu, delta] = distchck(2,nu,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize the mean and variance to zero.
m = zeros(size(nu));
v = zeros(size(nu));

% Return NaN for mean and variance if NU is less than 2.
k = find( nu <= 1 | round(nu) ~= nu);
if any(k)
    tmp  = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = tmp(ones(size(k))); 
end

% Return NaN for variance if NU is less than 3.
k = find(nu == 2);
if any(k)
   tmp = NaN;
   v(k) = tmp(ones(size(k))); 
end

k = find(nu >1 & round(nu) == nu);
if any(k)
    m(k) = delta(k) .* sqrt((nu(k)/2)) .* gamma((nu(k) - 1)/2) ./ gamma(nu(k)/2);
end

k = find(nu >2 & round(nu) == nu);
if any(k)
    v(k) = (nu(k) ./ (nu(k) - 2)) .* (1 + delta(k) .^2) ...
   - 0.5*(nu(k) .* delta(k) .^ 2) .* (gamma((nu(k)-1)/2) ./ gamma(nu(k)/2)).^2;
end
