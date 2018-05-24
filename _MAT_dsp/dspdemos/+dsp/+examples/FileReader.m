classdef FileReader < matlab.System & matlab.system.mixin.FiniteSource
%FileReader Basic text file reader
%   HFR = dspdemo.FileReader reads a text file one character at a time.
%

%   Copyright 2011-2013 The MathWorks, Inc.

    properties (Nontunable)
        %Filename The name of the file to read
        Filename   = ''
    end
    
    properties(Hidden, Access=private)
        %FID The identifier (handle) of the file being read
        FID        = 0
        %nextChar The next character of the file, stored as a double
        nextChar   = ' '
    end
    
    methods
        % Constructor for the System object
        function obj = FileReader(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    %% Overridden implementation methods
    methods(Access = protected)
        % initialize the object
        function setupImpl(obj)
            [obj.FID err] = fopen(obj.Filename, 'r', 'n');
            if ~isempty(err)
                error(message('dsp:FileReader:fileError', err));
            end
        end
        % reset the state of the object
        function resetImpl(obj)
            fseek(obj.FID, 0, 'bof');
            obj.nextChar = fread(obj.FID, 1,'*char');
        end
        % execute the algorithm
        function out = stepImpl(obj)
            out = obj.nextChar;
            obj.nextChar = fread(obj.FID, 1,'*char');
        end
        % release the object and its resources
        function releaseImpl(obj)
            fclose(obj.FID);
        end
        % indicate if we have reached the end of the file
        function tf = isDoneImpl(obj)
            tf = feof(obj.FID);
        end
        % define the number of inputs and outputs of the step method
        function n = getNumInputsImpl(~)
            n = 0;
        end
        function n = getNumOutputsImpl(~)
            n = 1;
        end
    end
end


