function Z = transz(Z)
%TRANSZ Translate output of LINKAGE into another format.
%   This is a helper function used by DENDROGRAM and COPHENET.  

%   In LINKAGE, when a new cluster is formed from cluster i & j, it is
%   easier for the latter computation to name the newly formed cluster
%   min(i,j). However, this definition makes it hard to understand
%   the linkage information. We choose to give the newly formed
%   cluster a cluster index M+k, where M is the number of original
%   observation, and k means that this new cluster is the kth cluster
%   to be formmed. This helper function converts the M+k indexing into
%   min(i,j) indexing.

%   ZP You, 3-10-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.1 $

m = size(Z,1)+1;

for i = 1:(m-1)
   if Z(i,1) > m
      Z(i,1) = traceback(Z,Z(i,1));
   end
   if Z(i,2) > m
      Z(i,2) = traceback(Z,Z(i,2));
   end
   if Z(i,1) > Z(i,2)
      Z(i,1:2) = Z(i,[2 1]);
   end
end


function a = traceback(Z,b)

m = size(Z,1)+1;

if Z(b-m,1) > m
   a = traceback(Z,Z(b-m,1));
else
   a = Z(b-m,1);
end
if Z(b-m,2) > m
   c = traceback(Z,Z(b-m,2));
else
   c = Z(b-m,2);
end

a = min(a,c);
