function p = fcdf(x,v1,v2);
%FCDF   F cumulative distribution function.
%   P = FCDF(X,V1,V2) returns the F cumulative distribution function
%   with V1 and V2 degrees of freedom at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:19 $

if nargin < 3, 
    error('Requires three input arguments.'); 
end

[errorcode x v1 v2] = distchck(3,x,v1,v2);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize P to zero.
p = zeros(size(x));

k1 = find(v1 <= 0 | v2 <= 0 | round(v1) ~= v1 | round(v2) ~= v2);
tmp   = NaN;
p(k1) = tmp(ones(size(k1)));

% Compute P when X > 0.
k = find(x > 0 & ~(v1 <= 0 | v2 <= 0 | round(v1) ~= v1 | round(v2) ~= v2));
if any(k), 
% use A&S formula 26.6.2 to relate to incomplete beta function 
    xx = v2(k) ./ (v2(k) + v1(k) .* x(k));
    p(k) = 1 - betainc( xx, v2(k)/2, v1(k)/2 );
end
