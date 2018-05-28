% SAMPLOT script

% parameters
N = 1e4; % # points to plot
fcar = 1000; % Hz carrier freq 
fmod = 100; % Hz mod freq 
dur = 20; % ms duration
phcar = 0; % rad carrier start phase
phmod = -pi/2; % rad mod start phase
moddepth = 0.5; % modulation depth

% compute waveform
t = linspace(0,dur,N); % N-point time axis in seconds
Car = sin(phcar+2*pi*fcar*t*1e-3); % carrier; factor 1e-3: ms-> s
Mod = sin(phmod+2*pi*fmod*t*1e-3); % modulator
Env = (1+moddepth*Mod);
Sam = Car.*Env;

% plot
plot(t,Sam);
hold on
plot(t,Env,'r');
plot(t,-Env,'r');
title(['SAM tone; carrier: ' num2str(fcar) ' Hz; modulation: ' num2str(fmod) ' Hz.']);
xlabel('Time (ms)');
ylabel('Amplitude')

