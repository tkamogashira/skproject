function [pc, score, latent, tsquare] = princomp(x);
%PRINCOMP Principal Component Analysis (centered and scaled data).
%   [PC, SCORE, LATENT, TSQUARE] = PRINCOMP(X) takes a data matrix X and
%   returns the principal components in PC, the so-called Z-scores in SCORES,
%   the eigenvalues of the covariance matrix of X in LATENT, and Hotelling's
%   T-squared statistic for each data point in TSQUARE.

%   Reference: J. Edward Jackson, A User's Guide to Principal Components
%   John Wiley & Sons, Inc. 1991 pp. 1-25.

%   B. Jones 3-17-94
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:28 $

[m,n] = size(x);
avg = mean(x);
centerx = (x - avg(ones(m,1),:));

[U,latent,pc] = svd(centerx./sqrt(m-1),0);
score = centerx*pc;

if nargout < 3, return; end
latent = diag(latent).^2;

if nargout < 4, return; end
tmp = sqrt(diag(1./latent))*score';
tsquare = sum(tmp.*tmp)';
