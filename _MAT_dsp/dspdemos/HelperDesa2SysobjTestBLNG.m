%HELPERDESA2SYSOBJBLNG Simulation script for BandlimitedNoiseGenerator

% Copyright 2013 The MathWorks, Inc.

%% Define system parameters

% Discrete time parameters
fs = 500;
totalTime = 5;
frameLength = 1;
nFrames = floor(totalTime/(frameLength/fs));

% Signal parameters
standardDeviation = 1.5;
noiseCutoffFreq = 5;
noiseBandRatio = noiseCutoffFreq/(fs/2);

%% Create all objects used in simulation

% Noise generator
hNoiseGen = dspdemo.BandlimitedNoiseGenerator(...
    'NoiseStandardDeviation', standardDeviation,...
    'NoiseNormalizedBandwidth', noiseBandRatio,...
    'SamplesPerFrame', frameLength);

% Scope to visualize expected and estimated frequencies
hScope = dsp.TimeScope(...
    'YLimits', standardDeviation*[-6 6],...
    'YLabel','Noisy signal',...
    'TimeSpan',totalTime/5,...
    'BufferLength', 2 * totalTime/2 * fs,...
    'FrameBasedProcessing', true,...
    'SampleRate', fs,...
    'Title', 'Bandlimited Noise',...
    'ShowLegend', true,...
    'ShowGrid', true,...
    'NumInputPorts', 1,...
    'PlotType', 'Stairs');

%% Execute simulation loop
for k = 1:nFrames
    % Random frequency variation signal
    frequencyRandZeroMean = step(hNoiseGen);
    
    % Visualization
    step(hScope, frequencyRandZeroMean)
end

clear hNoiseGen hScope