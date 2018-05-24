classdef MatFileReader< handle
%MatFileReader File reader
%   hmfr = dsp.MatFileReader returns a System object, hmfr, that reads MAT
%   files.
%
%   hmfr = dsp.MatFileReader('PropertyName', PropertyValue, ...) returns a
%   file reader object, hmfr, with each specified property set to the
%   specified value.
%
%   hmfr = dsp.MatFileReader(FILENAME, VARIABLENAME, 'PropertyName',
%   PropertyValue, ...) returns a file reader object, hmfr, with the
%   Filename property set to FILENAME, the VariableName property set
%   to VARIABLENAME, and other properties set to the specified values.
%
%   Step method syntax:
%
%   X = step(hmfr) reads data, X, from a variable stored in a MAT-file. The
%   variable is assumed to be N-dimensional and a MATLAB built-in datatype.
%   If the FrameBasedProcessing property is true, the data is read into
%   MATLAB by reading along the first dimension. If FrameBasedProcessing is
%   false, the data is read into MATLAB along the last dimension.
%
%   MatFileReader methods:
%
%   step     - See above description for use of this method
%   release  - Closes the MAT file
%   clone    - Create file reader object with same property values
%   reset    - Reset the reading to the start of the variable
%   isDone   - Returns true if object has reached end-of-file
%   isLocked - Locked status (logical)
%
%   MatFileReader properties:
%
%   Filename             - Name of MAT file to read
%   VariableName         - Name of variable to read
%   FrameBasedProcessing - Process input in frames or as samples
%   SamplesPerFrame      - Number of samples per output frame
%
%   % EXAMPLE: Use MatFileReader and MatFileWriter to stream data
%      % First, create a variable name
%      filename = [tempname '.mat'];
%
%      % Next, write that variable to a MAT-file.
%      originalData = rand(40,2);
%      save(filename, 'originalData', '-v7.3');
%
%      % Finally, stream the variable back into MATLAB.
%      hmfr = dsp.MatFileReader(filename, 'VariableName', 'originalData', ...
%                               'SamplesPerFrame', 4);
%      while ~isDone(hmfr)
%          finalData = step(hmfr);
%      end
%
%   See also dsp.MatFileWriter.

     
    %   Copyright 2011-2012 The MathWorks, Inc.

    methods
        function out=MatFileReader
            %MatFileReader File reader
            %   hmfr = dsp.MatFileReader returns a System object, hmfr, that reads MAT
            %   files.
            %
            %   hmfr = dsp.MatFileReader('PropertyName', PropertyValue, ...) returns a
            %   file reader object, hmfr, with each specified property set to the
            %   specified value.
            %
            %   hmfr = dsp.MatFileReader(FILENAME, VARIABLENAME, 'PropertyName',
            %   PropertyValue, ...) returns a file reader object, hmfr, with the
            %   Filename property set to FILENAME, the VariableName property set
            %   to VARIABLENAME, and other properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   X = step(hmfr) reads data, X, from a variable stored in a MAT-file. The
            %   variable is assumed to be N-dimensional and a MATLAB built-in datatype.
            %   If the FrameBasedProcessing property is true, the data is read into
            %   MATLAB by reading along the first dimension. If FrameBasedProcessing is
            %   false, the data is read into MATLAB along the last dimension.
            %
            %   MatFileReader methods:
            %
            %   step     - See above description for use of this method
            %   release  - Closes the MAT file
            %   clone    - Create file reader object with same property values
            %   reset    - Reset the reading to the start of the variable
            %   isDone   - Returns true if object has reached end-of-file
            %   isLocked - Locked status (logical)
            %
            %   MatFileReader properties:
            %
            %   Filename             - Name of MAT file to read
            %   VariableName         - Name of variable to read
            %   FrameBasedProcessing - Process input in frames or as samples
            %   SamplesPerFrame      - Number of samples per output frame
            %
            %   % EXAMPLE: Use MatFileReader and MatFileWriter to stream data
            %      % First, create a variable name
            %      filename = [tempname '.mat'];
            %
            %      % Next, write that variable to a MAT-file.
            %      originalData = rand(40,2);
            %      save(filename, 'originalData', '-v7.3');
            %
            %      % Finally, stream the variable back into MATLAB.
            %      hmfr = dsp.MatFileReader(filename, 'VariableName', 'originalData', ...
            %                               'SamplesPerFrame', 4);
            %      while ~isDone(hmfr)
            %          finalData = step(hmfr);
            %      end
            %
            %   See also dsp.MatFileWriter.
        end

        function assertValidClass(in) %#ok<MANU>
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function isDoneImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Call the base class method
        end

        function readAttributes(in) %#ok<MANU>
            % Read the attribute
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setDiscreteStateImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function setupObject(in) %#ok<MANU>
            % If the filename is empty and we are writing,
            % create a temporary file
            % Open the file
        end

        function stepImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Filename The name of the MAT file
        % The Filename property is a value-only property which indicates the
        % name of the file to be read.  The default value of this property is
        % 'Untitled.mat'
        Filename;

        %FrameBasedProcessing Process input in frames or as samples
        % Set this property to true to enable frame-based processing. Set this
        % property to false to enable sample-based processing. In frame-based
        % mode, this block will stream the data from the first dimension. In
        % sample-based mode, the last dimension of the data set is used. The
        % default value of this property is true.
        FrameBasedProcessing;

        %SamplesPerFrame Number of samples per output frame
        % Every time the step method is called, the number of elements
        % specified by this property are read from the MAT-file. This property
        % is available when FrameBasedProcessing is true. The default value of
        % this property is 1.
        SamplesPerFrame;

        %VariableName The name of the variable stored in the MAT file
        % The VariableName property corresponds to the name of the variable in
        % the MAT-file which is being read.  The default value of this property
        % is 'x'.
        VariableName;

        position;

    end
end
