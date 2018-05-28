function x = chi2inv(p,v);
%CHI2INV Inverse of the chi-square cumulative distribution function (cdf).
%   X = CHI2INV(P,V)  returns the inverse of the chi-square cdf with V  
%   degrees of freedom at the values in P. The chi-square cdf with V 
%   degrees of freedom, is the gamma cdf with parameters V/2 and 2.   
%
%   The size of X is the common size of P and V. A scalar input
%   functions as a constant matrix of the same size as the other input.   

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.4.
%      [2] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, section 10.2 (page 144)

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:05 $

if nargin < 2, 
    error('Requires two input arguments.');
end

[errorcode p v] = distchck(2,p,v);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Call the gamma inverse function. 
x = gaminv(p,v/2,2);

% Return NaN if the degrees of freedom is not a positive integer.
k = find(v < 0  |  round(v) ~= v);
if any(k)
    tmp  = NaN;
    x(k) = tmp(ones(size(k)));
end
