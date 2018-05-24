% CIstatSample -  SAC peak significance, sample script for the semi illiterate

% This script is just for data selection, the real work is 
% delegated to CIstat

binwidth = 0.05; % ms
Ntrial = 100; % # trials for stat calculation

%------specification of dataset and particular parameters--------

ds = dataset('G0868', '21-6-NRHO'); 
%rho = DSnoise.xval % this is just to show the values of the indep variable in order of presentation
isub = 2; % select rho = -1
AnaWindow = [50 1000]; % analysis window is 0 to 1000 ms
CIstat % compute stats and plot stuff
% text book!








