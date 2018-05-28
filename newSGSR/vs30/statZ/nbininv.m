function x = nbininv(y,r,p)
%NBININV Inverse of the negative binomial cumulative distribution function (cdf).
%   X = NBININV(Y,R,P) returns the inverse of the negative binomial cdf with 
%   parameters R and P. Since the negative binomial distribution is discrete,
%   NBININV returns the least integer X such that the negative
%   binomial cdf evaluated at X, equals or exceeds Y.
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

%   B.A. Jones 1-24-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/09/11 19:28:58 $

if nargin < 3, 
    error('Requires three input arguments.'); 
end 

[errorcode y r p] = distchck(3,y,r,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end
k = 1:prod(size(y));
k1 = find(r < 1 | p < 0 | p > 1 | round(r) ~= r | y < 0 | y > 1 | isnan(y)); 
k2 = find(y == 1);

% Initialize X to 0.
x = zeros(size(y)); cumdist = x;
x(k2) = Inf;
x(k1) = NaN;
k([k1; k2]) = [];

% if nothing left, return.
if isempty(k), return; end

cumdist(k) = nbinpdf(0,r(k),p(k));

count = 0;

k = k(cumdist(k) < y(k));
while ~isempty(k)
   x(k) = x(k) + 1;
   count = count + 1;
   cumdist(k) = cumdist(k) + nbinpdf(count,r(k),p(k));
   k = k(cumdist(k) < y(k));
end


