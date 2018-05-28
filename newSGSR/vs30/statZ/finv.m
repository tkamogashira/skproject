function x = finv(p,v1,v2);
%FINV   Inverse of the F cumulative distribution function.
%   X=FINV(P,V1,V2) returns the inverse of the F distribution 
%   function with V1 and V2 degrees of freedom, at the values in P.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.2

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:21 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode p v1 v2] = distchck(3,p,v1,v2);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize Z to zero.
z = zeros(size(p));
x = zeros(size(p));

k = find(v1 <= 0 | v2 <= 0 | v1 ~= round(v1) | v2 ~= round(v2));
if any(k)
   tmp  = NaN;
   x(k) = tmp(ones(size(k)));
end

k1 = find(p > 0 & p < 1 & v1 > 0 & v2 > 0 & v1 == round(v1) & v2 == round(v2));
if any(k1)
    z = betainv(1 - p(k1),v2(k1)/2,v1(k1)/2);
    x(k1) = (v2(k1) ./ z - v2(k1)) ./ v1(k1);
end

k2 = find(p == 1 & v1 > 0 & v2 > 0 & v1 == round(v1) & v2 == round(v2));
if any(k2)
   tmp   = Inf;
   x(k2) = tmp(ones(size(k2)));
end
