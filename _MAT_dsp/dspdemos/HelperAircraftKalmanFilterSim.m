function [trueX, trueY, noisyX, noisyY, filteredX, filteredY, ...
    XNoise, YNoise, XThrust, YThrust, pauseSim, stopSim] = ...
        HelperAircraftKalmanFilterSim(XNoise, YNoise, XThrust, YThrust, Fs)
%HELPERAIRCRAFTKALMANFILTERSIM Declare, initialize and step through the
% Kalman filter System object. The function also receives inputs for
% tunable parameters through a GUI.
% Inputs:
%     XNoise    - Noise variance for X-Position
% 	  YNoise    - Noise variance for Y-Position
%     XThrust   - Thrust used to generate the acceleration input for
%                 X-position of the aircraft 
%     YThrust   - Thrust used to generate the acceleration input for
%                 Y-position of the aircraft 
%     Fs        - Sampling rate
% Outputs:
%     trueX       -  Actual X-coordinate of the aircraft
%     trueY       -  Actual Y-coordinate of the aircraft
%     noisyX      -  X-coordinate of aircraft with measurement noise added
%     noisyY      -  Y-coordinate of aircraft with measurement noise added
%     filteredX   -  X-coordinate of aircraft estimated by Kalman filter
%     filteredY   -  Y-coordinate of aircraft estimated by Kalman filter
%     XNoise      -  New value for XNoise
%     YNoise      -  New value for YNoise
%     XThrust     -  New value for XThrust
%     YThrust     -  New value for YThrust
%     stopSim     -  Flag to stop the simulation. If true, the simulation 
%                    needs to be stopped
%
% This function HelperAircraftKalmanFilterSim is only in support of 
% AircraftPositionEstimateExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.


%#codegen

%% Initialization
persistent hKalman      % declare as persistent because states need to be 
                        % maintained between calls to the function
if isempty(hKalman)
    % The first step in using the System object is to declare it and
    % initialize its properties based on the application. The parameters
    % are set to match the aircraft-RADAR system as described in the
    % *Introduction* section of the example.
    hKalman = dsp.KalmanFilter;     % System object
    hKalman.StateTransitionMatrix = [1 1 0 0; 0 1 0 0 ; 0 0 1 1; 0 0 0 1];
    hKalman.ControlInputPort = false;
    hKalman.MeasurementMatrix = [1 0 0 0; 0 0 1 0];     
    hKalman.ProcessNoiseCovariance = 0.005*eye(4);
    hKalman.MeasurementNoiseCovariance = [XNoise 0; 0 YNoise];
    hKalman.InitialStateEstimate = [100; -5; -100; 10];
    hKalman.InitialErrorCovarianceEstimate = zeros(4);
end
trueX = 0;
trueY = 0;
noisyX = 0;
noisyY = 0;
filteredX = 0;
filteredY = 0;

%% New parameter values from the GUI
[paramNew, simControlFlags] = HelperUnpackUDP(); 
                % Obtain new values for parameters through UDP Receive

pauseSim = simControlFlags.pauseSim;
stopSim = simControlFlags.stopSim;

% Obtain new values for parameters through UDP Receive
if simControlFlags.stopSim
    release(hKalman);
    return;  % Stop the simulation
end
if simControlFlags.pauseSim
    return; % Pause the simulation (but keep checking for commands from GUI)
end
if ~isempty(paramNew)
    if simControlFlags.resetObj % Flag to reset the Kalman filter System object
        reset(hKalman);
    end
    XThrust = paramNew(1); % Thrust in X-direction
    YThrust = paramNew(2); % Thrust in Y-direction
    XNoise = paramNew(3);  % Noise variance for X-Position
    YNoise = paramNew(4);  % Noise variance for Y-Position
    hKalman.MeasurementNoiseCovariance = [XNoise 0; 0 YNoise];
end

%% Get RADAR measurement
[trueX, trueY, noisyX, noisyY] = ...
    HelperGenerateRadarData(1, XNoise, YNoise, XThrust, YThrust, Fs);
   % Use the model in HelperGenerateRadarData to generate measurements
noisyXY = [noisyX; noisyY]; % Noisy measurements by the RADAR

%% Call the step function of the System object
filteredXY = step(hKalman,noisyXY);
filteredX = filteredXY(1);
filteredY = filteredXY(2);