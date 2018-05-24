classdef LUFactor< handle
%LUFactor Factor a square matrix into lower and upper triangular matrices
%   HLU = dsp.LUFactor returns a LU Factor System object, HLU, which
%   factors a row permutation of a square input matrix A as Ap = L*U, where
%   L is the unit-lower triangular matrix, and U is the upper triangular
%   matrix. The row-pivoted matrix Ap contains the rows of A permuted as
%   indicated by the permutation index vector P. The equivalent MATLAB code
%   is Ap = A(P, :).
%
%   HLU = dsp.LUFactor('PropertyName', PropertyValue, ...) returns an LU
%   factor System object, HLU, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   [LU, P] = step(HLU, A) decomposes the matrix A into lower and upper
%   triangular matrices. The output LU is a composite matrix with lower
%   triangle elements from L and upper triangle elements from U. The
%   permutation vector P is the second output.
%
%   [LU, P, S] = step(HLU, A) returns an additional output S indicating if
%   the input is singular when the ExceptionOutputPort property is set to
%   true.
%
%   LUFactor methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LU factor object with same property values
%   isLocked - Locked status (logical)
%
%   LUFactor properties:
%
%   ExceptionOutputPort - Set to true to return singularity of input
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.LUFactor.helpFixedPoint.
%
%   % EXAMPLE: Decompose a square matrix into the lower and upper 
%   %          components.
%       hlu = dsp.LUFactor;
%       x = rand(4)
%       [LU, P] = step(hlu, x);
%       L = tril(LU,-1)+diag(ones(size(LU,1),1));
%       U = triu(LU);
%       y = L*U
%       xp = x(P,:)   % Check back whether this is equal to the permuted x
%
%   See also dsp.LDLFactor, dsp.LUFactor.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=LUFactor
            %LUFactor Factor a square matrix into lower and upper triangular matrices
            %   HLU = dsp.LUFactor returns a LU Factor System object, HLU, which
            %   factors a row permutation of a square input matrix A as Ap = L*U, where
            %   L is the unit-lower triangular matrix, and U is the upper triangular
            %   matrix. The row-pivoted matrix Ap contains the rows of A permuted as
            %   indicated by the permutation index vector P. The equivalent MATLAB code
            %   is Ap = A(P, :).
            %
            %   HLU = dsp.LUFactor('PropertyName', PropertyValue, ...) returns an LU
            %   factor System object, HLU, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   [LU, P] = step(HLU, A) decomposes the matrix A into lower and upper
            %   triangular matrices. The output LU is a composite matrix with lower
            %   triangle elements from L and upper triangle elements from U. The
            %   permutation vector P is the second output.
            %
            %   [LU, P, S] = step(HLU, A) returns an additional output S indicating if
            %   the input is singular when the ExceptionOutputPort property is set to
            %   true.
            %
            %   LUFactor methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LU factor object with same property values
            %   isLocked - Locked status (logical)
            %
            %   LUFactor properties:
            %
            %   ExceptionOutputPort - Set to true to return singularity of input
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.LUFactor.helpFixedPoint.
            %
            %   % EXAMPLE: Decompose a square matrix into the lower and upper 
            %   %          components.
            %       hlu = dsp.LUFactor;
            %       x = rand(4)
            %       [LU, P] = step(hlu, x);
            %       L = tril(LU,-1)+diag(ones(size(LU,1),1));
            %       U = triu(LU);
            %       y = L*U
            %       xp = x(P,:)   % Check back whether this is equal to the permuted x
            %
            %   See also dsp.LDLFactor, dsp.LUFactor.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.LUFactor System object 
            %               fixed-point information
            %   dsp.LUFactor.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.LUFactor System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % First output is always connected
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

        %ExceptionOutputPort Set to true to output the singularity of input
        %   Set this property to true to output the singularity of the input as
        %   logical data type values of true or false. An output of true
        %   indicates that the current input is singular, and an output of
        %   false indicates the current input is nonsingular.
        ExceptionOutputPort;

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
