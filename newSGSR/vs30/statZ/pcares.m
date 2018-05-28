function residuals = pcares(x,ndim);
%PCARES Residuals from a Principal Components Analysis.
%   RESIDUALS = PCARES(X,NDIM) takes a data matrix X and returns the
%   residuals obtained by retaining NDIM principal components of X.
%   Note that NDIM is a scalar and must be less than the number of
%   columns in X.

%   Reference: J. Edward Jackson, A User's Guide to Principal Components
%   John Wiley & Sons, Inc. 1991 p. 35.

%   B. Jones 3-24-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:46:20 $

[m,n] = size(x);

if prod(size(ndim)) > 1
    error('Requires a scalar second input.');
end

if ndim >= n
    error('The number of columns in the first input must exceed the value of the 2nd input.');
end
   
[pc,score,latent] = princomp(x);

avg = mean(x);
avgx = avg(ones(m,1),:);

retain = pc(:,1:ndim)';

predictx = avgx + score(:,1:ndim)*retain;

residuals = x - predictx;
