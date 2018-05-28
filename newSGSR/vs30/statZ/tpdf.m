function y = tpdf(x,v)
% TPDF  Probability density function (pdf) for Student's T distribution
%   Y = TPDF(X,V) returns the pdf of Student's T distribution with
%   V degrees of freedom, at the values in X.
%   
%   The size of Y is the common size of X and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    

%   References:
%      [1]  E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, New York, 1970, Section 10.3, pages 144-146.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:51 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode x v] = distchck(2,x,v);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y = zeros(size(x));

k1 = find(v <= 0 | round(v) ~= v);
if any(k1)
    tmp   = NaN;
    y(k1) = tmp(ones(size(k1)));
end

% Use gammaln function to avoid overflows.
k = find(v > 0 & round(v) == v);
if any(k)
    term = exp(gammaln((v(k) + 1) / 2) - gammaln(v(k)/2));
    y(k) = term ./ (sqrt(v(k)*pi) .* (1 + (x(k) .^ 2) ./ v(k)) .^ ((v(k) + 1)/2));
end
