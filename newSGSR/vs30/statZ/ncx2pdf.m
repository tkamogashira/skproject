function y = ncx2pdf(x,v,delta)
%NCX2PDF Noncentral chi-square probability density function (pdf).
%   Y = NCX2PDF(X,V,DELTA) Returns the noncentral chi-square pdf with V 
%   degrees of freedom and noncentrality parameter, DELTA, at the values 
%   in X.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     
%
%   Some texts refer to this distribution as the generalized Rayleigh,
%   Rayleigh-Rice, or Rice distribution.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 50-52.

%   B.A. Jones 4-29-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/05/29 19:46:27 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode x v delta] = distchck(3,x,v,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero.
y=zeros(size(x));

% Set up for infinite sum.
done = 0;
counter = 0;
s = sqrt(eps);

% Sum the series.
while ~done
   yplus  = poisspdf(counter,delta/2).*chi2pdf(x,v+2*counter);
   y    = y + yplus;
   % Convergence test.
   k = find(~isnan(yplus));
   if all((yplus(k)./(y(k)+s)) < s)
      done = 1;
   end
   counter = counter + 1;
end
