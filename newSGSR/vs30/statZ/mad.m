function y = mad(x)
%MAD    Mean absolute deviation. 
%   Y = MAD(X) calculates the mean absolute deviation (MAD) of X.
%   For matrix X, MAD returns a row vector containing the MAD of each  
%   column.
%
%   The algorithm involves subtracting the mean of X from X,
%   taking absolute values, and then finding the mean of the result.

%   References:
%      [1] L. Sachs, "Applied Statistics: A Handbook of Techniques",
%      Springer-Verlag, 1984, page 253.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:49 $

[nrow,ncol] = size(x);
med = mean(x);
y = abs(x - med(ones(nrow,1),:));
y = mean(y);
