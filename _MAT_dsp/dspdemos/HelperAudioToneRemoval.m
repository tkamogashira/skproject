function s = HelperAudioToneRemoval(usemex, plotResults, numTSteps)
%HELPERAUDIOTONEREMOVAL Graphical interface for tone removal from audio. 
%
% Input:
%   usemex       - If true, MEX-file is used for simulation for the
%                  algorithm. Default value is false. Note: in order to
%                  use the MEX file, first execute
%                  HelperAudioToneRemovalCodeGeneration 
%   plotResults  - If true, the results are displayed on time scopes.
%                  Default value is true
%   numTSteps    - Number of time steps. Default value is infinite
%
% Output:
%   s - Structure containing ArrayPlot and SpectrumAnalyzer
%
% This function HelperAudioToneRemoval is only in support of 
% AudioInterferringToneRemovalExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

if nargin < 1
    usemex = false;
end
maxTStepsPresent = true;
if nargin < 3
    maxTStepsPresent = false;  % Continue simulation till user asks to stop
end
if nargin < 2
    plotResults = true; % Plot results on TimeScopes
end

%% Setup
Fs = 44.1e3;
SamplesPerFrame = 1024;
NFFT = 4192;
dF = Fs/NFFT;
stIdx  = 2;  Fstart = stIdx*dF;
spIdx = 100; Fstop  = spIdx*dF;

% Define System objects
h = dsp.AudioFileReader('guitar10min.ogg');

hp = dsp.AudioPlayer;

% Interfering tone
ftone = 250;
hw = dsp.SineWave('Amplitude',0.8,'SampleRate',Fs,...
    'Frequency',[ftone ftone],'SamplesPerFrame',SamplesPerFrame);

if plotResults
    titlestr = ['Audio corrupted with 250 Hz tone (Channel 1); ',...
        'Filtered audio (Channel 2); ','Notch filter (Channel 3)'];
    hs = dsp.SpectrumAnalyzer('SampleRate',Fs,'SpectralAverages',5,...
        'RBWSource','Property','RBW',5,...
        'FrequencySpan','Start and stop frequencies','ShowLegend',true,...
        'StartFrequency',Fstart,'StopFrequency',Fstop,'Title',titlestr);
else
    hs = [];    
end
    
% Define parameters to be tuned
param(1).Name = 'Center Frequency';
param(1).InitialValue = 500;
param(1).Limits = [Fstart, Fstop];

param(2).Name = '3-dB Bandwidth';
param(2).InitialValue = 300;
param(2).Limits = [10, Fstop];           

% Create the UI and pass it the parameters
hUI = HelperCreateParamTuningUI(param, 'Notch Filter Tuning');

%% Streaming
args.SampleRate = Fs;

count = 1;
pauseSim = false;
if usemex
    clear HelperAudioToneRemovalProcessing_mex HelperUnpackUDP;
else
    clear HelperAudioToneRemovalProcessing HelperUnpackUDP;
end

while ~isDone(h)   
    if ~pauseSim
        x = step(h) + step(hw); % Add tone to input audio
    end
    if usemex
        [y,pauseSim,stopSim] = HelperAudioToneRemovalProcessing_mex(x,args,param);
    else
        [y,pauseSim,stopSim] = HelperAudioToneRemovalProcessing(x,args,param);
    end
    if stopSim     % If "Stop Simulation" button is pressed
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
    if plotResults
        updateSinks(hs,x,y);
    end
    if count > 20
        % Start playing audio after 20 iterations
        step(hp,y(:,1:2));
    end
    
    % Stop simulation if max number of simulations reached
    if maxTStepsPresent
        
        if (count == numTSteps)
            break;
        end
    end
    
    count = count + 1;
end

%% Cleanup
if ishghandle(hUI)  % If parameter tuning UI is open, then close it.
    delete(hUI);
    drawnow;
    clear hUI
end
if plotResults
    release(hs);
end
release(hp);
s.spectrumanalyzer = hs;

function updateSinks(hs,x,y)
step(hs,[x(:,1),y(:,1),y(:,3)]);

