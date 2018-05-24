%% Pitch Shifting and Time Dilation Using a Phase Vocoder
% This example shows how to use a phase vocoder to implement
% time dilation and pitch shifting of an audio signal.
%
%% The Example Model
% The phase vocoder in this example consists of an analysis section, a 
% phase calculation section and a synthesis section. The analysis section
% consists of an overlapped, short-time windowed FFT. The start of each
% frame to be transformed is delayed from the previous frame by the amount
% specified in the *Analysis hop size* parameter. The synthesis section
% consists of a short-time windowed IFFT and an overlap add of the
% resulting frames. The overlap size during synthesis is specified by the
% *Synthesis hop size* parameter. 
%
% The vocoder output has a different sample rate than its input. The ratio
% of the output to input sample rates is  the *Synthesis hop size* divided
% by the *Analysis hop size*. If the output is played at the input sample
% rate, it is time stretched or time reduced depending on that ratio. If
% the output is played at the output sample rate, the sound duration is
% identical to the input, but is pitch shifted either up or down. 
%
% To prevent distortion, the phase of the frequency domain signal is
% modified in the phase calculation section. In the frequency domain, the
% signal is split into its magnitude and phase components. For each bin, a
% phase difference between frames is calculated, then normalized by the
% nominal phase of the bin. Phase modification first requires that the
% normalized phase differences be unwrapped. The unwrapped differences are
% multiplied by th *Synthesis hop size* divided by the *Analysis hop size*.
% The differences are accumulated, frame by frame, to recover the phase
% components. Magnitude and phase components are then recombined.
%% Exploring the Example
% On running the model, the pitch-scaled signal is automatically played
% once the simulation has finished. The Audio Playback block allows you to
% choose between *Pitch Shifting* and *Time Dilation* modes.
%
% Double-click the Phase Vocoder block. Change the *Synthesis hop-size*
% parameter to 64, the same value as the *Analysis hop-size* parameter. Run
% the simulation and listen to the three signals. The pitch-scaled signal
% has the same pitch as the original signal, and the time-stretched signal
% has the same speed as the original signal.
%
% Next change the *Synthesis hop-size* parameter in the Phase Vocoder block
% to 48, which is less than the *Analysis hop-size* parameter. Run the
% simulation and listen to the three signals. The pitch-scaled signal has a
% lower pitch than the original signal. The time-stretched signal is faster
% than the original signal.
%
% To see the implementation, right-click on the Phase Vocoder block and
% select |Look Under Mask|.
%%

% Copyright 2005-2013 The MathWorks, Inc.

open_system('dsppitchtime');
%%
bdclose dsppitchtime

%% References
% A. D. Gotzen, N. Bernardini, and D. Arfib. "Traditional Implementations
% of a Phase-Vocoder: The Tricks of the Trade," _Proceedings of the COST
% G-6 Conference on Digital Audio Effects (DAFX-00)_. Verona, Italy,
% December 7-9, 2000.