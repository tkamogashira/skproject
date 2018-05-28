function [ndim, prob, chisquare] = barttest(x,alpha);
%BARTTEST Bartlett's test for dimensionality of the data in X.
%   [NDIM, PROB, CHISQUARE] = BARTTEST(X,ALPHA) requires a data matrix X and
%   a significance probability, ALPHA. It returns the number of dimensions
%   necessary to explain the nonrandom variation in X. The hypothesis is that 
%   the number of dimensions is equal to the number of the largest unequal 
%   eigenvalues of the covariance matrix of X.
%   CHISQUARE is a vector of statistics for testing this hypothesis 
%   sequentially for one, two, three, etc. dimensions.
%   PROB is the vector of significance probabilities that correspond to each
%   element of CHISQUARE.

%   Reference: J. Edward Jackson, "A User's Guide to Principal Components",
%   John Wiley & Sons, Inc. 1991 pp. 33-34.

%   B. Jones 3-17-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1997/11/29 01:44:49 $

if nargin == 1
  alpha = 0.05;
end

[r, c] = size(alpha);
if max(r,c) > 1
   error('Requires a scalar 2nd input.');
end
if alpha <= 0 | alpha >= 1
   error('Requires the 2nd input on the interval between zero and one.');
end

covmat = cov(x);
[u,latent,pc] = svd(covmat);

[nu,n] = size(x);
if n == 1
   error('Requires the 1st input to have more than one column.');
end

if nu == 1
   error('Requires the 1st input to have more than one row.');
end
k = (0:n-2)';

ls = flipud(diag(latent));
lnls = flipud(cumsum(log(ls)));

pk = n - k;

logsum = log(flipud(cumsum(ls(1:n-1))./flipud(pk)));
chisquare = (pk.*logsum - lnls(1:n-1))*nu;
df = (pk-1).*(pk+2)/2;
prob = 1-chi2cdf(chisquare,df);
dim  = min(find(prob>alpha));
if isempty(dim)
   ndim = n;
   return;
end
if dim == 1
   ndim = NaN;
   disp('The heuristics behind Bartlett''s Test are being violated for this data.'); 
else
   ndim = dim - 1;
end

