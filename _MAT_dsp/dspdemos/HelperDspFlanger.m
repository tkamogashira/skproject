function HelperDspFlanger(numTSteps)
%HELPERDSPFLANGER Initialize and execute Dsp Flanger example. 
% Inputs:
%   numTSteps    - Number of times the algorithm is executed in a loop. Inf
%                  if not specified

% Copyright 2014 The MathWorks, Inc.

%% Default values for input
if nargin == 0
    % Run until user stops simulation. 
    numTSteps = Inf; 
end

%% Initialization
% To create and initialize your algorithm components before they are used 
% in a processing loop is critical in getting optimal performance.

%%
% Use an audio file reader to read the WAV file called dspafxf.wav. Each
% frame contains 4096 samples.
SPF   = 4096;
hFile = dsp.AudioFileReader('dspafxf.wav', ...
                'PlayCount', Inf, ...
                'SamplesPerFrame', SPF, ...
                'OutputDataType', 'double');

%%
% Use a variable fractional delay to create the delay for the flanging 
% effect.
hfd = dsp.VariableFractionalDelay( ...
                'InterpolationMethod', 'FIR', ...
                'FilterHalfLength', 8, ...
                'Bandwidth', 0.5);

%%
% To listen to the audio signal, use an audio player that sends the audio 
% signal to your computer speakers.
Fs = 22050;
hAudioOut = dsp.AudioPlayer('SampleRate', Fs);

%%
% Use a sine wave generator to change the variable fractional delay over 
% time.
freq = 1/3.394;
hsin = dsp.SineWave( ...
                'Amplitude', 15, ...
                'Frequency', freq, ...
                'PhaseOffset', pi/4, ...
                'SampleRate', Fs, ...
                'SamplesPerFrame', SPF);

%% 
% Use two spectrum analyzers to calculate and plot the audio spectrograms.
% You can compare the spectrogram of the original audio signal with the 
% flanging audio signal.
hsao = dsp.SpectrumAnalyzer( ...
                'SpectrumType', 'Spectrogram', ...
                'FrequencySpan', 'Start and stop frequencies', ...
                'OverlapPercent', 75, ...
                'StartFrequency', 0, ...
                'StopFrequency', Fs/2, ...
                'RBWSource','Property',...
                'RBW',5, ...
                'TimeResolutionSource','Property', ...
                'TimeResolution', .2, ...
                'PlotAsTwoSidedSpectrum', false, ...
                'SampleRate', Fs, ...
                'Title', 'Original Audio Signal');

hsaf = dsp.SpectrumAnalyzer( ...
                'SpectrumType', 'Spectrogram', ...
                'FrequencySpan', 'Start and stop frequencies', ...
                'OverlapPercent', 75, ...
                'StartFrequency', 0, ...
                'StopFrequency', Fs/2, ...
                'RBWSource','Property',...
                'RBW',5, ...
                'TimeResolutionSource','Property', ...
                'TimeResolution', .2, ...
                'PlotAsTwoSidedSpectrum', false, ...
                'SampleRate', Fs, ...
                'Title', 'Audio Signal with Flanging');

%% Create a User Interface (UI)
% Create two sliders for changing the flanging effect delay and controling
% stereo panning. Use the 'Stop Simulation' button to exit the while-loop.
% 'Reset' and 'Pause Simulation' buttons are not used in this example.
param = struct([]);
param(1).Name = 'Frequency of delay for flanging';
param(1).InitialValue = freq;
param(1).Limits = [0, 0.5];
param(2).Name = 'Stereo panning';
param(2).InitialValue = 0;
param(2).Limits = [-1, 1];
hUI = HelperCreateParamTuningUI(param, 'Audio Flanging');
                       
%% Stream Processing Loop
% Now that you created and set up all the necessary algorithm components, 
% you can process the data in a loop without repeating any initialization.
% Moreover, you don't have to retain algorithm states between loop
% iterations.

% The while-loop below processes one frame of data per iteration, with
% components configured by properties set during initialization.
panner = 0;

while (numTSteps > 0)
    % Obtain new values for parameters through UDP Receive
    [paramNew, simControlFlags] = HelperUnpackUDP();

    % Check if simulation needs to be stopped
    if simControlFlags.stopSim
        break;
    end
        
    if ~isempty(paramNew)
        % Change parameters value
        freq = paramNew(1);    
        panner = paramNew(2);   
        
        % Change sine wave frequency
        release(hsin);
        hsin = dsp.SineWave( ...
                'Amplitude', 15, ...
                'Frequency', freq, ...
                'PhaseOffset', pi/4, ...
                'SampleRate', Fs, ...
                'SamplesPerFrame', SPF);
    end
    
    % Read audio file
    audio = step(hFile);
    
    % Sine wave with DC offset
    delay = 20 + step(hsin);                   
    
    % Create flanging effect
    flange = audio + step(hfd, audio, delay);

    % Add stereo panning
    A = [(1-panner)*ones(SPF, 1) (1+panner)*ones(SPF, 1)]; 
    stereopanning = [flange flange] .* A;
    
    % Plot audio spectrograms
    step(hsao, audio);                            
    step(hsaf, flange);
    
    % Send audio to device
    step(hAudioOut, stereopanning);    
    
    numTSteps = numTSteps - 1;    
end

%% Release
% Here you call the release method on the algorithm components to close any
% open files and devices.
close(hUI,'force');
release(hFile);
release(hAudioOut);

