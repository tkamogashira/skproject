function [dtnew, Xmean, Xvar, X] = fracLoopMean(dt, X, Period, ana_offset);
%  fracLoopMean - average subsequent cycles of an array; fractional lengths allowed
%    [dtnew, Xmean, Xvar] = fracLoopMean(dt, X, Period) returns Xmean, 
%    that is X averaged over the subsequent cycles X of length Period. 
%    dt is the sample period in the same units as Period. Period need not 
%    correspond to an integer # samples in X. If needed, X will be 
%    resampled (using interp1) to force Period to be an integer # samples 
%    in X. If X holds a non-integer number of Periods, this is accounted 
%    for when computing the cycled average. dtnew is the new sample period. 
%    Xvar is the variance across cycles.
%
%    For matrices X, each column is loop-averaged.
%
%    fracLoopMean(dt, X, Period, Ana_offset) compensates the use of a
%    delayed start of the analysis window. If the stimulus cycle starts at
%    t=0 ms, and X starts at t=Ana_offset ms, the outputs Xmean and Xvar
%    are cycle-shifted so that their first sample corresponds to phase zero
%    of the stimulus.
%
%    See also LoopMean, interp1, nanmean.

[ana_offset] = arginDefaults('ana_offset',0); % 0 ms delay between stimulus start and X start
% =====single array  from here =========
isrow = size(X,2)>1;
X = X(:);
Nsam = numel(X);
Dur = dt*Nsam; % duration of X
Fsam = 1/dt; % sample rate 
Fana = 1/Period; % analysis freq
Fsamnew = Fana*round(Fsam/Fana); % new sample rate must be integer multiple of analysis freq
dtnew = 1/Fsamnew;
NsamCycle = round(Fsam/Fana); % # new sample in one period
Ncycle = ceil(Dur/Period); % integer # Periods, make sure to include the entire original X
NewDur = Ncycle*Period;
NewNsam = Ncycle*NsamCycle;
warning('off', 'MATLAB:interp1:NaNinY'); % suppress out-of-X-range warning
X = interp1(linspace(dt,Dur, Nsam), X, linspace(dtnew,NewDur, NewNsam));
warning('on', 'MATLAB:interp1:NaNinY');
X = reshape(X,[NsamCycle, Ncycle]);
%ana_offset
time_shift = mod(ana_offset,Period);
Nshift = round(time_shift/dtnew);
X = circshift(X,[Nshift 0]);
Xmean = nanmean(X,2);
Xvar = nanvar(X,[], 2);

