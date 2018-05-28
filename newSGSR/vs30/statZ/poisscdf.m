function p = poisscdf(x,lambda)
%POISSCDF Poisson cumulative distribution function.
%   P = POISSCDF(X,LAMBDA) computes the Poisson cumulative
%   distribution function with parameter LAMBDA at the values in X.
%
%   The size of P is the common size of X and LAMBDA. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.22.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/05/28 22:59:46 $
 
if nargin < 2, 
    error('Requires two input arguments.'); 
end

scalarlambda = (prod(size(lambda)) == 1);

[errorcode x lambda] = distchck(2,x,lambda);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p = zeros(size(x));

% Return NaN if Lambda is not positive.
p(lambda<=0) = NaN;

% Compute P when X is positive.
xx = floor(x);
k = find(xx >= 0 & lambda > 0);
val = max(xx(:));

if scalarlambda
  tmp = cumsum(poisspdf(0:val,lambda(1)));            
  p(k) = tmp(xx(k) + 1);
else
  i = [0:val]';
  compare = i(:,ones(size(k)));
  index = xx(k);
  index = index(:);
  index = index(:,ones(size(i)))';
  lambdabig = lambda(k);
  lambdabig = lambdabig(:);
  lambdabig = lambdabig(:,ones(size(i)))';
  p0 = poisspdf(compare,lambdabig);
  indicator = find(compare > index);
  p0(indicator) = zeros(size(indicator));
  p(k) = sum(p0,1);
end 

% Make sure that round-off errors never make P greater than 1.
p(p>1) = 1;
