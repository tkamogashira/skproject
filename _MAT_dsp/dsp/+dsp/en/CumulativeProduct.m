classdef CumulativeProduct< handle
%CumulativeProduct Compute cumulative product of channel, column, or row
%elements
%   HCUMPROD = dsp.CumulativeProduct returns a System object, HCUMPROD,
%   that computes the cumulative product of input matrix or input vector
%   elements along a specified dimension.
%
%   HCUMPROD = dsp.CumulativeProduct('PropertyName', PropertyValue, ...)
%   returns a cumulative product object, HCUMPROD, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HCUMPROD, X) computes the cumulative product along the
%   specified dimension for the input X.
%
%   Y = step(HCUMPROD, X, R) computes the cumulative product of the input
%   elements over time, and optionally resets the System object's state
%   based on the ResetCondition property value, and the value of the reset
%   signal, R. This occurs when the ResetInputPort property is true.
%
%   CumulativeProduct methods:
%
%   step     - See above description for the use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create cumulative product object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the cumulative product to one
%
%   CumulativeProduct properties:
%
%   Dimension            - Computation dimension for cumulative product
%   FrameBasedProcessing - Process input in frames or as samples
%   ResetInputPort       - Enables resetting the cumulative product via an
%                          input port
%   ResetCondition       - Reset condition for cumulative product
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.CumulativeProduct.helpFixedPoint.
%
%   % EXAMPLE: Use CumulativeProduct System object to compute cumulative
%   %          product of a matrix.
%       hcumprod = dsp.CumulativeProduct;
%       x = magic(2);
%       y = step(hcumprod,x);
%       y = step(hcumprod,x)
%
%   See also dsp.CumulativeSum,
%            dsp.CumulativeProduct.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=CumulativeProduct
            %CumulativeProduct Compute cumulative product of channel, column, or row
            %elements
            %   HCUMPROD = dsp.CumulativeProduct returns a System object, HCUMPROD,
            %   that computes the cumulative product of input matrix or input vector
            %   elements along a specified dimension.
            %
            %   HCUMPROD = dsp.CumulativeProduct('PropertyName', PropertyValue, ...)
            %   returns a cumulative product object, HCUMPROD, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCUMPROD, X) computes the cumulative product along the
            %   specified dimension for the input X.
            %
            %   Y = step(HCUMPROD, X, R) computes the cumulative product of the input
            %   elements over time, and optionally resets the System object's state
            %   based on the ResetCondition property value, and the value of the reset
            %   signal, R. This occurs when the ResetInputPort property is true.
            %
            %   CumulativeProduct methods:
            %
            %   step     - See above description for the use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create cumulative product object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the cumulative product to one
            %
            %   CumulativeProduct properties:
            %
            %   Dimension            - Computation dimension for cumulative product
            %   FrameBasedProcessing - Process input in frames or as samples
            %   ResetInputPort       - Enables resetting the cumulative product via an
            %                          input port
            %   ResetCondition       - Reset condition for cumulative product
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.CumulativeProduct.helpFixedPoint.
            %
            %   % EXAMPLE: Use CumulativeProduct System object to compute cumulative
            %   %          product of a matrix.
            %       hcumprod = dsp.CumulativeProduct;
            %       x = magic(2);
            %       y = step(hcumprod,x);
            %       y = step(hcumprod,x)
            %
            %   See also dsp.CumulativeSum,
            %            dsp.CumulativeProduct.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.CumulativeProduct System object
            %               fixed-point information
            %   dsp.CumulativeProduct.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.CumulativeProduct System object.
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
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same
        %   as product'| {'Same as input'} | 'Custom'].
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of
        %   this property is numerictype([], 32, 30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomIntermediateProductDataType Intermediate product word and
        %                                  fraction lengths
        %   Specify the intermediate product fixed-point type as an
        %   auto-signed, scaled numerictype object. This property is
        %   applicable when the IntermediateProductDataType property is
        %   'Custom'. The default value of this property is numerictype([],
        %   16, 15).
        %
        %   See also numerictype.
        CustomIntermediateProductDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([], 16, 15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product output word and fraction lengths
        %   Specify the product output fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([], 32, 30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %Dimension  Computation dimension for cumulative product
        %   Specify the computation dimension as one of [{'Channels (running
        %   product)'} | 'Rows' | 'Columns'].
        Dimension;

        %FrameBasedProcessing Enables frame-based processing
        %   Set this property to true to enable frame-based processing. When
        %   this property is true, the System object treats each column as
        %   an independent channel. Set this property to false to enable
        %   sample-based processing. When this property is false, the object
        %   treats each element of the input as an individual channel. This
        %   property is accessible when the Dimension property is 'Channels
        %   (running product)'.The default value of this property
        %   is false.
        FrameBasedProcessing;

        %IntermediateProductDataType Intermediate product word- and
        %                            fraction-length designations
        %   Specify the intermediate product fixed-point data type as one of
        %   [{'Same as input'} | 'Custom'].
        IntermediateProductDataType;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of ['Same as
        %   product' | {'Same as input'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product output word- and fraction-length designations
        %   Specify the product output fixed-point data type as one of
        %   [{'Same as input'} | 'Custom'].
        ProductDataType;

        %ResetCondition Reset condition for cumulative product 
        %   Specify the event on the reset input port that causes the
        %   cumulative product to be reset as one of [{'Rising edge'} |
        %   'Falling edge' | 'Either edge' | 'Non-zero']. This property is
        %   applicable when the Dimension property is set to 'Channels
        %   (running sum)' and the ResetInputPort property is true.
        ResetCondition;

        %ResetInputPort Enables resetting the cumulative product via an
        %               input port
        %   Set this property to true to enable resetting the cumulative
        %   product. When the property is set to true, a reset input must be
        %   specified to the step method to reset the cumulative product.
        %   This property is accessible when the Dimension property is set
        %   to 'Channels (running product)'.  The default value of this
        %   property is false.
        ResetInputPort;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent'
        %   | {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
