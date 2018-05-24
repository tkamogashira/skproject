%% Estimating Position of an Aircraft using Kalman Filter 
% This example shows how to use the Kalman filter in an application that
% involves estimating the position of an aircraft through a model for RADAR
% measurements. A user interface (UI) allows the user to control
% various parameters while the simulation is running. A MEX-file is also
% generated from the MATLAB code for accelerating the speed of execution in
% the same application. A speed comparison between the MATLAB function and
% the generated MEX-file is presented at the end.

% Copyright 2013 The MathWorks, Inc.


%% Introduction 
% Kalman filter is often used in tracking and navigation applications. In
% this example, we aim to simulate the tracking of an aircraft through a
% RADAR. The position of an aircraft can be estimated from noisy RADAR
% measurements using a Kalman filter. The scenario is depicted below:
%
% <<AircraftKalman01.png>>
%
% Four states related to the position of the aircraft are used to describe
% the system: x-coordinate ($x$), rate of change of x-coordinate
% ($\dot{x}$), y-coordinate ($y$) and rate of change of y-coordinate
% ($\dot{y}$). The system is, therefore, modeled as:
%
% <<AircraftKalman02.png>>
%
% <<AircraftKalman03.png>>
%
% where the noise is independent, white and Gaussian
%
% $$P (w) \sim  \mathcal{N}(0,Q)$$
%
% $$P (v) \sim  \mathcal{N}(0,R)$$

%% Kalman Filter System Object
% The Kalman filter System object used in this example was created using
% the procedure described in
% <matlab:web([docroot,'/dsp/gs/system-design-in-matlab-using-system-objects.html']);
% System Design in MATLAB Using System Objects>. The implementation is
% available in <matlab:edit('dsp.KalmanFilter'); |dsp.KalmanFilter|>. For
% the algorithm and properties of the Kalman filter, refer to the
% documentation for |dsp.KalmanFilter|.

%% Model for Generation of RADAR Measurements
% A model simulates acceleration values for the aircraft and uses that to
% generate the position and velocity data in Cartesian coordinate system.
% To create inaccurate measurements by the RADAR antenna, noise is added to
% the data.

%% Using the Kalman Filter in MATLAB
% The core algorithm of this example application applies Kalman filter to
% noisy RADAR measurements. It performs the following sequence of tasks:
%
% # Initialize the Kalman filter System object
% # Assign its properties based on the aircraft-RADAR system
% # Generate noisy RADAR measurement and pass it to the step() function of
% the Kalman filter
%
% The function <matlab:edit('HelperAircraftKalmanFilter')
% HelperAircraftKalmanFilter> wraps around the above algorithm and
% iteratively calls it, providing continuous tracking of the aircraft. It
% also plots the trajectory of the aircraft to compare the three: True
% position, noisy measurement of the position and Kalman filtered estimate
% of the position. The plots are created only when the |plotResults| input
% to the function is |true|.
%
% <matlab:run('HelperAircraftKalmanFilter') Click here> to call
% |HelperAircraftKalmanFilter| and plot the results on TimeScopes. Note
% that the simulation will be run for as long as the user does not
% explicitly stop it.
%
% The plots below are the output of running the above simulation for 2000
% time-steps:
%
% <<AircraftKalman05.png>>
%
%
% <<AircraftKalman06.png>>
%
%
% <<AircraftKalman07.png>>
%
%
% <<AircraftKalman08.png>>
%

%%
% The mitigation effect of Kalman filter over the noise can be seen through
% the above plots.
%
% The function <matlab:edit('HelperAircraftKalmanFilter')
% HelperAircraftKalmanFilter> launches a User Interface (UI)
% designed to interact with the simulation. The UI allows you to tune
% parameters and the results are reflected in the simulation instantly. For
% example, moving the slider for the 'Thrust in X-Position' to the right
% while the simulation is running, will increase the acceleration of the
% aircraft along the X-direction. You will notice the corresponding plot in
% the TimeScope get steeper, to reflect this change.
% 
% There are also three buttons on the UI - the 'Reset' button will reset
% the states of the Kalman filter to their initial values and the 'Pause
% Simulation' button will hold the simulation until you press on it again.
% The simulation may be terminated by either closing the UI or by clicking
% on the 'Stop simulation' button will end the simulation. The interaction
% between the UI and the simulation is performed using UDP. Using UDP
% enables the UI to control either the simulation or, optionally, a
% MEX-file (or standalone executable) generated from the simulation code as
% detailed below. If you have a MIDI controller, it is possible to
% synchronize it with the UI. You can do this by choosing a MIDI control
% in the dialog that is opened when you right-click on the sliders or
% buttons and select "Synchronize" from the context menu. The chosen MIDI
% control then works in accordance with the slider/button so that operating
% one control is tracked by the other.
%
% <<AircraftKalman04.png>>

%% Generating and Using the MEX-File
% MATLAB Coder can be used to generate C code for the function containing
% the algorithm. In order to generate a MEX-file for your platform,
% <matlab:run('HelperAircraftKalmanFilterGenMEX') execute the script
% HelperAircraftKalmanFilterGenMEX>. This will create the MEX-file in the
% current directory, so make sure that it is writable.
%
% By calling the wrapper function
% <matlab:edit('HelperAircraftKalmanFilter') HelperAircraftKalmanFilter>
% with  |'true'| as an argument, the generated MEX-file can be used for the
% simulation instead of MATLAB code. In this scenario, the UI is still
% running inside the MATLAB environment, but the main processing algorithm
% is being performed by a MEX-file. Performance is improved in this mode
% without compromising the ability to tune parameters.
%
% <matlab:run('HelperAircraftKalmanFilter(true)') Click on this>
% to call |HelperAircraftKalmanFilter| with |'true'| as argument to use the
% MEX-file for simulation. Again, the simulation will be run till the user
% explicitly stops it from the UI.

%% Speed Comparison
% Creating MEX-Files often helps achieve faster run-times for simulations.
% The function <matlab:edit('HelperCompareSpeedKalmanFilter')
% HelperCompareSpeedKalmanFilter> first measures the time taken by the
% MATLAB function that uses the System object without any plotting, and
% then measures the time for the run of the corresponding MEX-file. When
% you <matlab:run('HelperCompareSpeedKalmanFilter') run the function>, you
% can observe the magnitude of improvement in speed of execution on the
% Command Window output.

displayEndOfDemoMessage(mfilename)