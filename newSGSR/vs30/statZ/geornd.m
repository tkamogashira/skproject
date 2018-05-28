function r = geornd(p,m,n)
%GEORND Random matrices from geometric distribution.
%   R = GEORND(P) returns a matrix of random numbers chosen from a 
%   geometric distribution where the parameter, P, is the probability  
%   of success in any trial.
%
%   The size of R is the size of P. Alternatively, 
%   R = GEORND(P,M,N) returns an M by N matrix. 

%   The method is direct. (Devroye, page 87)

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:33 $

if nargin < 1, 
    error('Requires at least one input argument.'); 
end

if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,p);
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,1,p,m);
    p = p(ones(m(1),1),ones(m(2),1));

end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,1,p,m,n);
    p = p(ones(m,1),ones(n,1));
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);


k1 = find(p < 0 | p >= 1);
if any(k1) 
    tmp = NaN;
    r(k1) = tmp(ones(size(k1)));
end

k = find(p >= 0 & p < 1);
if any(k)
    u = rand(size(k));
    r(k) = floor(log(u) ./ log(1 - p(k)));
end
