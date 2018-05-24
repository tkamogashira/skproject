%% Adaptive Noise Canceling (ANC) Applied to Fetal Electrocardiography
% This example shows how to apply adaptive filters to noise removal using
% adaptive noise canceling. The example uses a user interface (UI) which
% can be launched by typing the command HelperAdaptiveNoiseCancellation.
% For more details, see 'Example Architecture' below.
%
%   Copyright 1999-2013 The MathWorks, Inc.

%% Introduccion
% In adaptive noise canceling, a measured signal d(n) contains two signals:
%        - an unknown signal of interest v(n)
%        - an interference signal u(n)
% The goal is to remove the interference signal from the measured
% signal by using a reference signal x(n) that is highly correlated with 
% the interference signal.  The example considered here is an application
% of adaptive filters to fetal electrocardiography, in which a maternal 
% heartbeat signal is adaptively removed from a fetal heartbeat sensor
% signal.  This example is adapted from Widrow, et al, "Adaptive noise 
% canceling:  Principles and applications," Proc. IEEE(R), vol. 63, no. 12, 
% pp. 1692-1716, December 1975.  

%% Creating the Maternal Heartbeat Signal
% In this example, we shall simulate the shapes of the electrocardiogram 
% for both the mother and fetus.  We use a 4000 Hz sampling rate.  The
% heart rate for this signal is approximately 89 beats per minute, and the
% peak voltage of the signal is 3.5 millivolts.

%% Creating the Fetal Heartbeat Signal
% The heart of a fetus beats noticeably faster than that of its mother, 
% with rates ranging from 120 to 160 beats per minute.  The amplitude of
% the fetal electrocardiogram is also much weaker than that of the maternal
% electrocardiogram.  The following series of commands creates an
% electrocardiogram signal corresponding to a heart rate of 139 beats per
% minute and a peak voltage of 0.25 millivolts. 

%% The Measured Maternal Electrocardiogram
% The maternal electrocardiogram signal is obtained from the chest of the
% mother. The goal of the adaptive noise canceller in this task is to
% adaptively remove the maternal heartbeat signal from the fetal
% electrocardiogram signal. The canceller needs a reference signal
% generated from a maternal electrocardiogram to perform this task.  Just
% like the fetal electrocardiogram signal, the maternal electrocardiogram
% signal will contain some additive broadband noise.


%% The Measured Fetal Electrocardiogram
% The measured fetal electrocardiogram signal from the abdomen of the mother
% is usually dominated by the maternal heartbeat signal that propagates
% from the chest cavity to the abdomen.  We shall describe this propagation
% path as a linear FIR filter with 10 randomized coefficients.  In
% addition, we shall add a small amount of uncorrelated Gaussian noise to 
% simulate any broadband noise sources within the measurement.  

%% Applying the Adaptive Noise Canceller
% The adaptive noise canceller can use most any adaptive procedure to
% perform its task.  For simplicity, we shall use the least-mean-square
% (LMS) adaptive filter with 15 coefficients and a step size of 0.00007.
% With these settings, the adaptive noise canceller converges reasonably
% well after a few seconds of adaptation--certainly a reasonable period 
% to wait given this particular diagnostic application.  

%% Recovering the Fetal Heartbeat Signal
% The output signal y(n) of the adaptive filter contains the estimated 
% maternal heartbeat signal, which is not the ultimate signal of interest.  
% What remains in the error signal e(n) after the system has converged is
% an estimate of the fetal heartbeat signal along with residual measurement
% noise.  Using the error signal, can you estimate the heart rate of the 
% fetus?

%% Example Architecture
% The command <matlab:edit('HelperAdaptiveNoiseCancellation')
% HelperAdaptiveNoiseCancellation> launches a user interface
% designed to interact with the simulation. It also launches a
% time scope to view the the measured fetal hearbeat as well as the
% measured maternal heartbeat and the extracted fetal heartbeat.

%% Using a Generated MEX File
% Using MATLAB Coder, you can generate a MEX file for the main processing
% algorithm by executing the command
% <matlab:edit('HelperANCCodeGeneration') HelperANCCodeGeneration>. You can
% use the generated MEX file by executing the command
% HelperAdaptiveNoiseCancellation(true).

displayEndOfDemoMessage(mfilename)
