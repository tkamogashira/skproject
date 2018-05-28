function DC = getdc(X, Y, Range)
%GETDC  get direct current of digital signal
%   DC = GETDC(X, Y, Range) gives direct current of digital signal givan by the vectors X and Y. It is
%   calculated is the mean over a given time interval(in the same units as X) at begin and end of the signal.
%   This interval is given by the scalar Range.

%B. Van de Sande 25-03-2003

if nargin ~= 3, error('Wrong number of input parameters.'); end

idxlow  = max(find(X <= (X(1) + Range)));
idxhigh = min(find(X >= (X(end)- Range)));
    
DC = mean([Y(1:idxlow) Y((end-idxhigh+1):end)],2);