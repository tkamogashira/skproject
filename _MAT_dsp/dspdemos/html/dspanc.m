%% Acoustic Noise Cancellation (LMS)
% This example shows how to use the Least Mean Square (LMS) algorithm to
% subtract noise from an input signal. The LMS adaptive filter uses the
% reference signal on the |Input| port and the desired signal on the
% |Desired| port to automatically match the filter response. As it
% converges to the correct filter model, the filtered noise is subtracted
% and the error signal should contain only the original signal.

% Copyright 2006-2013 The MathWorks, Inc.

%% Exploring the Example
% In the model, the signal output at the upper port of the Acoustic
% Environment subsystem is white noise. The signal output at the lower port
% is composed of colored noise and a signal from a .wav file. This example
% model uses an adaptive filter to remove the noise from the signal output
% at the lower port. When you run the simulation, you hear both noise and a
% person playing the drums. Over time, the adaptive filter in the model
% filters out the noise so you only hear the drums.

%% Acoustic Noise Canceler Model
% The all-platform floating-point version of the model is shown below.
%%
open_system('dspanc');
close all hidden;
%%
bdclose dspanc;

%% Utilizing Your Audio Device
% By running this model, we can listen to the audio signal in real time
% (while running the simulation). The stop time is set to infinity. This
% allows us to interact with the model while it is running. For example, we
% can change the filter or alternate from slow adaptation to fast
% adaptation (and vice versa), and get a sense of the real-time audio
% processing behavior under these conditions.
%%
open_system('dspanc');
set_param('dspanc','StopTime','5');
sim('dspanc');
%%
bdclose dspanc;

%% Color Codes of the Blocks
% Notice the colors of the blocks in the model. These are sample time
% colors that indicate how fast a block executes. Here, the fastest
% discrete sample time (e.g., the 8 kHz audio signal processing portion) is
% red, and the second fastest discrete sample time is green. You can see
% that the color changes from red to green after down-sampling by 32 (in
% the Downsample block before the Waterfall Scope block). Further
% information on displaying sample time colors can be found in the
% Simulink(R) documentation.

%% Waterfall Scope
% The Waterfall window displays the behavior of the adaptive filter's
% filter coefficients. It displays multiple vectors of data at one time.
% These vectors represent the values of the filter's coefficients of a
% normalized LMS adaptive filter, and are the input data at consecutive
% sample times. The data is displayed in a three-dimensional axis in the
% Waterfall window. By default, the x-axis represents amplitude, the y-axis
% represents samples, and the z-axis represents time. The Waterfall window
% has toolbar buttons that enable you to zoom in on displayed data, suspend
% data capture, freeze the scope's display, save the scope position, and
% export data to the workspace.

%% Acoustic Environment Subsystem
% You can see the details of the Acoustic Environment subsystem by double
% clicking on that block. Gaussian noise is used to create the signal sent
% to the Exterior Mic output port. If the input to the Filter port changes
% from 0 to 1, the Digital Filter block changes from a lowpass filter to a
% bandpass filter. The filtered noise output from the Digital Filter block
% is added to the signal coming from a .wav-file to produce the signal sent
% to the Pilot's Mic output port.

%% References
% Haykin, S., *Adaptive Filter Theory*, 3rd Ed., Prentice-Hall, 1996.

%% Available Example Versions
% Floating-point version: <matlab:dspanc dspanc.mdl>
% 
% Fixed-point version: <matlab:dspanc_fixpt dspanc_fixpt.mdl>
