function fg = fallGate(N, FallDur, FallStart, SamP);

% returns N-sized cos^2 ramp (fall part) starting
% at FallStart ms from begin (first sample: t=0 ms by definition)
% SamP is sample period in us, FallDur is duration
% of fall window in ms.

% during FallDur, the argument of cos^2 should run from
% 0 to pi/2 radians. Compute the angular freq in rad/ms
FallDur = max(FallDur,1e-4); % avoid dividing by zero
omega = 0.5*pi/FallDur; % in rad/ms

t = linspace(0,(N-1)*1e-3*SamP, N); % time axis in ms
fg = cos(omega*(t-FallStart)).^2;

% correct out samples prior to, and following, window
NfallStart = floor(FallStart*1e3/SamP); % sample number 
NfallEnd = ceil((FallStart+FallDur)*1e3/SamP); % sample number 

fg(1:NfallStart) = ones(1,NfallStart);
if NfallEnd==0, return; end;
fg(NfallEnd:N) = zeros(1,N-NfallEnd+1);


