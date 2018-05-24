function maxChannels = computeMaxChannelsForDevice(deviceName, mode)
% Determines the maximum number of input or output channels for a specified
% device 

% Copyright 2012-2013 The MathWorks, Inc.

% The device name that is used from the From/To Audio Device blocks.
if strcmp(deviceName, 'No device available.')
    maxChannels = 0;
    return;
end

if strcmpi(mode, 'input')
    if strcmp(deviceName, 'Default')
        devInfo = dspAudioDeviceInfo('defaultInput');
        maxChannels = devInfo.maxInputs;
    elseif strcmp(deviceName, 'No audio input devices found')
        maxChannels = 0;
    else
        devInfo = dspAudioDeviceInfo('inputs');
        selDeviceIdx = arrayfun(@(x) strncmp(x.name, deviceName, ...
                                   length(deviceName)), devInfo);
        if ~any(selDeviceIdx)
            maxChannels = 0;
        else
            maxChannels = devInfo(selDeviceIdx).maxInputs;
        end
    end
    return;
end

if strcmpi(mode, 'output')
    if strcmp(deviceName, 'Default')
        devInfo = dspAudioDeviceInfo('defaultOutput');
        maxChannels = devInfo.maxOutputs;
    elseif strcmp(deviceName, 'No audio output devices found')
        maxChannels = 0;
    else
        devInfo = dspAudioDeviceInfo('outputs');
        selDeviceIdx = arrayfun(@(x) strncmp(x.name, deviceName, ...
                                   length(deviceName)), devInfo);
        if ~any(selDeviceIdx)
            maxChannels = 0;
        else
            maxChannels = devInfo(selDeviceIdx).maxOutputs;
        end
    end
    return;
end

assert(false, 'Invalid mode specified');
    