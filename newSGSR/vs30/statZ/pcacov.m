function [pc,latent,explained] = pcacov(x)
% PCACOV  Principal Component Analysis using the covariance matrix.
%   [PC, LATENT, EXPLAINED] = PCACOV(X) takes a the covariance matrix,
%   X, and returns the principal components in PC, the eigenvalues of
%   the covariance matrix of X in LATENT, and the percentage of the
%   total variance in the observations explained by each eigenvector 
%   in EXPLAINED.

%   Reference: J. Edward Jackson, A User's Guide to Principal Components
%   John Wiley & Sons, Inc. 1991 pp. 1-25.

%   B. Jones 3-17-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:19 $

[u,latent,pc] = svd(x);
latent = diag(latent);

totalvar = sum(latent);
explained = 100*latent/totalvar;
