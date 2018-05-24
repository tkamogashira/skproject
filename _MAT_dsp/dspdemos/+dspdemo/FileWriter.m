
%   Copyright 2011-2013 The MathWorks, Inc.

classdef FileWriter < matlab.System
%FileWriter Basic text file writer
%   HFW = dspdemo.FileWriter reads a text file one character at a time.
%
    
    properties (Nontunable)
        %Filename The name of the file to read
        Filename   = ''
    end
    
    properties(Access=private)
        %FID The identifier (handle) of the file being read
        FID        = 0
    end
    
    methods
        % Constructor for the System object
        function obj = FileWriter(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    %% Overridden implementation methods
    methods(Access = protected)
        % initialize the object
        function setupImpl(obj, data) %#ok<INUSD>
            [obj.FID err] = fopen(obj.Filename, 'w', 'n');
            if ~isempty(err)
                error(message('dsp:FileWriter:fileError', err));
            end
        end
        % reset the state of the object
        function resetImpl(obj)
            fseek(obj.FID, 0, 'bof');
        end
        % execute the algorithm
        function stepImpl(obj, data)
            fwrite(obj.FID, data);
        end
        % release the object and its resources
        function releaseImpl(obj)
            fclose(obj.FID);
        end
        % define the number of inputs and outputs of the step method
        function n = getNumInputsImpl(~)
            n = 1;
        end
        function n = getNumOutputsImpl(~)
            n = 0;
        end
    end
end


