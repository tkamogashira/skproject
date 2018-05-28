function [m,v]= normstat(mu,sigma);
%NORMSTAT Mean and variance for the normal distribution.
%   [M,V] = NORMSTAT(MU,SIGMA) returns the mean and variance of
%   the normal distribution with parameters MU and SIGMA.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.26.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:46:19 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode mu sigma] = distchck(2,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m = mu;
v = sigma .^ 2;

% Return NaN if SIGMA is negative or zero.
k = find(sigma <= 0);
if any(k)
    tmp  = NaN;
    m(k) = tmp(ones(size(k))); 
    v(k) = tmp(ones(size(k))); 
end
