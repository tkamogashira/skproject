function D = dummyvar(group)
%DUMMYVAR Dummy variable coding.
%   DUMMYVAR(GROUP) makes a dummy column for
%   each unique value in each column of the 
%   matrix GROUP. The values of the elements
%   in any column of GROUP go from one to the
%   number of members in the group.

%   Example: Suppose we are studying the effects
%   of two machines and three operators on a process.
%   The first column of GROUP would have the values
%   one or two depending on which machine
%   was used. The second column of GROUP would have 
%   the values one, two, or three depending on which
%   operator ran the machine. 

%   B.A. Jones 2-04-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:14 $

[m,n] = size(group);
if m == 1
  m = n;
  n = 1;
  group = group(:);
end

if any(any(group - round(group))) ~= 0
   error('Each element of the input argument must be a positive integer.')
end

maxg = max(group);
colstart = [0 cumsum(maxg)];
colstart(n+1) = [];
colstart = reshape(colstart(ones(m,1),:),m*n,1);

colD = sum(maxg);
D = zeros(m,colD);

row = (1:m)';
row = reshape(row(:,ones(n,1)),m*n,1);

idx = m*(colstart + group(:) - 1) + row;
D(idx) = ones(size(row));
