classdef ZeroCrossingDetector< handle
%ZeroCrossingDetector Count number of times signal crosses zero
%   HZCD = dsp.ZeroCrossingDetector returns a zero crossing detection
%   System object, HZCD, that calculates the number of times the signal
%   crosses zero. This System object supports fixed-point data types.
%
%   HZCD = dsp.ZeroCrossingDetector('PropertyName', PropertyValue, ...)
%   returns a zero crossing detector object, HZCD, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HZCD, X) calculates the number of zero crossings Y of input X.
%
%   ZeroCrossingDetector methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create zero crossing detector object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ZeroCrossingDetector properties:
%
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE: Use ZeroCrossingDetector System object to calculate the 
%   %          number of zero crossings of a signal.
%       hzcd = dsp.ZeroCrossingDetector;
%       x = rand(20,1)-0.3;
%       y = step(hzcd,x)
%       plot((1:20)',x,'b-',[0 20], [0 0], 'r');
%       title('Zero crossings');

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=ZeroCrossingDetector
            %ZeroCrossingDetector Count number of times signal crosses zero
            %   HZCD = dsp.ZeroCrossingDetector returns a zero crossing detection
            %   System object, HZCD, that calculates the number of times the signal
            %   crosses zero. This System object supports fixed-point data types.
            %
            %   HZCD = dsp.ZeroCrossingDetector('PropertyName', PropertyValue, ...)
            %   returns a zero crossing detector object, HZCD, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HZCD, X) calculates the number of zero crossings Y of input X.
            %
            %   ZeroCrossingDetector methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create zero crossing detector object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ZeroCrossingDetector properties:
            %
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE: Use ZeroCrossingDetector System object to calculate the 
            %   %          number of zero crossings of a signal.
            %       hzcd = dsp.ZeroCrossingDetector;
            %       x = rand(20,1)-0.3;
            %       y = step(hzcd,x)
            %       plot((1:20)',x,'b-',[0 20], [0 0], 'r');
            %       title('Zero crossings');
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

    end
end
