function [outData] = dspwin32Transform(inData)
%dspwin32Transform dspwin32 library transformation table
%   Transforms and forwards all blocks in the dspwin32 library.
%   This is an internal function called by Simulink(R) during model load.

% Copyright 2012 The MathWorks, Inc.

forwardingTable = struct2cell(inData.ForwardingTableEntry);
srcBlk = regexprep(forwardingTable{1}, '\n', ' ');
if strcmp(srcBlk, sprintf('dspwin32/From Wave Device'))
    
    outData = localTransformFromWaveDevice(inData);
    
elseif strcmp(srcBlk, sprintf('dspwin32/To Wave Device'))

    outData = localTransformToWaveDevice(inData);
    
elseif strcmp(srcBlk, sprintf('dspwin32/From Wave File'))
    
   [outData warn] = localTransformFromWaveFile(inData);
   
   if warn
    warning(message('dsp:dsplib:startOfFilePortWarning', gcs));
   end
   
elseif strcmp(srcBlk, sprintf('dspwin32/To Wave File'))   
    
    outData = localTransformToWaveFile(inData);
    
end

end

%--------------------------------------------------------------------------

function outData = localTransformFromWaveDevice(inData)

    % Get From Wave Device parameter values from inData. If parameter is not
    % in inData, set to the library default value.
    inValues = cell(9,1);
    inValues{1} = localGetVal(inData.InstanceData, 'SampleRate', '8000');
    inValues{2} = localGetVal(inData.InstanceData, 'UserRate', '16000');
    inValues{3} = localGetVal(inData.InstanceData, 'SampleWidth', '16');
    inValues{4} = localGetVal(inData.InstanceData, 'Stereo', 'off');
    inValues{5} = localGetVal(inData.InstanceData, 'SamplesPerFrame', '512');
    inValues{6} = localGetVal(inData.InstanceData, 'QueueDuration', '3');
    inValues{7} = localGetVal(inData.InstanceData, 'useDefaultDevice', 'on');
    inValues{8} = localGetVal(inData.InstanceData, 'userDeviceID', '<empty>');
    inValues{9} = localGetVal(inData.InstanceData, 'dType', 'double');
    
    outData.NewBlockPath = '';
            
    if strcmp(inValues{7}, 'on') % Use default device
        value= 'Default';
    else       
        value = inValues{8};
    end
    outData.NewInstanceData = localNVPair('deviceName', value);
        
    if strcmp(inValues{4}, 'on') % Stereo
        value = '2'; % Stereo
    else
        value = '1'; % Mono
    end
    outData.NewInstanceData(2) = localNVPair('numChannels', value);
        
    if strcmp(inValues{1}, 'User-defined')  % Sample-rate
        % UserRate edit box
        value = inValues{2};
    else
        % SampleRate popup
       value = inValues{1};
    end
    outData.NewInstanceData(3) = localNVPair('sampleRate', value);
    
    % Change popup value format (Ex: 8 -> 8-bit integer)    
    sampleWidth = inValues{3};   
    value = [sampleWidth, '-bit integer'];
    outData.NewInstanceData(4) = localNVPair('deviceDatatype', value);
    
    % Library default for 'autoBufferSize'. No need to set.
    % Library default for 'bufferSize'. No need to set.  
    
    % These parameters can be aliased
    
    % queueDuration = QueueDuration        
    outData.NewInstanceData(5) = localNVPair('queueDuration', inValues{6});
    
    % frameSize = SamplesPerFrame    
    outData.NewInstanceData(6) = localNVPair('frameSize', inValues{5});
    
    % outputDatatype = dType    
    outData.NewInstanceData(7) = localNVPair('outputDatatype', inValues{9});

end

%--------------------------------------------------------------------------

function outData = localTransformToWaveDevice(inData)

    % Get To Wave Device parameter values from inData. If parameter is not
    % in inData, set to the library default value.
    inValues = cell(4,1);
    inValues{1} = localGetVal(inData.InstanceData, 'bufDuration', '2');
    inValues{2} = localGetVal(inData.InstanceData, 'determineBufSize', 'on');
    inValues{3} = localGetVal(inData.InstanceData, 'userIntBufSize', '256');
    inValues{4} = localGetVal(inData.InstanceData, 'useDefaultDevice', 'on');
    inValues{5} = localGetVal(inData.InstanceData, 'userDeviceID', 'Microsoft RDP Audio Driver');    
    
    % Input parameters 'initDelay' and 'enable24Bit' are not used to set
    % the output parameters.
    
    outData.NewBlockPath = '';
        
    if strcmp(inValues{4}, 'on') % Use default device
        value = 'Default';
    else
        value = inValues{5};
    end
    outData.NewInstanceData = localNVPair('deviceName', value);
    
    % Library default for 'inheritSampleRate'. No need to set.
    % Library default for 'sampleRate'. No need to set.        
    
    % Best match considering there is no exact match    
    outData.NewInstanceData(2) = localNVPair('deviceDatatype', ...
        'Determine from input data type');
    
    % Can be aliased    
    outData.NewInstanceData(3) = localNVPair('autoBufferSize', inValues{2});        
        
    if strcmp(inValues{2}, 'on')
        value = '4096'; % Set to library default
    else
        value = inValues{3};
    end
    
    outData.NewInstanceData(4) = localNVPair('bufferSize', value);
        
    outData.NewInstanceData(5) = localNVPair('queueDuration', inValues{1});

end

%--------------------------------------------------------------------------

function [outData warn] = localTransformFromWaveFile(inData)

    % Get From Wave File parameter values from inData. If parameter is not
    % in inData, set to the library default value.
    inValues = cell(6,1);
    inValues{1} = localGetVal(inData.InstanceData, 'FileName', 'speech_dft.wav');
    inValues{2} = localGetVal(inData.InstanceData, 'SamplesPerFrame', '256');
    inValues{3} = localGetVal(inData.InstanceData, 'dType', 'double');
    inValues{4} = localGetVal(inData.InstanceData, 'bLoop', 'off');
    inValues{5} = localGetVal(inData.InstanceData, 'timesToPlay', '1'); 
    inValues{6} = localGetVal(inData.InstanceData, 'lastSampleOutput', '1');
    
    % If startOfFilePortWarning is 'on', issue a warning.
    val  = localGetVal(inData.InstanceData, 'firstSampleOutput', 'off');
    warn = strcmp(val, 'on');
    
    % Input parameters 'MinBufSize', 'restartMode',
    % 'firstSampleOutput' are not used to set the output parameters.

    outData.NewBlockPath = '';
    
    % Add file extension if missing
    [~,~,e] = fileparts(inValues{1});
	if isempty(e),
        e = '.wav';
        inValues{1} = [inValues{1} e];
    end
    % Can be aliased
    outData.NewInstanceData = localNVPair('inputFilename', inValues{1});
    
    % Library default for 'loop' 'on'. No need to set.
    % Will keep on and set numPlays based on From Wave File parameters.    
    
    % If From Wave File 'Loop' checkbox is 'on', set 'numPlays' to be
    % 'timesToPlay'. Else, set it to 1.    
    if strcmp(inValues{4}, 'on')
        value = inValues{5};
    else
        value = '1';
    end
    outData.NewInstanceData(2) = localNVPair('numPlays', value);
    
    % Library default for 'outputStreams'. No need to set.    
    % Library default for 'videoDataType'. No need to set.
       
    outData.NewInstanceData(3) = localNVPair('audioDataType', inValues{3});
     
    % Library default for 'inheritSampleTime'. No need to set.     
    % Library default for 'userDefinedSampleTime'. No need to set.         
    % Library default for 'noAudioOutput'. No need to set. 
    % Library default for 'isIntensityVideo'. No need to set.
    % Library default for 'fourcc'. No need to set.
    % Library default for 'colorVideoFormat'. No need to set. 
       
    outData.NewInstanceData(4) = localNVPair('outputEOF', inValues{6});
    
    % Library default for 'dataOrg'. No need to set. 
    
    % Can be aliased    
    outData.NewInstanceData(5) = localNVPair('audioFrameSize', inValues{2});
     
    % Library default for 'computeAudioFrameSize'. No need to set. 
        
    if eval(inValues{2}) == 1
        value = 'Sample based';
    else
        value = 'Frame based';
    end
    outData.NewInstanceData(6) = localNVPair('outSamplingMode', value);    

end

%--------------------------------------------------------------------------

function outData = localTransformToWaveFile(inData)

    % Get To Wave File parameter values from inData. If parameter is not
    % in inData, set to the library default value.
    inValues = cell(2,1);
    inValues{1} = localGetVal(inData.InstanceData, 'filename', 'audio');
    inValues{2} = localGetVal(inData.InstanceData, 'sampleWidth', '16');
    
    % Input parameter 'MinNumSamples'is not used to set the output parameters.    

    outData.NewBlockPath = '';
    
    % Add file extension if missing
    [~,~,e] = fileparts(inValues{1});
	if isempty(e),
        e = '.wav';
        inValues{1} = [inValues{1} e];
    end
    % Can be aliased    
    outData.NewInstanceData = localNVPair('outputFilename', inValues{1});
     
    % Library default for 'streamSelection'. No need to set.     
    % Library default for 'VideoCompressor'. No need to set.         
    % Library default for 'audioCompressor'. No need to set.         
    % Library default for 'imagePorts'. No need to set. 
        
    outData.NewInstanceData(2) = localNVPair('fileType', 'WAV');
        
    sampleWidth = inValues{2};
    if strcmp(sampleWidth, '32')
        value = [sampleWidth, '-bit float'];
    else
        value = [sampleWidth, '-bit integer'];
    end
    outData.NewInstanceData(3) = localNVPair('audioDatatype', value);
     
    % Library default for 'fourcc'. No need to set. 

end

%--------------------------------------------------------------------------

function entry = localNVPair(name, value)

    entry = struct('Name', name, 'Value', value);

end

%--------------------------------------------------------------------------

function index = localParamIndex(InstanceData, paramName)
% Search paramName for index of paramName

    index = -1; % Means not found

    for i=1:length(InstanceData)
        if strcmp(InstanceData(i).Name, paramName)
            index = i;
            break;
        end
    end

end

%--------------------------------------------------------------------------

function [value index] = localGetVal(InstanceData, paramName, defaultValue)
% Attemp to get value from InstanceData. But if it is not in the
% InstanceData, set it to the library default value.

    index = localParamIndex(InstanceData, paramName);
    if index == -1
        value = defaultValue;
    else
        value = InstanceData(index).Value;
    end

end
