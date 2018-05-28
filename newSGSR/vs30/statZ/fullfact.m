function design = fullfact(levels)
%FULLFACT Mixed-level full-factorial designs.
%    FULLFACT(LEVELS) outputs the factor settings for a full factorial
%   design. The vector LEVELS specifies the number of unique setting
%   in each column of the design.
%   Example: If LEVELS = [2 4 3], FULLFACT will generate a 24 run design
%   with 2 levels in the first column, 4 in the second column, and 3 in
%   the third column.

%   B.A. Jones 10-09-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:24 $

[m,n] = size(levels);

if min(m,n) ~= 1
   error('Requires a vector input.');
end

if any((floor(levels) - levels) ~= 0)  | any(levels <= 1)
   error('The input values must be integers greater than one.');
end

ssize = prod(levels);
ncycles = ssize;
cols = max(m,n);

design = zeros(ssize,cols);

for k = 1:cols
   settings = (1:levels(k));
   ncycles = ncycles./levels(k);
   nreps = ssize./(ncycles*levels(k));
   settings = settings(ones(1,nreps),:);
   settings = settings(:);
   settings = settings(:,ones(1,ncycles));
   design(:,k) = settings(:);
end
