classdef SignalSink< handle
%SignalSink Log simulation data in MATLAB
%   HLOG = dsp.SignalSink returns a signal logger System object, HLOG,
%   that logs 2-D input data in the object. This object accepts any numeric
%   data type.
%
%   HLOG = dsp.SignalSink('PropertyName', PropertyValue, ...) returns a
%   signal logger System object, HLOG, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   step(HLOG, Y) buffers the signal Y. The buffer may be accessed at any
%   time from the Buffer property of HLOG.
%
%   SignalSink methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create signal logger object with same property values
%   isLocked - Locked status (logical)
%   reset    - Clear the logged data
%
%   SignalSink properties:
%
%   FrameBasedProcessing - Process input in frames or as samples
%   BufferLength         - Maximum number of input samples or frames to log
%   Decimation           - Decimation factor
%   FrameHandlingMode    - Dimensionality of output for frame-based inputs
%   Buffer               - Logged data (read only)
%
%   % EXAMPLE: Log input data.
%       hlog = dsp.SignalSink;
%       for i = 1:10
%         y = sin(i);
%         step(hlog, y);
%       end
%       log = hlog.Buffer;  % log = sin([1;2;3;4;5;6;7;8;9;10]);
%
%   See also dsp.SignalSource.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=SignalSink
            %SignalSink Log simulation data in MATLAB
            %   HLOG = dsp.SignalSink returns a signal logger System object, HLOG,
            %   that logs 2-D input data in the object. This object accepts any numeric
            %   data type.
            %
            %   HLOG = dsp.SignalSink('PropertyName', PropertyValue, ...) returns a
            %   signal logger System object, HLOG, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   step(HLOG, Y) buffers the signal Y. The buffer may be accessed at any
            %   time from the Buffer property of HLOG.
            %
            %   SignalSink methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create signal logger object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Clear the logged data
            %
            %   SignalSink properties:
            %
            %   FrameBasedProcessing - Process input in frames or as samples
            %   BufferLength         - Maximum number of input samples or frames to log
            %   Decimation           - Decimation factor
            %   FrameHandlingMode    - Dimensionality of output for frame-based inputs
            %   Buffer               - Logged data (read only)
            %
            %   % EXAMPLE: Log input data.
            %       hlog = dsp.SignalSink;
            %       for i = 1:10
            %         y = sin(i);
            %         step(hlog, y);
            %       end
            %       log = hlog.Buffer;  % log = sin([1;2;3;4;5;6;7;8;9;10]);
            %
            %   See also dsp.SignalSource.
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Save the public properties
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
            % Need to set this to false for the case when step is called after
            % reset.
        end

    end
    methods (Abstract)
    end
    properties
        %Buffer Logged Data (read only)
        Buffer;

        %BufferLength Maximum number of input samples or frames to log
        %   Specify maximum number of most recent samples of data to log when
        %   the input is sample based, or the maximum number of most recent
        %   frames of data to log when the input is frame based. To capture all
        %   data, set BufferLength to inf. The default value of this property
        %   is inf.
        BufferLength;

        %Decimation Decimation factor
        %   This property can be set to any positive integer d, and indicates
        %   that the System object writes data at every dth sample. The default
        %   value of this property is 1.
        Decimation;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. This property
        %   affects how BufferLength and Decimation work. The default value of
        %   this property is true.
        FrameBasedProcessing;

        %FrameHandlingMode Output dimensionality for frame-based inputs
        %   Set the dimension of the output array for frame-based inputs as one
        %   of [{'2-D array (concatenate)'} | '3-D array (separate)'].
        %   Concatenation occurs along the first dimension for '2-D array
        %   (concatenate)'. This property is only applicable when
        %   FrameBasedProcessing is true.
        FrameHandlingMode;

    end
end
