function [logL,info] = gamlike(params,data)
%GAMLIKE Negative gamma log-likelihood function.
%   L = GAMLIKE(PARAMS,DATA) returns the negative of the gamma log-likelihood 
%   function for the parameters PARAMS(1) = A and PARAMS(12) = B, given DATA.
%   The length of the vector LOGL is the length of the vector DATA.     
%
%   [LOGL, INFO] = GAMLIKE(PARAMS,DATA) adds Fisher's information matrix,
%   INFO. The diagonal elements of INFO are the asymptotic variances of 
%   their respective parameters.
%
%   GAMLIKE is a utility function for maximum likelihood estimation. 
%   See also MLE. 


%   B.A. Jones 11-4-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1997/11/29 01:45:27 $

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

x = gampdf(data,a,b);

logL = -sum(log(x));

if nargout == 2
  delta = sqrt(eps);
  xplus = gampdf([data data],[a+delta a],[b b+delta]);
  J = zeros(n,2);
  J = (log(xplus) - log([x x]))./delta;
  [Q,R]= qr(J,0);
  Rinv = R\eye(2);
  info = Rinv*Rinv';
end
