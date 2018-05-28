function X = TScorr(ts1,ts2);
% TSCORR - crosscorrelation of time series
%   TSCORR(T,S) , where T and S are length N resp. length M time series, 
%   returns the NM-length vector containing the differences between each 
%   pair of events S(i)-T(j). A histogram of these differences is the
%   "binned crosscorrelation" of the histograms of T and S.
%
%   See also TSautocorr, HIST, XCORR.

if ~isreal(ts1) | ~isreal(ts2),
   error('Time series must be real vectors');
end

X = log(kron(exp(ts2(:)),exp(-ts1(:))));


