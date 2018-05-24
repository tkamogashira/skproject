function [trueX, trueY, noisyX, noisyY] = ...
    HelperGenerateRadarData(numSteps, XNoise, YNoise, XThrust, YThrust, Fs)
% HELPERGENERATERADARDATA Model the Aircraft-RADAR system and generate true
% and noisy measurements for the position of the aircraft.
% Input:
%     tSteps - Number of time-steps to generate the data for
%     XNoise - Noise variance for X-Position
% 	  YNoise - Noise variance for Y-Position
%     XThrust- Thrust used to generate the acceleration input for
%              X-position of the aircraft 
%     YThrust- Thrust used to generate the acceleration input for
%              Y-position of the aircraft 
%     Fs     - Sampling rate
%     
% Outputs:
%     trueX  - Actual X-position of the aircraft
%     trueY  - Actual Y-position of the aircraft
%     noisyX - X-position with noise added
%     noisyY - Y-position with noise added
%
% This function HelperGenerateRadarData is only in support of 
% AircraftPositionEstimateExample. It may change in a future release.

% Copyright 2012 The MathWorks, Inc.

%#codegen

%% Initialization of variables

persistent thrustPrev velocityPrev positionPrev  
% These values are persistent because the function can be called multiple
% times in a loop

measNoisePower = [XNoise,YNoise]; % Noise power for the measurement noise
thrust         = [XThrust, YThrust];    % Thrust for aircraft

if isempty(positionPrev)
    % Initial values 
    
    thrustPrev = [0, 0];
    Speed = 4;
    velocityPrev = [0,Speed];
    positionPrev = [2000,-4000];
end

tauc = 5;
tauT = 4;
K = 5;    % gain of integrator
T = 1/Fs;  % step-size

g = 32.2;  % feet/sec^2

trueX = zeros(numSteps,1);    % Actual X-coordinates of the Aircraft's path
trueY = zeros(numSteps,1);    % Actual Y-coordinates of the Aircraft's path
noisyX = zeros(numSteps,1);   % Noisy X-coordinates of the Aircraft's path
noisyY = zeros(numSteps,1);   % Noisy Y-coordinates of the Aircraft's path

%% Position calculation through iteration
for ind = 1:numSteps
    
    % Generate thrust values for the aircraft
    sigX = thrust(1);
    sigY = thrust(2);
    sig = [sigX, sigY];

    %% Acceleration Model
    % Compute the acceleration value for the aircraft at current time step
    sig = sig - thrustPrev.*[1/tauc, 1/tauT];
    thrustNew = thrustPrev + K*T*sig;
    thrustPrev = thrustNew;
    acc = thrustNew * g;
    
    %% Velocity
    % Compute the velocity value for the aircraft at current time step
    vel = velocityPrev + K*T*acc;
    velocityPrev = vel;
    
    %% Position
    % Compute the position value for the aircraft at current time step
    pos = positionPrev + K*T*vel;
    positionPrev = pos;

    %% True values for position in XY
    trueX(ind) = pos(1);
    trueY(ind) = pos(2);
       
    %% Add measurement noise
    noiseX = randn * sqrt(measNoisePower(1)); % Noise in X measuement
    noiseY = randn * sqrt(measNoisePower(2)); % Noise in Ymeasuement
    
    noisyX(ind) = trueX(ind) + noiseX;
    noisyY(ind) = trueY(ind) + noiseY;
    
end

