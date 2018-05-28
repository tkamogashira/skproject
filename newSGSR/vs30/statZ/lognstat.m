function [m,v]= lognstat(mu,sigma);
%LOGNSTAT Mean and variance for the lognormal distribution.
%   [M,V] = LOGNSTAT(MU,SIGMA) returns the mean and variance of
%   the lognormal distribution with parameters MU and SIGMA.

%   Reference:
%      [1]  Mood, Alexander M., Graybill, Franklin A. and Boes, Duane C.,
%      "Introduction to the Theory of Statistics, Third Edition", McGraw Hill
%      1974 p. 540-541.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:47 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode mu sigma] = distchck(2,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

s2 = sigma .^ 2;

m = exp(mu + 0.5 * s2);
v = exp(2*(mu + s2)) - exp(2*mu + s2);

% Return NaN if SIGMA is negative or zero.
k = find(sigma <= 0);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k))); 
    v(k) = tmp(ones(size(k))); 
end
