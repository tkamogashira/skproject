function W = SNR2W(SNR, SNRmin, SNRmax);
% SNR2W - convert S/N ratio of spectral components to weight factors
%   W = SNR2std(SNR), where SNR is an array of the S/N ratios (in dB) of
%   spectral components, returns weighting factors corresponding to the 
%   elements of SNR. These weighting factors can be used for linear fitting
%   as in WLinFit and WLinSolve. Apart from an overall normalization,
%   the weighting factors are equal to 1./SNS2std(SNR), i.e., the
%   reciprocal of the standard devations derived from the S/N ratio.
%
%   W = SNR2std(SNR, SNRmin SNRmax) restricts the dynamical range of the
%   weighting factors. The elements of W for which SNR<=SNRmin are put to
%   zero. The elements of W for which SNR>SNRmax are put to
%   SNSR2std(SNRmax). Default values are SNRmin=0; SNRmax=inf.
%
%   See also WLinFit, WLinSolve, SNR2std.

if nargin<2, SNRmin = 0; end
if nargin<3, SNRmax = inf; end

SNR(SNR<=SNRmin) = -10;
SNR(SNR>SNRmax) = SNRmax;

W = 1./SNR2std(SNR);
% normalize
if any(W>0),
    W = 100*W/sum(W);
end


