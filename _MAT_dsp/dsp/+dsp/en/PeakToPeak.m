classdef PeakToPeak< handle
%PeakToPeak Compute peak-to-peak values in an input or sequence of inputs
%   H = dsp.PeakToPeak returns a System object, H, that computes the 
%   difference between the maximum and minimum value in an input or a
%   sequence of inputs.
%
%   H = dsp.PeakToPeak('PropertyName', PropertyValue, ...) returns a
%   PeakToPeak System object, H, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(H, X) computes the peak-to-peak value, Y, of real floating
%   point input vector X. When the RunningPeakToPeak property is true, Y
%   corresponds to the peak-to-peak value of the input elements over
%   successive calls to the step method.
%
%   Y = step(H, X, R) computes the peak-to-peak value of the input
%   elements over successive calls to the step method. The object
%   optionally resets its state based on the reset input signal, R, and the
%   ResetCondition property. This is possible when you set both the
%   RunningPeakToPeak and the ResetInputPort properties to true.
%
%   PeakToPeak methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create PeakToPeak object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running peak-to-peak ratio
%
%   PeakToPeak properties:
%
%   RunningPeakToPeak    - Calculation over successive calls to step method
%   ResetInputPort       - Enables resetting in running peak-to-peak mode
%   ResetCondition       - Reset condition for running peak-to-peak mode
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE #1: Determine the peak-to-peak value of a vector input
%      in1 = (1:10)';
%      h1 = dsp.PeakToPeak;
%      y1 = step(h1, in1)
%
%   % EXAMPLE #2: Determine the peak-to-peak value of a matrix input
%      in2 = magic(4);
%      h2 = dsp.PeakToPeak;
%      h2.Dimension = 'All';
%      y2 = step(h2, in2)
%
%   See also dsp.Maximum, dsp.Minimum, dsp.PeakToRMS

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=PeakToPeak
            %PeakToPeak Compute peak-to-peak values in an input or sequence of inputs
            %   H = dsp.PeakToPeak returns a System object, H, that computes the 
            %   difference between the maximum and minimum value in an input or a
            %   sequence of inputs.
            %
            %   H = dsp.PeakToPeak('PropertyName', PropertyValue, ...) returns a
            %   PeakToPeak System object, H, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(H, X) computes the peak-to-peak value, Y, of real floating
            %   point input vector X. When the RunningPeakToPeak property is true, Y
            %   corresponds to the peak-to-peak value of the input elements over
            %   successive calls to the step method.
            %
            %   Y = step(H, X, R) computes the peak-to-peak value of the input
            %   elements over successive calls to the step method. The object
            %   optionally resets its state based on the reset input signal, R, and the
            %   ResetCondition property. This is possible when you set both the
            %   RunningPeakToPeak and the ResetInputPort properties to true.
            %
            %   PeakToPeak methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create PeakToPeak object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running peak-to-peak ratio
            %
            %   PeakToPeak properties:
            %
            %   RunningPeakToPeak    - Calculation over successive calls to step method
            %   ResetInputPort       - Enables resetting in running peak-to-peak mode
            %   ResetCondition       - Reset condition for running peak-to-peak mode
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE #1: Determine the peak-to-peak value of a vector input
            %      in1 = (1:10)';
            %      h1 = dsp.PeakToPeak;
            %      y1 = step(h1, in1)
            %
            %   % EXAMPLE #2: Determine the peak-to-peak value of a matrix input
            %      in2 = magic(4);
            %      h2 = dsp.PeakToPeak;
            %      h2.Dimension = 'All';
            %      y2 = step(h2, in2)
            %
            %   See also dsp.Maximum, dsp.Minimum, dsp.PeakToRMS
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomDimension Numerical dimension to operate along
        %   Specify the dimension of the input signal along which the
        %   peak-to-peak ratio is computed as a positive integer. The value of
        %   this property cannot exceed the number of dimensions in the input
        %   signal. This property is applicable when Dimension property is
        %   'Custom'. The default value of this property is 1.
        CustomDimension;

        %Dimension Dimension to operate along    
        %   Specify the dimension along which to calculate the peak-to-peak
        %   ratio as one of 'All' | 'Row' | 'Column' | 'Custom', where the
        %   default is 'Column'. This property is applicable when the
        %   RunningPeakToPeak property is false. 
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable frame-based processing. Set this
        %   property to false to enable sample-based processing. This property
        %   is applicable when the RunningPeakToPeak property is true. The default
        %   value of this property is true.
        FrameBasedProcessing;

        %ResetCondition Reset condition for running peak-to-peak mode
        %   Specify the event to reset the running peak-to-peak as one of
        %   'Rising edge' | 'Falling edge' | 'Either edge' | 'Non-zero', where
        %   the default is 'Non-zero'. This property is applicable when the
        %   ResetInputPort property is true. 
        ResetCondition;

        %ResetInputPort Enables resetting in running peak-to-peak mode 
        %   Set this property to true to enable resetting the running
        %   peak-to-peak. When the property is set to true, a reset input must
        %   be specified to the step method to reset the running peak-to-peak
        %   value. This property is applicable when the RunningPeakToPeak
        %   property is true. The default value of this property is false.
        ResetInputPort;

        %RunningPeakToPeak Calculation over successive calls to step method
        %   Set this property to true to enable the calculation of the
        %   peak-to-peak ratio over successive calls to the step method. The
        %   default value of this property is false.
        RunningPeakToPeak;

    end
end
