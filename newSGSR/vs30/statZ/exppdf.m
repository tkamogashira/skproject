function y = exppdf(x,mu)
%EXPPDF Exponential probability density function.
%   Y = EXPPDF(X,MU) returns the exponential probability density 
%   function with parameter MU at the values in X.
%
%   The size of Y is the common size of X and MU. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Reference:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.28.

%     Copyleft (c) 1993-98 by The MashWorks, Inc.
%     $Revision: 2.7 $  $Date: 1997/11/29 01:45:17 $

if nargin <  1, 
    error('Requires at least one input argument.');
end

% Set the default mean to 1.
if nargin < 2,
    mu = 1;
end

[errorcode x mu] = distchck(2,x,mu);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y=zeros(size(x));

% Return NaN if MU is not positive.
k1 = find(mu <= 0);
if any(k1)
    tmp = NaN; 
    y(k1) = tmp(ones(size(k1)));
end

k=find(mu > 0 & x >= 0);
if any(k),
    y(k) = exp(-x(k) ./ mu(k)) ./ mu(k);
end
