function [lambdahat, lambdaci] = poissfit(x,alpha)
%POISSFIT Parameter estimates and confidence intervals for Poisson data.
%   POISSFIT(X) Returns the estimate of the parameter of the Poisson
%   distribution give the data X. 
%
%   [LAMBDAHAT, LAMBDACI] = POISSFIT(X,ALPHA) gives MLEs and 100(1-ALPHA) 
%   percent confidence intervals given the data. By default, the
%   optional paramter ALPHA = 0.05 corresponding to 95% confidence intervals.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:46:22 $

if nargin < 2 
    alpha = 0.05;
end


% Initialize params to zero.
[m, n] = size(x);
if min(m,n) == 1
   x = x(:);
   m = max(m,n);
   n = 1;
end

lambdahat = mean(x);

if nargout > 1,
   lsum = m*lambdahat;
   k = find(lsum < 100);
   if any(k)
      lb(k) = poissinv(alpha/2,lsum(k));
      ub(k) = poissinv(1 - alpha/2,lsum(k));
   end
   k = find(lsum >= 100);
   if any(k)
      lb(k) = norminv(alpha/2,lsum(k),sqrt(lsum(k)));
      ub(k) = norminv(1 - alpha/2,lsum(k),sqrt(lsum(k)));
   end
   
   lambdaci = [lb;ub]/m;
end

