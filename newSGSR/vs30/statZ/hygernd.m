function r = hygernd(m,k,n,mm,nn)
%HYGERND Random matrices from a hypergeometric distribution.
%   R = HYGERND(M,K,N) returns a matrix of random numbers chosen from
%   a hypergeometric distribution with parameters M, K, and N.
%   The size of R is the common size of M, K, and N. Alternatively,
%   R = HYGERND(M,K,N,MM,NN) returns an MM by NN matrix.
%
%   HYGERND uses an inversion method.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:40 $


if nargin < 3, 
    error('Requires at least three input arguments.'); 
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,3,m,k,n);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,3,m,k,n,mm);
end

if nargin == 5
    [errorcode rows columns] = rndcheck(5,3,m,k,n,mm,nn);
end

scalarm = (prod(size(m)) == 1);
scalark = (prod(size(k)) == 1);
scalarn = (prod(size(n)) == 1);

if scalarm,
    m = m(ones(rows,1),ones(columns,1));
end

if scalark,
    k = k(ones(rows,1),ones(columns,1));
end

if scalarn,
    n = n(ones(rows,1),ones(columns,1));
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);


k2 = find(n > k + m);   
if any(k2),
    tmp = NaN;
    r(k2) = tmp(ones(size(k2)));
end

k1 = find(n <= k + m);
if any(k1)
    u = rand(size(k1));
    r(k1) = hygeinv(u,m(k1),k(k1),n(k1));
end
