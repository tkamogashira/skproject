%% Signal Statistics
% This example shows how to perform statistical measurements on an input
% data stream using DSP System Toolbox(TM) functionality available at the
% MATLAB(R) command line. You will compute the signal statistics minimum,
% maximum, mean and the spectrum and plot them.

%   Copyright 1995-2011 The MathWorks, Inc.

%% Introduction
% This example computes signal statistics using DSP System Toolbox
% System objects. These objects handle their states automatically reducing
% the amount of hand code needed to update states reducing the possible
% chance of coding errors.

%%
% These System objects pre-compute many values used in the processing. This
% is very useful when you are processing signals of same properties in a
% loop. For example, in computing an FFT, the values of sine and cosine can
% be computed and stored once you know the properties of the input and
% these values can be reused for subsequent calls. Also the objects check
% only whether the input properties are of same type as previous inputs in
% each call.

%% Initialization
% Here you initialize some of the variables used in the code and
% instantiate the System objects used in your processing.  These objects
% also pre-compute any necessary variables or tables resulting in efficient
% processing calls later inside a loop. 

frameSize = 1024; % Size of one chunk of signal to be processed in one loop

% Here you create a System object to read from a specified audio file and
% set its output data type.
hfileIn = dsp.AudioFileReader(which('speech_dft.mp3'), ...
            'SamplesPerFrame', frameSize, ...
            'OutputDataType', 'double');

fileInfo = info(hfileIn);
Fs = fileInfo.SampleRate;

%%
% Create an FFT System object to compute the FFT of the input.
hfft = dsp.FFT;

%%
% Create System objects to calculate mean, minimum and maximum and set them
% to running mode. In running mode, you compute the statistics of the input
% for its entire length in the past rather than the statistics for just the
% current input.
hmean = dsp.Mean('RunningMean', true);
hmin  = dsp.Minimum('RunningMinimum', true);
hmax  = dsp.Maximum('RunningMaximum', true);

%%
% Create audio output System object. Note that audio output to speakers
% from small chunks of data in a loop is possible using the |AudioPlayer|
% System object. Using |sound| or |audioplayer| in MATLAB, either overlaps
% or introduces gaps in audio playback.
haudioOut = dsp.AudioPlayer('SampleRate', Fs, ...
                            'QueueDuration', 1);

% Initialize figures for plotting
s = hfigsstats(frameSize, Fs);

%% Stream Processing Loop
% Here you call your processing loop which will calculate the mean, min,
% max, FFT, and filter the data using the System objects.
%
% Note that inside the loop you are reusing the same FFT System object
% twice. Since the input data properties do not change, this enables reuse
% of objects here. This reduces memory usage. The loop is stopped when you
% reach the end of input file, which is detected by the AudioFileReader
% object.

while ~isDone(hfileIn)
    % Audio input from file
    sig = step(hfileIn);

    % Compute FFT of the input audio data
    fftoutput = step(hfft, sig);
    fftoutput = fftoutput(1:512); % Store for plotting

    % The hmean System object keeps track of the information about past
    % samples and gives you the mean value reached until now. The same is
    % true for hmin and hmax System objects.
    meanval = step(hmean, sig);
    minimum = step(hmin, sig);
    maximum = step(hmax, sig);

    % Play output audio
    step(haudioOut, sig);

    % Plot the data you have processed
    s = plotstatsdata(s, minimum, maximum, sig.', meanval, fftoutput);
end
pause(haudioOut.QueueDuration); % Wait for audio to finish

%% Release
% Here you call the release method on the System objects to close any open
% files and devices.
release(hfileIn);
release(haudioOut);

%% Conclusion
% You have seen visually that the code involves just calling successive
% System objects with appropriate input arguments and does not involve
% maintaining any more variables like indices or counters to compute the
% statistics. This helps in quicker and error free coding. Pre-computation
% of constant variables inside the objects generally lead to faster
% processing time.

%% Appendix
% Following helper functions are used in this example.
%
% * <matlab:edit('hfigsstats.m') hfigsstats.m>
% * <matlab:edit('plotstatsdata.m') plotstatsdata.m>
%


displayEndOfDemoMessage(mfilename)
