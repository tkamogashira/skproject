function [xm, ym, xs, ys] = getPeaks(X, Y, RunAvRange, DomPer, primPeakRange)
% GETPEAKS Gets the main and the secondary peaks from an oscillatory signal.
% 
%  [Xm, Ym, Xs, Ys] = GETPEAKS( X, Y [, runAvRange, Periodicity] )
%     Gets the main and the secondary peak out of an oscillatory signal.
%   
%     Arguments: 
%               X,Y: vectors containing the signal. The X vector should be
%                    sampled linearly and its units should be ms.  
%        RunAvRange: a running average is taken before computing the
%                    location of the maxima. RunAvRange has same dimension
%                    as the X vector, so ms. 
%       Periodicity: if given, getPeaks uses the periodicity given by the
%                    argument Periodicity (in ms) instead of calculating
%                    the FFT of the signal.
% 
%     Returns: 
%       xm, ym: the location of the main peak
%       xs, ys: locations of the first maximum before the main peak and the
%               first peak after the main peak. 

%B. Van de Sande 01-05-2003
% Adjusted by Kevin Spiritus 2007-03-12

% Kevin: added primPeakRange: primary peak needs to be in this range

%% Parameters
if ~any(nargin == [2,3,4,5])
    error('Wrong number of input arguments.'); 
end
if nargin == 2
    RunAvRange = 0; 
    DomPer = NaN;
    primPeakRange = [-Inf +Inf];
elseif nargin == 3
    DomPer = NaN; 
    primPeakRange = [-Inf +Inf];
elseif nargin == 4
    primPeakRange = [-Inf +Inf];
end
if ~isnumeric(X) | ~isnumeric(Y) | ~isequal(length(X), length(Y))
    error('First two arguments should be numeric vectors with same length.'); 
end
if ~isnumeric(RunAvRange) | (length(RunAvRange) ~= 1) | (RunAvRange < 0)
    error('Third argument should be positive number.'); 
end

%% Get main peak from oscilating signal ...
[xm, ym] = getmaxloc(X, Y, RunAvRange, primPeakRange);

%% Secondary peaks, use dominant period
if isnan(DomPer)
    [dummy, dummy, dummy, DF] = spectana(X, Y);
    DomPer = 1000/DF;
end

idx = find(X > (xm - 3/2*DomPer) & X < (xm - DomPer/2));
if ~isempty(idx)
    [xs, ys] = getmaxloc(X(idx), Y(idx), RunAvRange);
else
    [xs, ys] = deal(NaN); 
end

idx = find(X > (xm + DomPer/2) & X < (xm + 3/2*DomPer));
if ~isempty(idx)
    [xs(2), ys(2)] = getmaxloc(X(idx), Y(idx), RunAvRange);
else
    [xs(2), ys(2)] = deal(NaN); 
end
