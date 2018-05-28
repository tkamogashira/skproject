function [m,v]= ncx2stat(nu,delta)
%NCX2STAT Mean and variance for the noncentral chi-square distribution.
%   [M,V] = NCX2STAT(NU,DELTA) returns the mean and variance
%   of the noncentral chi-square pdf with NU degrees of freedom and
%   noncentrality parameter, DELTA.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 50-51.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:10 $

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

% Return NaN for mean and variance for certain parameter values.
k = find(nu <= 0 | round(nu) ~= nu | delta < 0);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end

k = find(nu > 0 & round(nu) == nu);
if any(k)
    m(k) = delta(k) + nu(k);
end

k = find(nu >2 & round(nu) == nu);
if any(k)
    v(k) = 2*(nu(k) + 2*(delta(k)));
end
