function HelperSoundPressureUI(numTSteps)
%HELPERSOUNDPRESSUREUI Initialize and execute Sound Pressure example 
% Inputs:
%   numTSteps    - Number of times the algorithm is executed in a loop. Inf
%                  if not specified

% Copyright 2014 The MathWorks, Inc.

%% Default values for input
if nargin == 0
    % Run until user stops simulation. 
    numTSteps = Inf; 
end

%% Setup Application Default Parameters
% This application starts by processing white noise until we specify an
% input file or an external audio source. We need a default configuration 
% for all algorithm components.

frameSize = 8192;
inFs = 22050;
inFsNew = inFs;
resetMean = 1000;

% Create the A- and C- weighting filters
h = fdesign.audioweighting('WT,Class', 'A', 1, inFs);
Hfilt1 = design(h, 'ansis142', 'SystemObject', true);

h = fdesign.audioweighting('WT,Class', 'C', 2, inFs);
Hfilt2 = design(h, 'SystemObject', true);

% Create the spectrum analyzers
Hsa = dsp.SpectrumAnalyzer('SampleRate', inFs, ...
        'OverlapPercent', 80, ...
        'SpectralAverages', 20, ...
        'PlotAsTwoSidedSpectrum', false, ...
        'FrequencyScale', 'Log', ...
        'ShowLegend', true, ...
        'Title', 'Input data (channel 1), filtered data (channel 2)');

% Default white noise source
HaudioIn = dsp.SignalSource(randn(frameSize, 1), frameSize, ...
        'SignalEndAction', 'Cyclic repetition');
    
% Use a running mean to average the sound pressure value
Hmean1 = dsp.Mean('RunningMean', true, ...
        'ResetInputPort', true);
Hmean2 = dsp.Mean('RunningMean', true, ...
        'ResetInputPort', true);

%% Create The User Interface (UI)
hUI = createSoundPressureUI();

% Define three handles to access the UI, update the rms pressure values 
% and retreive the input file name.
hStRmsPressureFilt = findobj(hUI, 'Tag', 'StRmsPressureFilt');
hStRmsPressureNoFilt = findobj(hUI, 'Tag', 'StRmsPressureNoFilt');
hStFileName = findobj(hUI, 'Tag', 'StFileName');

%% Streaming Loop
% This loop runs until the 'Stop' button is pressed
idx = 0;
while(numTSteps > 0)
    % Obtain new values for parameters through UDP Receive
    [filtNum, resetFilt, stopSim, changeFile, audioSource] = ...
                                                  soundPressureUnpackUDP(); 
    
    % Check if user has pressed the 'Stop' button
    if stopSim
        % Stop simulation
        break;
    end
    
    % Set the filter
    if (filtNum == 1)
        Hfilt = Hfilt1;
    else
        Hfilt = Hfilt2;
    end
    
    % Reset the filter before using it
    if resetFilt
        reset(Hfilt);
        
        % Reset the running means
        reset(Hmean1);
        reset(Hmean2);
        idx = 0;        
    end
    
    % Set the audio source
    if changeFile
        % Release the audio source
        if HaudioIn~=0
            release(HaudioIn);
        end
        
        % Read data from an audio file
        if (audioSource == 2)
            % Get file name from the UI
            fileName = get(hStFileName, 'String');

            % Create an audio file reader
            HaudioIn = dsp.AudioFileReader(fileName, ...
                        'SamplesPerFrame', frameSize, ...
                        'PlayCount', Inf, ...
                        'OutputDataType', 'double');
            
            % Get the new sample rate
            inFsNew = HaudioIn.SampleRate;
            
        % Read data from an external source (mic)
        elseif (audioSource == 1)
            HaudioIn = dsp.AudioRecorder('OutputDataType', 'double', ...
                        'SamplesPerFrame', frameSize, ...
                        'SampleRate', inFs);
            
            % Get the new sample rate
            inFsNew = inFs;
        else % Create white noise data
            HaudioIn = dsp.SignalSource(randn(frameSize, 1), frameSize, ...
                        'SignalEndAction', 'Cyclic repetition'); 
        end
        
        % If the sample rate has changed, we need to redesign the filters, 
        % update the player and the spectrum analyzer.
        if (inFsNew~=inFs)
            inFs = inFsNew;
            
            % Update filters and spectrum analyzer
            release(Hfilt1);
            release(Hfilt2);
            release(Hsa);
                    
            h = fdesign.audioweighting('WT,Class', 'A', 1, inFs);
            Hfilt1 = design(h, 'ansis142', 'SystemObject', true);

            h = fdesign.audioweighting('WT,Class', 'C', 2, inFs);
            Hfilt2 = design(h, 'SystemObject', true);

            Hsa = dsp.SpectrumAnalyzer('SampleRate', inFs,...
                    'OverlapPercent', 80, ...
                    'SpectralAverages', 20, ...
                    'PlotAsTwoSidedSpectrum', false, ...
                    'FrequencyScale', 'Log', ...
                    'ShowLegend', true, ...
                    'Title', ...
                    'Input data (channel 1), filtered data (channel 2)');
        end
        
        % Reset the running means
        reset(Hmean1);
        reset(Hmean2);
        idx = 0;
    end

    % Retrieve audio samples from audio source (file, mic or white noise)
    audio = step(HaudioIn);
    
    % Filter the audio data (if it is not set to 'None' in the UI).
    % In the case of a stereo file, only the left channel is processed.
    if (filtNum~=0)
        filt = step(Hfilt, audio(:,1));
    else
        filt = audio(:,1);
    end
    
    idx = idx + 1;
    
    % Compute the RMS pressure before filtering and convert to dB. 
    % Reference to a sound pressure of 20e-6 Pascals.
    rms1 = 20*log10(std(audio(:,1))) - 20*log10(20e-6);
    
    % Smooth out short-term fluctuations with a running mean
    RmsPressureNoFilt = round(step(Hmean1, rms1, ~mod(idx, resetMean)));

    % Update UI with the RMS pressure value
    set(hStRmsPressureNoFilt, 'String', RmsPressureNoFilt);     

    % Compute the RMS pressure after filtering and convert to dB. 
    % Reference to a sound pressure of 20e-6 Pascals.
    rms2 = 20*log10(std(filt(:,1))) - 20*log10(20e-6);
    
    % Smooth out short-term fluctuations with a running mean    
    RmsPressureFilt = round(step(Hmean2, rms2, ~mod(idx, resetMean)));
    
    % Update UI with the RMS pressure value
    set(hStRmsPressureFilt, 'String', RmsPressureFilt);

    % Display input and filtered data spectrum (left channel only)
    step(Hsa, [audio(:,1),filt(:,1)]);
    
    numTSteps = numTSteps - 1; 
end

%% Cleanup
% Close the interface, the input file, the audio input device, and release 
% resources.
close(hUI,'force');
if HaudioIn~=0
    release(HaudioIn);
end
