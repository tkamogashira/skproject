function [phat, pci] = binofit(x,n,alpha)
%BINOFIT Parameter estimates and confidence intervals for binomial data.
%   BINOFIT(X,N) Returns the estimate of the probability of success 
%   for the binomial distribution given the data in the vector, X.  
%
%   [PHAT, PCI] = BINOFIT(X,N,ALPHA) gives MLEs and 100(1-ALPHA) 
%   percent confidence intervals given the data. By default, the
%   optional paramter ALPHA = 0.05 corresponding to 95% confidence intervals.

%   Reference:
%      [1]  Johnson, Norman L., Kotz, Samuel, & Kemp, Adrienne W.,
%      "Univariate Discrete Distributions, Second Edition", Wiley
%      1992 p. 124-130.

%   B.A. Jones 7-27-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/05/28 20:13:53 $

if nargin < 3 
    alpha = 0.05;
end


% Initialize params to zero.
[row, col] = size(x);
if min(row,col) ~= 1
   error('First argument has to be a vector..');
end

[r1,c1] = size(n);
if max(r1,c1) == 1
   n = n(ones(size(x)));
   r1 = row;
   c1 = col;
end
if row ~= r1 | col ~= c1
   error('The first two inputs must match in size.');
end

phat = x./n;

if nargout > 1,
   nu1 = 2*x;
   nu2 = 2*(n-x+1);

   F   = finv(alpha/2,nu1,nu2);
   lb  = (nu1.*F)./(nu2 + nu1.*F);

   xeq0 = find(x == 0);
   if ~isempty(xeq0)
      lb(xeq0) = 0;
   end
   
   nu1 = 2*(x+1);
   nu2 = 2*(n-x);
    
   F   = finv(1-alpha/2,nu1,nu2);
   ub = (nu1.*F)./(nu2 + nu1.*F);
   
   xeqn = find(x == n);
   if ~isempty(xeqn)
      ub(xeqn) = 1;
   end

   pci = [lb ub];
end

