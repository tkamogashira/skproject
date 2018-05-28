function x = gaminv(p,a,b);
%GAMINV Inverse of the gamma cumulative distribution function (cdf).
%   X = GAMINV(P,A,B)  returns the inverse of the gamma cdf with  
%   parameters A and B, at the probabilities in P.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   GAMINV uses Newton's method to converge to the solution.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 6.5.

%   B.A. Jones 1-12-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:26 $

if nargin<3, 
    b=1;
end

[errorcode p a b] = distchck(3,p,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize X to zero.
x = zeros(size(p));

k = find(p<0 | p>1 | a <= 0 | b <= 0);
if any(k),
    tmp  = NaN;
    x(k) = tmp(ones(size(k)));
end

% The inverse cdf of 0 is 0, and the inverse cdf of 1 is 1.  
k0 = find(p == 0 & a > 0 & b > 0);
if any(k0),
    x(k0) = zeros(size(k0)); 
end

k1 = find(p == 1 & a > 0 & b > 0);
if any(k1), 
    tmp = Inf;
    x(k1) = tmp(ones(size(k1))); 
end

% Newton's Method
% Permit no more than count_limit interations.
count_limit = 100;
count = 0;

k = find(p > 0  &  p < 1 & a > 0 & b > 0);
pk = p(k);

% Supply a starting guess for the iteration.
%   Use a method of moments fit to the lognormal distribution. 
mn = a(k) .* b(k);
v = mn .* b(k);
temp = log(v + mn .^ 2); 
mu = 2 * log(mn) - 0.5 * temp;
sigma = -2 * log(mn) + temp;
xk = exp(norminv(pk,mu,sigma));

h = ones(size(pk)); 

% Break out of the iteration loop for three reasons:
%  1) the last update is very small (compared to x)
%  2) the last update is very small (compared to sqrt(eps))
%  3) There are more than 100 iterations. This should NEVER happen. 

while(any(abs(h) > sqrt(eps)*abs(xk))  &  max(abs(h)) > sqrt(eps)    ...
                                 & count < count_limit), 
                                 
    count = count + 1;
    h = (gamcdf(xk,a(k),b(k)) - pk) ./ gampdf(xk,a(k),b(k));
    xnew = xk - h;
    % Make sure that the current guess stays greater than zero.
    % When Newton's Method suggests steps that lead to negative guesses
    % take a step 9/10ths of the way to zero:
    ksmall = find(xnew < 0);
    if any(ksmall),
        xnew(ksmall) = xk(ksmall) / 10;
        h = xk-xnew;
    end
    xk = xnew;
end


% Store the converged value in the correct place
x(k) = xk;

if count == count_limit, 
    fprintf('\nWarning: GAMINV did not converge.\n');
    str = 'The last step was:  ';
    outstr = sprintf([str,'%13.8f'],h);
    fprintf(outstr);
end
