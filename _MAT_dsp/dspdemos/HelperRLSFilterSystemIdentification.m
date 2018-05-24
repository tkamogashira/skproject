function scopeHandles = HelperRLSFilterSystemIdentification(genCode,plotResults,numTSteps)
%HELPERRLSFILTERSYSTEMIDENTIFICATION Initialize and execute RLS Filter 
% system identification example. The results are then displayed using 
% scopes. The function returns the handles to the scope and UI objects.  
% Inputs:
%   genCode      - If true, Generate MEX-File and use that for simulation.
%                  Otherwise, use the MATLAB function. false if not 
%                  specified. 
%   numTSteps    - Number of times the algorithm is executed in a loop. Inf
%                  if not specified
%   plotResults  - If true, the results are displayed on scopes. true if
%                  unspecified. 

% Outputs:
%   scopeHandles    - If plotResults is true, handle to the visualization scopes            . 

% Copyright 2013 The MathWorks, Inc.

%#codegen

%% Default values for inputs
if nargin < 3
    numTSteps = Inf; % Run until user stops simulation. 
end
if nargin < 2
    plotResults = true; % Plot results
end
if nargin == 0
    genCode = false; % Do not generate code. 
end

% Create scopes only if plotResults is true
if plotResults
%     tfescope = dsp.ArrayPlot('PlotType','Line',...
%         'YLimits',[-80 30],...
%         'SampleIncrement',1e4/1024,...
%         'YLabel','Amplitude (dB)',...
%         'XLabel','Frequency (Hz)',...
%         'Title','Desired and Estimated Transfer Functions',...
%         'ShowLegend',true,...
%         'XOffset',-5000);
% 
%     msescope = dsp.TimeScope('SampleRate',1e4,'TimeSpan',.01,...
%         'YLimits',[-300 10],'ShowGrid',true,...
%         'YLabel','Mean-Square Error (dB)',...
%         'Title','RLSFilter Learning Curve');
%      
   load('RLSFiltersystemIdentificationScopes.mat', 'tfescope', ...
                                                   'msescope');                             
    screen = get(0,'ScreenSize');
    outerSize = min((screen(4)-40)/2, 512);
    tfescope.Position = [8, screen(4)-outerSize+8, outerSize+8,...
                            outerSize-92];
    coeffscope.Position = [outerSize+32, screen(4)-outerSize+8, ...
                              outerSize+8, outerSize-92];
    msescope.Position = [8, screen(4)-2*outerSize+8, outerSize+8, ...
                            outerSize-92];
                                       
    % Create UI to tune FIR filter cutoff frequency and RLS filter 
    %  forgetting factor
    Fs = 1e4;
    param = struct([]);
    param(1).Name = 'Cutoff Frequency (Hz)';
    param(1).InitialValue = 0.48 * Fs/2;
    param(1).Limits = Fs/2 * [1e-5, .9999];
    param(2).Name = 'RLS Forgetting Factor';
    param(2).InitialValue = 0.99;
    param(2).Limits = [.3, 1];
    hUI = HelperCreateParamTuningUI(param, 'RLS FIR Demo');
    set(hUI,'Position',[outerSize+32, screen(4)-2*outerSize+8, ...
        outerSize+8, outerSize-92]); 
else
    tfescope = [];
    coeffscope = [];
    msescope = [];
end

clear HelperUnpackUDP

% Execute algorithm
while(numTSteps>=0)
    if ~genCode
        [tfe,err,pauseSim,stopSim] = HelperRLSFilterSystemIdentificationSim();
    else
        [tfe,err,pauseSim,stopSim] = HelperRLSFilterSystemIdentificationSimMEX();
    end
    if stopSim     % If "Stop Simulation" button is pressed
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
    if plotResults
            % Plot transfer functions
            step(tfescope,20*log10(abs(tfe)));
            % Plot learning curve
            step(msescope,10*log10(sum(err.^2)));
    end
    numTSteps = numTSteps - 1;
end

if ishghandle(hUI)  % If parameter tuning UI is open, then close it.
    delete(hUI);
    drawnow;
    clear hUI
end
  
scopeHandles.tfescope = tfescope;
scopeHandles.coeffscope = coeffscope;
scopeHandles.msescope = msescope;
