classdef PeakToRMS< handle
%PeakToRMS Compute peak-to-root-mean-square of the vector elements
%   H = dsp.PeakToRMS returns a System object, H, that
%   computes the ratio of the maximum magnitude (peak) to the
%   root-mean-square (RMS) value in an input or a sequence of inputs.
%
%   H = dsp.PeakToRMS('PropertyName', PropertyValue, ...) returns a
%   PeakToRMS System object, H, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(H, X) computes the peak-to-RMS ratio, Y, of floating point
%   input vector X. When the RunningPeakToRMS property is true, Y
%   corresponds to the peak-to-RMS ratio of the input elements over
%   successive calls to the step method.
%
%   Y = step(H, X, R) computes the peak-to-RMS ratio of the input
%   elements over successive calls to the step method. The object
%   optionally resets its state based on the reset input signal, R, and the
%   ResetCondition property. This is possible when you set both the
%   RunningPeakToRMS and the ResetInputPort properties to true.
%
%   PeakToRMS methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create PeakToRMS object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running peak-to-RMS ratio
%
%   PeakToRMS properties:
%
%   RunningPeakToRMS     - Calculation over successive calls to step method
%   ResetInputPort       - Enables resetting in running peak-to-RMS mode
%   ResetCondition       - Reset condition for running peak-to-RMS mode
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%   FrameBasedProcessing - Process input in frames or as samples
%   DecibelScaledOutput  - Report output in decibels (dB)
%
%   % EXAMPLE #1: Determine the peak-to-RMS ratio of a vector input
%      in1 = (1:10)';
%      h1 = dsp.PeakToRMS;
%      y1 = step(h1, in1)
%
%   % EXAMPLE #2: Determine the peak-to-RMS ratio of a matrix input
%      in2 = magic(4);
%      h2 = dsp.PeakToRMS;
%      h2.Dimension = 'All';
%      y2 = step(h2, in2)
%
%   See also dsp.Maximum, dsp.RMS, dsp.StandardDeviation, dsp.Variance

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=PeakToRMS
            %PeakToRMS Compute peak-to-root-mean-square of the vector elements
            %   H = dsp.PeakToRMS returns a System object, H, that
            %   computes the ratio of the maximum magnitude (peak) to the
            %   root-mean-square (RMS) value in an input or a sequence of inputs.
            %
            %   H = dsp.PeakToRMS('PropertyName', PropertyValue, ...) returns a
            %   PeakToRMS System object, H, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(H, X) computes the peak-to-RMS ratio, Y, of floating point
            %   input vector X. When the RunningPeakToRMS property is true, Y
            %   corresponds to the peak-to-RMS ratio of the input elements over
            %   successive calls to the step method.
            %
            %   Y = step(H, X, R) computes the peak-to-RMS ratio of the input
            %   elements over successive calls to the step method. The object
            %   optionally resets its state based on the reset input signal, R, and the
            %   ResetCondition property. This is possible when you set both the
            %   RunningPeakToRMS and the ResetInputPort properties to true.
            %
            %   PeakToRMS methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create PeakToRMS object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running peak-to-RMS ratio
            %
            %   PeakToRMS properties:
            %
            %   RunningPeakToRMS     - Calculation over successive calls to step method
            %   ResetInputPort       - Enables resetting in running peak-to-RMS mode
            %   ResetCondition       - Reset condition for running peak-to-RMS mode
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %   FrameBasedProcessing - Process input in frames or as samples
            %   DecibelScaledOutput  - Report output in decibels (dB)
            %
            %   % EXAMPLE #1: Determine the peak-to-RMS ratio of a vector input
            %      in1 = (1:10)';
            %      h1 = dsp.PeakToRMS;
            %      y1 = step(h1, in1)
            %
            %   % EXAMPLE #2: Determine the peak-to-RMS ratio of a matrix input
            %      in2 = magic(4);
            %      h2 = dsp.PeakToRMS;
            %      h2.Dimension = 'All';
            %      y2 = step(h2, in2)
            %
            %   See also dsp.Maximum, dsp.RMS, dsp.StandardDeviation, dsp.Variance
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
        %   Specify the dimension as a positive integer, along which the
        %   peak-to-RMS ratio is computed. The value of this property cannot
        %   exceed the number of dimensions in the input signal. This property
        %   is applicable when Dimension property is 'Custom'. The default
        %   value of this property is 1.
        CustomDimension;

        %DecibelScaledOutput report output in decibels (dB)
        %   Set this property to true to enable output in dB. Set this
        %   property to false to report output as a ratio. The default value
        %   of this property is false.
        DecibelScaledOutput;

        %Dimension Dimension to operate along    
        %   Specify the dimension along which to calculate the peak-to-RMS
        %   ratio as one of 'All' | 'Row' | 'Column' | 'Custom', where the
        %   default is 'Column'. This property is applicable when the
        %   RunningPeakToRMS property is false.
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable frame-based processing. Set
        %   this property to false to enable sample-based processing. This
        %   property is applicable when the RunningPeakToRMS property is true.
        %   The default value of this property is true.
        FrameBasedProcessing;

        %ResetCondition Reset condition for running peak-to-RMS mode
        %   Specify the event to reset the running peak-to-RMS as one of
        %   'Rising edge' | 'Falling edge' | 'Either edge' | 'Non-zero', where
        %   the default is 'Non-zero'. This property is applicable when the
        %   ResetInputPort property is true. 
        ResetCondition;

        %ResetInputPort Enables resetting in running peak-to-RMS mode 
        %   Set this property to true to enable resetting the running RMS. When
        %   the property is set to true, a reset input must be specified to the
        %   step method to reset the running peak-to-RMS ratio. This property
        %   is applicable when the RunningPeakToRMS property is true. The
        %   default value of this property is false.
        ResetInputPort;

        %RunningPeakToRMS Calculation over successive calls to step method
        %   Set this property to true to enable the calculation of the
        %   peak-to-RMS ratio over successive calls to the step method. The
        %   default value of this property is false.
        RunningPeakToRMS;

    end
end
