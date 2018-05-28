function rnd =nbinrnd(r,p,m,n)
%NBINRND Random matrices from a negative binomial distribution.
%   RND = NBINRND(R,P,M,N)  is an M-by-N matrix of random
%   numbers chosen from a negative binomial distribution with parameters R and P.
%
%   The size of RND is the common size of R and P if both are matrices.
%   If either parameter is a scalar, the size of RND is the size of the other
%   parameter. 
%   Alternatively, RND = NBINRND(R,P,M,N) returns an M by N matrix. 

%   B.A. Jones 1-24-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:58 $

if nargin < 2, 
    error('Requires at least two input arguments.'); 
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,r,p);
    if max(size(r)) == 1,r = r(ones(rows,1),ones(columns,1));end
    if max(size(p)) == 1,p = p(ones(rows,1),ones(columns,1));end
end


if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,r,p,m);
    r = r(ones(m(1),1),ones(m(2),1));
    p = p(ones(m(1),1),ones(m(2),1));

end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,r,p,m,n);
    r = r(ones(m,1),ones(n,1));
    p = p(ones(m,1),ones(n,1));
end

if errorcode > 0
    error('Size information is inconsistent.');
end

rnd = zeros(rows,columns);
plong = p(:)';
rlong = r(:)';
maxr = max(rlong);
if maxr == 1;
   rnd = geornd(p);
   return;
end
pbig = plong(ones(maxr,1),:);
gr = geornd(pbig);

count = length(plong);
k = (0:count-1);
mask = zeros(maxr,count);
mask(k*maxr+rlong)=ones(count,1);
mask = 1 - cumsum(mask) + mask;
rnd = (sum(gr .* mask));


rnd = reshape(rnd,rows,columns);

k= find(p < 0 | p > 1 | r < 1| round(r) ~= r);
if any(k)
    tmp = NaN;
    rnd(k) = tmp(ones(size(k)));
end
