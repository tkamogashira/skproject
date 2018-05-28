function p = raylcdf(x,b)
%RAYLCDF  Rayleigh cumulative distribution function.
%   P = RAYLCDF(X,B) returns the Rayleigh cumulative distribution 
%   function with parameter B at the values in X.
%
%   The size of P is the common size of X and B. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 134-136.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:32 $

if nargin <  1, 
    error('Requires at least one input argument.'); 
end

[errorcode x b] = distchck(2,x,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p=zeros(size(x));

% Return NaN if B is not positive.
k1 = find(b <= 0);
if any(k1) 
    tmp   = NaN;
    p(k1) = tmp(ones(size(k1)));
end

k=find(b > 0 & x >= 0);
if any(k),
   xk = x(k);
   bk = b(k);
    p(k) = 1 - exp(-xk .^ 2 ./ (2*bk .^ 2));
end
