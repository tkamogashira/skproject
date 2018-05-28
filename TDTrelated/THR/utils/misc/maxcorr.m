function [MaxC, iLag]=maxcorr(A,B,maxLag, flag);
% Maxcorr - max correlation value
%   Maxcorr(A,B,maxLag) returns max normalized correlation value
%   of arrays A and B, restricting the range of the correlation function to
%   maxLag (see xcorr). When using complex A and B, mind Matlab's idiotic
%   convention concerning the max of complex values.
%
%   When A and B are arrays, they must have equal length. A and/or B may 
%   be matrices having the same number of rows, in which case a row
%   vector is returned that contains the maxcorr of the respective columns.
%
%   Maxcorr(A,B,maxLag, 'real') takes the real value of A and B before
%   crosscorrelating them.
%
%   Maxcorr(A,B,maxLag, 'abs') takes the abs value of the correlation
%   function before evaluating its maximum.
%
%   [MaxC, iLag] = maxcorr(..) also returns the lags at which the maximum
%   correlation occurred. The sign convention is such that when applying
%   circshift to B using iLag will shift the maximum xcorr to zero-lag.
%   Thus positive lags indicate that B is leading A.
%
%   Note that the underlying call to XCORR uses the 'coeff' normalization.
%   Thus no compensation for boundary effects is attempted. It is advisable
%   to apply a temporal window (e.g. HANN) to the wavefor ms being
%   crosscorrelated, or else boundary effects may dominate shallow trends
%   in the crosscorrelation function.
%
%   See also xcorr, locateSegment.

if nargin<3, 
    maxLag = []; % xcorr accepts this as a default value
end
if nargin<4, 
    flag=''; 
else,
    [flag, Mess] = keywordMatch(flag, {'real' 'abs'}, 'option');
end

if isequal('real', flag),
    A = real(A);
    B = real(B);
end

if isvector(A) && isvector(B), % neither A nor B was a matrix: single xcorr
    [X, lags] = xcorr(zscore(A),zscore(B),maxLag,'biased');
    if isequal('abs', flag), X = abs(X); end
    [MaxC, imax] = max(X);
    iLag = lags(imax);
else, % columnwise
    NcolA = size(A,2);
    NcolB = size(B,2);
    Ncol = max(NcolA,NcolB);
    for icol=1:Ncol,
        icolA = min(NcolA,icol);
        icolB = min(NcolB,icol);
        [X, lags] = xcorr(zscore(A(:,icolA)),zscore(B(:,icolB)),maxLag,'biased');
        if isequal('abs', flag), X = abs(X); end
        [MaxC(icol), imax] = max(X);
        iLag(icol) = lags(imax);
    end
end



