function x = unidinv(p,n);
%UNIDINV Inverse of uniform (discrete) distribution function.
%   X = UNIDINV(P,N) returns the inverse of the uniform
%   (discrete) distribution function at the values in P.
%   X takes the values (1,2,...,N).
%   
%   The size of X is the common size of P and N. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:56 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode p n] = distchck(2,p,n);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize X to zero.
x = zeros(size(p));

%   Return NaN if the arguments are outside their respective limits.
k1 = find(p <= 0 | p > 1 | n < 1 | round(n) ~= n);
if any(k1),
    tmp   = NaN;
    x(k1) = tmp(ones(size(k1)));
end

k = find(p > 0 & p <= 1 & n >= 1 & round(n) == n);
if any(k)
    x(k) = ceil(n(k) .* p(k));
end
