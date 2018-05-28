function Z = linkage(Y, method)
%LINKAGE Hierarchical cluster information.
%   LINKAGE(Y) computes the hierarchical cluster information, using the
%   single linkage algorithm, from a given distance matrix Y generated
%   by PDIST. Y is also commonly known as similarity or
%   dissimilarity matrix.
%
%   LINKAGE(Y, method) computes the hierarchical cluster information using
%   the specified algorithm. The available methods are:
%
%      'single'   --- nearest distance
%      'complete' --- furthest distance
%      'average'  --- average distance
%      'centroid' --- center of mass distance
%      'ward'     --- inner squared distance
%
%   Cluster information will be returned in the matrix Z with size m-1
%   by 3.  Column 1 and 2 of Z contain cluster indices linked in pairs
%   to form a binary tree. The leaf nodes are numbered from 1 to
%   m. They are the singleton clusters from which all higher clusters
%   are built. Each newly-formed cluster, corresponding to Z(i,:), is
%   assigned the index m+i, where m is the total number of initial
%   leaves. Z(i,1:2) contains the indices of the two component
%   clusters which form cluster m+i. There are n-1 higher clusters
%   which correspond to the interior nodes of the output clustering
%   tree. Z(i,3) contains the corresponding linkage distances between
%   the two clusters which are merged in Z(i,:), e.g. if there are
%   total of 30 initial nodes, and at step 12, cluster 5 and cluster 7
%   are combined and their distance at this time is 1.5, then row 12
%   of Z will be (5,7,1.5). The newly formed cluster will have an
%   index 12+30=42. If cluster 42 shows up in a latter row, that means
%   this newly formed cluster is being combined again into some bigger
%   cluster.
%
%   See also PDIST, INCONSISTENT, COPHENET, DENDROGRAM, CLUSTER, CLUSTERDATA

%   ZP You, 3-10-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.4 $

[k, n] = size(Y);

if n < 3
  error('You have to have at least three distances to do a linkage.');
end
  

m = (1+sqrt(1+8*n))/2;
if k ~= 1 | m ~= fix(m)
  error('The first input has to match the output of the PDIST function in size.');   
end

if nargin == 1 % set default switch to be 's' 
   method = 'si';
end

if length(method) < 2
   error('The switch given by the second argument is not defined.');
end

method = lower(method(1:2)); % simplify the switch string.

Z = zeros(m-1,3); % allocate the output matrix.

% during updating clusters, cluster index is constantly changing, R is
% a index vector mapping the original index to the current (row
% column) index in X.  N denotes how many points are contained in each
% cluster.

N = zeros(1,2*m-1);
N(1:m) = 1;
n = m; % since m is changing, we need to save m in n. 
R = 1:n;

if method == 'ce'  % square the X so that it is easier to update.
   Y = Y .* Y;
elseif method == 'wa'
   Y = Y .* Y/2;
end

for s = 1:(n-1)
   if method == 'av'
      p = (m-1):-1:2;
      I = zeros(m*(m-1)/2,1);
      I(cumsum([1 p])) = 1;
      I = cumsum(I);
      J = ones(m*(m-1)/2,1);
      J(cumsum(p)+1) = 2-p;
      J(1)=2;
      J = cumsum(J);
      W = N(R(I)).*N(R(J));
      X = Y./W;   
   else
      X = Y;
   end
   
   [v, k] = min(X);
   if method == 'ce'
      v = sqrt(v);
   end
   
   i = floor(m+1/2-sqrt(m^2-m+1/4-2*(k-1)));
   j = k - (i-1)*(m-i/2)+i;
   
   Z(s,:) = [R(i) R(j) v]; % update one more row to the output matrix A
   
   % update X, in order to vectorize the computation, we need to compute
   % all the index corresponds to cluster i and j in X, denoted by I and J.
   I1 = 1:(i-1); I2 = (i+1):(j-1); I3 = (j+1):m; % these are temp variables.
   U = [I1 I2 I3];
   I = [I1.*(m-(I1+1)/2)-m+i i*(m-(i+1)/2)-m+I2 i*(m-(i+1)/2)-m+I3];
   J = [I1.*(m-(I1+1)/2)-m+j I2.*(m-(I2+1)/2)-m+j j*(m-(j+1)/2)-m+I3];
   
   switch method
   case 'si' %single linkage
      Y(I) = min(Y(I),Y(J));
   case 'av' % average linkage
      Y(I) = Y(I) + Y(J);
   case 'co' %complete linkage
      Y(I) = max(Y(I),Y(J));
   case 'ce' % centroid linkage
      K = N(R(i))+N(R(j));
      Y(I) = (N(R(i)).*Y(I)+N(R(j)).*Y(J)-(N(R(i)).*N(R(j))*v^2)./K)./K;
   case 'wa'
      Y(I) = ((N(R(U))+N(R(i))).*Y(I) + (N(R(U))+N(R(j))).*Y(J) - ...
	  N(R(U))*v)./(N(R(i))+N(R(j))+N(R(U)));
   otherwise error('method not recognized.');
   end
   J = [J i*(m-(i+1)/2)-m+j];
   Y(J) = []; % no need for the cluster information about j.
   
   % update m, N, R
   m = m-1; 
   N(n+s) = N(R(i)) + N(R(j));
   R(i) = n+s;
   R(j:(n-1))=R((j+1):n); 
end

if method == 'wa'
   Z(:,3) = sqrt(Z(:,3));
end
