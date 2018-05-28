function Y = inconsistent(Z,depth)
%INCONSISTENT Inconsistent values of a cluster tree.
%   T = INCONSISTENT(Z) computes the inconsistent values of the
%   cluster tree given by Z. Z is a M-1 by 3 matrix generated from the
%   function LINKAGE. 
%
%   T = INCONSISTENT(Z, DEPTH) computes the inconsistent values
%   with depth equal to DEPTH.
%
%   The output Y is a M-1 by 4 matrix. Suppose S is the pruned
%   subtree starting from node i to a depth of DEPTH, then
%
%      Y(i,1) = Average distance between nodes in S
%      Y(i,2) = Standard deviation of distances between nodes in S
%      Y(i,3) = Number of nodes in S
%      Y(i,4) = (Distance of node i - Y(i,1))/Y(i,2)
%
%   When DEPTH is not given, the default value is set to be 2.
%
%   See also PDIST, LINKAGE, COPHENET, DENDROGRAM, CLUSTER, CLUSTERDATA

%   ZP You, 3-10-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.2 $

if nargin < 2, depth = 2; end

m = size(Z,1);

Y = zeros(m,4);

for k = 1:m
   s = zeros(4,1);
   s(4) = depth;
   s = tracetree(Z, s, k);
   Y(k,1) = s(1)/s(3); % average edge length 
   Y(k,2) = sqrt(s(2) - (s(1)*s(1))/s(3)); % standard deviation
   Y(k,3) = s(3); % number of edges 
   if Y(k,2) > 0
      Y(k,4) = (Z(k,3) - Y(k,1))/Y(k,2);
   else 
      Y(k,4) = 0;  
   end
end

function s = tracetree(Z,s,k)
% recursive function to search down the tree.

m = size(Z,1)+1;
s(1) = s(1) + Z(k,3); % sum of the edge lengths so far
s(2) = s(2) + Z(k,3)*Z(k,3); % sum of the square of the edge length 
s(3) = s(3) + 1; % number of the edges so far 
i = Z(k,1); % left subtree index 
j = Z(k,2); % right subtree index 
s(4) = s(4)-1; % one less steps 
if s(4) > 0 % depth is greater than 0, need to go down further 
   if i > m %* node i is not a leave, it has subtrees 
       s = tracetree(Z, s, i-m); % trace back left subtree 
   end
   if j > m %* node j is not a leave, it has subtrees 
       s = tracetree(Z, s, j-m); % trace back left subtree 
   end
end

s(4) = s(4)+1;
