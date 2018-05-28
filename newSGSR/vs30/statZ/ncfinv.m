function x = ncfinv(p,nu1,nu2,delta)
%NCFINV Inverse of the noncentral F cumulative distribution function (cdf).
%   X = NCFINV(P,NU1,NU2,DELTA) Returns the inverse of the noncentral F cdf with 
%   numerator degrees of freedom (df), NU1, denominator df, NU2, and noncentrality
%   parameter, DELTA, for the probabilities, P.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 73-74.

%   B.A. Jones 2-7-95, ZP You 9/17-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/09/30 19:12:39 $

if nargin <  4, 
    error('Requires four input arguments.'); 
end

[errorcode, p, nu1, nu2, delta] = distchck(4,p,nu1,nu2,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize x to zero.
x = zeros(size(p)); y = ones(size(p));

%   Return NaN if the arguments are outside their respective limits.
k1 = (p < 0 | p > 1 | nu1 < 1 | nu1 ~= round(nu1) | nu2 < 1 | nu2 ~= round(nu2) | delta < 0);
k2 = (p == 0); k3 = (p == 1);
k4 = (k1 | k2 | k3);
k = ~k4;
% The inverse cdf of 0 is 0, and the inverse cdf of 1 is Inf.
x(k2) = 0; x(k3) = Inf; 
% assign NaN to illegal indices
x(k1) = NaN;
% if nothing left, return;
if isempty(k), return; end

if any(k4) % reset variable so that we don't have to deal with unneccessary indices.
   y = y(k);
   p = p(k);
   nu1 = nu1(k);
   nu2 = nu2(k);
   delta = delta(k);
end

% Newton's Method.
% Permit no more than count_limit interations.
count_limit = 100;
count = 0;

h = y;
ah = h;
crit = sqrt(eps); 

% Break out of the iteration loop for the following:
%  1) The last update is very small (compared to x).
%  2) The last update is very small (compared to 100*eps).
%  3) There are more than 100 iterations. This should NEVER happen. 

while(any(ah > crit * abs(y)) & max(ah) > crit & count < count_limit)
   
   count = count+1;    
   h = (ncfcdf(y,nu1,nu2,delta) - p) ./ ncfpdf(y,nu1,nu2,delta);
   ynew = y-h;
   
   % Make sure that the values stay inside the bounds.
   % Initially, Newton's Method may take big steps.
   ksmall = find(ynew < 0);
   ynew(ksmall) = y(ksmall)/10;
   y = ynew;  
   ah = abs(h);
end

% Return the converged value(s).
x(k) = y;

if count==count_limit, 
    fprintf('\nWarning: NCFINV did not converge.\n');
    fprintf(['The last step was:  ' num2str(h) '\n']);
end

