classdef ArrayVectorMultiplier< handle
%ArrayVectorMultiplier Multiply array by vector along specified dimension
%   HAVM = dsp.ArrayVectorMultiplier returns an array vector multiplication
%   System object, HAVM, that multiplies the input array A by the elements
%   of vector V along the specified dimension. In the two-dimensional case,
%   this is equivalent to multiplying a full matrix (A) by a diagonal (V),
%   and vice versa.
%
%   HAVM = dsp.ArrayVectorMultiplier('PropertyName', PropertyValue, ...)
%   returns an array vector multiplication object, HAVM, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HAVM, A, V) returns Y, the result of multiplying the input
%   array A by the elements of input vector V along the specified dimension
%   when the VectorSource property is 'Input port'. The length of the input
%   V must be the same as the length of the specified dimension of A.
%
%   Y = step(HAVM, A) returns Y, the result of multiplying the input array
%   A by the elements of vector specified in Vector property along the
%   specified dimension when the VectorSource property is set to
%   'Property'. The length of the vector specified in Vector property must
%   be the same as the length of the specified dimension of A.
%
%   ArrayVectorMultiplier methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create array vector multiplication object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ArrayVectorMultiplier properties:
%
%   Dimension    - Dimension along which to multiply input by vector
%                  elements
%   VectorSource - Source of vector
%   Vector       - Vector values
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.ArrayVectorMultiplier.helpFixedPoint.
%
%   % EXAMPLE: Use ArrayVectorMultiplier System object to multiply a matrix
%   %          with a vector
%       havm = dsp.ArrayVectorMultiplier;
%       a = ones(2);
%       x = [2 3]';
%       y = step(havm, a, x) 
%
%   See also dsp.ArrayVectorAdder, dsp.ArrayVectorDivider,
%            dsp.ArrayVectorSubtractor,
%            dsp.ArrayVectorMultiplier.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ArrayVectorMultiplier
            %ArrayVectorMultiplier Multiply array by vector along specified dimension
            %   HAVM = dsp.ArrayVectorMultiplier returns an array vector multiplication
            %   System object, HAVM, that multiplies the input array A by the elements
            %   of vector V along the specified dimension. In the two-dimensional case,
            %   this is equivalent to multiplying a full matrix (A) by a diagonal (V),
            %   and vice versa.
            %
            %   HAVM = dsp.ArrayVectorMultiplier('PropertyName', PropertyValue, ...)
            %   returns an array vector multiplication object, HAVM, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HAVM, A, V) returns Y, the result of multiplying the input
            %   array A by the elements of input vector V along the specified dimension
            %   when the VectorSource property is 'Input port'. The length of the input
            %   V must be the same as the length of the specified dimension of A.
            %
            %   Y = step(HAVM, A) returns Y, the result of multiplying the input array
            %   A by the elements of vector specified in Vector property along the
            %   specified dimension when the VectorSource property is set to
            %   'Property'. The length of the vector specified in Vector property must
            %   be the same as the length of the specified dimension of A.
            %
            %   ArrayVectorMultiplier methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create array vector multiplication object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ArrayVectorMultiplier properties:
            %
            %   Dimension    - Dimension along which to multiply input by vector
            %                  elements
            %   VectorSource - Source of vector
            %   Vector       - Vector values
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.ArrayVectorMultiplier.helpFixedPoint.
            %
            %   % EXAMPLE: Use ArrayVectorMultiplier System object to multiply a matrix
            %   %          with a vector
            %       havm = dsp.ArrayVectorMultiplier;
            %       a = ones(2);
            %       x = [2 3]';
            %       y = step(havm, a, x) 
            %
            %   See also dsp.ArrayVectorAdder, dsp.ArrayVectorDivider,
            %            dsp.ArrayVectorSubtractor,
            %            dsp.ArrayVectorMultiplier.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.ArrayVectorMultiplier System
            %               object fixed-point information 
            %   dsp.ArrayVectorMultiplier.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.ArrayVectorMultiplier System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as product' | 'Same as first input' | 'Custom'].
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomVectorDataType Vector word and fraction lengths
        %   Specify the vector fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the VectorSource property
        %   is 'Property' and the VectorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomVectorDataType;

        %Dimension Dimension along which to multiply input by vector elements
        %   Specify the dimension along which to multiply the input array by
        %   the elements of vector as an integer-valued scalar greater than 0.
        %   The default value is 2.
        Dimension;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   product'} | 'Same as first input' | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as first input' | 'Custom'].
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %Vector Vector values
        %   Specify the vector values. This property is applicable when the
        %   VectorSource property is 'Property'. The default value is [0.5
        %   0.25]. This property is tunable.
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
