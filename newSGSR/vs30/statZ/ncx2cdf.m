function p = ncx2cdf(x,v,delta)
%NCX2CDF Noncentral chi-square cumulative distribution function (cdf).
%   P = NCX2CDF(X,V,DELTA) Returns the noncentral chi-square cdf with V 
%   degrees of freedom and noncentrality parameter, DELTA, at the values 
%   in X.
%
%   The size of P is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     
%
%   Some texts refer to this distribution as the generalized Rayleigh,
%   Rayleigh-Rice, or Rice distribution.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 50-52.

%   B.A. Jones 4-29-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/12/17 21:40:15 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode x v delta] = distchck(3,x,v,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p = zeros(size(x));

% Set up for infinite sum.
done = 0;
counter = 0;

% Sum the series.
s = sqrt(eps);
while ~done
   pplus = poisspdf(counter,delta/2).*chi2cdf(x,v+2*counter);
   p = p + pplus;

   % Convergence test.
   k = find(~isnan(pplus));
   if all((pplus(k)./(p(k)+s)) < s)
      done = 1;
   end
   counter = counter + 1;
end
