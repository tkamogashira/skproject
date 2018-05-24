function scopeHandles = HelperMultibandCompression(genCode,plotResults,numTSteps)
% HELPERMULTIBANDCOMPRESSION  Initialize and execute audio multiband
% dynamic range compression example. The results are displayed using
% scopes. The function returns the handles to the scope and UI objects.
% Inputs:
%   genCode      - If true, use generated MEX file for simulation.
%                  Otherwise, use the MATLAB function. false if
%                  unspecified.
%   numTSteps    - Number of times the algorithm is executed in a loop. Inf
%                  if unspecified.
%   plotResults  - If true, the results are displayed on scopes. true if
%                  unspecified.

% Outputs:
%   scopeHandles    - If plotResults is true, handle to the visualization

% Copyright 2013 The MathWorks, Inc.

% Default values for inputs
if nargin < 3
    numTSteps = Inf; % Run until user stops simulation. 
end
if nargin < 2
    plotResults = true; % Plot results
end
if nargin == 0
    genCode = false; % Do not generate code. 
end
clear HelperUnpackUDP

% Create tuning UI 
param = struct([]);
param(1).Name = 'Band 1 Compression Factor';
param(1).InitialValue = 5;
param(1).Limits =  [1, 100];
param(2).Name = 'Band 1 Threshold (dB)';
param(2).InitialValue = -5;
param(2).Limits = [-80, 0];
param(3).Name = 'Band 1 Attack Time (sec)';
param(3).InitialValue = 5e-3;
param(3).Limits =  [0, 2000];
param(4).Name = 'Band 1 Release Time (sec)';
param(4).InitialValue = 100e-3;
param(4).Limits = [0, 2000];
param(5).Name = 'Band 2 Compression Factor';
param(5).InitialValue = 5;
param(5).Limits =  [1, 100];
param(6).Name = 'Band 2 Threshold (dB)';
param(6).InitialValue = -10;
param(6).Limits = [-80, 0];
param(7).Name = 'Band 2 Attack Time (sec)';
param(7).InitialValue = 5e-3;
param(7).Limits =  [0, 2000];
param(8).Name = 'Band 2 Release Time (sec)';
param(8).InitialValue = 100e-3;
param(8).Limits = [0, 2000];
param(9).Name = 'Band 3 Compression Factor';
param(9).InitialValue = 5;
param(9).Limits =  [1, 100];
param(10).Name = 'Band 3 Threshold (dB)';
param(10).InitialValue = -20;
param(10).Limits = [-80, 0];
param(11).Name = 'Band 3 Attack Time (sec)';
param(11).InitialValue = 2e-3;
param(11).Limits =  [0, 2000];
param(12).Name = 'Band 3 Release Time (sec)';
param(12).InitialValue = 50e-3;
param(12).Limits = [0, 2000];
param(13).Name = 'Band 4 Compression Factor';
param(13).InitialValue = 5;
param(13).Limits =  [1, 100];
param(14).Name = 'Band 4 Threshold (dB)';
param(14).InitialValue = -30;
param(14).Limits = [-80, 0];
param(15).Name = 'Band 4 Attack Time (sec)';
param(15).InitialValue = 2e-3;
param(15).Limits =  [0, 2000];
param(16).Name = 'Band 4 Release Time (sec)';
param(16).InitialValue = 50e-3;
param(16).Limits = [0, 2000];

hui = HelperCreateParamTuningUI(param, 'Multiband Dynamic Compression Example');

set(hui,'Position',[57   221   971   902]);

if plotResults
   % Plot the compressed and uncompressed signals
   %L = 8192;
   %SampleRate =  44100;
   %     hplot = dsp.TimeScope(...
   %         'SampleRate',SampleRate,...
   %         'TimeSpan',L/SampleRate,...
   %         'Title','Uncompressed and Compressed Audio Signals',...
   %         'YLabel','Value',...
   %         'ShowGrid',true,...
   %         'ShowLegend',true,...
   %         'YLimits',[-.4 .4],...
   %         'Position',[8 184 520 420],...     
   %         'TimeSpanOverrunAction','Wrap');
   %     hplot.show
   load dmultibandcompression.mat    
else
    hplot = [];
end

% Execute algorithm
count = 1;
while count<numTSteps
    if genCode
        [audio,stopSim,pauseSim] = HelperMultibandCompressionSim_mex();
    else
        [audio,stopSim,pauseSim] = HelperMultibandCompressionSim();
    end
    if stopSim     % If "Stop Simulation" button is pressed
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
   if plotResults
        % Visualize results
        step(hplot,audio);
    end
    count = count + 1;
end

% Clean up
if plotResults
    release(hplot);
end
clear HelperMultibandCompressionSim
clear HelperMultibandCompressionSim_mex
clear HelperUnpackUDP
  
scopeHandles.hplot = hplot;


end