function r=binornd(n,p,mm,nn)
% BINORND Random matrices from a binomial distribution.
%   R = BINORND(N,P,MM,NN)  is an MM-by-NN matrix of random
%   numbers chosen from a binomial distribution with parameters N and P.
%
%   The size of R is the common size of N and P if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. 
%   Alternatively, R = BINORND(N,P,MM,NN) returns an MM by NN matrix. 
%
%   The method is direct using the definition of the binomial
%   distribution as a sum of Bernoulli random variables.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986
%   See Lemma 4.1 on page 428, method on page 524.

%   B.A. Jones 1-12-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:44:57 $

if nargin < 2, 
    error('Requires at least two input arguments.'); 
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,n,p);
   if max(size(p)) == 1 & max(size(n)) > 1
      p = p(ones(size(n)));
   end   
   if max(size(n)) == 1 & max(size(p)) > 1
      n = n(ones(size(p)));
   end
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,n,p,mm);
    n = n(ones(mm(1),1),ones(mm(2),1));
    p = p(ones(mm(1),1),ones(mm(2),1));

end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,n,p,mm,nn);
    n = n(ones(mm,1),ones(nn,1));
    p = p(ones(mm,1),ones(nn,1));
end

if errorcode > 0
    error('Size information is inconsistent.');
end

r = zeros(rows,columns);

for i = 1:max(max(n))
    u = rand(rows,columns);
    k1 = find(n >= i);
    k2 = find(u(k1) < p(k1));
    r(k1(k2)) = r(k1(k2)) + 1;
end

k= find(p < 0 | p > 1 | n < 0);
if any(k)
    tmp  = NaN;
    r(k) = tmp(ones(size(k)));
end
