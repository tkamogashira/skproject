function [muhat, muci] = expfit(x,alpha)
%EXPFIT Parameter estimates and confidence intervals for exponential data.
%   EXPFIT(X) Returns the maximum likelihood estimate of the parameter
%   of the exponential distribution given the data in X. 
%
%   [MUHAT, MUCI] = EXPFIT(X,ALPHA) gives MLEs and 100(1-ALPHA) 
%   percent confidence intervals given the data. By default, the
%   optional paramter ALPHA = 0.05 corresponding to 95% confidence intervals.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:16 $

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

muhat = mean(x);

if nargout > 1,
   lb = gaminv(alpha/2,m,muhat/m);
   ub = gaminv(1 - alpha/2,m,muhat/m);
   muci = [lb;ub];
end

