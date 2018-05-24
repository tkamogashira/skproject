classdef LDLFactor< handle
%LDLFactor Factor square Hermitian positive definite matrices into
%lower, upper, and diagonal components
%   HLDL = dsp.LDLFactor returns a System object, HLDL, that computes unit
%   lower triangular L and diagonal D such that S = LDL' for square,
%   symmetric/Hermitian, positive definite input matrix S. The System
%   object uses only the lower triangle of S.
%
%   HLDL = dsp.LDLFactor('PropertyName', PropertyValue, ...) returns an LDL
%   factor System object, HLDL, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HLDL, S) decomposes the matrix into lower, upper, and diagonal
%   components. The output Y is a composite matrix with the L as its lower
%   triangular part and D as the diagonal and L' as its upper triangular
%   part. If S is not positive definite the output Y is not a valid
%   factorization.
%
%   LDLFactor methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LDL factor object with same property values
%   isLocked - Locked status (logical)
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.LDLFactor.helpFixedPoint.
%
%   % EXAMPLE: Decompose a square Hermitian positive definite matrix using
%   %         LDL factor.
%      A = gallery('randcorr',5);
%      hldl = dsp.LDLFactor;
%      y = step(hldl, A);
%
%   See also dsp.LUFactor, dsp.LDLFactor.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=LDLFactor
            %LDLFactor Factor square Hermitian positive definite matrices into
            %lower, upper, and diagonal components
            %   HLDL = dsp.LDLFactor returns a System object, HLDL, that computes unit
            %   lower triangular L and diagonal D such that S = LDL' for square,
            %   symmetric/Hermitian, positive definite input matrix S. The System
            %   object uses only the lower triangle of S.
            %
            %   HLDL = dsp.LDLFactor('PropertyName', PropertyValue, ...) returns an LDL
            %   factor System object, HLDL, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HLDL, S) decomposes the matrix into lower, upper, and diagonal
            %   components. The output Y is a composite matrix with the L as its lower
            %   triangular part and D as the diagonal and L' as its upper triangular
            %   part. If S is not positive definite the output Y is not a valid
            %   factorization.
            %
            %   LDLFactor methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LDL factor object with same property values
            %   isLocked - Locked status (logical)
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.LDLFactor.helpFixedPoint.
            %
            %   % EXAMPLE: Decompose a square Hermitian positive definite matrix using
            %   %         LDL factor.
            %      A = gallery('randcorr',5);
            %      hldl = dsp.LDLFactor;
            %      y = step(hldl, A);
            %
            %   See also dsp.LUFactor, dsp.LDLFactor.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.LDLFactor System object
            %               fixed-point information
            %   dsp.LDLFactor.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.LDLFactor System object.
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
        %   precision'} | 'Same as input' | 'Same as product' | 'Custom'].
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomIntermediateProductDataType Intermediate product word and fraction lengths
        %   Specify the intermediate product fixed-point type as an
        %   auto-signed, scaled numerictype object. This property is applicable
        %   when the IntermediateProductDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomIntermediateProductDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %IntermediateProductDataType Intermediate product word- and fraction-length designations
        %   Specify the intermediate product fixed-point data type as one of
        %   [{'Same as input'} | 'Custom'].
        IntermediateProductDataType;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   input'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as input' | 'Custom'].
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
