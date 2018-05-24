function s = HelperAudioEqualization(usemex, plotResults, numTSteps)
%HelperAudioEqualization Graphical interface for audio equalization. 
%
% Input:
%   usemex       - If true, MEX-file is used for simulation for the
%                  algorithm. Default value is false. Note: in order to
%                  use the MEX file, first execute
%                  HelperAudioEqualizationCodeGeneration  
%   plotResults  - If true, the results are displayed on time scopes.
%                  Default value is true
%   numTSteps    - Number of time steps. Default value is infinite
%
% Output:
%   s - Structure containing ArrayPlot
%
% This function HelperAudioEqualization is only in support of 
% AudioEqualizationWithParametricEQExample. It may change in a future 
% release.

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
Fs   = 44.1e3;
NFFT = 4192;
dF   = Fs/NFFT;

% Define System objects
h = dsp.AudioFileReader('guitar10min.ogg','SamplesPerFrame',8000);

hp = dsp.AudioPlayer;

if plotResults
    titlestr = ['Parametric Filter Magnitude Response:',...
        'Filter 1 (Channel 1);',...
        'Filter 2 (Channel 2);',...
        'Filter 3 (Channel 3);',...
        'Overall Filter (Channel 4);'];
    hplot = dsp.ArrayPlot('PlotType','Line',...
        'YLimits',[-20 20],...
        'YLabel','Magnitude (dB)',...
        'XLabel','Frequency (Hz)',...
        'ShowLegend',true,...
        'Title',titlestr);
    
    hplot.XOffset = 0;
    pos = hplot.Position;
    hplot.Position(1:2) = [pos(1)-0.8*pos(3) pos(2)+0.7*pos(4)];
    hplot.SampleIncrement = dF;
else
    hplot = [];
end


% Define parameters to be tuned
param(1).Name = 'Center Frequency1';
param(1).InitialValue = 300;
param(1).Limits = [0, Fs/2];

param(2).Name = 'Bandwidth1';
param(2).InitialValue = 300;
param(2).Limits = [10, Fs/2];

param(3).Name = 'Peak Gain1 (dB)';
param(3).InitialValue = 3;
param(3).Limits = [-15 15];

param(4).Name = 'Center Frequency2';
param(4).InitialValue = 1000;
param(4).Limits = [0, Fs/2];

param(5).Name = 'Bandwidth2';
param(5).InitialValue = 500;
param(5).Limits = [10, Fs/2];

param(6).Name = 'Peak Gain2 (dB)';
param(6).InitialValue = -2;
param(6).Limits = [-15 15];

param(7).Name = 'Center Frequency3';
param(7).InitialValue = 3000;
param(7).Limits = [0, Fs/2];

param(8).Name = 'Bandwidth3';
param(8).InitialValue = 700;
param(8).Limits = [10, Fs/2];

param(9).Name = 'Peak Gain3 (dB)';
param(9).InitialValue = 2;
param(9).Limits = [-15 15];         


% Create the UI and pass it the parameters
hUI = HelperCreateParamTuningUI(param, 'Parametric Equalizer Tuning');

%% Streaming
args.SampleRate = Fs;
args.NFFT = NFFT;

count = 1;
pauseSim = false;
if usemex
    clear HelperEqualizationProcessing_mex HelperUnpackUDP;
else
    clear HelperEqualizationProcessing HelperUnpackUDP;
end
while ~isDone(h)   
    if ~pauseSim
        x = step(h);
    end
    if usemex
        [y,tfe,pauseSim,stopSim] = HelperEqualizationProcessing_mex(x,args,param);
    else
        
        [y,tfe,pauseSim,stopSim] = HelperEqualizationProcessing(x,args,param);
    end
    if stopSim     % If "Stop Simulation" button is pressed
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
    if plotResults
        updateSinks(hplot,tfe);         
    end
    if count > 20
        % Start playing audio after 20 iterations
        step(hp,y);
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
    release(hplot);
end
release(hp);
s.magscope = hplot;

function updateSinks(hplot,tfe)
step(hplot,20*log10(abs(tfe)));
