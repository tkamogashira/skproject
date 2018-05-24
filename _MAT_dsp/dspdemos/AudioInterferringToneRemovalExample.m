%% Removing an Interfering Tone From a Streaming Audio Signal 
% This example shows how to remove a 250 Hz interfering tone from an audio
% signal by using a notch filter. To listen to the effect of the filter on
% the audio, the center frequency and 3 dB bandwidth of the notch filter
% can be tuned as the audio is playing. 

% Copyright 2013 The MathWorks, Inc.

%% Introduction 
% A notch filter is used to eliminate a specific frequency from a given
% signal. In their most common form, the filter design parameters for notch
% filters are center frequency for the notch and the 3 dB bandwidth. The
% center frequency is the frequency point at which the filter has a gain of
% zero. The 3 dB bandwidth measures the frequency width of the notch of the
% filter computed at the half-power or 3 dB attenuation point.
%
% In this example, you tune a notch filter in order to eliminate a 250 Hz
% sinusoidal tone corrupting an audio signal. You can control both the
% center frequency and the bandwidth of the notch filter and listen to the
% filtered audio signal as you tune the design parameters.

%% Example Architecture
% The command <matlab:edit('HelperAudioToneRemoval')
% HelperAudioToneRemoval> launches a user interface designed to interact
% with the simulation. It also launches a SpectrumAnalyzer to view the
% spectrum of the audio with and without filtering along with the magnitude
% response of the notch filter.
%
% The notch filter itself is implemented in
% <matlab:edit('dsp.NotchPeakFilter') dsp.NotchPeakFilter>. The filter has
% two specification modes: 'Design parameters' and 'Coefficients'. The
% 'Design parameters' mode allows you to specify the center frequency and
% bandwidth in Hz. This is the only mode used in this example. The
% 'Coefficients' mode allows you to specify the multipliers or coefficients
% in the filter directly. In the latter mode, each coefficient affects only
% one characteristic of the filter (either the center frequency or the 3 dB
% bandwidth). In other words, the effect of tuning the coefficients is
% completely decoupled.

%% Using a Generated MEX File
% Using MATLAB Coder, you can generate a MEX file for the main processing
% algorithm by executing the command
% <matlab:edit('HelperAudioToneRemovalCodeGeneration')
% HelperAudioToneRemovalCodeGeneration>. You can use the generated MEX file
% by executing the command HelperAudioToneRemoval(true).

displayEndOfDemoMessage(mfilename)