function x = nctinv(p,nu,delta)
%NCTINV Inverse of the noncentral T cumulative distribution function (cdf).
%   X = NCTINV(P,NU,DELTA) Returns the inverse of the noncentral T cdf with 
%   NU degrees of freedom and noncentrality parameter, DELTA, for the  
%   probabilities, P.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 147-148.

%   B.A. Jones 1-26-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1997/11/29 01:46:04 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode, p, nu, delta] = distchck(3,p,nu,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize x to zero.
x = zeros(size(p));

%   Return NaN if the arguments are outside their respective limits.
k = find(p < 0 | p > 1 | nu < 1 | nu ~= round(nu));
if any(k),
   tmp  = NaN;
   x(k) = tmp(ones(size(k))); 
end

% The inverse cdf of 0 is -Inf, and the inverse cdf of 1 is Inf.
k0  = find(p == 0);
tmp = Inf;
if any(k0)
    x(k0) = -tmp(ones(size(k0)));
end
k1 = find(p ==1);
if any(k1)
    x(k1) =  tmp(ones(size(k1)));
end

% Newton's Method.
% Permit no more than count_limit interations.
count_limit = 100;
count = 0;

k = find(p > 0 & p < 1 & nu > 0 & delta > 0);
pk = p(k);
bigp = find(pk > 0.75);
smallp = find(pk <= 0.25);
vk = nu(k);
dk = delta(k);

% Use delta as a starting guess for x.
xk = dk;

h = ones(size(pk));
crit = 0.0001; 

% Break out of the iteration loop for the following:
%  1) The last update is very small (compared to x).
%  2) The last update is very small (compared to 100*eps).
%  3) There are more than 100 iterations. This should NEVER happen. 

while(any(abs(h) > crit * abs(xk)) & max(abs(h)) > crit  & count < count_limit), 
    count = count+1;
   ppred =  nctcdf(xk,vk,dk);
   dpred =  nctpdf(xk,vk,dk);
    h = (ppred - pk) ./ dpred;
    xnew = xk - h;

    xk = xnew;  
end

% Return the converged value(s).
x(k) = xk;

if count==count_limit, 
    fprintf('\nWarning: NCTINV did not converge.\n');
    str = 'The last step was:  ';
    outstr = sprintf([str,'%13.8f'],h);
    fprintf(outstr);
end

