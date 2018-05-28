function [logL,info] = normlike(params,data)
%NORMLIKE Negative normal log-likelihood function.
%   L = NORMLIKE(PARAMS,DATA) returns the negative of the normal log-likelihood 
%   function for the parameters PARAMS(1) = MU and PARAMS(12) = SIGMA, given
%   DATA. The length of the vector LOGL is the length of the vector DATA.     
%
%   [LOGL, INFO] = NORMLIKE(PARAMS,DATA) adds Fisher's information matrix,
%   INFO. The diagonal elements of INFO are the asymptotic variances of 
%   their respective parameters.
%
%   NORMLIKE is a utility function for maximum likelihood estimation. 
%   See also MLE. 


%   B.A. Jones 11-4-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:15 $

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

mu = params(1);
sigma = params(2);

mu = mu(ones(n,1),:);

sigma = params(2);
sigma = sigma(ones(n,1),:);

x = normpdf(data,mu,sigma);

logL = -sum(log(x));

if nargout == 2
  delta = sqrt(eps);
  xplus = normpdf([data data],[mu+delta mu],[sigma sigma+delta]);
  J = zeros(n,2);
  J = (log(xplus) - log([x x]))./delta;
  [Q,R]= qr(J,0);
  Rinv = R\eye(2);
  info = Rinv*Rinv';
end

