classdef MatFileWriter< handle
%MatFileWriter File writer
%   hmfw = dsp.MatFileWriter returns a System object, hmfw, that writes MAT
%   files.
%
%   hmfw = dsp.MatFileWriter('PropertyName', PropertyValue, ...) returns a
%   file writer object, hmfw, with each specified property set to the
%   specified value.
%
%   hmfw = dsp.MatFileWriter(FILENAME, VARIABLENAME, 'PropertyName',
%   PropertyValue, ...) returns a file writer object, hmfw, with the
%   Filename property set to FILENAME, the VariableName property set
%   to VARIABLENAME, and other properties set to the specified values.
%
%   Step method syntax:
%
%   step(hmfw, X) writes data, X, to a variable stored in a MAT-file. The
%   variable is assumed to be N-dimensional and a MATLAB built-in datatype.
%   If the FrameBasedProcessing property is true, the data is written to
%   the file by concatenating along the first dimension. If
%   FrameBasedProcessing is false, the data is written by appending an
%   additional dimension to the end of the data set.
%
%   MatFileWriter methods:
%
%   step     - See above description for use of this method
%   release  - Closes the MAT file.
%   clone    - Create file writer object with same property values
%   reset    - Reset the writing to the start of the variable
%   isLocked - Locked status (logical)
%
%   MatFileWriter properties:
%
%   Filename             - Name of MAT file to write
%   VariableName         - Name of variable to write
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE: Use MatFileReader and MatFileWriter to stream data
%      % First, create a variable name
%      filename = [tempname '.mat'];
%
%      % Next, write that variable to a MAT-file.
%      hmfw = dsp.MatFileWriter(filename, 'VariableName', 'originalData');
%      for i=1:10
%          originalData = rand(4,2);
%          step(hmfw, originalData);
%      end
%      release(hmfw); % This will close the MAT file
%
%      % Finally, load the variable back into MATLAB.
%      data = load(filename, 'originalData');
%
%   See also dsp.MatFileReader.

 
%   Copyright 2011-2013 The MathWorks, Inc.

    methods
        function out=MatFileWriter
            %MatFileWriter File writer
            %   hmfw = dsp.MatFileWriter returns a System object, hmfw, that writes MAT
            %   files.
            %
            %   hmfw = dsp.MatFileWriter('PropertyName', PropertyValue, ...) returns a
            %   file writer object, hmfw, with each specified property set to the
            %   specified value.
            %
            %   hmfw = dsp.MatFileWriter(FILENAME, VARIABLENAME, 'PropertyName',
            %   PropertyValue, ...) returns a file writer object, hmfw, with the
            %   Filename property set to FILENAME, the VariableName property set
            %   to VARIABLENAME, and other properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   step(hmfw, X) writes data, X, to a variable stored in a MAT-file. The
            %   variable is assumed to be N-dimensional and a MATLAB built-in datatype.
            %   If the FrameBasedProcessing property is true, the data is written to
            %   the file by concatenating along the first dimension. If
            %   FrameBasedProcessing is false, the data is written by appending an
            %   additional dimension to the end of the data set.
            %
            %   MatFileWriter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Closes the MAT file.
            %   clone    - Create file writer object with same property values
            %   reset    - Reset the writing to the start of the variable
            %   isLocked - Locked status (logical)
            %
            %   MatFileWriter properties:
            %
            %   Filename             - Name of MAT file to write
            %   VariableName         - Name of variable to write
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE: Use MatFileReader and MatFileWriter to stream data
            %      % First, create a variable name
            %      filename = [tempname '.mat'];
            %
            %      % Next, write that variable to a MAT-file.
            %      hmfw = dsp.MatFileWriter(filename, 'VariableName', 'originalData');
            %      for i=1:10
            %          originalData = rand(4,2);
            %          step(hmfw, originalData);
            %      end
            %      release(hmfw); % This will close the MAT file
            %
            %      % Finally, load the variable back into MATLAB.
            %      data = load(filename, 'originalData');
            %
            %   See also dsp.MatFileReader.
        end

        function cloneImpl(in) %#ok<MANU>
        end

        function extend(in) %#ok<MANU>
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Call the base class method
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
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function writeAttributes(in) %#ok<MANU>
            % Write the class attribute
        end

    end
    methods (Abstract)
    end
    properties
        %Filename Name of MAT file to write
        % The Filename property is a value-only property which indicates the
        % name of the file to be written.  The default value of this property
        % is 'Untitled.mat'
        Filename;

        %FrameBasedProcessing Process input in frames or as samples
        % Set this property to true to enable frame-based processing. Set this
        % property to false to enable sample-based processing. In frame-based
        % mode, this block will stream the data to the first dimension. In
        % sample-based mode, a new dimension is appended to the end of the data
        % set. The default value of this property is true.
        FrameBasedProcessing;

        %VariableName Name of variable to write
        % The VariableName property corresponds to the name of the variable in
        % the MAT-file which is being written.  The default value of this
        % property is 'x'.
        VariableName;

        position;

    end
end
