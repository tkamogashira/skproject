function x = poissinv(p,lambda)
%POISSINV Inverse of the Poisson cumulative distribution function (cdf).
%   X = POISSINV(P,LAMBDA) returns the inverse of the Poisson cdf 
%   with parameter lambda. Since the Poisson distribution is discrete,
%   POISSINV returns the smallest value of X, such that the poisson 
%   cdf evaluated, at X, equals or exceeds P.
%
%   The size of X is the common size of P and LAMBDA. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   B.A. Jones 1-15-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/09/02 22:24:14 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode p lambda] = distchck(2,p,lambda);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

x = zeros(size(p));

cumdist = poisspdf(0,lambda);
count = 0;

% Compare P to the poisson cdf.
k = find(lambda > 0 & p >= 0 & p < 1);
k = k(find(cumdist(k) < p(k)));
while ~isempty(k)
   count = count + 1;
   x(k) = count;
   cumdist(k) = cumdist(k) + poisspdf(count,lambda(k));
   k = k(find(cumdist(k) < p(k)));
end

% Return NaN if the arguments are outside their respective limits.
x(lambda <= 0 | p < 0 | p > 1) = NaN;

% Return Inf if p = 1 and lambda is positive.
x(lambda > 0 & p == 1) = Inf;

