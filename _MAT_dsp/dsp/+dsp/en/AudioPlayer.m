classdef AudioPlayer< handle
%AudioPlayer Play audio data using the computer's audio device
%   HAP = dsp.AudioPlayer returns a System object, HAP, that plays audio
%   samples using an audio output device in real-time.
%
%   HAP = dsp.AudioPlayer('PropertyName', PropertyValue, ...) returns an
%   audio player System object, HAP, with each specified property set to
%   the specified value.
%
%   HAP = dsp.AudioPlayer(SAMPLERATE, 'PropertyName', PropertyValue, ...)
%   returns an audio player System object, HAP, with the SampleRate
%   property set to SAMPLERATE and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   step(HAP, AUDIO) writes one frame of audio samples to the selected
%   audio output device.
%
%   AudioPlayer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release audio player resources
%   clone    - Create audio player object with same property values
%   isLocked - Locked status (logical)
%
%   AudioPlayer properties:
%
%   DeviceName       - Device used to play audio data
%   SampleRate       - Number of samples per second sent to audio device
%   DeviceDataType   - Data type used by the device
%   BufferSizeSource - Source of Buffer Size
%   BufferSize       - Buffer size
%   QueueDuration    - Size of queue in seconds
%   ChannelMappingSource  - Source of Output Device Channel Mapping 
%   ChannelMapping        - Data to Output Device Channel Mapping 
%
%   % EXAMPLE: Read in an AVI audio file and play it back using the
%   %          standard audio output device.
%      hafr = dsp.AudioFileReader;
%      hap = dsp.AudioPlayer('SampleRate',22050);
%      while ~isDone(hafr)
%          audio = step(hafr);
%          step(hap, audio);
%      end
%      pause(hap.QueueDuration); % Wait until audio is played to the end
%      release(hafr);            % close the input file
%      release(hap);             % close the audio output device
%
%   See also dsp.AudioRecorder, dsp.AudioFileWriter.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=AudioPlayer
            %AudioPlayer Play audio data using the computer's audio device
            %   HAP = dsp.AudioPlayer returns a System object, HAP, that plays audio
            %   samples using an audio output device in real-time.
            %
            %   HAP = dsp.AudioPlayer('PropertyName', PropertyValue, ...) returns an
            %   audio player System object, HAP, with each specified property set to
            %   the specified value.
            %
            %   HAP = dsp.AudioPlayer(SAMPLERATE, 'PropertyName', PropertyValue, ...)
            %   returns an audio player System object, HAP, with the SampleRate
            %   property set to SAMPLERATE and other specified properties set to the
            %   specified values.
            %
            %   Step method syntax:
            %
            %   step(HAP, AUDIO) writes one frame of audio samples to the selected
            %   audio output device.
            %
            %   AudioPlayer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release audio player resources
            %   clone    - Create audio player object with same property values
            %   isLocked - Locked status (logical)
            %
            %   AudioPlayer properties:
            %
            %   DeviceName       - Device used to play audio data
            %   SampleRate       - Number of samples per second sent to audio device
            %   DeviceDataType   - Data type used by the device
            %   BufferSizeSource - Source of Buffer Size
            %   BufferSize       - Buffer size
            %   QueueDuration    - Size of queue in seconds
            %   ChannelMappingSource  - Source of Output Device Channel Mapping 
            %   ChannelMapping        - Data to Output Device Channel Mapping 
            %
            %   % EXAMPLE: Read in an AVI audio file and play it back using the
            %   %          standard audio output device.
            %      hafr = dsp.AudioFileReader;
            %      hap = dsp.AudioPlayer('SampleRate',22050);
            %      while ~isDone(hafr)
            %          audio = step(hafr);
            %          step(hap, audio);
            %      end
            %      pause(hap.QueueDuration); % Wait until audio is played to the end
            %      release(hafr);            % close the input file
            %      release(hap);             % close the audio output device
            %
            %   See also dsp.AudioRecorder, dsp.AudioFileWriter.
        end

        function cloneImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %BufferSize Buffer size
        %   Specify the size of the buffer that the System object uses to
        %   communicate with the audio device as a scalar integer. This
        %   property is applicable when the BufferSizeSource property is
        %   'Property'. This property is tunable. The default value of this
        %   property is 4096.
        BufferSize;

        %BufferSizeSource Source of Buffer Size
        %   Specify how to determine the buffer size as one of [{'Auto'} |
        %   'Property'].
        BufferSizeSource;

        %ChannelMapping 
        %   Vector of valid channel indices to represent the mapping
        %   between data and device output channels
        ChannelMapping;

        %ChannelMappingSource 
        %   Specify how to determine the channel mapping as one of
        %   [{'Auto'} | 'Property'].
        ChannelMappingSource;

        %DeviceDataType Data type used by the device
        %   Specify the data type used by the device to acquire audio data
        %   as one of [{'Determine from input data type'} | '8-bit integer'
        %   | '16-bit integer' | '24-bit integer' | '32-bit float'].
        DeviceDataType;

        %DeviceName Device to which to send audio data
        %   Specify the device to which the audio data should be sent.
        DeviceName;

        %QueueDuration Size of queue in seconds
        %   Specify the length of the audio queue, in seconds. This
        %   property is tunable. The default value of this property is 1.0.
        QueueDuration;

        %SampleRate Number of samples per second sent to audio device
        %   Specify the number of samples per second in the signal as a
        %   scalar value. This property is tunable. The default value of
        %   this property is 44100.
        SampleRate;

    end
end
