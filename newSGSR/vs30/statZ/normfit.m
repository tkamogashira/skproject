function [muhat, sigmahat, muci, sigmaci] = normfit(x,alpha)
%NORMFIT Parameter estimates and confidence intervals for normal data.
%   NORMFIT(X,ALPHA) Returns estimates of the parameters of the 
%   normal distribution given the data in X. 
%
%   [MUHAT,SIGMAHAT,MUCI,SIGMACI] = NORMFIT(X,ALPHA) gives the minimum
%   variance unbiased estimates of the parameters of the normal distribution 
%   and 100(1-ALPHA) percent confidence intervals given the data.
%   By default the optional paramter ALPHA = 0.05 corresponding
%   to 95% confidence intervals. 

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:14 $

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

params = zeros(2,n);

muhat = mean(x);
sigmahat = std(x);

if nargout > 2,
   muci = zeros(2,n);
   sigmaci = zeros(2,n);

   tcrit = tinv([alpha/2 1-alpha/2],m-1);
   muci = [(muhat + tcrit(1)*sigmahat/sqrt(m));...
           (muhat + tcrit(2)*sigmahat/sqrt(m))];

   chi2crit = chi2inv([alpha/2 1-alpha/2],m-1);
   sigmaci =  [(sigmahat*sqrt((m-1)./chi2crit(2)));
               (sigmahat*sqrt((m-1)./chi2crit(1)))];

end

