function [Rise, Fall, NfullCycle] = cyclegate(X, dt, RiseDur, FallDur, TotalDur);
% cyclegate - gated rise and fall segments for cyclic waveforms
%    [Rise, Fall] = cyclegate(X, dt, RiseDur, FallDur) cuts portions from
%    waveform X and gates them. Rise is to be prepended to X and Fall is to
%    be appended. Rise and Fall are taken from the last and first portion
%    of X, respectively, so that they will be continuous with X. Rise and
%    Fall are gated by a cos^2 window.
%    Sample period dt, RiseDur and FallDur in the same time units.
%
%    If X is a matrix, its columns are gated.
%
%    [Rise, Tail, NfullCycle] = cyclegate(X, dt, RiseDur, FallDur, TotDur)
%    anticipates a non-integer number of cycles of X, requiring the
%    falling segment to start the incomplete last cycle of X ends. TotDur
%    is the total duration,including rise and fall, which determines how long 
%    that incomplete last cycle is. For convenience, the unfinished cycle
%    and the falling segment are combined into a single output arg Tail
%    which replaces the Fall output of the above call. NfullCycle is the
%    number of full cycles that fit in TotalDur.
%
%    See also exactgate, cyclegate.

TotalDur = arginDefaults('TotalDur',RiseDur+FallDur); % default renders SteadyDur zero
SteadyDur = TotalDur-(RiseDur+FallDur);
if SteadyDur<-dt/10,
    error('Sum of ramp durations exceeds total duration.');
end
[X, isRow] = TempColumnize(X);

NsamCycle = size(X,1);
NsamRise = round(RiseDur/dt);
NsamFall = round(FallDur/dt);
NsamSteady = round(SteadyDur/dt);
MaxNramp = max([NsamRise NsamFall]);
NsamLast = rem(NsamSteady, NsamCycle);

NfullCycle = floor(NsamSteady/NsamCycle);
Nmult = ceil(MaxNramp/NsamCycle); % number of cycles of X needed to cut out the ramps
Nmult = max(1,Nmult);
X = repmat(X,[Nmult 1]);
Xcut = [X(NsamLast+1:end,:); X]; % include unfinished cycle
NsamX = size(Xcut,1);

RiseOffset = NsamX-NsamRise; % where to start cutting the rising part (see help text)
FallOffset = 0;

RiseWin = sin(linspace(0,pi/2, NsamRise+2).').^2;
FallWin = sin(linspace(0,pi/2, NsamFall+2).').^2;
RiseWin = RiseWin(2:end-1);
FallWin = FallWin(end-1:-1:2);
for icol=1:size(X,2),
    Rise(:,icol) = RiseWin.*Xcut(RiseOffset+(1:NsamRise),icol);
    Fall(:,icol) = FallWin.*Xcut(FallOffset+(1:NsamFall),icol);
end
Fall = [X((1:NsamLast),:); Fall]; % combine unfinished cycle and fall (see help)

if isRow, % restore original 'orientation'
    X = X.';
end












