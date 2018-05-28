function y = lognpdf(x,mu,sigma)
%LOGNPDF Lognormal probability density function (pdf).
%   Y = LOGNPDF(X,MU,SIGMA) Returns the lognormal pdf at the values
%   in X. The mean and standard deviation of log(Y) are MU and SIGMA.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     
%
%   Default values for MU and SIGMA are 0 and 1 respectively.

%   Reference:
%      [1]  Mood, Alexander M., Graybill, Franklin A. and Boes, Duane C.,
%      "Introduction to the Theory of Statistics, Third Edition", McGraw Hill
%      1974 p. 540-541.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/05/29 21:27:33 $

if nargin < 3, 
    sigma = 1;
end

if nargin < 2;
    mu = 0;
end

if nargin < 1, 
    error('Requires at least one input argument.');
end

[errorcode x mu sigma] = distchck(3,x,mu,sigma);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize Y to zero.
y = zeros(size(x));

k = find(sigma > 0 & x > 0);
if any(k)
    xn = (log(x(k)) - mu(k)) ./ sigma(k);
    y(k) = exp(-0.5 * xn .^2) ./ (x(k) .* sqrt(2*pi) .* sigma(k));
end

% Return NaN if SIGMA is negative or zero.
y(sigma <= 0 | x < 0) = NaN;
