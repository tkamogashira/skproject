function x = ff2n(n)
%FF2N   Two-level full-factorial design.
%   X = FF2N(N) creates a two-level full-factorial design, X.
%   N is the number of columns of X. The number of rows is 2^N.

%   B.A. Jones 2-17-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:45:20 $

rows = 2.^(n);
ncycles = rows;
group = zeros(rows,n);

for k = 1:n
   settings = (0:1);
   ncycles = ncycles/2;
   nreps = rows./(2*ncycles);
   settings = settings(ones(1,nreps),:);
   settings = settings(:);
   settings = settings(:,ones(1,ncycles));
   x(:,n-k+1) = settings(:);
end
