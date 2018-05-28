function r = unidrnd(n,mm,nn)
%UNIDRND Random matrices from the discrete uniform distribution.
%   R = UNIDRND(N) returns a matrix of random numbers chosen 
%   uniformly from the set {1, 2, 3, ... ,N}.
%
%   The size of R is the size of N. Alternatively, 
%   R = UNIDRND(N,MM,NN) returns an MM by NN matrix. 

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:58 $

if nargin < 1, 
    error('Requires at least one input argument.'); 
end

if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,n);
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,1,n,mm);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,1,n,mm,nn);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

r = ceil(n .* rand(rows,columns));

k1 = find(n < 0 | round(n) ~= n);
if any(k1) 
    tmp = NaN;
    r(k1) = tmp(ones(size(k1)));
end
