function [logL, info] = weiblike(params,data)
%WEIBLIKE Weibull log-likelihood function.
%   L = WEIBLIKE(params,data) returns the Weibull log-likelihood with 
%   parameters PARAMS(1) = A and PARAMS(2) = B given DATA.
%   [LOGL, INFO] = WEIBLIKE(PARAMS,DATA) adds Fisher's information matrix,
%   INFO. The diagonal elements of INFO are the asymptotic variances of 
%   their respective parameters.
%
%   WEIBLIKE is a utility function for maximum likelihood estimation. 
%
%   See also BETALIKE, GAMLIKE, MLE, WEIBFIT, WEIBPLOT. 

%   References:
%      [1] J. K. Patel, C. H. Kapadia, and D. B. Owen, "Handbook
%      of Statistical Distributions", Marcel-Dekker, 1976.

%   B.A. Jones 11-4-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/07/21 15:04:40 $


if nargin < 2, 
    error('Requires at least two input arguments'); 
end

[n, m] = size(data);

if nargout == 2 & max(m,n) == 1
    error('To compute the 2nd output, the 2nd input must have at least two elements.');
end

if n == 1
   data = data';
   n = m;
end

a = params(1);
b = params(2);

a = a(ones(n,1),:);

b = params(2);
b = b(ones(n,1),:);

x = weibpdf(data,a,b)+eps;

logL = -sum(log(x));

if nargout == 2
  delta = sqrt(eps);
  xplus = weibpdf([data data],[a+delta a],[b b+delta])+eps;
  J = zeros(n,2);
  J = (log(xplus) - log([x x]))./delta;
  [Q,R]= qr(J,0);
  Rinv = R\eye(2);
  info = Rinv'*Rinv;
end
