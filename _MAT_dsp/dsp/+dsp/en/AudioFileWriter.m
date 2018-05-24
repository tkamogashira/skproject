classdef AudioFileWriter< handle
%AudioFileWriter Write audio samples to audio file
%   HAFW = dsp.AudioFileWriter returns a System object, HAFW, that writes
%   audio samples to an audio file (such as a WAV file).
%
%   HAFW = dsp.AudioFileWriter('PropertyName', PropertyValue, ...)
%   returns an audio file writer System object, HAFW, with each
%   specified property set to the specified value.
%
%   HAFW = dsp.AudioFileWriter(FILENAME, 'PropertyName',
%   PropertyValue, ...) returns an audio file writer System object,
%   HAFW, with Filename property set to FILENAME and other specified
%   properties set to the specified values.
%
%   Step method syntax:
%
%   step(HAFW, AUDIO) writes one frame of audio samples, AUDIO, to the
%   output file. AUDIO is either a vector or an M-by-N matrix for mono or
%   N-channel audio input, respectively.
%
%   AudioFileWriter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release audio file writer resources
%   clone    - Create audio file writer object with same property values
%   isLocked - Locked status (logical)
%
%   AudioFileWriter properties:
%
%   Filename   - Name of audio file to which to write
%   FileFormat - Format of created file
%   SampleRate - Sampling rate of audio data stream
%   Compressor - Algorithm used to compress audio data
%   DataType   - Data type of the uncompressed audio
%
%   % EXAMPLE: Decimate an audio signal and write it to disk as an WAV file.
%      hafr = dsp.AudioFileReader('OutputDataType', 'double');
%      hfirdec = dsp.FIRDecimator; % decimate by 2
%      hafw = dsp.AudioFileWriter('speech_dft.wav', ...
%                                 'SampleRate', hafr.SampleRate/2);
%      while ~isDone(hafr)
%        audio = step(hafr);
%        audiod = step(hfirdec, audio);
%        step(hafw, audiod);
%      end
%      release(hafr);
%      release(hafw);
%
%   See also dsp.AudioFileReader.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=AudioFileWriter
            %AudioFileWriter Write audio samples to audio file
            %   HAFW = dsp.AudioFileWriter returns a System object, HAFW, that writes
            %   audio samples to an audio file (such as a WAV file).
            %
            %   HAFW = dsp.AudioFileWriter('PropertyName', PropertyValue, ...)
            %   returns an audio file writer System object, HAFW, with each
            %   specified property set to the specified value.
            %
            %   HAFW = dsp.AudioFileWriter(FILENAME, 'PropertyName',
            %   PropertyValue, ...) returns an audio file writer System object,
            %   HAFW, with Filename property set to FILENAME and other specified
            %   properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   step(HAFW, AUDIO) writes one frame of audio samples, AUDIO, to the
            %   output file. AUDIO is either a vector or an M-by-N matrix for mono or
            %   N-channel audio input, respectively.
            %
            %   AudioFileWriter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release audio file writer resources
            %   clone    - Create audio file writer object with same property values
            %   isLocked - Locked status (logical)
            %
            %   AudioFileWriter properties:
            %
            %   Filename   - Name of audio file to which to write
            %   FileFormat - Format of created file
            %   SampleRate - Sampling rate of audio data stream
            %   Compressor - Algorithm used to compress audio data
            %   DataType   - Data type of the uncompressed audio
            %
            %   % EXAMPLE: Decimate an audio signal and write it to disk as an WAV file.
            %      hafr = dsp.AudioFileReader('OutputDataType', 'double');
            %      hfirdec = dsp.FIRDecimator; % decimate by 2
            %      hafw = dsp.AudioFileWriter('speech_dft.wav', ...
            %                                 'SampleRate', hafr.SampleRate/2);
            %      while ~isDone(hafr)
            %        audio = step(hafr);
            %        audiod = step(hfirdec, audio);
            %        step(hafw, audiod);
            %      end
            %      release(hafr);
            %      release(hafw);
            %
            %   See also dsp.AudioFileReader.
        end

        function cloneImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Compressor Algorithm used to compress audio data
        %   Specify the type of compression algorithm to use to compress the
        %   audio data. This compression reduces the size of the audio file.
        %   Choose 'None (uncompressed)' to save uncompressed audio data to the
        %   file. The other options reflect the available audio compression
        %   algorithms installed on your system.  This property is only
        %   available when writing WAV or AVI files on Windows (R) platforms.
        Compressor;

        %DataType Data type of uncompressed audio
        %   Specify the data type of uncompressed audio which is written to the
        %   file. 
        %   For uncompressed WAV files, the value can be one of :
        %     'inherit'|'uint8'|'int16'|'int24'|'int32'|'single'|'double'.
        %   For FLAC files, the value can be one of :
        %     'inherit'|'uint8'|'int16'|'int24'.
        %   The default is 'int16'. Note that this property is only applicable 
        %   when writing uncompressed WAV and FLAC files.
        DataType;

        %FileFormat Format of created file
        %   Specify the format of the audio file that is created. 
        %   On Windows (R) platforms, this may be one of: 
        %       ['AVI' | {'WAV'} | 'FLAC' | 'OGG' | 'WMA' | 'MPEG4'].
        %   On Linux (R) platforms, this may be one of:
        %       ['AVI' | {'WAV'} | 'FLAC' | 'OGG']. 
        %   On Mac OS X (R) platforms, this may be one of:
        %       ['AVI' | {'WAV'} | 'FLAC' | 'OGG' | 'MPEG4']
        %   These abbreviations correspond to the following file formats:
        %       WAV: Microsoft WAVE Files
        %       FLAC: Free Lossless Audio Codec
        %       OGG: Ogg/Vorbis Compressed Audio File
        %       WMA: Windows Media Audio
        %       AVI: Audio-Video Interleave
        %       MPEG4: MPEG-4 AAC File
        FileFormat;

        %Filename Name of audio file to which to write
        %   Specify the name of the audio file as a string. The default
        %   value of this property is 'output.wav'.
        Filename;

        %SampleRate Sampling rate of audio data stream
        %   Specify the sampling rate of the input audio data as a positive
        %   numeric scalar. The default value of this property is 44100.
        SampleRate;

    end
end
