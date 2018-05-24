classdef ArrayVectorDivider< handle
%ArrayVectorDivider Divide array by vector along specified dimension
%   HAVD = dsp.ArrayVectorDivider returns an array vector division System
%   object, HAVD, that divides the input array A by the elements of vector
%   V along the specified dimension.
%
%   HAVD = dsp.ArrayVectorDivider('PropertyName', PropertyValue, ...)
%   returns an array vector division object, HAVD, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HAVD, A, V) returns Y, the result of dividing the input array
%   A by the elements of input vector V along the specified dimension when
%   the VectorSource property is 'Input port'. The length of the input V
%   must be the same as the length of the specified dimension of A.
%
%   Y = step(HAVD, A) returns Y, the result of dividing the input array A
%   by the elements of the vector specified in the Vector property along
%   the specified dimension when the VectorSource property is 'Property'.
%   The length of the vector specified in the Vector property must be the
%   same as the length of the specified dimension of A.
%
%   ArrayVectorDivider methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create array vector division object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ArrayVectorDivider properties:
%
%   Dimension    - Dimension along which to divide input by vector elements
%   VectorSource - Source of vector
%   Vector       - Vector values
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.ArrayVectorDivider.helpFixedPoint.
%
%   % EXAMPLE: Use ArrayVectorDivider System object to divide a matrix 
%   %          with a vector
%       havd = dsp.ArrayVectorDivider;
%       a = ones(2);
%       x = [2 3]';
%       y = step(havd, a, x) 
%
%   See also dsp.ArrayVectorMultiplier, dsp.ArrayVectorAdder,
%            dsp.ArrayVectorSubtractor,
%            dsp.ArrayVectorDivider.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ArrayVectorDivider
            %ArrayVectorDivider Divide array by vector along specified dimension
            %   HAVD = dsp.ArrayVectorDivider returns an array vector division System
            %   object, HAVD, that divides the input array A by the elements of vector
            %   V along the specified dimension.
            %
            %   HAVD = dsp.ArrayVectorDivider('PropertyName', PropertyValue, ...)
            %   returns an array vector division object, HAVD, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HAVD, A, V) returns Y, the result of dividing the input array
            %   A by the elements of input vector V along the specified dimension when
            %   the VectorSource property is 'Input port'. The length of the input V
            %   must be the same as the length of the specified dimension of A.
            %
            %   Y = step(HAVD, A) returns Y, the result of dividing the input array A
            %   by the elements of the vector specified in the Vector property along
            %   the specified dimension when the VectorSource property is 'Property'.
            %   The length of the vector specified in the Vector property must be the
            %   same as the length of the specified dimension of A.
            %
            %   ArrayVectorDivider methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create array vector division object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ArrayVectorDivider properties:
            %
            %   Dimension    - Dimension along which to divide input by vector elements
            %   VectorSource - Source of vector
            %   Vector       - Vector values
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.ArrayVectorDivider.helpFixedPoint.
            %
            %   % EXAMPLE: Use ArrayVectorDivider System object to divide a matrix 
            %   %          with a vector
            %       havd = dsp.ArrayVectorDivider;
            %       a = ones(2);
            %       x = [2 3]';
            %       y = step(havd, a, x) 
            %
            %   See also dsp.ArrayVectorMultiplier, dsp.ArrayVectorAdder,
            %            dsp.ArrayVectorSubtractor,
            %            dsp.ArrayVectorDivider.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.ArrayVectorDivider System object
            %               fixed-point information
            %   dsp.ArrayVectorDivider.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.ArrayVectorDivider System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomVectorDataType Vector word and fraction lengths
        %   Specify the vector fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the VectorSource property
        %   is 'Property' and the VectorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomVectorDataType;

        %Dimension Dimension along which to divide input by vector elements
        %   Specify the dimension along which to divide the input array by the
        %   elements of a vector as an integer-valued scalar greater than 0.
        %   The default value is 1.
        Dimension;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as first
        %   input'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

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
        %   Specify the vector fixed-point mode as one of [{'Same word length
        %   as input'} | 'Custom']. This property is applicable when the
        %   VectorSource property is 'Property'.
        VectorDataType;

        %VectorSource Source of vector  
        %   Specify the source of the vector values as one of [{'Input port'} |
        %   'Property'].
        VectorSource;

    end
end
