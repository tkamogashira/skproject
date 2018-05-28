function [phat, pci] = gamfit(x,alpha)
%GAMFIT Parameter estimates and confidence intervals for gamma distributed data.
%   GAMFIT(X) Returns the maximum likelihood estimates of the  
%   parameters of the gamma distribution given the data in the vector, X.  
%
%   [PHAT, PCI] = GAMFIT(X,ALPHA) gives MLEs and 100(1-ALPHA) 
%   percent confidence intervals given the data. By default, the
%   optional paramter ALPHA = 0.05 corresponding to 95% confidence intervals.

%   Reference:
%      [1]  Hahn, Gerald J., & Shapiro, Samuel, S.
%      "Statistical Models in Engineering", Wiley Classics Library
%      John Wiley & Sons, New York. 1994 p. 88.

%   B.A. Jones 10-5-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:45:26 $

if nargin < 2 
    alpha = 0.05;
end
p_int = [alpha/2; 1-alpha/2];

if min(size(x)) > 1
  error('The first argument in GAMFIT must be a vector.');
end


% Initialize params to zero.
[row, col] = size(x);

% Method of Moments Estimates.
xbar = mean(x);
s2   = var(x);

bhat = s2./xbar;
ahat = xbar./bhat;

phat = [ahat bhat];
phat = fmins('gamlike',phat,[],[],x);

if nargout == 2
   [logL,info]=gamlike(phat,x);
   sigma = sqrt(diag(info));
   pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);
end 
