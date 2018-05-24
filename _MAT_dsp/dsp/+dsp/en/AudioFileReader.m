classdef AudioFileReader< handle
%AudioFileReader Read audio samples from audio file
%   HAFR = dsp.AudioFileReader returns a System object, HAFR, to read an
%   audio file.
%
%   HAFR = dsp.AudioFileReader('PropertyName', PropertyValue, ...) returns
%   an audio file reader System object, HAFR, with each specified property
%   set to the specified value.
%
%   HAFR = dsp.AudioFileReader(FILENAME, 'PropertyName', PropertyValue,
%   ...) returns an audio file reader System object, HAFR, with Filename
%   property set to FILENAME and other specified properties set to the
%   specified values.
%
%   Step method syntax:
%
%   AUDIO = step(HAFR) outputs one frame of audio samples, AUDIO. After the
%   file has been played through the number of times specified by
%   PlayCount, AUDIO will contain silence.
%
%   [AUDIO, EOF] = step(HAFR) gives the end-of-file indicator in EOF. EOF
%   will be true each time the output contains the last audio sample in the
%   file.
%
%   AudioFileReader methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release audio file reader resources
%   clone    - Create audio file reader object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset to the beginning of the audio file
%   isDone   - Returns true if object has reached end-of-file PlayCount
%              times
%   info     - Returns information about the specified audio file
%
%   AudioFileReader properties:
%
%   Filename        - Name of audio file from which to read
%   PlayCount       - Number of times to play the file
%   SampleRate      - Sampling rate of audio file in Hz
%   SamplesPerFrame - Number of samples in audio frame
%   OutputDataType  - Data type of output
%
%   % EXAMPLE: Read in an audio file and play it back using the standard
%   % audio output device.
%      hafr = dsp.AudioFileReader('speech_dft.mp3');
%      hap = dsp.AudioPlayer('SampleRate', hafr.SampleRate);
%      while ~isDone(hafr)
%        audio = step(hafr);
%        step(hap, audio);
%      end
%      release(hafr); % close the input file
%      release(hap);  % close the audio output device
%
%   See also dsp.AudioFileWriter.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=AudioFileReader
            %AudioFileReader Read audio samples from audio file
            %   HAFR = dsp.AudioFileReader returns a System object, HAFR, to read an
            %   audio file.
            %
            %   HAFR = dsp.AudioFileReader('PropertyName', PropertyValue, ...) returns
            %   an audio file reader System object, HAFR, with each specified property
            %   set to the specified value.
            %
            %   HAFR = dsp.AudioFileReader(FILENAME, 'PropertyName', PropertyValue,
            %   ...) returns an audio file reader System object, HAFR, with Filename
            %   property set to FILENAME and other specified properties set to the
            %   specified values.
            %
            %   Step method syntax:
            %
            %   AUDIO = step(HAFR) outputs one frame of audio samples, AUDIO. After the
            %   file has been played through the number of times specified by
            %   PlayCount, AUDIO will contain silence.
            %
            %   [AUDIO, EOF] = step(HAFR) gives the end-of-file indicator in EOF. EOF
            %   will be true each time the output contains the last audio sample in the
            %   file.
            %
            %   AudioFileReader methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release audio file reader resources
            %   clone    - Create audio file reader object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset to the beginning of the audio file
            %   isDone   - Returns true if object has reached end-of-file PlayCount
            %              times
            %   info     - Returns information about the specified audio file
            %
            %   AudioFileReader properties:
            %
            %   Filename        - Name of audio file from which to read
            %   PlayCount       - Number of times to play the file
            %   SampleRate      - Sampling rate of audio file in Hz
            %   SamplesPerFrame - Number of samples in audio frame
            %   OutputDataType  - Data type of output
            %
            %   % EXAMPLE: Read in an audio file and play it back using the standard
            %   % audio output device.
            %      hafr = dsp.AudioFileReader('speech_dft.mp3');
            %      hap = dsp.AudioPlayer('SampleRate', hafr.SampleRate);
            %      while ~isDone(hafr)
            %        audio = step(hafr);
            %        step(hap, audio);
            %      end
            %      release(hafr); % close the input file
            %      release(hap);  % close the audio output device
            %
            %   See also dsp.AudioFileWriter.
        end

        function infoImpl(in) %#ok<MANU>
            %info Returns information about the specified audio file
            %   S = info(OBJ) returns a MATLAB structure, S, with information
            %   about the audio file specified in the Filename property. The
            %   possible fields and values for the structure S are described
            %   below:
            %
            %   SampleRate  - Audio sampling rate of the audio file in Hz.
            %   NumBits     - Number of bits used to encode the audio stream.
            %   NumChannels - Number of audio channels.
        end

        function isDoneImpl(in) %#ok<MANU>
            %isDone Returns true if System object has reached end-of-file 
            %PlayCount times. 
            %   STATUS = isDone(OBJ) returns a logical value, STATUS, indicating
            %   if the AudioFileReader System object, OBJ, has reached the end of
            %   the audio file PlayCount times. If the PlayCount property is set 
            %   to Inf, STATUS will be always false.
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function setFileInfoProps(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Filename Name of audio file from which to read
        %   Specify the name of the audio file as a string. The full path
        %   for the file needs to be specified only if the file is not on the
        %   MATLAB path. The default value of this property is
        %   'speech_dft.mp3'.
        Filename;

        %OutputDataType Data type of output
        %   Set the data type of the audio data output from the System object.
        %   This property can be set to one of ['double' | 'single' | {'int16'}
        %   | 'uint8'].
        OutputDataType;

        %PlayCount Number of times to play the file
        %   Specify a positive integer or inf to represent the number of times
        %   to play the file. The default value of this property is 1.
        PlayCount;

        %SampleRate Sampling rate of audio file in Hz
        %   This read-only property indicates the sampling rate in Hz of
        %   the specified audio file. 
        SampleRate;

        %SamplesPerFrame Number of samples in audio frame
        %   Specify the number of samples in an audio frame as a positive
        %   scalar integer value. The default value of this property is 1024.
        SamplesPerFrame;

    end
end
