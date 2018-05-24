classdef AudioRecorder< handle
%AudioRecorder Record audio data using computer's audio device
%   HAR = dsp.AudioRecorder returns a System object, HAR, that records
%   audio samples using an audio input device in real-time.
%
%   HAR = dsp.AudioRecorder('PropertyName', PropertyValue, ...) returns an
%   audio recorder System object, HAR, with each specified property set to
%   the specified value.
%
%   HAR = dsp.AudioRecorder(SAMPLERATE, 'PropertyName', PropertyValue, ...)
%   returns an audio recorder System object, HAR, with the SampleRate
%   property set to SAMPLERATE and other specified properties set to the
%   specified values.
%
%   HAR = dsp.AudioRecorder(SAMPLERATE, SAMPLESPERFRAME, 'PropertyName',
%   PropertyValue, ...) returns an audio recorder System object, HAR, with
%   the SampleRate property set to SAMPLERATE, the SamplesPerFrame property
%   set to SAMPLESPERFRAME, and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   AUDIO = step(HAR) reads one frame of audio samples from the selected
%   audio input device.
%
%   AudioRecorder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release audio recorder resources
%   clone    - Create audio recorder object with same property values
%   isLocked - Locked status (logical)
%
%   AudioRecorder properties:
%
%   DeviceName       - Device used to record audio data
%   SampleRate       - Number of samples per second read from audio device
%   NumChannels      - Number of audio channels
%   DeviceDataType   - Data type used by the device
%   BufferSizeSource - Source of Buffer Size
%   BufferSize       - Buffer size
%   QueueDuration    - Size of queue in seconds
%   SamplesPerFrame  - Number of samples in the output signal
%   OutputDataType   - Data type of the output
%   ChannelMappingSource  - Source of Input Device Channel Mapping 
%   ChannelMapping        - Input Device Channels to Data Mapping 
%
%   % EXAMPLE: Record ten seconds of speech from a microphone and send the
%   %          output to a .wav file.
%      har = dsp.AudioRecorder;
%      hafw = dsp.AudioFileWriter('myspeech.wav','FileFormat', 'WAV');
%      disp('Speak into microphone now');
%      tic;
%      while toc < 10,
%        step(hafw, step(har));
%      end
%      release(har);
%      release(hafw);
%      disp('Recording complete');
%
%   See also dsp.AudioPlayer, dsp.AudioFileReader.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=AudioRecorder
            %AudioRecorder Record audio data using computer's audio device
            %   HAR = dsp.AudioRecorder returns a System object, HAR, that records
            %   audio samples using an audio input device in real-time.
            %
            %   HAR = dsp.AudioRecorder('PropertyName', PropertyValue, ...) returns an
            %   audio recorder System object, HAR, with each specified property set to
            %   the specified value.
            %
            %   HAR = dsp.AudioRecorder(SAMPLERATE, 'PropertyName', PropertyValue, ...)
            %   returns an audio recorder System object, HAR, with the SampleRate
            %   property set to SAMPLERATE and other specified properties set to the
            %   specified values.
            %
            %   HAR = dsp.AudioRecorder(SAMPLERATE, SAMPLESPERFRAME, 'PropertyName',
            %   PropertyValue, ...) returns an audio recorder System object, HAR, with
            %   the SampleRate property set to SAMPLERATE, the SamplesPerFrame property
            %   set to SAMPLESPERFRAME, and other specified properties set to the
            %   specified values.
            %
            %   Step method syntax:
            %
            %   AUDIO = step(HAR) reads one frame of audio samples from the selected
            %   audio input device.
            %
            %   AudioRecorder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release audio recorder resources
            %   clone    - Create audio recorder object with same property values
            %   isLocked - Locked status (logical)
            %
            %   AudioRecorder properties:
            %
            %   DeviceName       - Device used to record audio data
            %   SampleRate       - Number of samples per second read from audio device
            %   NumChannels      - Number of audio channels
            %   DeviceDataType   - Data type used by the device
            %   BufferSizeSource - Source of Buffer Size
            %   BufferSize       - Buffer size
            %   QueueDuration    - Size of queue in seconds
            %   SamplesPerFrame  - Number of samples in the output signal
            %   OutputDataType   - Data type of the output
            %   ChannelMappingSource  - Source of Input Device Channel Mapping 
            %   ChannelMapping        - Input Device Channels to Data Mapping 
            %
            %   % EXAMPLE: Record ten seconds of speech from a microphone and send the
            %   %          output to a .wav file.
            %      har = dsp.AudioRecorder;
            %      hafw = dsp.AudioFileWriter('myspeech.wav','FileFormat', 'WAV');
            %      disp('Speak into microphone now');
            %      tic;
            %      while toc < 10,
            %        step(hafw, step(har));
            %      end
            %      release(har);
            %      release(hafw);
            %      disp('Recording complete');
            %
            %   See also dsp.AudioPlayer, dsp.AudioFileReader.
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
        %   between device input channels and the data 
        ChannelMapping;

        %ChannelMappingSource 
        %   Specify how to determine the channel mapping as one of
        %   [{'Auto'} | 'Property'].
        ChannelMappingSource;

        %DeviceDataType Data type used by the device
        %   Specify the data type used by the device to acquire audio data
        %   as one of [{'Determine from output data type'} | '8-bit
        %   integer' | '16-bit integer' | '24-bit integer' | '32-bit
        %   float']. 
        DeviceDataType;

        %DeviceName Device from which to acquire audio data
        %   Specify the device from which to acquire audio data.
        DeviceName;

        %NumChannels Number of audio channels
        %   Specify the number of audio channels as a scalar integer. The
        %   default value of this property is 2.
        NumChannels;

        %OutputDataType Data type of the output
        %   Select the output data type as one of ['uint8' | 'int16' |
        %   'int32' | 'single' | {'double'}].
        OutputDataType;

        %QueueDuration Size of queue in seconds
        %   Specify the length of the audio queue, in seconds. This
        %   property is tunable. The default value of this property is 1.0.
        QueueDuration;

        %SampleRate Number of samples per second read from audio device
        %   Specify the number of samples per second in the signal as a
        %   scalar value. This property is tunable. The default value of
        %   this property is 44100.
        SampleRate;

        %SamplesPerFrame Number of samples in the output signal
        %   Specify the number of samples in the System object's output
        %   signal as a scalar integer value. The default value of this
        %   property is 1024.
        SamplesPerFrame;

    end
end
