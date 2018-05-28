function y = fpdf(x,v1,v2)
%FPDF   F probability density function.
%   Y = FPDF(X,V1,V2) returns the F distribution probability density
%   function with V1 and V2 degrees of freedom at the values in X.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   References:
%      [1] J. K. Patel, C. H. Kapadia, and D. B. Owen, "Handbook
%      of Statistical Distributions", Marcel-Dekker, 1976.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:21 $

if nargin < 3, 
    error('Requires three input arguments.'); 
end

[errorcode x v1 v2] = distchck(3,x,v1,v2);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize Y to zero.
y = zeros(size(x));

k1 = find(v1 < 1 | v2 < 1 | v1 ~= round(v1) | v2 ~= round(v2));
if any(k1)
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1)));
end

k = find(x > 0 & v1 >= 1 & v2 >= 1 & v1 == round(v1) & v2 == round(v2));
if any(k)
    xk = x(k);

    temp = (v1(k) ./ v2(k)) .^ (v1(k)/2) .* xk .^ ((v1(k)-2)/2) ./ beta(v1(k)/2,v2(k)/2);
    y(k) = temp .* (1 + v1(k) ./v2(k) .* xk) .^ (-(v1(k) + v2(k)) / 2);
end
