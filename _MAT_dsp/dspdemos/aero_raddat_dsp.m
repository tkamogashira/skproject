%AERO_RADDAT_DSP sets up data needed to run radar model "aero_radmod_dsp".

% Copyright 2010 The MathWorks, Inc.

g = 32.2;    % Acceleration due to gravity (ft/sec^2)
tauc = 5;    % Correlation time of aircraft cross axis acceleration
tauT = 4;    % Correlation time of aircraft thrust axis acceleration
Speed = 400; % Initial speed of aircraft in y direction feet/sec
deltat = 1;  % Radar update rate (also hard-coded in extkalman.m)
