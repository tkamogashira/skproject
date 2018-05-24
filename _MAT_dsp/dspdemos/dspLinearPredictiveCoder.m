%% LPC Analysis and Synthesis of Speech
% This example shows how to implement a speech compression technique known
% as Linear Prediction Coding (LPC) using DSP System Toolbox(TM)
% functionality available at the MATLAB(R) command line. 

%   Copyright 1995-2013 The MathWorks, Inc.

%% Introduction
% In this example you implement LPC analysis and synthesis (LPC coding) of a
% speech signal. This process consists of two steps; analysis and
% synthesis. In the analysis section, you extract the reflection
% coefficients from the signal and use it to compute the residual signal.
% In the synthesis section, you reconstruct the signal using the residual
% signal and reflection coefficients. The residual signal and reflection
% coefficients require less number of bits to code than the original speech
% signal.
%
% The block diagram below shows the system you will implement.
%
% <<dspLinearPredictiveCoderModel.png>>
%
% In this simulation, the speech signal is divided into frames of size 3200
% samples, with an overlap of 1600 samples. Each frame is windowed using a
% Hamming window. Twelfth-order autocorrelation coefficients are found, and
% then the reflection coefficients are calculated from the autocorrelation
% coefficients using the Levinson-Durbin algorithm. The original speech
% signal is passed through an analysis filter, which is an all-zero filter
% with coefficients as the reflection coefficients obtained above. The
% output of the filter is the residual signal. This residual signal is
% passed through a synthesis filter which is the inverse of the analysis
% filter. The output of the synthesis filter is the original signal.

%% Initialization
% Here you initialize some of the variables like the frame size and also
% instantiate the System objects used in your processing. These objects
% also pre-compute any necessary variables or tables resulting in efficient
% processing calls later inside a loop.
%
% Initialize variables.
frameSize = 1600;
fftLen = 2048;

%%
% Here you create a System object to read from an audio file and
% determine the file's audio sampling rate.
hfileIn = dsp.AudioFileReader('SamplesPerFrame', frameSize, ...
            'OutputDataType', 'double');

fileInfo = info(hfileIn);
Fs = fileInfo.SampleRate;

%%
% Create an FIR digital filter System object used for pre-emphasis.
hpreemphasis = dsp.FIRFilter(...        
        'Numerator', [1 -0.95]);

%%
% Create a buffer System object and set its properties such that you get
% an output of twice the length of the frameSize with an overlap length of
% frameSize.
hbuf = dsp.Buffer(2*frameSize, frameSize);

%%
% Create a window System object. Here you will use the default window
% which is Hamming.
hwindow = dsp.Window;

%%
% Create an autocorrelator System object and set its properties to
% compute the lags in the range [0:12] scaled by the length of input.
hacf = dsp.Autocorrelator( ...
            'MaximumLagSource', 'Property', ...
            'MaximumLag', 12, ...
            'Scaling', 'Biased');

%%
% Create a System object which computes the reflection coefficients from
% auto-correlation function using the Levinson-Durbin recursion. You
% configure it to output both polynomial coefficients and reflection
% coefficients. The polynomial coefficients are used to compute and plot
% the LPC spectrum.
hlevinson = dsp.LevinsonSolver( ...
                'AOutputPort', true, ...
                'KOutputPort', true);

%%
% Create an FIR digital filter System object used for analysis. Also create
% two all-pole digital filter System objects used for synthesis and
% de-emphasis.

hanalysis = dsp.FIRFilter(...
                    'Structure','Lattice MA',...
                    'ReflectionCoefficientsSource', 'Input port');

hsynthesis = dsp.AllpoleFilter('Structure','Lattice AR');

hdeemphasis = dsp.AllpoleFilter('Denominator',[1 -0.95]);

%%
% Create a System object to play the resulting audio.
haudioOut = dsp.AudioPlayer( ...
                'SampleRate', Fs, ...
                'QueueDuration', 1.0);

% Setup plots for visualization.
s = hfigslpc('setup',Fs,frameSize,fftLen);

%% Stream Processing Loop
% Here you call your processing loop where you do the LPC analysis and
% synthesis of the input audio signal using the System objects you have
% instantiated.
%
% The loop is stopped when you reach the end of the input file, which is
% detected by the |AudioFileReader| System object.
while ~isDone(hfileIn)
    sig = step(hfileIn);                         % Read audio input

    % Analysis
    % Note that the filter coefficients are passed in as an argument to the
    % step method of the hanalysis filter System object.    
    sigpreem = step(hpreemphasis, sig);          % Pre-emphasis
    sigwin   = step(hwindow, step(hbuf, sigpreem) );% Buffer and Window
    sigacf   = step(hacf, sigwin);               % Autocorrelation
    [sigA, sigK] = step(hlevinson, sigacf);      % Levinson-Durbin
    siglpc   = step(hanalysis, sigpreem, sigK);        % Analysis filter

    % Synthesis
    hsynthesis.ReflectionCoefficients = sigK.';
    sigsyn = step(hsynthesis, siglpc);           % Synthesis filter
    sigout = step(hdeemphasis, sigsyn);          % De-emphasis
  
    step(haudioOut, sigout);                     % Play output audio

    % Update plots
    s = plotlpcdata(s, sigA, sigwin);
end

%% Release
% Here you call the release method on the System objects to close any open
% files and devices.
release(hfileIn);
pause(haudioOut.QueueDuration);    % Wait until audio finishes playing
release(haudioOut);
hfigslpc('cleanup',s);

%% Conclusion
% You have seen here the implementation of speech compression technique
% using Linear Prediction Coding. The implementation used the DSP System 
% Toolbox functionality available at the MATLAB command line.
% The code involves only calling of the successive System objects with
% appropriate input arguments. This involves no error prone manual state
% tracking which may be the case for instance for a MATLAB implementation
% of Buffer.

%% Appendix
% The following helper functions are used in this example.
%
% * <matlab:edit('hfigslpc.m') hfigslpc.m>
% * <matlab:edit('plotlpcdata.m') plotlpcdata.m>
%


displayEndOfDemoMessage(mfilename)
