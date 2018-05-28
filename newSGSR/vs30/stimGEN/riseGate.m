function rg = riseGate(N, RiseDur, RiseStart, SamP);

% returns N-sized cos^2 ramp (rising part) starting
% at RiseStart ms from begin (first sample: t=0 ms by definition)
% SamP is sample period in us, riseDur is duration
% Of rise window in ms.

% during riseDur, the argument of sin^2 should run from
% 0 to pi/2 radians. Compute the angular freq in rad/ms
RiseDur = max(RiseDur,SamP*1e-3); % avoid dividing by zero
omega = 0.5*pi/RiseDur; % in rad/ms

t = linspace(0,(N-1)*1e-3*SamP, N); % time axis in ms
rg = sin(omega*(t-RiseStart)).^2;

% zero out samples prior to window
NstartRise = min(N,ceil(RiseStart*1e3/SamP)); % sample number 
rg(1:NstartRise) = 0;


