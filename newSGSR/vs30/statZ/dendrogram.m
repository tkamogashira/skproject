function [h,T] = dendrogram(Z,p)
%DENDROGRAM Generate dendragram plot.
%   DENDROGRAM(Z) generates a dendrogram from the output matrix of
%   LINKAGE.  Z is a (M-1) by 3 matrix. M is the number of
%   observations in the original data. 
%
%   A dendrogram consists of many upsidedown U shape lines connecting
%   nodes in a hierachichale tree. Except for the WARD linkage (see
%   LINKAGE), the height of each U is the distance between the two
%   clusters to be connected at that time.  
%
%   DENDROGRAM(Z,P) generate a dendrogram with only the top P nodes.
%   When there are more than 30 nodes in the original data, the
%   dendrogram may look crowded. The default value of P is 30. If P =
%   0, then, every node will be displayed.
%
%   H = DENDROGRAM(...) returns a vector of line handles.
%
%   [H, T] = DENDROGRAM(...) also returns T, a vector of size M that
%   contains cluster number for each observation in the original data.
%
%   When bottom leaves are cutoff, some information are lost. T
%   supplies this lost information. For example, to find out which
%   observations are contained in node k of the dendrogram, use
%   FIND(T==k). 
%
%   When there are less than P observations in the original data, T
%   is the identical map, i.e. T = (1:M)'. Each node only contains
%   itself.
%
%   See also LINKAGE, PDIST, CLUSTER, CLUSTERDATA, INCONSISTENT.

%   ZP You, 3-10-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.2 $

m = size(Z,1)+1;
if nargin < 2
   p = 30;
end

Z = transz(Z); % convert from m+k indexing to min(i,j) indexing.
T = (1:m)';

% if there are more than p node, dendrogram looks crowded, the following code
% will make the last p link nodes as the leaf node.
if (m > p) & (p ~= 0)
   
   Y = Z((m-p+1):end,:);
   
   R = Y(:,1:2);
   R = unique(R(:));
   Rlp = R(R<=p);
   Rgp = R(R>p);
   W(Rlp) = Rlp;
   W(Rgp) = setdiff(1:p, Rlp);
   W = W';
   T(R) = W(R);
   
   % computer all the leaf that each node (in the last 30 row) has 
   for i = 1:p
      c = R(i);
      T = clusternum(Z,T,W(c),c,m-p+1,0); % assign to it's leaves.
   end
   
   
   Y(:,1) = W(Y(:,1));
   Y(:,2) = W(Y(:,2));
   Z = Y;
   Z(:,3) = Z(:,3)-min(Z(:,3))*0.8; % this is to make the graph look more uniform.
   
   m = p; % reset the number of node to be 30 (row number = 29).
end

A = zeros(4,m-1);
B = A;
n = m;
X = 1:n;
Y = zeros(n,1);
r = Y;

% arrange Z into W so that there will be no crossing in the dendrogram.
W = zeros(size(Z));
W(1,:) = Z(1,:);

nsw = zeros(n,1); rsw = nsw;
nsw(Z(1,1:2)) = 1; rsw(1) = 1;
k = 2; s = 2;

while (k < n)
   i = s;
   while rsw(i) | ~any(nsw(Z(i,1:2)))
      if rsw(i) & i == s, s = s+1; end
      i = i+1;
   end
   
   W(k,:) = Z(i,:);
   nsw(Z(i,1:2)) = 1;
   rsw(i) = 1;
   if s == i, s = s+1; end
   k = k+1;
end

g = 1;
for k = 1:m-1 % initialize X
   i = W(k,1);
   if ~r(i), 
      X(i) = g; 
      g = g+1; 
      r(i) = 1;   
   end
   i = W(k,2);
   if ~r(i), 
      X(i) = g; 
      g = g+1; 
      r(i) = 1;   
   end
end
[u,v]=sort(X);
label = num2str(v');

for n=1:(m-1)
   i = Z(n,1); j = Z(n,2); w = Z(n,3);
   A(:,n) = [X(i) X(i) X(j) X(j)]';
   B(:,n) = [Y(i) w w Y(j)]';
   X(i) = (X(i)+X(j))/2; Y(i) = w;
end

figure
set(gcf,'Position', [50, 50, 800, 500]);
h = plot(A,B,'b');
axis([0 m+2 0 max(Z(:,3))*1.05])
set(gca,'XTickLabel',[],'XTick',[],'box','off','xcolor','w');

text((1:m)-0.2,zeros(m,1)-0.05*max(Z(:,3)),label);

function T = clusternum(X, T, c, k, m, d)
% assign leaves under cluster c to c.

d = d+1;
n = m; flag = 0;
while n > 1
  n = n-1;
  if X(n,1) == k % node k is not a leave, it has subtrees 
     T = clusternum(X, T, c, k, n,d); % trace back left subtree 
     T = clusternum(X, T, c, X(n,2), n,d);
     flag = 1; break;
  end
end

n = size(X,1);
if flag == 0 & d ~= 1 % row m is leaf node.
   T(X(m,1)) = c;
   T(X(m,2)) = c;
end



