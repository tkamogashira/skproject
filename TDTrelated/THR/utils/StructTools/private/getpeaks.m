function [xm, ym, xs, ys] = getpeaks(X, Y, RunAvRange, DomPer)
%GETPEAKS   get main- and secondary peaks out of oscillatory signal
%   [Xm, Ym, Xs, Ys] = GETPEAKS(X, Y) gets main- and secondary peak out of oscillatory signal given by the
%   vectors X and Y. The X vector should be sampled linearly and its units should be ms. Xm and Ym are scalars 
%   containing the location of the main peak, Xs and Ys are two element vectors where the first element gives 
%   the location of the first maximum before the main peak and the second element the first peak after the main 
%   peak.
%
%   [Xm, Ym, Xs, Ys] = GETPEAKS(X, Y, RunAvRange) does the same, except that a running average is taken before 
%   computing the location of the maxima. RunAvRange has same dimension as the X vector, so ms.
%
%   [Xm, Ym, Xs, Ys] = GETPEAKS(X, Y, RunAvRange, Periodicity) uses the periodicity given by the argument
%   Periodicity (in ms) instead of calculating the FFT of the signal.

%B. Van de Sande 01-05-2003

%Parameters nagaan ...
if ~any(nargin == [2,3,4]), error('Wrong number of input arguments.'); end
if nargin == 2, RunAvRange = 0; DomPer = NaN;
elseif nargin == 3, DomPer = NaN; end
if ~isnumeric(X) | ~isnumeric(Y) | ~isequal(length(X), length(Y)), error('First two arguments should be numeric vectors with same length.'); end
if ~isnumeric(RunAvRange) | (length(RunAvRange) ~= 1) | (RunAvRange < 0), error('Third argument should be positive number.'); end

%Range waarover lopend gemiddelde moet berekend worden omzetten naar aantal elementen ...
binwidth = X(2)-X(1); RunAvN = getrangen(RunAvRange, binwidth);

%Hoofdpiek uit oscillerend signaal halen ...
[xm, ym] = getmaxloc(X, Y, RunAvRange);

%Secundaire pieken nagaan ... via dominante periode in signaal ...
if isnan(DomPer)
    [dummy, dummy, dummy, DF] = spectana(X, Y);
    DomPer = 1000/DF;
end

idx = find(X > (xm - 3/2*DomPer) & X < (xm - DomPer/2));
if ~isempty(idx), [xs, ys] = getmaxloc(X(idx), Y(idx), RunAvRange);
else [xs, ys] = deal(NaN); end    

idx = find(X > (xm + DomPer/2) & X < (xm + 3/2*DomPer));
if ~isempty(idx), [xs(2), ys(2)] = getmaxloc(X(idx), Y(idx), RunAvRange);
else [xs(2), ys(2)] = deal(NaN); end    
