classdef FileWriter < matlab.System
%FileWriter Write a file one character at a time
%   HFW = dsp.examples.FileWriter returns a System object, HFW, that writes
%   a text file one character at a time.
%
%   HFW = dsp.examples.FileWriter('PropertyName', PropertyValue, ...)
%   returns a FileWriter, HFW, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   step(HFW, X) writes a scalar double, X, to a file as a character.
%
%   FileWriter properties:
%
%   Filename - The name of the file to write
% 
%   % EXAMPLE: Convert a file to uppercase 
%      % Create two different file names by calling the MATLAB tempname 
%      % function twice.
%      sourceFile      = tempname();
%      destinationFile = tempname();
%      % % Create the file containing the text to copy
%      fid = fopen(sourceFile, 'w');
%      fprintf(fid,'Simple System object example');
%      fclose(fid);
%      hIn  = dsp.examples.FileReader('Filename', sourceFile);
%      hOut = dsp.examples.FileWriter('Filename', destinationFile);
%      
%      while ~isDone(hIn)
%          % Read in a single character. 
%          c = step(hIn);
%          % Convert the character to uppercase.
%          c = double(upper(char(c)));
%          % Write the character that was read from the source.
%          step(hOut, c);
%      end
%

%   Copyright 2011-2013 The MathWorks, Inc.

  properties (Nontunable)
    %Filename The name of the file to write
    Filename = ''
  end
  
  properties (Access=private)
    %FID The identifier (handle) of the file being written
    FID = 0
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
        % error('dsp:examples:FileWriter:fileError', 'fopen failed returning ''%s''', err);
        error(message('dsp:examples:FileWriter:fileError', err));
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


