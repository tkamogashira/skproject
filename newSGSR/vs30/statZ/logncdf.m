function p = logncdf(x,mu,sigma)
%LOGNCDF Lognormal cumulative distribution function (cdf).
%   P = LOGNCDF(X,MU,SIGMA) computes the lognormal cdf with mean MU and
%   standard deviation SIGMA at the values in X.
%
%   The size of P is the common size of X, MU and SIGMA. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   Default values for MU and SIGMA are 0 and 1 respectively.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 102-105.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/05/22 23:00:15 $

if nargin < 3, 
    sigma = 1;
end

if nargin < 2;
    mu = 0;
end

[errorcode x mu sigma] = distchck(3,x,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize P to zero.
p = zeros(size(x));

% Return NaN if SIGMA and x are not positive.
p(sigma <= 0 | x < 0) = NaN;

% Express lognormal CDF in terms of the error function.
k = find(sigma > 0 & x > 0);
p(k) = 0.5 * (1 + erf((log(x(k)) - mu(k)) ./ (sigma(k) * sqrt(2))));

% Make sure that round-off errors never make P greater than 1.
p(p > 1) = 1;
