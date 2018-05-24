% CIstatSample -  SAC peak significance, sample script for the semi illiterate

% This script is just for data selection, the real work is 
% delegated to CIstat

binwidth = 0.05; % ms
Ntrial = 100; % # trials for stat calculation

%------specification of dataset and particular parameters--------

ds = dataset('A0428', '3-2-NRHO'); 
rho = DSnoise.xval % this is just to show the values of the indep variable in order of presentation
isub = 1; % select rho = -1
AnaWindow = [0 1000]; % analysis window is 0 to 1000 ms
CIstat % compute stats and plot stuff
% text book!

ds = dataset('A0428', '3-4-FS');
isub = 3; % 3200 Hz tone freq
AnaWindow = [0 2000]; % analysis window 
CIstat % compute stats and plot stuff
% poor signifance due to small # reps: 10, resulting in a ...
% ... quantized pdf in the second panel. Could be improved by ...
% ... artificially chopping up the responses into smaller ...
% ... segment lasting a whole # stimulus cycles.

ds = dataset('A0428', '3-4-FS');
isub = 8; % 3700 Hz tone freq
AnaWindow = [0 2000]; % analysis window is 0 to 1000 ms
CIstat % compute stats and plot stuff
% phaselocking limit kicks in - see cycle histogram etc

ds = dataset('A0428', '35-2-FS');
isub = 1; % 591 Hz tone freq
AnaWindow = [0 5000]; % analysis window 
CIstat % compute stats and plot stuff
% low freq, 40 reps, long duration: high significance






