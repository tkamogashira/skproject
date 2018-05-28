function x = logninv(p,mu,sigma);
%LOGNINV Inverse of the lognormal cumulative distribution function (cdf).
%   X = LOGNINV(P,MU,SIGMA) finds the inverse of the lognormal cdf with
%   mean, MU, and standard deviation, SIGMA.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   Default values for MU and SIGMA are 0 and 1 respectively.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 102-105.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:45 $

if nargin < 3, 
    sigma = 1;
end

if nargin < 2;
    mu = 0;
end

[errorcode p mu sigma] = distchck(3,p,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Allocate space for x.
x = zeros(size(p));

% Return NaN if the arguments are outside their respective limits.
k = find(sigma <= 0 | p < 0 | p > 1);
if any(k)
    tmp  = NaN;
    x(k) = tmp(ones(size(k))); 
end

% Put in the correct values when P is 1.
k = find(p == 1);
if any(k)
    tmp  = Inf;
    x(k) = tmp(ones(size(k))); 
end

% Compute the inverse function for the intermediate values.
k = find(p > 0  &  p < 1 & sigma > 0);
if any(k),
    x(k) = exp(sqrt(2) * sigma(k) .* erfinv(2 * p(k) - 1) + mu(k));
end
