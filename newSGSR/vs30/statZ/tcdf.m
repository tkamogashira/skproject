function p = tcdf(x,v);
%TCDF   Student's T cumulative distribution function (cdf).
%   P = TCDF(X,V) computes the cdf for Student's T distribution 
%   with V degrees of freedom, at the values in X.
%
%   The size of P is the common size of X and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    
   
%   References:
%      [1] M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.7.
%      [2] L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986
%      [3] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, Section 10.3, pages 144-146.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:50 $

if nargin < 2, 
    error('Requires two input arguments.');
end

[errorcode x v] = distchck(2,x,v);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize P to zero.
p=zeros(size(x));

% use special cases for some specific values of v
k = find(v==1);
    % See Devroye pages 29 and 450.
    % (This is also the Cauchy distribution)
if any(k)
    p(k) = .5 + atan(x(k))/pi;
end

    % See Abramowitz and Stegun, formulas 26.5.27 and 26.7.1
    % separate into positive and negative components.
    
k = find(x > 0 & v ~= 1 & v > 0 & v == round(v));
if any(k),
    xx = v(k) ./ (v(k) + x(k).^2);
    temp = 1 - betainc(xx, v(k)/2, 0.5);
    % Now convert from P(|T| < t) = temp to what we want, 
    % i.e. P(T < t)
    p(k) = 1 - (1 - temp) / 2;
end

k = find(x < 0 & v ~= 1 & v > 0 & v == round(v));
if any(k),
    xx = v(k) ./ (v(k) + x(k).^2);
    temp = 1 - betainc(xx, v(k)/2, 0.5);
    % Now convert from P(|T| < t)=temp to what we want, 
    % i.e. P(T < t)
    p(k) = (1 - temp)/2;
end

k = find(x == 0 & v ~= 1 & v > 0 & v == round(v));
if any(k)
    p(k) = 0.5 * ones(size(k));
end

% Return NaN if the degrees of freedom is not a positive integer.
k = find(v <= 0  |  round(v) ~= v);
if any(k)
    tmp  = NaN;
    p(k) = tmp(ones(size(k)));
end
