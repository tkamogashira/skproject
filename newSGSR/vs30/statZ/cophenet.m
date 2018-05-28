function c = cophenet(Z,Y)
%COPHENET Cophenetic coefficient.
%   C = COPHENETIC(Z,Y) computes the Cophenetic coefficient between the
%   distance of the cluster tree in Z and the distance in Y. Z is the
%   output of the function LINKAGE. Y is the output of the function
%   PDIST.
%
%   The Cophenetic coefficient is defined as
%   
%                    sum((Z(i,j)-z)*(Y(i,j)-y)) 
%                    i<j             
%       c =   -----------------------------------------
%             sqrt(sum((Z(i,j)-z)^2)*sum((Y(i,j)-y)^2))
%                  i<j               i<j
%
%           
%   Y(i,j) is the distance between observation i and j. y is mean(Y).
%   Z(i,j) is the distance between observation i and j at the combine
%   time and z = mean(Z).
%
%   See also PDIST, LINKAGE, INCONSISTENT, DENDROGRAM, CLUSTER, CLUSTERDATA

%   ZP You, 3-10-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.2 $


n = size(Z,1)+1;

link = zeros(n,1); listhead = 1:n;
sum1 = 0; sum2 = 0; s11 = 0; s22 = 0; s12 = 0;

for k = 1:(n-1)
   i = Z(k,1); j = Z(k,2); t = Z(k,3);
   m1 = listhead(i); % head of the updated cluster i
   while m1 > 0
      m = listhead(j);
      while m > 0
         u = Y((m1-1)*(n-m1/2)+m-m1); % distance between m and m1.
         sum1 = sum1+t; sum2 = sum2+u; 
         s11 = s11+t*t; s22 = s22+u*u;
         s12 = s12+t*u; 
         msav = m;
         m = link(m);
      end
      m1 = link(m1); % find the next point in cluster i 
   end
   
   % link the end of cluster j to the head of cluster i 
   link(msav) = listhead(i);
   
   % make the head of newly formed cluster i to be the head of cluster
   % j before the merge.
   listhead(n+k) = listhead(j);

end
t = 2/(n*(n-1));
s11 = s11-sum1*sum1*t; s22 = s22-sum2*sum2*t; s12 = s12-sum1*sum2*t;
c = s12/sqrt(s11*s22); % cophenectic coefficient formula 
