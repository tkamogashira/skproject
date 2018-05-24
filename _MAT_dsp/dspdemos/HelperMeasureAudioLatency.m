function latency = HelperMeasureAudioLatency(plotFlag, frameSize, ...
    bufferSize, playerQueueSize, recorderQueueSize, playDuration,...
    useSimulink)
%HELPERMEASUREAUDIOLATENCY Measure audio latency on the system by using a
%loopback audio cable to connect audio-out port to audio-in port. 
%
% Input: 
% plotFlag: Set this to true if you want to visualize the input to
% dsp.AudioPlayer and the output from dsp.AudioRecorder objects. A graph of
% cross-correlation between the two signals is also plotted.
% 
% frameSize: This is the number of samples of audio that constitute a
% single frame. This sets the SamplesPerFrame property of
% |dsp.AudioFileReader| object that reads the audio file to be played.
% 
% bufferSize: The value of this parameter is copied to the BufferSize
% property of dsp.AudioPlayer and dsp.AudioRecorder System objects.
% 
% playerQueueSize and recoderQueueSize:  These are the queue size (in
% samples) for the dsp.AudioPlayer and dsp.AudioRecorder System objects,
% respectively. These are mapped to the QueueDuration property of these
% objects through the equation: QueueDuration = QueueSize/(Sample Rate).
% 
% playDuration: Number of seconds to play the audio.
%
% Output:
% latency: The audio latency of the system in seconds.
%
% This function HelperMeasureAudioLatency is only in support of 
% AudioLatencyMeasurementExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

%% Initialization
fprintf('Initializing... ');
if nargin < 1
    plotFlag = false;
end
if nargin < 2
    frameSize = 512;
end
if nargin < 3
    bufferSize = frameSize;
end
if nargin < 4
    playerQueueSize = 2*frameSize+1;
end
if nargin < 5
    recorderQueueSize = 2*frameSize+1;
end
if nargin < 6
    playDuration = 10;
end
if nargin < 7
    useSimulink = false;
end

if ~useSimulink
    % Measure latency using MATLAB System objects

    % Audio file to read from:
    hmfr = dsp.AudioFileReader('guitar10min.ogg','SamplesPerFrame',frameSize);
    Fs = hmfr.SampleRate;

    % Audio player:
    hap = dsp.AudioPlayer('SampleRate', Fs);
    hap.BufferSizeSource='Property';
    hap.BufferSize = bufferSize;
    hap.QueueDuration = playerQueueSize/Fs;

    % Audio recorder:
    har = dsp.AudioRecorder('SamplesPerFrame',frameSize);
    har.BufferSizeSource='Property';
    har.BufferSize = bufferSize;
    har.QueueDuration = recorderQueueSize/Fs;

else
    % Measure latency using Simulink blocks
    
    modelName = 'audiolatencymeasurement';
    open_system(modelName);
    
    % From Multimedia File block:
    set_param([modelName,'/From Multimedia File'], ...
        'inputFilename', 'guitar10min.ogg');
    set_param([modelName,'/From Multimedia File'], ...
        'audioFrameSize', num2str(frameSize));
    [~, Fs] = audioread('guitar10min.ogg',[1,1]);
    
    % To Audio Device block:
    set_param([modelName,'/To Audio Device'], ...
        'sampleRate', num2str(Fs));
    set_param([modelName,'/To Audio Device'], ...
        'autoBufferSize', 'off');
    set_param([modelName,'/To Audio Device'], ...
        'bufferSize', num2str(bufferSize));
    set_param([modelName,'/To Audio Device'], ...
        'queueDuration', num2str(playerQueueSize/Fs));
    
    % From Audio Device block:
    set_param([modelName,'/From Audio Device'], ...
        'frameSize', num2str(frameSize));
    set_param([modelName,'/From Audio Device'], ...
        'sampleRate', num2str(Fs));
    set_param([modelName,'/From Audio Device'], ...
        'autoBufferSize', 'off');
    set_param([modelName,'/From Audio Device'], ...
        'bufferSize', num2str(bufferSize));
    set_param([modelName,'/From Audio Device'], ...
        'queueDuration', num2str(recorderQueueSize/Fs));
       
end

% Signal sink to store played and recorded signals
hs = dsp.SignalSink;
fprintf('Done. \n');

%% Loopback simulation
fprintf('Streaming audio... ');
if ~useSimulink
    % MATLAB simulation
    tic;
    ind = 1;
    while toc < playDuration
        audioOut = step(hmfr);     % Read audio signal from file
        step(hap, audioOut);       % Play through audio-out
        audioIn = step(har);       % Record through audio-in
        if ind > 10
            % Ignore first 10 frames as startup transient
            step(hs,[audioOut(:,1),audioIn(:,1)]);   % Save the signals
        end
        ind = ind+1;
    end
else
    % Simulink simulation
    set_param(modelName, 'StopTime', num2str(playDuration));
    sim(modelName);
    pause(0.1);
    % Ignore first 10 frames as startup transient
    step(hs,[audioOut(10*frameSize+1:end,1),audioIn(10*frameSize+1:end,1)])
end
fprintf('Done. \n');

%% Compute cross-correlation and plot
[temp,idx] = xcorr(hs.Buffer(:,1),hs.Buffer(:,2));
rxy = abs(temp);

[~,Midx] = max(rxy);
latency = -idx(Midx)*1/Fs;

if plotFlag
    fprintf('Plotting... ');
    
    figure
    t = 1/44100*(0:size(hs.Buffer,1)-1);
    plot(t,hs.Buffer)
    title('Audio signals: Before player and after recorder');
    legend('Signal from audio file',...
           'Signal recorded (added latency of player and recorder)');
    xlabel('Time (in sec)');
    ylabel('Audio signal');
    fprintf('Done. \n');
end

%% Cleanup
if ~useSimulink
    release(hmfr); % release the input file
    release(hap);  % release the audio output device
    release(har);  % release the audio input device
    release(hs);   % release the sink
else
    close_system(modelName, 0);
end