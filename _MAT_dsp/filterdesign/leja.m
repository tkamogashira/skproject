function x_out = leja(x_in)
%LEJA   Order roots in a way suitable to compute polynomial coefficients.
%    Y = LEJA(X) orders the values x_in (supposed to be the roots of a 
%    polynomial) in a way that computing the polynomial coefficients by
%    using POLY(Y) yields numerically accurate results.
%
%    Example:
%               z=exp(j*(1:100)*2*pi/100);
%               p1 = poly(z);
%               p2 = poly(leja(z));
%    % Computing p1 and p2 should lead to the polynomial x^100-1. 
%
%    % LEJA is by Markus Lang, and is available from the Rice University DSP
%    % webpage: www.dsp.rice.edu


%   Author(s): Markus Lang
%   Copyright 2004-2008 The MathWorks, Inc.


x = x_in(:).'; n = length(x);

a = x(ones(1,n+1),:);
a(1,:) = abs(a(1,:));

[dum1,ind] = max(a(1,1:n));  
if ind~=1
  dum2 = a(:,1);  a(:,1) = a(:,ind);  a(:,ind) = dum2;
end
x_out(1) = a(n,1);
a(2,2:n) = abs(a(2,2:n)-x_out(1));

for l=2:n-1
  [dum1,ind] = max(prod(a(1:l,l:n)));  ind = ind+l-1;
  if l~=ind
    dum2 = a(:,l);  a(:,l) = a(:,ind);  a(:,ind) = dum2;
  end
  x_out(l) = a(n,l);
  a(l+1,(l+1):n) = abs(a(l+1,(l+1):n)-x_out(l));
end
x_out = a(n+1,:);


% [EOF]
