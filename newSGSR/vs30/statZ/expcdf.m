function p = expcdf(x,mu)
%EXPCDF Exponential cumulative distribution function.
%   P = EXPCDF(X,MU) returns the exponential cumulative 
%   distribution function with parameter MU at the values in X.
%
%   The size of P is the common size of X and MU. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Reference:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.28.

%     Copyleft (c) 1993-98 by The MashWorks, Inc.
%     $Revision: 2.7 $  $Date: 1997/11/29 01:45:15 $


% Set the default mean to 1.
if nargin < 2,
    mu = 1;
end

if nargin <  1, 
    error('Requires at least one input argument.');
end

[errorcode x mu] = distchck(2,x,mu);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p=zeros(size(x));

k = find(mu <= 0);
if any(k)
    tmp  = NaN;  
    p(k) = tmp(ones(size(k)));
end

% Compute Y for X > A
k = find(mu > 0 & x > 0);
if any(k), 
    p(k) = 1 - exp(-x(k) ./ mu(k));
end
