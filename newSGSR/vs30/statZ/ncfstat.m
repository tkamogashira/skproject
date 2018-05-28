function [m,v]= ncfstat(nu1,nu2,delta)
%NCFSTAT Mean and variance for the noncentral F distribution.
%   [M,V] = NCFSTAT(NU1,NU2,DELTA) returns the mean and variance
%   of the noncentral F pdf with NU1 and NU2 degrees of freedom and
%   noncentrality parameter, DELTA.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 73-74.

%   B.A. Jones 2-7-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:02 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode, nu1, nu2, delta] = distchck(3,nu1,nu2,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize the mean and variance to zero.
m = zeros(size(delta));
v = zeros(size(delta));

% Return NaN for mean and variance if NU2 is less than 2.
k = find(nu2 <= 2 | any(any(round(nu1) ~= nu1)) | any(any(round(nu2) ~= nu2)));
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end

% Return NaN for variance if NU2 is less than 4.
k = find(nu2 == 4);
if any(k)
   tmp  = NaN;
   v(k) = tmp(ones(size(k))); 
end

k = find(nu2 > 2 & round(nu1) == nu1 & round(nu2) == nu2);
if any(k)
   m(k) = nu2(k).*(nu1(k) + delta(k))./(nu1(k).*(nu2(k) - 2));
end

k = find(nu2 > 4 &  round(nu1) == nu1 & round(nu2) == nu2);
if any(k)
   n1pd = nu1(k) + delta(k);
   n2m2 = nu2(k) - 2;
   n1dn2 = (nu1(k)./nu2(k)).^2;
   v(k) = 2*n1dn2.*(n1pd.^2 + (nu1(k) + 2*delta(k).*n2m2)./((nu2(k) - 4).*n2m2.^2));
end
