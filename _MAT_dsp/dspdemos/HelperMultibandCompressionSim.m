function [audio,stopFlag,pauseFlag] = HelperMultibandCompressionSim()
% HELPERRLSFILTERSYSTEMIDENTIFICATIONSIM implements algorithm used in audio
% multiband dynamic range compression example. This function instantiates,
% initializes and steps through the System objects used in the algorithm.
% 
% You can tune the properties of the compressor bank through the GUI that
% appears when HelperMultibandCompression is executed.

%   Copyright 2013 The MathWorks, Inc.

%#codegen

% Instantiate and initialize System objects. The objects are declared
% persistent so that they are not recreated every time the function is
% called inside the simulation loop. 
persistent hread hCompressor1 hCompressor2 hCompressor3 hCompressor4 hmultiband hplay hmax hrms
if isempty(hread)
    SampleRate = 44100;
    % audio I/O
    hread = dsp.AudioFileReader('Filename','guitar10min.ogg',...
                                'PlayCount',Inf,'SamplesPerFrame',8192);
    hplay = dsp.AudioPlayer('SampleRate',SampleRate);
    % Compressor bank                            
    hCompressor1 = dspdemo.DynamicRangeCompressor('SampleRate',SampleRate,...
                                                 'CompressionRatio',5,...
                                                 'Threshold',-5,...
                                                 'KneeWidth',5,...
                                                 'AttackTime',5e-3,...
                                                 'ReleaseTime',100e-3);
    hCompressor2 = dspdemo.DynamicRangeCompressor('SampleRate',SampleRate,...
                                                  'CompressionRatio',5,...
                                                 'Threshold',-10,...
                                                 'KneeWidth',5,...
                                                 'AttackTime',5e-3,...
                                                 'ReleaseTime',100e-3);
    hCompressor3 = dspdemo.DynamicRangeCompressor('SampleRate',SampleRate,...
                                                 'CompressionRatio',5,...
                                                 'Threshold',-20,...
                                                 'KneeWidth',5,...
                                                 'AttackTime',2e-3,...
                                                 'ReleaseTime',50-3);
    hCompressor4 = dspdemo.DynamicRangeCompressor('SampleRate',SampleRate,...
                                                  'CompressionRatio',4,...
                                                 'Threshold',-30,...
                                                 'KneeWidth',5,...
                                                 'AttackTime',2e-3,...
                                                 'ReleaseTime',50e-3);
    % Multiband crossover filter                                             
    hmultiband = dspdemo.MultibandCrossoverFilter('SampleRate',SampleRate,...
                                                  'NumBands',4,...
                                     'CrossoverFrequencies',[120 1e3 3e3]);
    hmax = dsp.Maximum('RunningMaximum',true,...
                       'ResetInputPort',true,...
                       'ResetCondition','Non-zero');
    hrms = dsp.RMS('RunningRMS',true,...
                   'ResetInputPort',true,...
                   'ResetCondition','Non-zero');
end

audio = zeros(8192,2);

% Tune parameters if needed
[paramNew,simControlFlags] = HelperUnpackUDP();
pauseFlag = simControlFlags.pauseSim;
stopFlag = simControlFlags.stopSim;
if ~isempty(paramNew)
    hCompressor1.CompressionRatio = paramNew(1);
    hCompressor1.Threshold = paramNew(2);
    hCompressor1.AttackTime = paramNew(3);
    hCompressor1.ReleaseTime = paramNew(4);
    
    hCompressor2.CompressionRatio = paramNew(5);
    hCompressor2.Threshold = paramNew(6);
    hCompressor2.AttackTime = paramNew(7);
    hCompressor2.ReleaseTime = paramNew(8);
    
    hCompressor3.CompressionRatio = paramNew(9);
    hCompressor3.Threshold = paramNew(10);
    hCompressor3.AttackTime = paramNew(11);
    hCompressor3.ReleaseTime = paramNew(12);
    
    hCompressor4.CompressionRatio = paramNew(13);
    hCompressor4.Threshold = paramNew(14);
    hCompressor4.AttackTime = paramNew(15);
    hCompressor4.ReleaseTime = paramNew(16);
    
    if simControlFlags.resetObj % reset System objects
        reset(hread);
        reset(hCompressor1);
        reset(hCompressor2);
        reset(hCompressor3);
        reset(hCompressor4);
        reset(hmultiband);
        reset(hplay);
        reset(hmax);
        reset(hrms);
    end
end

if stopFlag
    return;  % Stop the simulation
end
if pauseFlag
    return; % Pause the simulation (but keep checking for commands from GUI)
end

% Read audio from file
x = step(hread);

% Split into 4 bands
[a10, a20 ,a30 ,a40] = step(hmultiband,x);

% Compress the 3rd band
a1 = step(hCompressor1,a10);
a2 = step(hCompressor2,a20);
a3 = step(hCompressor3,a30);
a4 = step(hCompressor4,a40);

% New audio output
audioOut = a1 + a2 + a3 +  a4;
audioIn = a10 + a20 + a30 + a40;

audio = [audioIn(:,1),audioOut(:,1)];

% Play audio
step(hplay,audioOut);