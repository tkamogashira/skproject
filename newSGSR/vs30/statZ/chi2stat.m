function [m,v]= chi2stat(nu);
%CHI2STAT Mean and variance for the chi-square distribution.
%   [M,V] = CHI2STAT(NU) returns the mean and variance 
%   of the chi-square distribution with NU degrees of freedom.
%
%   A chi-square random variable, with NU degrees of freedom,
%   is identical to a gamma random variable with parameters NU/2 and 2.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986, pages 402-403.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:07 $

if nargin < 1, 
    error('Requires one input argument.'); 
end

[m v] = gamstat(nu/2,2);

% Return NaN if the degrees of freedom is not a positive integer.
k = find(nu <= 0  |  round(nu) ~= nu);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end
