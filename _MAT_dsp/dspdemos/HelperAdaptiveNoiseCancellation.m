function s = HelperAdaptiveNoiseCancellation(usemex, plotResults, numTSteps)
%HelperAdaptiveNoiseCancellation Graphical interface for Adaptive Noise 
% Canceling (ANC) Applied to Fetal Electrocardiography
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
%   s - Structure containing time scope
%
% This function HelperAdaptiveNoiseCancellation is only in support of 
% adaptncdemo. It may change in a future release.

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

F = 75; % Samples per frame
%% Creating the Maternal Heartbeat Signal
% In this example, we shall simulate the shapes of the electrocardiogram 
% for both the mother and fetus.  The following commands create an 
% electrocardiogram signal that a mother's heart might produce assuming
% a 4000 Hz sampling rate.  The heart rate for this signal is approximately
% 89 beats per minute, and the peak voltage of the signal is 3.5
% millivolts. 

x1 = 3.5*ecg(2700).';
y1 = sgolayfilt(x1,0,21);
Hmhb = dsp.SignalSource(y1,'SamplesPerFrame',F,...
    'SignalEndAction','Cyclic repetition');

%% Creating the Fetal Heartbeat Signal
% The heart of a fetus beats noticeably faster than that of its mother, 
% with rates ranging from 120 to 160 beats per minute.  The amplitude of
% the fetal electrocardiogram is also much weaker than that of the maternal
% electrocardiogram.  The following series of commands creates an
% electrocardiogram signal corresponding to a heart rate of 139 beats per
% minute and a peak voltage of 0.25 millivolts. 

x2 = 0.25*ecg(1725).';
y2 = sgolayfilt(x2,0,17);
Hfhb = dsp.SignalSource(y2,'SamplesPerFrame',F,...
    'SignalEndAction','Cyclic repetition');


if plotResults
    load adaptnc_timescope;
else
    Hts = [];    
end
    
% Define parameters to be tuned
param(1).Name = 'Fetal Heartbeat Measurement noise';
param(1).InitialValue = 0.02;
param(1).Limits = [0, 0.1];

param(2).Name = 'Maternal Heartbeat Measurement noise';;
param(2).InitialValue = 0.02;
param(2).Limits = [0, 0.1];           

% Create the UI and pass it the parameters
hUI = HelperCreateParamTuningUI(param, 'Adaptive Noise Cancellation');

%% Streaming
count = 1;
if usemex
    clear HelperAdaptiveNoiseCancellationProcessing_mex HelperUnpackUDP;
else
    clear HelperAdaptiveNoiseCancellationProcessing HelperUnpackUDP;
end

pauseSim = false;

while true  
    if ~pauseSim
        mhb = step(Hmhb);
        fhb = step(Hfhb);
    end
    if usemex
        [d,x,e,pauseSim,stopSim] = HelperAdaptiveNoiseCancellationProcessing_mex(mhb,fhb,param);
    else
        [d,x,e,pauseSim,stopSim] = HelperAdaptiveNoiseCancellationProcessing(mhb,fhb,param);
    end
    if stopSim       % If "Stop Simulation" button is pressed
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
    
    if plotResults
        step(Hts,d,x,e);
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
    release(Hts);    
end
s.timescope = Hts;



