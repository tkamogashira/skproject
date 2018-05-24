%HELPERAIRCRAFTKALMANFILTERGENMEX Generate a MEX-file for the Aircraft
%position estimation demo that uses Kalman filter System object
% 
% Note that a license for MATLAB Coder is needed to run this script.
%
% This script HelperAircraftKalmanFilterGenEXE is only in support of 
% AircraftPositionEstimateExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

clear HelperGenerateRadarData HelperAircraftKalmanFilterSim HelperAircraftKalmanFilterMEX
                                              % clear persistent variables
disp('Generating MEX-file ...');
codegen HelperAircraftKalmanFilterSim -args {0, 0, 0, 0, 0} -o HelperAircraftKalmanFilterMEX
disp('Done');