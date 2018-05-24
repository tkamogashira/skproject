%HELPERDESA2SYSOBJ Main simulation for Desa2SysobjExample
%
% Copyright 2013 The MathWorks, Inc.

%% Define system parameters

% Discrete time parameters
fs = 500;
totalTime = 4;
frameLength = 4;
nFrames = floor(totalTime/(frameLength/fs));

% FM-modulated sinusoid parameters
amplitude = 2;
frequencyOffset = 50;
frequencyStandardDeviation = 5;
frequencyResolution = 0.025;
frequencyNoiseCutoffFreq = 5;
frequencyNoiseBandRatio = frequencyNoiseCutoffFreq/(fs/2);

if(~exist('timeLimit', 'var'))
    timeLimit = Inf;
end

%% Create all objects used in simulation
% Including for testbench and core algorithm

% Tunable parameters during simulation
param(1) = struct('Name', 'Frequency Offset',...
    'InitialValue', frequencyOffset,...
    'Limits', [frequencyOffset/10, 2*frequencyOffset]);
param(2) = struct('Name', 'Standard Deviation',...
    'InitialValue', frequencyStandardDeviation,...
    'Limits', [0, 15*frequencyStandardDeviation]);
param(3) = struct('Name', 'Volatility',...
    'InitialValue', frequencyNoiseCutoffFreq,...
    'Limits', [1, fs/5]);

% Create UI to tune parameters
hUI = HelperCreateParamTuningUI(param);

% Test signal generator
hFMTone = dspdemo.RandomFMToneGenerator(...
    'Amplitude', amplitude,...
    'FrequencyOffset', param(1).InitialValue,...
    'FrequencyResolution', frequencyResolution,...
    'FrequencyStandardDeviation', param(2).InitialValue,...
    'FrequencyVariationNormalizedBandwidth',...
        param(3).InitialValue/(fs/2),...
    'SampleRate', fs,...
    'SamplesPerFrame', frameLength);

% Load two pre-saved scopes to visualize
% * Actual and estimated instantaneous tone frequencies
% * FM-modulated tone over time
load('HelperDesa2SysobjScopes.mat')

% Actual frequency estimator (DESA-2 operator)
hDESA2 = dspdemo.DesaTwo('SampleRate', fs);

% Set positions of scopes and parameter-tuning UI
p = get(0,'ScreenSize');
set(hUI, 'Position', [ 6*p(3)/10, 2*p(4)/8, 3*p(3)/10, 3*p(4)/8])
hScopeFreq.Position = [ 1*p(3)/10, 4*p(4)/8, 5*p(3)/10, 3*p(4)/8];
hScopeTime.Position = [ 1*p(3)/10, 1*p(4)/8, 5*p(3)/10, 3*p(4)/8];

%% Execute simulation loop
% Use Parameter-tuning UI to tune simulation parameters and pause or stop
% the simulation
tic
while(toc < timeLimit)  % Continue until 'Stop Simulation' button is pressed
    
    % *** Step 1 - Tune parameters
    
    % Obtain new parameter values from UI through a UDP Receiver
    [paramNewValues, simControlFlags] = HelperUnpackUDP();

    if simControlFlags.stopSim
        break;  % Stop the simulation
    end
    if simControlFlags.pauseSim
        drawnow;
         % Pause the simulation (but keep checking for commands from UI)
        continue;           
    end
    if simControlFlags.resetObj % Check if simulation needs to be reset
        reset(hFMTone);
        reset(hDESA2);
        reset(hScopeFreq);
        reset(hScopeTime);
    end
    if ~isempty(paramNewValues)
            hFMTone.FrequencyOffset = paramNewValues(1);
            hFMTone.FrequencyStandardDeviation = paramNewValues(2);
            hFMTone.FrequencyVariationNormalizedBandwidth = ...
                paramNewValues(3)/(fs/2);
    end
    
    % *** Step 2 - Simulate all system components through their STEP method

    % FM test tone generation
    [testTone, actualFrequency] = step(hFMTone);

    % Instantaneous frequency estimation (the instantaneous amplitude is
    % also estimated but not plotted for simplicity)
    [estimatedAmplitude, estimatedFreq] = step(hDESA2, testTone);

    % Visualization
    step(hScopeFreq, actualFrequency, estimatedFreq)
    step(hScopeTime, testTone)
    
end

% Cleanup after simulation
close(hUI); clear hUI     % Close the tuning UI
clear HelperUnpackUDP hUI
