classdef CumulativeSum< handle
%CumulativeSum Compute cumulative sum of channel, column, or row elements
%   HCUMSUM = dsp.CumulativeSum returns a System object, HCUMSUM, that
%   computes the cumulative sum of input matrix or input vector elements
%   along a specified dimension.
%
%   HCUMSUM = dsp.CumulativeSum('PropertyName', PropertyValue, ...) returns
%   a cumulative sum object, HCUMSUM, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(HCUMSUM, X) computes the cumulative sum along the specified
%   dimension for the input X.
%
%   Y = step(HCUMSUM, X, R) computes the cumulative sum of the input
%   elements over time, and optionally resets the System object's state
%   based on the ResetCondition property value, and the value of the reset
%   signal, R. This occurs when the ResetInputPort property is true.
%
%   CumulativeSum methods:
%
%   step     - See above description for the use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create cumulative sum object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the cumulative sum to zero
%
%   CumulativeSum properties:
%
%   Dimension            - Computation dimension for cumulative sum
%   FrameBasedProcessing - Process input in frames or as samples
%   ResetInputPort       - Enables resetting the cumulative sum via an
%                          input port
%   ResetCondition       - Reset condition for cumulative sum
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.CumulativeSum.helpFixedPoint.
%
%   % EXAMPLE: Use CumulativeSum System object to compute cumulative sum of a
%   %          matrix.
%       hcumsum = dsp.CumulativeSum;
%       x = magic(2);
%       y = step(hcumsum,x);
%       y = step(hcumsum,x)
%
%   See also dsp.CumulativeProduct, 
%            dsp.CumulativeSum.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=CumulativeSum
            %CumulativeSum Compute cumulative sum of channel, column, or row elements
            %   HCUMSUM = dsp.CumulativeSum returns a System object, HCUMSUM, that
            %   computes the cumulative sum of input matrix or input vector elements
            %   along a specified dimension.
            %
            %   HCUMSUM = dsp.CumulativeSum('PropertyName', PropertyValue, ...) returns
            %   a cumulative sum object, HCUMSUM, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCUMSUM, X) computes the cumulative sum along the specified
            %   dimension for the input X.
            %
            %   Y = step(HCUMSUM, X, R) computes the cumulative sum of the input
            %   elements over time, and optionally resets the System object's state
            %   based on the ResetCondition property value, and the value of the reset
            %   signal, R. This occurs when the ResetInputPort property is true.
            %
            %   CumulativeSum methods:
            %
            %   step     - See above description for the use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create cumulative sum object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the cumulative sum to zero
            %
            %   CumulativeSum properties:
            %
            %   Dimension            - Computation dimension for cumulative sum
            %   FrameBasedProcessing - Process input in frames or as samples
            %   ResetInputPort       - Enables resetting the cumulative sum via an
            %                          input port
            %   ResetCondition       - Reset condition for cumulative sum
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.CumulativeSum.helpFixedPoint.
            %
            %   % EXAMPLE: Use CumulativeSum System object to compute cumulative sum of a
            %   %          matrix.
            %       hcumsum = dsp.CumulativeSum;
            %       x = magic(2);
            %       y = step(hcumsum,x);
            %       y = step(hcumsum,x)
            %
            %   See also dsp.CumulativeProduct, 
            %            dsp.CumulativeSum.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.CumulativeSum System object
            %               fixed-point information
            %   dsp.CumulativeSum.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.CumulativeSum System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % Hide the reset and sampling mode properties unless we're in
            % running mode
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType  Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Same
        %   as input'} | 'Custom'].
        AccumulatorDataType;

        %CustomAccumulatorDataType  Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of
        %   this property is numerictype([], 32, 30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType  Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([], 16, 15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %Dimension  Computation dimension for cumulative sum
        %   Specify the computation dimension as one of [{'Channels (running
        %   sum)'} | 'Rows' | 'Columns'].
        Dimension;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set
        %   this property to false to enable sample-based processing. This
        %   property is accessible when the Dimension property is set to
        %   'Channels (running sum)'. The default value of this property is
        %   false.
        FrameBasedProcessing;

        %OutputDataType  Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as input' | 'Custom'].
        OutputDataType;

        %OverflowAction  Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ResetCondition Reset condition for cumulative sum
        %   Specify the event on the reset input port that causes the
        %   cumulative sum to be reset as one of [{'Rising edge'} | 'Falling
        %   edge' | 'Either edge' | 'Non-zero']. This property is applicable
        %   when the Dimension property is set to 'Channels (running sum)'
        %   and the ResetInputPort property is true.
        ResetCondition;

        %ResetInputPort Enables resetting the cumulative sum via an input
        %               port
        %   Set this property to true to enable resetting the cumulative
        %   sum. When the property is set to true, a reset input must be
        %   specified to the step method to reset the cumulative sum. This
        %   property is accessible when the Dimension property is set to
        %   'Channels (running sum)'. The default value of this property is
        %   false.
        ResetInputPort;

        %RoundingMethod  Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent'
        %   | {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
