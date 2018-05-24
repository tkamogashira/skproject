%% Creating New Kinds of System Objects for File Input and Output
% This example shows how to create and use two System objects,
% dsp.examples.FileReader and dsp.examples.FileWriter. These System objects
% implement basic file reading and writing by using the MATLAB functions
% FREAD and FWRITE.

%   Copyright 2011-2013 The MathWorks, Inc.

%% Introduction
% In this example, you create two new kinds of System objects, a file
% reader and a file writer, and you stream characters from one to the
% other.

%% Creation of the Classes
% System objects are MATLAB classes that derive from matlab.System,
% and implement several methods of that class. In this example, we will use
% a simple file reader (<matlab:edit('dsp.examples.FileReader')
% dsp.examples.FileReader>) and a file writer
% (<matlab:edit('dsp.examples.FileWriter') dsp.examples.FileWriter>). The
% FileWriter System object consists of four sections:

%% 
% 1. A public property Filename, which is nontunable (it cannot be changed
% after the first call to step):

%%
%    properties (Nontunable)
%      Filename = ''
%    end

%% 
% 2. A private property that holds the file handle. 

%%
%    properties (Access=private)
%      pFID = 0
%    end

%% 
% 3. A constructor. You call the method setProperties in the constructor to
% allow users to set the properites of the System object by providing
% name-value pairs to the constructor.

%%
%    methods
%      function obj = FileWriter(varargin)
%        setProperties(obj, nargin, varargin{:});
%      end
%    end

%%
% 4. A number of overridden methods from the matlab.System base
% class. The public System object methods each have a corresponding
% protected method with an Impl suffix that can be overridden. For example,
% the public step method has a corresponding protected stepImpl method,
% which is used to implement the algorithm for the object. The
% implementation methods that are overridden for this System object are:

%%
% * *setupImpl*         - Initializes the object
% * *resetImpl*         - Resets the state of the object
% * *stepImpl*          - Executes the algorithm
% * *releaseImpl*       - Releases the object and its resources
% * *getNumInputsImpl*  - Defines the number of inputs to step
% * *getNumOutputsImpl* - Defines the number of outputs to step


%% Initialization
% Before the processing loop, create the source file that you will copy and
% initialize the System objects.

% Create two different file names by calling the MATLAB tempname function
% twice.
sourceFile      = tempname();
destinationFile = tempname();

% Create the file containing the text to copy
fid = fopen(sourceFile, 'w');
fprintf(fid,'Simple System object example');
fclose(fid);

% You call the System object constructors before the stream processing
% loop.
hIn  = dsp.examples.FileReader('Filename', sourceFile);
hOut = dsp.examples.FileWriter('Filename', destinationFile);

%% Stream Processing Loop
% Next, create a processing loop to read from the source file and write to
% the destination file.  Although not done here, you can read or write
% multiple characters from (or to) the file at each step to increase
% performance.

% The isDone method returns true when the FileReader has reached the end of
% the file.
while ~isDone(hIn)
    % Read in a single character.  The first time that you call step(), it
    % also calls the setup() method, which is where the file is opened.
    % Note that the step() method calls the stepImpl() method on the
    % reader/writer class.
    c = step(hIn);
    
    % Convert the character  to upper
    % case.
    c = upper(c);
    
    % Write the character that was read from the source.
    step(hOut, c);
end

%% Release the System Objects
% Explicitly using the release method is not always necessary. It is
% performed implicitly when System objects are destroyed. In some cases,
% however, you may want to release the resources immediately. In this
% example, the resources are file pointers, so calling release closes the
% files.
release(hIn);
release(hOut);

%% 
% Display the contents of the source and destination files to verify
% correct operation.
type(sourceFile);
type(destinationFile);

%% Summary
% This example used System objects to read from and write to a file.
% Characters were read one at a time from a file, converted to upper case,
% and streamed to a destination file. You can edit the FileReader and
% FileWriter System objects to perform your own special-purpose file
% reading and writing.

%% Appendix
% The following System objects were created for this example:
%
% * <matlab:edit('dsp.examples.FileReader') dsp.examples.FileReader>
% * <matlab:edit('dsp.examples.FileWriter') dsp.examples.FileWriter>
%

displayEndOfDemoMessage(mfilename)
