function X = ExactGate(X, Fsam, BurstDur, Tstart, RiseDur, FallDur);
% ExactGate - exactly timed gating using cos^2 ramps
%    X = ExactGate(X, Fsam, BurstDur, Tstart, RiseDur, FallDur) imposes 
%    cos^2 ramps onto waveform X. Inputs are
%          X: waveform. Must be single array.
%       Fsam: sample rate in Hz.
%   BurstDur: duration of burst in ms, measured from start-of-rise to 
%             end-of-fall. Sub-sample precision is respected.
%     Tstart: start of rising ramp in ms re first sample of X. Must be
%             nonnegative. Sub-sample precision is respected.
%    RiseDur: duration in ms of cos^2 rising ramp.
%    FallDur: duration in ms of cos^2 falling ramp.
%
%    See also simplegate.

if ~isvector(X),
    error('X must be vector.');
end
[X, wasRow] = TempColumnize(X);

error(NumericTest(Tstart, 'nonnegative/rreal/scalar', 'Tstart arg is'));
error(NumericTest(RiseDur, 'nonnegative/rreal/scalar', 'RiseDur arg is'));
error(NumericTest(BurstDur, 'nonnegative/rreal/scalar', 'BurstDur arg is'));
error(NumericTest(FallDur, 'nonnegative/rreal/scalar', 'FallDur arg is'));

NsamTot = numel(X);
dt = 1e3/Fsam;
TotDur = dt*NsamTot;
if Tstart+RiseDur>TotDur,
    error('Rising ramp exceeds signal duration.');
end
if Tstart+BurstDur>TotDur+dt,
    Tstart, BurstDur, TotDur
    error('End of falling ramp exceeds signal duration.');
end
if Tstart+BurstDur-FallDur<0,
    error('Start of falling portion preceeds signal start.');
end

NsamHead = round((Tstart+RiseDur)/dt); % # samples in the heading silence plus rising portion
t_re_tstart = dt*(0:NsamHead-1)-Tstart;
if RiseDur>0,
    Wrise = sin(2*pi*t_re_tstart/(4*RiseDur)).^2.'; % generate and 
    X(1:NsamHead) = Wrise.*X(1:NsamHead);  % ... apply rising window
end
X(find(t_re_tstart<=0)) = 0; % set pre-rise samples to zero.

Tfall = Tstart+BurstDur-FallDur; % start of falling portion
isamTail = (1+ceil(Tfall/dt):NsamTot).'; % sample indices of falling portion
t_re_tfallstart = (isamTail-1)*dt - Tfall; % time re start of fall
if FallDur>0,
    Wfall = cos(2*pi*t_re_tfallstart/(4*FallDur)).^2; % generate and ...
    X(isamTail) = Wfall.*X(isamTail); % apply fall window
end
Tend = Tstart+BurstDur; % end of falling portion
isamPost = (1+ceil(Tend/dt):NsamTot); % sample indices of post-fall era: ...
X(isamPost) = 0; % ... zero them


% restore original 'orientation'
if wasRow, X = X.'; end









