classdef PhaseUnwrapper< handle
%PhaseUnwrapper Unwrap signal phase
%   HUNWRAP = dsp.PhaseUnwrapper returns a System object, HUNWRAP, that
%   adds or subtracts appropriate multiples of 2pi to each input element to
%   remove phase discontinuities (unwrap). Inputs should be radian phase
%   values.
%
%   HUNWRAP = dsp.PhaseUnwrapper('PropertyName', PropertyValue, ...)
%   returns an unwrap System object, HUNWRAP, with each specified property
%   set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HUNWRAP, X) unwraps the input signal X.
%
%   PhaseUnwrapper methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create unwrap object with same property values
%   isLocked - Locked status (logical)
%   reset    - Resets the states when the InterFrameUnwrap property is true
%
%   PhaseUnwrapper properties:
%
%   InterFrameUnwrap     - Enables unwrapping of phase discontinuities
%                          between successive frames
%   Tolerance            - Jump size as a true phase discontinuity
%   FrameBasedProcessing - Process input as frames or as samples
%
%   %EXAMPLE: Unwrap input phase data.
%       hunwrap = dsp.PhaseUnwrapper;
%       p = [0 2/5 4/5 -4/5 -2/5 0 2/5 4/5 -4/5 -2/5 0 2/5 4/5 -4/5, ...
%           -2/5]*pi;
%       y = step(hunwrap, p'); 
%       figure,stem(p); hold 
%       stem(y, 'r');
%
%   See also unwrap.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=PhaseUnwrapper
            %PhaseUnwrapper Unwrap signal phase
            %   HUNWRAP = dsp.PhaseUnwrapper returns a System object, HUNWRAP, that
            %   adds or subtracts appropriate multiples of 2pi to each input element to
            %   remove phase discontinuities (unwrap). Inputs should be radian phase
            %   values.
            %
            %   HUNWRAP = dsp.PhaseUnwrapper('PropertyName', PropertyValue, ...)
            %   returns an unwrap System object, HUNWRAP, with each specified property
            %   set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HUNWRAP, X) unwraps the input signal X.
            %
            %   PhaseUnwrapper methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create unwrap object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Resets the states when the InterFrameUnwrap property is true
            %
            %   PhaseUnwrapper properties:
            %
            %   InterFrameUnwrap     - Enables unwrapping of phase discontinuities
            %                          between successive frames
            %   Tolerance            - Jump size as a true phase discontinuity
            %   FrameBasedProcessing - Process input as frames or as samples
            %
            %   %EXAMPLE: Unwrap input phase data.
            %       hunwrap = dsp.PhaseUnwrapper;
            %       p = [0 2/5 4/5 -4/5 -2/5 0 2/5 4/5 -4/5 -2/5 0 2/5 4/5 -4/5, ...
            %           -2/5]*pi;
            %       y = step(hunwrap, p'); 
            %       figure,stem(p); hold 
            %       stem(y, 'r');
            %
            %   See also unwrap.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %FrameBasedProcessing Process input as frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. In sample-based
        %   processing, each element in a sample is in a separate channel and
        %   the PhaseUnwrapper will unwrap along each channel across successive
        %   samples. The default value of this property is true.
        FrameBasedProcessing;

        %InterFrameUnwrap Enables unwrapping of phase discontinuities between
        %                 successive frames
        %   Set this property to false to unwrap phase discontinuities only within
        %   the frame.  Set this property to true to also unwrap phase
        %   discontinuities between successive frames. This property is
        %   applicable when FrameBasedProcessing is set to true. The default
        %   value of this property is true.
        InterFrameUnwrap;

        %Tolerance Jump size as a true phase discontinuity
        %   Specify the jump size that the System object recognizes as a true
        %   phase discontinuity. The default value of this property is set to
        %   pi (rather than a smaller value) to avoid altering legitimate
        %   signal features. To increase the System object's sensitivity, set
        %   Tolerance to a value slightly less than pi.
        Tolerance;

    end
end
