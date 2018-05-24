function scopeHandles = ...
                HelperAircraftKalmanFilter(genCode, plotResults, numTSteps)
%HELPERAIRCRAFTKALMANFILTER Declare, initialize and step through
% the Kalman filter System object. The results are then displayed on time
% scope. The function returns a structure containing the time scopes. 
%
% Input:
%   genCode      - If true, MEX-file is used for simulation for the
%                  algorithm. Default value is false
%   plotResults  - If true, the results are displayed on time scopes.
%                  Default value is true
%   numTSteps    - Number of time steps. Default value is infinite
% Output:
%   scopeHandles - If plotResults is true, this is a structure containing
%                  four time scopes: X-position, Y-position, error in
%                  X-position and error in Y-position
%
% This function HelperAircraftKalmanFilterExample is only in support of 
% AircraftPositionEstimateExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.


%#codegen

%% Default values for inputs
maxTStepsPresent = true;
simCount = 0;
if nargin < 3
    maxTStepsPresent = false;  % Continue simulation till user asks to stop
end
if nargin < 2
    plotResults = true; % Plot results on TimeScopes
end
if nargin == 0
    genCode = false;    % Do not generate code
end

%% Initialization
% Initialize the parameters that will be tuned by the UI. The thrust
% parameters affect the aircraft trajectory and the noise parameters add
% the measurement noise of the RADAR.

clear HelperGenerateRadarData HelperAircraftKalmanFilterSim HelperAircraftKalmanFilterMEX HelperUnpackUDP
                    % Clear persistent variables from functions

rng(1);             % To get repeatable results
XNoise  = 1e6;    % Variance of noise in X-Coordinate
YNoise  = 5e5;    % Variance of noise in Y-Coordinate
XThrust = 5;       % Thrust for aircraft in X-direction
YThrust = -3;       % Thrust for aircraft in Y-direction
Fs      = 1000;     % Number of samples per second

%% Setting up time scopes
% Time scopes are used to view the results of the Kalman filter. Note that
% the results are plotted only if plotResults variable is true.
if plotResults
    load('AircraftPositionEstimateScopes.mat', 'hXScope', 'hYScope', ...
                                           'hXErrorScope', 'hYErrorScope');
    screen = get(0,'ScreenSize');
    outerSize = min((screen(4)-40)/2, 512);
    hXScope.Position = [8, screen(4)-outerSize+8, outerSize-16, outerSize-92];
    hYScope.Position = [outerSize+8, screen(4)-outerSize+8, outerSize-16, outerSize-92];
    hXErrorScope.Position = [8, screen(4)-2*outerSize+8, outerSize-16, outerSize-92];
    hYErrorScope.Position = [outerSize+8, screen(4)-2*outerSize+8, outerSize-16, outerSize-92];
else
    hXScope = [];
    hYScope = [];
    hXErrorScope = [];
    hYErrorScope = [];
end

%% Create UI to tune thrust and noise values
% Define parameters to be tuned
param = struct([]);
param(1).Name = 'Thrust in X-Position';
param(1).InitialValue = XThrust;
param(1).Limits = [-70, 70];

param(2).Name = 'Thrust in Y-Position';
param(2).InitialValue = YThrust;
param(2).Limits = [-70, 70];

param(3).Name = 'Var of noise in X-Position';
param(3).InitialValue = XNoise;
param(3).Limits = [0, 1e7];

param(4).Name = 'Var of noise in Y-Position';
param(4).InitialValue = YNoise;
param(4).Limits = [0, 1e7];

% Create the UI and pass it the parameters
hUI = HelperCreateParamTuningUI(param, 'Thrust and Variance of Measurement Noise');

%% Estimation using Kalman Filter
% Next, a loop needs to be configured that collects measurement values at
% every time step and passes it to the System object. The step() method for
% the System object hKalman is called with this recent measurement value.
% The results are plotted on time scopes.

% Setting up running mean for MSE
hMeanX = dsp.Mean('RunningMean', true);
hMeanY = dsp.Mean('RunningMean', true);

% Streaming
while (1)
    
    % Generate measurements of RADAR and then estimate using Kalman filter
    if ~genCode
       [trueX, trueY, noisyX, noisyY, filteredX, filteredY, ...
            XNoise, YNoise, XThrust, YThrust, pauseSim, stopSim] = ...
       HelperAircraftKalmanFilterSim(XNoise, YNoise, XThrust, YThrust, Fs);
    else
        [trueX, trueY, noisyX, noisyY, filteredX, filteredY, ...
            XNoise, YNoise, XThrust, YThrust, pauseSim, stopSim] = ...
       HelperAircraftKalmanFilterMEX(XNoise, YNoise, XThrust, YThrust, Fs);
    end
    
    if stopSim  % End of simulation
        break;
    end
    drawnow;   % needed to flush out UI event queue
    if pauseSim
        continue;
    end
    % Running mean relative error in estimation
    estErrorX = step(hMeanX, abs((filteredX-trueX)/trueX));
    estErrorY = step(hMeanY, abs((filteredY-trueY)/trueY));
    
    % Plot on time scopes
    if plotResults
        step(hXScope, noisyX, trueX, filteredX);
        step(hYScope, noisyY, trueY, filteredY);
        step(hXErrorScope, 20*log10(estErrorX));
        step(hYErrorScope, 20*log10(estErrorY));
    end
    
    % Stop simulation if max number of simulations reached
    if maxTStepsPresent
        simCount = simCount + 1;
        if (simCount == numTSteps)
            break;
        end
    end
end

if ishghandle(hUI)  % If parameter tuning UI is open, then close it.
    delete(hUI);
    drawnow;
    clear hUI
end
if plotResults
    release(hXScope);
    release(hYScope);
    release(hXErrorScope);
    release(hYErrorScope);
end
scopeHandles.XScope = hXScope;
scopeHandles.YScope = hYScope;
scopeHandles.XErrorScope = hXErrorScope;
scopeHandles.YErrorScope = hYErrorScope;
