classdef Buffer< handle
%Buffer Buffer input signal
%   HBUFF = dsp.Buffer returns a buffer System object, HBUFF, used to
%   buffer input signals with overlap.
%
%   HBUFF = dsp.Buffer('PropertyName', PropertyValue, ...) returns a buffer
%   object, HBUFF, with each specified property set to the specified value.
%
%   HBUFF = dsp.Buffer(LENGTH, OVERLAPLENGTH, INITIALCONDITIONS,
%   'PropertyName', PropertyValue, ...) returns a buffer object, HBUFF,
%   with Length property set to LENGTH, OverlapLength property set to
%   OVERLAPLENGTH, InitialConditions property set to INITIALCONDITIONS and
%   other specified properties set to the specified values.
%
%   The number of samples per channel in the input to the Buffer object
%   must match the condition 
%   Number of samples per channel = Length - OverlapLength.
%   Number of samples per channel is equal to the number of rows in the
%   input when FrameBasedProcessing is true. Otherwise, it is equal to 1.
%
%   Step method syntax:
%
%   Y = step(HBUFF, X) creates output Y based on current input and stored
%   past values of X. Output length is equal to the Length property.
%
%   Buffer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create buffer object with same property values
%   isLocked - Locked status (logical)
%   reset    - Resets the states to initial conditions
%
%   Buffer properties:
%
%   Length               - Number of samples to buffer
%   OverlapLength        - Amount of overlap between outputs
%   InitialConditions    - Initial output
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE #1:  Create buffer of 256 samples with 128 sample overlap
%       hreader = dsp.SignalSource(randn(1024,1), 128);
%       hbuff = dsp.Buffer(256, 128);
%       for i=1:8
%           y = step(hbuff, step(hreader));
%           % y is of length 256 with 128 samples from previous input
%       end
%
%   See also dsp.DelayLine, dsp.Delay.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=Buffer
            %Buffer Buffer input signal
            %   HBUFF = dsp.Buffer returns a buffer System object, HBUFF, used to
            %   buffer input signals with overlap.
            %
            %   HBUFF = dsp.Buffer('PropertyName', PropertyValue, ...) returns a buffer
            %   object, HBUFF, with each specified property set to the specified value.
            %
            %   HBUFF = dsp.Buffer(LENGTH, OVERLAPLENGTH, INITIALCONDITIONS,
            %   'PropertyName', PropertyValue, ...) returns a buffer object, HBUFF,
            %   with Length property set to LENGTH, OverlapLength property set to
            %   OVERLAPLENGTH, InitialConditions property set to INITIALCONDITIONS and
            %   other specified properties set to the specified values.
            %
            %   The number of samples per channel in the input to the Buffer object
            %   must match the condition 
            %   Number of samples per channel = Length - OverlapLength.
            %   Number of samples per channel is equal to the number of rows in the
            %   input when FrameBasedProcessing is true. Otherwise, it is equal to 1.
            %
            %   Step method syntax:
            %
            %   Y = step(HBUFF, X) creates output Y based on current input and stored
            %   past values of X. Output length is equal to the Length property.
            %
            %   Buffer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create buffer object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Resets the states to initial conditions
            %
            %   Buffer properties:
            %
            %   Length               - Number of samples to buffer
            %   OverlapLength        - Amount of overlap between outputs
            %   InitialConditions    - Initial output
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE #1:  Create buffer of 256 samples with 128 sample overlap
            %       hreader = dsp.SignalSource(randn(1024,1), 128);
            %       hbuff = dsp.Buffer(256, 128);
            %       for i=1:8
            %           y = step(hbuff, step(hreader));
            %           % y is of length 256 with 128 samples from previous input
            %       end
            %
            %   See also dsp.DelayLine, dsp.Delay.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. The default
        %   value of this property is true. 
        FrameBasedProcessing;

        %InitialConditions Initial output
        %   Specify the value of the System object's initial output for cases
        %   of nonzero latency as a scalar, vector, or matrix. The default
        %   value of this property is 0.
        InitialConditions;

        %Length Number of samples to buffer
        %   Specify the number of consecutive samples from each input channel
        %   to buffer. This property can be set to any scalar integer greater
        %   than 0 of MATLAB built-in numeric data type. The default value of
        %   this property is 64.
        Length;

        %OverlapLength Amount of overlap between outputs
        %   Specify the number of samples by which consecutive output frames
        %   overlap. This property can be set to any scalar integer greater
        %   than or equal to 0 of MATLAB built-in numeric data type. The
        %   default value of this property is 0.
        OverlapLength;

    end
end
