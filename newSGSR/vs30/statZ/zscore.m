function z = zscore(d)
%ZSCORE Standadized z score.
%   Z = ZSCORE(D) returns the deviation of each column of D from its mean 
%   normalized by its standard deviation. This is known as the Z score of D.
%   For a column vector V, z score is Z = (V-mean(V))./std(V)
%
%   ZSCORE is commonly used to preprocess data before computing distances for 
%   cluster analysis.
%
%   See also PDIST, CLUSTER, CLUSTERDATA.

%   ZP. You, July 22, 1998
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.2 $ 

[m,n] = size(d);

if m == 1
   m = n;
   d = d';
end

md = repmat(mean(d),m,1);
sd = repmat(std(d),m,1);
sd(sd==0) = 1; % all the numerator will be zero in such case.

z = (d-md)./sd;

