classdef RMS< handle
%RMS    Root-mean-square of the vector elements
%   HRMS = dsp.RMS returns a System object, HRMS, that computes the
%   root-mean-square (RMS) in an input or a sequence of inputs.
%
%   HRMS = dsp.RMS('PropertyName', PropertyValue, ...) returns an RMS
%   System object, HRMS, with each specified property set to the specified
%   value.
%
%   Step method syntax:
%
%   Y = step(HRMS, X) computes the root-mean-square output, Y, of input
%   vector X. When the RunningRMS property is true, Y corresponds to the
%   RMS of the input elements over successive calls to the step method.
%
%   Y = step(HRMS, X, R) computes RMS of the input elements over successive
%   calls to the step method. The object optionally resets its state based
%   on the reset input signal, R, and the ResetCondition property. This is
%   possible when you set both the RunningRMS and the ResetInputPort
%   properties to true.
%
%   RMS methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create RMS object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running RMS
%
%   RMS properties:
%
%   RunningRMS           - Calculation over successive calls to step method
%   ResetInputPort       - Enables resetting in running RMS mode
%   ResetCondition       - Reset condition for running RMS mode
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE #1: Determine the RMS of a vector input
%      in1 = [1:10]';
%      hrms = dsp.RMS;
%      y_rms1 = step(hrms, in1)
%
%   % EXAMPLE #2: Determine the RMS of a matrix input
%      in2 = magic(4);
%      hrms2d = dsp.RMS;
%      hrms2d.Dimension = 'All';
%      y_rms2 = step(hrms2d, in2)
%
%   See also dsp.Mean, dsp.StandardDeviation, dsp.Variance. 

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=RMS
            %RMS    Root-mean-square of the vector elements
            %   HRMS = dsp.RMS returns a System object, HRMS, that computes the
            %   root-mean-square (RMS) in an input or a sequence of inputs.
            %
            %   HRMS = dsp.RMS('PropertyName', PropertyValue, ...) returns an RMS
            %   System object, HRMS, with each specified property set to the specified
            %   value.
            %
            %   Step method syntax:
            %
            %   Y = step(HRMS, X) computes the root-mean-square output, Y, of input
            %   vector X. When the RunningRMS property is true, Y corresponds to the
            %   RMS of the input elements over successive calls to the step method.
            %
            %   Y = step(HRMS, X, R) computes RMS of the input elements over successive
            %   calls to the step method. The object optionally resets its state based
            %   on the reset input signal, R, and the ResetCondition property. This is
            %   possible when you set both the RunningRMS and the ResetInputPort
            %   properties to true.
            %
            %   RMS methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create RMS object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running RMS
            %
            %   RMS properties:
            %
            %   RunningRMS           - Calculation over successive calls to step method
            %   ResetInputPort       - Enables resetting in running RMS mode
            %   ResetCondition       - Reset condition for running RMS mode
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE #1: Determine the RMS of a vector input
            %      in1 = [1:10]';
            %      hrms = dsp.RMS;
            %      y_rms1 = step(hrms, in1)
            %
            %   % EXAMPLE #2: Determine the RMS of a matrix input
            %      in2 = magic(4);
            %      hrms2d = dsp.RMS;
            %      hrms2d.Dimension = 'All';
            %      y_rms2 = step(hrms2d, in2)
            %
            %   See also dsp.Mean, dsp.StandardDeviation, dsp.Variance. 
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomDimension Numerical dimension to operate along
        %   Specify the dimension (one-based scalar integer value) of the input
        %   signal, along which the RMS is computed. The value of this property
        %   cannot exceed the number of dimensions in the input signal. This
        %   property is applicable when Dimension property is 'Custom'. The
        %   default value of this property is 1.
        CustomDimension;

        %Dimension Dimension to operate along    
        %   Specify the dimension along which to calculate the RMS as one of
        %   ['All' | 'Row' | {'Column'} | 'Custom']. This property is
        %   applicable when the RunningRMS property is false.
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. This property
        %   is applicable when RunningRMS property is true. The default value of
        %   this property is true.
        FrameBasedProcessing;

        %ResetCondition Reset condition for running RMS mode
        %   Specify the event to reset the running RMS as one of ['Rising edge'
        %   | 'Falling edge' | 'Either edge' | {'Non-zero'}]. This property is
        %   applicable when the ResetInputPort property is true.
        ResetCondition;

        %ResetInputPort Enables resetting in running RMS mode 
        %   Set this property to true to enable resetting the running RMS. When
        %   the property is set to true, a reset input must be specified to the
        %   step method to reset the running RMS. This property is applicable
        %   when the RunningRMS property is true. The default value of this
        %   property is false.
        ResetInputPort;

        %RunningRMS Calculation over successive calls to step method
        %   Set this property to true to enable the calculation of RMS over
        %   successive calls to the step method. The default value of this
        %   property is false.
        RunningRMS;

    end
end
