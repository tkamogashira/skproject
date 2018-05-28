function p = nctcdf(x,nu,delta)
%NCTCDF Noncentral T cumulative distribution function (cdf).
%   P = NCTCDF(X,NU,DELTA) Returns the noncentral T cdf with NU 
%   degrees of freedom and noncentrality parameter, DELTA, at the values 
%   in X.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.     

%   References:
%      [1]  Johnson, Norman, and Kotz, Samuel, "Distributions in
%      Statistics: Continuous Univariate Distributions-2", Wiley
%      1970 p. 205.
%      [2]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 pp. 147-148.

%   B.A. Jones 8-22-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.8 $  $Date: 1998/05/26 18:37:02 $

if nargin <  3, 
    error('Requires three input arguments.'); 
end

[errorcode x nu delta] = distchck(3,x,nu,delta);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

if any(delta < 0)
   error('Noncentrality parameter delta has to be non-negative.');
end

% if some delta==0, call tcdf for those entries, call nctcdf for other entries.
f = (delta == 0);
if any(f(:))
   p = zeros(size(delta));
   p(f) = tcdf(x(f),nu(f));
   f1 = ~f;
   if any(f1)
      p(f1) = nctcdf(x(f1),nu(f1),delta(f1));
   end
   return
end

% Initialize P to zero.
[m,n] = size(x);
p = zeros(m,n);

% Probability that x < 0
p0 = normcdf(-delta,0,1);

kneg = find(x < 0);
kzero = find(x == 0);
kpos = 1:m*n;
kpos([kneg(:); kzero(:)]) = [];

%Value passed to Incomplete Beta function.
tmp = (x.^2)./(nu+x.^2);

% Set up for infinite sum.
done = 0;
j = 0;
jk9a  = zeros(size(x));
jk10a = zeros(size(x));
eterm = exp(-0.5*delta.^2);
seps = sqrt(eps);
qeps = eps^(1/4);

% Sum the series.
k0      = find(x~=0);
if any(k0)
   tmp = tmp(k0);
   nu = nu(k0);
   ld = log(0.5*delta(k0).^2);
   jk9 = zeros(size(k0));
   jk10 = zeros(size(k0));
   while 1
      ibeta9 = betainc(tmp,(j+1)/2,nu/2);    % Johnson & Kotz eqn. 9
      ibeta10 = betainc(tmp,(j+1/2),nu/2);    % Johnson & Kotz eqn. 10
      
      %Probability that t lies between 0 and x (x>0)
      nt9   = (exp(0.5*j*ld - gammaln(j/2+1))).*ibeta9;
      jk9   = jk9 + nt9;
      %Probability that t lies between x and -x.
      nt10  = (exp(j*ld - gammaln(j+1))).*ibeta10;
      jk10  = jk10 + nt10; 
      
      % Convergence test.
      if all((nt9./(jk9+qeps)) < seps) & all((nt10./(jk10+qeps)) < seps)
         jk9a(k0) = jk9;
         jk10a(k0) = jk10;
         break;
      end
      j = j+1;
   end
end

% Compute probability for non-negative Xs.
p = p0 + eterm.*jk9a/2;

% Compute probability for negative Xs. P(t < 0) + P(0 < t < |x|) - P(-|x| < t < |x|)
p(kneg) = p(kneg) - eterm(kneg).*jk10a(kneg);


% Return NaN if X is negative or NU is not a positive integer.
p(nu <= 0 | round(nu) ~= nu) = NaN;
