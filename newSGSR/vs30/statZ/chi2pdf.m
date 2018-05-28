function y = chi2pdf(x,v)
%CHI2PDF Chi-square probability density function (pdf).
%   Y = CHI2PDF(X,V) returns the chi-square pdf with V degrees  
%   of freedom at the values in X. The chi-square pdf with V 
%   degrees of freedom, is the gamma pdf with parameters V/2 and 2.
%
%   The size of Y is the common size of X and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986, pages 402-403.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/09/30 19:12:39 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode x v] = distchck(2,x,v);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y=zeros(size(x));

y = gampdf(x,v/2,2);

