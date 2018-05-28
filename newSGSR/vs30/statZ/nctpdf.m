function y = nctpdf(x,v,delta)
%NCTPDF Noncentral T probability density function (pdf).
%   Y = NCTPDF(X,V,DELTA) Returns the noncentral T pdf with V degrees 
%   of freedom and noncentrality parameter, DELTA, at the values in X. 
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     

%   Reference:
%      [1]  Johnson, Norman, and Kotz, Samuel, "Distributions in
%      Statistics: Continuous Univariate Distributions-2", Wiley
%      1970 pp. 204-205 equation 8.
%      [2]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 pp. 147-148.

%   B.A. Jones 4-21-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1998/05/22 23:00:17 $


if nargin < 1, 
    error('Requires at least one input argument.');
end

[errorcode, x, v, delta] = distchck(3,x,v,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

if any(delta < 0)
   error('Noncentrality parameter delta has to be non-negative.');
end

% if some delta==0, call tcdf for those entries, call nctcdf for other entries.
f = (delta == 0);
if any(f(:))
   y = zeros(size(delta));
   y(f) = tpdf(x(f),v(f));
   f1 = ~f;
   if any(f1)
      y(f1) = nctpdf(x(f1),v(f1),delta(f1));
   end
   return
end

%   Initialize Y to zero.
y = zeros(size(x));

k = find(v > 0 & round(v) == v);
if any(k)
   nu = v(k);
   d = delta(k);
   t = x(k);
   lnu = log(nu+t.^2);
   lnu1 = gammaln((nu+1)/2);
   t = t.*d.*sqrt(2);
   term = exp(-0.5.*(log(pi)+log(nu)) -(d.^2)/2  + lnu1 - gammaln(nu/2) ...
      + ((nu+1)/2).*(log(nu)-lnu));
   
   infsum = zeros(size(k));
   qeps = eps^(3/4);
   % Set up for infinite sum.
   j = 0;
   % Sum the series.
   while 1
      newterm = (t.^j).*exp(gammaln((nu+j+1)/2)-lnu1-gammaln(j+1)-(j./2).*lnu);
      infsum = infsum + newterm;
      % Convergence test.
      if all(abs(newterm)./infsum < qeps)
         break;
      end
      j = j + 1;
   end
   y(k) = term .* infsum;
end

p(v <= 0 | round(v) ~= v) = NaN;
