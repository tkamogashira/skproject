%% Radar Tracking
% This example shows how to use a Kalman filter to estimate an 
% aircraft's position and velocity from noisy radar measurements. 

% Copyright 2005-2012 The MathWorks, Inc.

%% Example Model
% The example model has three main functions. It generates aircraft position,
% velocity, and acceleration in polar (range-bearing) coordinates; it adds
% measurement noise to simulate inaccurate readings by the sensor; and it
% uses a Kalman filter to estimate position and velocity from the noisy
% measurements.
open_system('aero_radmod_dsp')
%% Model Output
% Run the model. At the end of the simulation, a figure displays the following
% information:
%
% - The actual trajectory compared to the estimated trajectory
%
% - The estimated residual for range
%
% - The actual, measured, and estimated positions in X
% (North-South) and Y (East-West)
sim('aero_radmod_dsp')
%% Kalman Filter Block
% Estimation of the aircraft's position and velocity is performed by the
% 'Radar Kalman Filter' subsystem. This subsystem samples the noisy
% measurements, converts them to rectangular coordinates, and sends them as
% input to the DSP System Toolbox(TM) Kalman Filter block.
%
% The Kalman Filter block produces two outputs in this application. The first is
% an estimate of the actual position. This output is converted back to polar
% coordinates so it can be compared with the measurement to produce a residual,
% the difference between the estimate and the measurement. The Kalman Filter
% block smoothes the measured position data to produce its estimate of the
% actual position.
%
% The second output from the Kalman Filter block is the estimate of the state of
% the aircraft. In this case, the state is comprised of four numbers that
% represent position and velocity in the X and Y coordinates.
open_system('aero_radmod_dsp/Radar Kalman Filter')
%% Experiment: Initial Velocity Mismatch
% The Kalman Filter block works best when it has an accurate estimate of the
% aircraft's position and velocity, but given time it can compensate for a bad
% initial estimate. To see this, change the entry for the *Initial condition for
% estimated state* parameter in the Kalman Filter. The correct value of the
% initial velocity in the Y direction is 400. Try changing the estimate to 100
% and run the model again.
set_param('aero_radmod_dsp/Radar Kalman Filter/Kalman Filter', ...
    'X','[0.001; 0.01; 0.001; 100]');
sim('aero_radmod_dsp')

%%
% Observe that the range residual is much greater and the 'E-W Position' 
% estimate is inaccurate at first. Gradually, the residual becomes smaller
% and the position becomes more accurate as more measurements are gathered.
set_param('aero_radmod_dsp/Radar Kalman Filter/Kalman Filter', ...
    'X','[0.001; 0.01; 0.001; 400]');

%% Experiment: Increasing the Measurement Noise
% In the present model, the noise added to the range estimate is rather small
% compared to the ultimate range. The maximum magnitude of the noise is 300 ft,
% compared to a maximum range of 40,000 ft. Try increasing the magnitude of the
% range noise to an larger value, for example, 5 times this amount or 1500 ft. 
% by changing the first component of the *Gain* parameter in the 'Meas. Noise
% Intensity' Gain block.
set_param('aero_radmod_dsp/Meas. Noise Intensity','Gain','[1500 0.01]');
sim('aero_radmod_dsp')
%%
% Observe that the blue lines representing the estimated positions have moved
% farther from the red lines representing the actual positions, and the curves
% have become much more 'bumpy' and 'jagged'. We can partially compensate for
% the inaccuracy by giving the Kalman Filter block a better estimate of the
% measurement noise. Try setting the *Measurement noise covariance* parameter
% of the Kalman Filter block to 1500 and run the model again.
set_param('aero_radmod_dsp/Radar Kalman Filter/Kalman Filter', ...
    'R', '1500*eye(2)');
sim('aero_radmod_dsp');
%%
% Observe that when the measurement noise estimate is better, the E-W and
% N-S position estimate curves become smoother. The N-S position curve
% now consistently underestimates the position. Given how noisy the
% measurements are compared to the value of the N-S coordinate, this is
% expected behavior.
set_param('aero_radmod_dsp/Meas. Noise Intensity','Gain','[300 0.01]');
set_param('aero_radmod_dsp/Radar Kalman Filter/Kalman Filter', ...
    'R', '300*eye(2)');
%% See Also
% The Simulink(R) example 'sldemo_radar_eml' uses the same initial simulation
% of target motion and accomplishes the tracking through the use of an
% extended Kalman filter implemented using the MATLAB Function block.
bdclose aero_radmod_dsp


