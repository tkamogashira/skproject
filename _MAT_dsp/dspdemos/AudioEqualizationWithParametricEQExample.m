%% Audio Equalization using Parametric Equalizer Filters
% This example shows how to use parametric equalizer filters for audio
% equalization. The example uses three parametric EQ filters that can be
% tuned as the audio is playing. 

% Copyright 2013 The MathWorks, Inc.

%% Introduction 
% Parametric equalizer filters can be used to compensate for the response
% of loudspeakers in order to improve the sound quality when playing an
% audio stream. In this example, each parametric equalizer allows three
% parameters to be tuned: center frequency, bandwidth, and the peak (or
% dip) gain. The bandwidth is defined at the arithmetic mean between the
% base of the filter (1 in this example) and the peak value.
%
% The three parametric equalizers in this example are cascaded together so
% that the overall effect of the 3 filters is given by the product of the
% frequency response of each filter with the others. The example shows the
% magnitude response estimate of each of the three filters along with the
% overall magnitude response of the cascade of the filters.

%% Example Architecture
% The command <matlab:edit('HelperAudioEqualization')
% HelperAudioEqualization> launches a user interface designed to interact
% with the simulation. It also launches an ArrayPlot to visualize the
% magnitude response estimates described above.
%
% The parametric equalizer filter itself is implemented in
% <matlab:edit('dsp.ParametricEQFilter') dsp.ParametricEQFilter>.
% The filter has two specification modes: 'Design Parameters' and 'Raw
% Gains'. The 'Design Parameters' mode allows you to specify the center
% frequency and bandwidth in Hz and the peak and reference gains in dB.
% This is the only mode used in this example. The 'Raw Gains' mode allows
% you to specify the multipliers or gains in the filter directly. In the
% latter mode, each gain affects only one characteristic of the filter
% (either the center frequency, the bandwidth, the peak gain, or the
% reference gain). In other words, the effect of tuning the gains is
% completely decoupled.

%% Using a Generated MEX File
% Using MATLAB Coder, you can generate a MEX file for the main processing
% algorithm by executing the command
% <matlab:edit('HelperAudioEqualizationCodeGeneration')
% HelperAudioEqualizationCodeGeneration>. You can use the generated MEX
% file by executing the command HelperAudioEqualization(true).

displayEndOfDemoMessage(mfilename)