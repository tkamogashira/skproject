function HelperCompareSpeedKalmanFilter
% HELPERCOMPARESPEEDKALMANFILTER Demonstrate the speed-up achieved by
% generating a MEX-File for the MATLAB code that uses Kalman filter System
% object
%
% This function HelperCompareSpeedSystemObject is only in support of 
% AircraftPositionEstimateExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

%% Initialize inputs
XNoise = 10000;
YNoise = 10000;
XThrust = 30;
YThrust = 30;
Fs = 1000;
nSamples = 10000;

%% Execute the MATLAB code and time it
clear HelperGenerateRadarData HelperAircraftKalmanFilterSim HelperAircraftKalmanFilterMEX
                                              % clear persistent variables
disp('Running the MATLAB code...')
tic
for ind = 1:nSamples
    HelperAircraftKalmanFilterSim(XNoise, YNoise, XThrust, YThrust, Fs);
end
tMATLAB = toc;

%% Create the MEX-File in a temporary directory
currDir = pwd;  % Store the current directory address
mexDir   = [tempdir 'AircraftPositionEstimateExampleMEXDir']; % Name of
                                                              % temporary directory
if ~exist(mexDir,'dir')
    mkdir(mexDir);       % Create temporary directory
end
cd(mexDir);          % Change directory

clear HelperGenerateRadarData HelperAircraftKalmanFilterSim HelperAircraftKalmanFilterMEX
                                              % clear persistent variables
disp('Generating MEX-File...')
codegen HelperAircraftKalmanFilterSim -args {XNoise, YNoise, XThrust, YThrust, Fs} -o HelperAircraftKalmanFilterMEX

%% Execute the MEX-File and time it
clear HelperGenerateRadarData HelperAircraftKalmanFilterSim HelperAircraftKalmanFilterMEX
                                              % clear persistent variables
disp('Running the MEX-File...')
tic
for ind = 1:nSamples
    HelperAircraftKalmanFilterMEX(XNoise, YNoise, XThrust, YThrust, Fs);
end
tMEX = toc;

%% Clean up generated files and delete temporary directory
cd(currDir);
clear HelperAircraftKalmanFilterMEX;
rmdir(mexDir, 's');

%% Display the results
disp('RESULTS:')
disp(['Time taken to run the MATLAB System object: ', num2str(tMATLAB),...
    ' seconds']);
disp(['Time taken to run the MEX-File: ', num2str(tMEX), ' seconds']);
disp(['Speed-up by a factor of ', num2str(tMATLAB/tMEX),...
    ' is achieved by creating the MEX-File']);