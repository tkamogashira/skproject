function A = TSautocorr(T,maxlag);
% TSAUTOCORR - autocorrelation of time series
%   TSCORR(T, MaxLag) where T is a time series, returns a vector containing 
%   the differences between those pairs of events T(i)-T(j) for which
%   the magnitude of this difference does not exceed MaxLag.
%   A histogram of these differences is the
%   "binned autocorrelation" of the histogram of T.
%
%   For large MaxLag values, TScorr might be faster.
%
%   See also TScorr, HIST, XCORR.

if ~isreal(T),
   error('Time series must be real vector');
end

T = sort(T);


