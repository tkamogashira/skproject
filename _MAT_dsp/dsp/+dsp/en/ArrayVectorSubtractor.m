classdef ArrayVectorSubtractor< handle
%ArrayVectorSubtractor Subtract vector from array along specified dimension
%   HAVS = dsp.ArrayVectorSubtractor returns an array vector subtraction
%   System object, HAVS, that subtracts the elements of vector V from input
%   array A along the specified dimension.
%
%   HAVS = dsp.ArrayVectorSubtractor('PropertyName', PropertyValue, ...)
%   returns an array vector subtraction object, HAVS, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HAVS, A, V) returns Y, the result of subtracting the elements
%   of input vector V from the input array A along the specified dimension
%   when the VectorSource property is 'Input port'. The length of the input
%   V must be the same as the length of the specified dimension of A.
%
%   Y = step(HAVS, A) returns Y, the result of subtracting the elements of
%   the vector specified in the Vector property from the input array A
%   along the specified dimension when the VectorSource property is
%   'Property'. The length of the vector specified in the Vector property
%   must be the same as the length of the specified dimension of A.
%
%   ArrayVectorSubtractor methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create array vector subtraction object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ArrayVectorSubtractor properties: 
%
%   Dimension    - Dimension along which to subtract vector elements from
%                  input
%   VectorSource - Source of vector
%   Vector       - Vector values
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.ArrayVectorSubtractor.helpFixedPoint.
%
%   % EXAMPLE: Use ArrayVectorSubtractor System object to subtract a vector
%   %          from a matrix
%       havs = dsp.ArrayVectorSubtractor;
%       a = ones(2);
%       x = [1 2]';
%       y = step(havs, a, x) 
%
%   See also dsp.ArrayVectorMultiplier,
%            dsp.ArrayVectorDivider,
%            dsp.ArrayVectorAdder,
%            dsp.ArrayVectorSubtractor.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ArrayVectorSubtractor
            %ArrayVectorSubtractor Subtract vector from array along specified dimension
            %   HAVS = dsp.ArrayVectorSubtractor returns an array vector subtraction
            %   System object, HAVS, that subtracts the elements of vector V from input
            %   array A along the specified dimension.
            %
            %   HAVS = dsp.ArrayVectorSubtractor('PropertyName', PropertyValue, ...)
            %   returns an array vector subtraction object, HAVS, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HAVS, A, V) returns Y, the result of subtracting the elements
            %   of input vector V from the input array A along the specified dimension
            %   when the VectorSource property is 'Input port'. The length of the input
            %   V must be the same as the length of the specified dimension of A.
            %
            %   Y = step(HAVS, A) returns Y, the result of subtracting the elements of
            %   the vector specified in the Vector property from the input array A
            %   along the specified dimension when the VectorSource property is
            %   'Property'. The length of the vector specified in the Vector property
            %   must be the same as the length of the specified dimension of A.
            %
            %   ArrayVectorSubtractor methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create array vector subtraction object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ArrayVectorSubtractor properties: 
            %
            %   Dimension    - Dimension along which to subtract vector elements from
            %                  input
            %   VectorSource - Source of vector
            %   Vector       - Vector values
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.ArrayVectorSubtractor.helpFixedPoint.
            %
            %   % EXAMPLE: Use ArrayVectorSubtractor System object to subtract a vector
            %   %          from a matrix
            %       havs = dsp.ArrayVectorSubtractor;
            %       a = ones(2);
            %       x = [1 2]';
            %       y = step(havs, a, x) 
            %
            %   See also dsp.ArrayVectorMultiplier,
            %            dsp.ArrayVectorDivider,
            %            dsp.ArrayVectorAdder,
            %            dsp.ArrayVectorSubtractor.helpFixedPoint.
        end

        function accumulatorType(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System outputs
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            %getPropertyGroupsImpl   Return property groups for object display
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.ArrayVectorSubtractor System object fixed-point
            %               information
            %   dsp.ArrayVectorSubtractor.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.ArrayVectorSubtractor System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Restore the private data only if we were locked
        end

        function outputType(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Call the base class method
        end

        function setupImpl(in) %#ok<MANU>
            % Vector type can be 'Same as first input'
        end

        function stepImpl(in) %#ok<MANU>
        end

        function vectorType(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as first input' | 'Custom']. This
        %   property is applicable when the FullPrecisionOverride property is
        %   false.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomVectorDataType Vector word and fraction lengths
        %   Specify the vector fixed-point type as a numerictype
        %   object. This property is applicable when the VectorSource property
        %   is 'Property' and the VectorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomVectorDataType;

        %Dimension Dimension along which to subtract vector elements from input
        %   Specify the dimension along which to subtract the elements of the
        %   vector from the input array as an integer-valued scalar greater
        %   than 0. The default value is 1.
        Dimension;

        %FullPrecisionOverride Full precision override for fixed-point arithmetic
        %   Specify whether to use full precision rules. If you set
        %   FullPrecisionOverride to true the object computes all
        %   internal arithmetic and output data types using full
        %   precision rules. These rules guarantee that no quantization
        %   occurs within the object. Bits are added as needed to ensure
        %   that no round-off or overflow occurs. If you set
        %   FullPrecisionOverride to false, fixed-point data types
        %   are controlled through individual property settings.
        FullPrecisionOverride;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as first input' | 'Custom']. This
        %   property is applicable when the FullPrecisionOverride property is
        %   false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        OverflowAction;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        RoundingMethod;

        %Vector Vector values 
        %   Specify the vector values. This property is applicable when the
        %   VectorSource property is 'Property'. The default value is
        %   [0.5 0.25]. This property is tunable.
        Vector;

        %VectorDataType Vector word- and fraction-length designations
        %   Specify the vector fixed-point data type as one of [{'Same word
        %   length as input'} | 'Custom']. This property is applicable when the
        %   VectorSource property is 'Property'.
        VectorDataType;

        %VectorSource Source of vector  
        %   Specify the source of the vector values as one of [{'Input port'} |
        %   'Property'].
        VectorSource;

    end
end
