%% Live Direction Of Arrival Estimation with a Linear Microphone Array
% This example shows how to acquire and process live multichannel audio.
% It also presents a simple algorithm for estimating the Direction Of
% Arrival (DOA) of a sound source using multiple microphone pairs within
% a linear array.
%
% Copyright 2013 The MathWorks, Inc.

%% Select and configure the source of audio samples
% If a multichannel input audio interface is available, then modify this
% script to set sourceChoice to 'live'. In this mode the example will use
% live audio input signals - it will also assume all inputs (two or more)
% are driven by microphones arranged on a linear array.
% If no microphone array or multichanel audio card is available, then set
% sourceChoice to 'recorded'. In this mode the example will use prerecorded 
% audio samples, acquired with a linear array.
% For sourceChoice = 'live', the following code uses dsp.AudioRecorder to
% acquire 4 live audio channels through a Microsoft Kinect(TM) for
% Windows(R). 
% To use another microphone array setup, ensure the installed audio device
% driver is one of the conventional types supported by MATLAB and set the 
% 'DeviceName' property of dsp.AudioRecorder accordingly. 
% You can use tab completion to query valid DeviceName assignments for your
% computer by typing AudioInput.DeviceName = ' and then pressing the tab
% key. The tab completion functionality shows all valid audio device names
% for your computer.

% sourceChoice = {'recorded'|'live'}
sourceChoice = 'recorded';

% Set for how long the live processing should last
endTime = 20;
% And how many samples per channel should be acquired and processed at each
% iteration
audioFrameLength = 3200;

switch sourceChoice
    case 'live'
        fs = 16000;
        AudioInput = dsp.AudioRecorder(...
            'DeviceName', ...
             'Microphone Array (Microsoft Kinect USB Audio)',...
            'SampleRate', fs, ...
            'NumChannels', 4,...
            'OutputDataType','double',...
            'QueueDuration', 2,...
            'SamplesPerFrame', audioFrameLength);
    case 'recorded'    
        % The following audio files holds a 20-second recording of 4 raw
        % audio channels acquired with a Microsoft Kinect(TM) for
        % Windows(R) in the presence of a noisy source moving in front of
        % the array roughly from -40° to about +40° and then back to the
        % initial position
        audioFileName = 'HelperAudioArrayDOAEstimationRecordedData.wav';
        AudioInput = dsp.AudioFileReader(...
            'OutputDataType','double',...
            'Filename', audioFileName,...
            'PlayCount', inf, ...
            'SamplesPerFrame', audioFrameLength);
        fs = AudioInput.SampleRate;
end

%% Define Array Geometry
% The following values identify the approximate linear coordinates of the 4
% built-in microphones of the Microsoft Kinect(TM) relative to the position
% of the RGB camera (not used in this example).
% For 3D coordinates use [[x1;y1;z1], [x2;y2;z2], ..., [xN;yN;zN]
micPositions = [-0.088, 0.042, 0.078, 0.11]; 

%% Form Microphone Pairs
% The algorithm used in this example works with pairs of microphones
% independently. It then combines the individual DOA estimates to provide
% a single live DOA output. The more pairs available, the more robust (yet
% computationally expensive) DOA estimation. The maximum number of pairs
% available can be computed through nchoosek(length(micPositions),2). In
% this case the 3 pairs with the largest inter-microphone distances are
% selected. The larger the inter-microphone distance the more sensitive the
% DOA estimate.
% Each column of the following matrix decribes a choice of microphone pair
% within the array. All values must be integers between 1 and
% length(micPositions).
micPairs = [1 4; 1 3; 1 2];
numPairs = size(micPairs, 1);

%% Initialize DOA visualization

% Create an instance of the helper plotting object DOADisplay. This will be
% display the estimated DOA live with an arrow in a polar plot.
DOAPointer = dspdemo.DOADisplay();

%% Create and configure the algorithmic building blocks
% Audio Frame lengths
bufferLength = 64;

% Use a helper object to rearrange the input samples according the how the
% microphone pairs are selected
Preprocessor = dspdemo.PairArrayPreprocessor(...
    'MicPositions', micPositions,...
    'MicPairs', micPairs,...
    'BufferLength', bufferLength);
micSeparations = getPairSeparations(Preprocessor);

% The main algorithmic builing block of this example is a cross-correlator.
% That is used in conjunction with an interpolator to ensure a finer DOA
% resolution. In this simple case it is sufficient to use the same two
% objects across the different pairs available. In general, however, 
% different channels may need to independently save their internal states
% and hence to be handled by separate objects.
XCorrelator = dsp.Crosscorrelator(...
    'Method', 'Frequency Domain');
interpFactor = 8;
b = interpFactor * fir1((2*interpFactor*8-1),1/interpFactor);
groupDelay = median(grpdelay(b));
Interpolator = dsp.FIRInterpolator(...
    'InterpolationFactor',interpFactor,...
    'Numerator',b);

%% Acquire and process signals in a loop
% For each iteration of the following while loop: read audioFrameLength 
% samples for each audio channel, process the data to estimate a DOA value
% and display the result on a bespoke arrow-based polar visualization.

tic
while(toc < endTime)    
    cycleStart = toc;
    % Read a multichannel frame from the audio source
    % The returned array is of size AudioFrameLenght x size(micPositions,2)
    multichannelAudioFrame = step(AudioInput);
    
    % Rearrange the acquired sample in 4-D array of size
    % bufferLength x numBuffers x 2 x numPairs where 2 is the number of
    % channels per microphone pair
    bufferedFrame = step(Preprocessor, multichannelAudioFrame);
    
    % First estimate the DOA for each pair, independently
    
    % Initialize arrays uses across available pairs
    numBuffers = size(bufferedFrame, 2);
    delays = zeros(1,numPairs);
    anglesInRadians = zeros(1,numPairs);
    xcDense = zeros((2*bufferLength-1)*interpFactor, numPairs);
    
    % Loop through available pairs
    for kPair = 1:numPairs
        % Estimate inter-microphone delay for each 2-channel buffer 
        delayVector = zeros(numBuffers, 1);
        for kBuffer = 1:numBuffers
            % Cross-correlate pair channels to get a coarse
            % crosscorrelation
            xcCoarse = step(XCorrelator, ...
                bufferedFrame(:,kBuffer,1,kPair), ...
                bufferedFrame(:,kBuffer,2,kPair));

            % Interpolate to increase spatial resolution
            xcDense = step(Interpolator, flipud(xcCoarse));

            % Extract position of maximum, equal to delay in sample time
            % units, including the group delay of the interpolation filter
            [~,idx] = max(xcDense);
            delayVector(kBuffer) = ...
                (idx - groupDelay)/interpFactor - bufferLength;
        end

        % Combine DOA estimation across pairs by selecting the median value
        delays(kPair) = median(delayVector);

        % Convert delay into angle using the microsoft pair spatial
        % separtions provided
        anglesInRadians(kPair) = HelperDelayToAngle(delays(kPair), fs, ...
            micSeparations(kPair));
    end

    % Combine DOA estimation across pairs by keeping only the median value
    DOAInRadians = median(anglesInRadians);
    
    % Arrow display
    step(DOAPointer, DOAInRadians)
    
    % Delay cycle execution artificially if using recorded data
    if(strcmp(sourceChoice,'recorded'))
        pause(audioFrameLength/fs - toc + cycleStart)
    end
end

release(AudioInput)

displayEndOfDemoMessage(mfilename)
