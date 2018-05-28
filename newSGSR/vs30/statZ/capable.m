function [p, Cp, Cpk] = capable(data,specs)
%CAPABLE Capability indices.
%   CAPABLE(DATA,SPECS) returns the probability that a sample from
%   the process will fall outside the specifications, SPECS.
%   The assumptions are that the measured values in DATA are normally
%   distributed with constant mean and variance and the the measurements
%   are statistically independent.
%
%   SPECS is a two element vector containing a lower and upper bound. If
%   there is no lower bound, then use -Inf. Similarly, for no upper bound
%   use Inf.
%
%   [P, CP, CPK] = CAPABLE(DATA,SPECS) also returns the capability 
%   indices CP and CPK. 

%   Reference: Montgomery, Douglas, Introduction to Statistical
%   Quality Control, John Wiley & Sons 1991 p. 369-374.

%   B.A. Jones 2-14-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1998/05/28 20:13:54 $

if prod(size(specs)) ~= 2,
   error('Requires the second argument to be a two element vector.');
end

lb = specs(1);
ub = specs(2);
if lb > ub
  lb = specs(2);
  ub = specs(1);
end

if lb == -Inf & ub == Inf
   error('The vector of specifications must have at least one finite element');
end


[m,n] = size(data);
if min(m,n) ~= 1
   error('First argument has to be a vector.');
end

if m == 1
   m = n;
   data = data(:);
end

mu = mean(data);
sigma = std(data);

if lb == -Inf,
   p = 1 - normcdf(ub,mu,sigma);
   if nargout > 1
      Cp = NaN;
      Cpk = NaN;
      disp('Capability indices Cp and Cpk are undefined if there is no lower bound.');
   end
elseif ub == Inf,
   p = normcdf(lb,mu,sigma);
   if nargout > 1
      Cp = NaN;
      Cpk = NaN;
      disp('Capability indices Cp and Cpk are undefined if there is no upper bound.');
   end
else  
   p = 1 - diff(normcdf([lb ub],mu,sigma));
   Cp = (ub - lb)./(6.*sigma);
   Cpk = min((ub - mu)./(3.*sigma),(mu-lb)./(3.*sigma));
end


