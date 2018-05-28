function p = ncfcdf(x,nu1,nu2,delta)
%NCFCDF Noncentral F cumulative distribution function (cdf).
%   P = NCFCDF(X,NU1,NU2,DELTA) Returns the noncentral F cdf with numerator 
%   degrees of freedom (df), NU1, denominator df, NU2, and noncentrality
%   parameter, DELTA, at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     

%   References:
%      [1]  Johnson, Norman, and Kotz, Samuel, "Distributions in
%      Statistics: Continuous Univariate Distributions-2", Wiley
%      1970 p. 192.
%      [2]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 73-74.

%   B.A. Jones 2-7-95, ZP You 9-17-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/09/18 14:10:48 $

if nargin <  4,
    error('Requires four input arguments.'); 
end

[errorcode x nu1 nu2 delta] = distchck(4,x,nu1,nu2,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

[m,n] = size(x);

% Initialize p to zero.
y = zeros(m,n);
p = y;

k = (nu1 <= 0 | round(nu1) ~= nu1 | nu2 <= 0 | round(nu2) ~= nu2 | x < 0 | delta < 0);
k1 = ~k;
% set Y to NaN for indices where X is negative or NU1 or NU2 are not positives integers.
p(k) = NaN;
if ~any(k1), return; end

if any(k) % reset variable so that we don't have to deal with bad indices.
   y = y(k1);
   x = x(k1);
   nu1 = nu1(k1);
   nu2 = nu2(k1);
   delta = delta(k1);
end

% to simply computation, pre-divide nu1,nu2 and delta
nu1 = nu1/2; nu2 = nu2/2; delta = delta/2;


%Value passed to Beta distribution function.
tmp = nu1.*x./(nu2+nu1.*x);
j = 0;
epsq = eps^(1/4);
epsr = sqrt(eps);

% Sum the series.
while j < 1000 % so that we don't get into a infinit loop
   deltay = poisspdf(j,delta).*betacdf(tmp,j+nu1,nu2);
   y = y + deltay;
   
   % Convergence test.
   if all(deltay(:)./(y(:)+epsq) < epsr), break; end
   j = j + 1;
end

if (j == 1000) 
  warning('Failed to converge, use the result cautiously.\n');
end

p(k1) = y;
