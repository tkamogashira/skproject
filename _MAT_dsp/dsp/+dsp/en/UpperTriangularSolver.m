classdef UpperTriangularSolver< handle
%UpperTriangularSolver Solve UX = B for X when U is upper triangular matrix
%   HUPTRIANG = dsp.UpperTriangularSolver returns a upper triangular solver
%   System object, HUPTRIANG, used to solve UX = B where U is an upper (or
%   unit-upper) triangular matrix. U must be square. B must have the same
%   number of rows as U.
%
%   HUPTRIANG = dsp.UpperTriangularSolver('PropertyName', PropertyValue,
%   ...) returns a upper triangular solver System object, HUPTRIANG, with
%   each specified property set to the specified value.
%
%   Step method syntax:
%
%   X = step(HUPTRIANG, U, B) computes the solution of the equation UX = B.
%
%   UpperTriangularSolver methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create upper triangular solver object with same property
%              values
%   isLocked - Locked status (logical)
%
%   UpperTriangularSolver properties:
%
%   OverwriteDiagonal    - Replace diagonal elements of input with ones
%   RealDiagonalElements - Indicate that diagonal of complex input U is
%                          real
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.UpperTriangularSolver.helpFixedPoint.
%
%   % EXAMPLE: Solve a set of linear equations by using an
%   %          UpperTriangularSolver component.
%        huptriang = dsp.UpperTriangularSolver;
%        u = triu(rand(4, 4));
%        b = rand(4, 1);
%        % Check result is the solution to the linear
%        % equations.
%        x1 = inv(u)*b
%        x = step(huptriang, u, b)
%
%   See also dsp.LowerTriangularSolver, 
%            dsp.UpperTriangularSolver.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=UpperTriangularSolver
            %UpperTriangularSolver Solve UX = B for X when U is upper triangular matrix
            %   HUPTRIANG = dsp.UpperTriangularSolver returns a upper triangular solver
            %   System object, HUPTRIANG, used to solve UX = B where U is an upper (or
            %   unit-upper) triangular matrix. U must be square. B must have the same
            %   number of rows as U.
            %
            %   HUPTRIANG = dsp.UpperTriangularSolver('PropertyName', PropertyValue,
            %   ...) returns a upper triangular solver System object, HUPTRIANG, with
            %   each specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   X = step(HUPTRIANG, U, B) computes the solution of the equation UX = B.
            %
            %   UpperTriangularSolver methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create upper triangular solver object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   UpperTriangularSolver properties:
            %
            %   OverwriteDiagonal    - Replace diagonal elements of input with ones
            %   RealDiagonalElements - Indicate that diagonal of complex input U is
            %                          real
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.UpperTriangularSolver.helpFixedPoint.
            %
            %   % EXAMPLE: Solve a set of linear equations by using an
            %   %          UpperTriangularSolver component.
            %        huptriang = dsp.UpperTriangularSolver;
            %        u = triu(rand(4, 4));
            %        b = rand(4, 1);
            %        % Check result is the solution to the linear
            %        % equations.
            %        x1 = inv(u)*b
            %        x = step(huptriang, u, b)
            %
            %   See also dsp.LowerTriangularSolver, 
            %            dsp.UpperTriangularSolver.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.UpperTriangularSolver System
            %               object fixed-point information
            %   dsp.UpperTriangularSolver.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.UpperTriangularSolver System object.
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
        %   precision'} | 'Same as first input' | 'Same as product' | 'Custom'].
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

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as first
        %   input'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %OverwriteDiagonal Replace diagonal elements of input with ones
        %   Set to true to replace the elements on the diagonal of the input,
        %   U, with ones. This property can be set to true or false. The
        %   default value of this property is false.
        OverwriteDiagonal;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as first input' | 'Custom'].
        ProductDataType;

        %RealDiagonalElements Indicate that diagonal of complex input is real
        %   Set to true to optimize computation speed when the diagonal
        %   elements of complex input, U, are real. This property is applicable
        %   when the OverwriteDiagonal property is false. This property can be
        %   set to true or false. The default value of this property is false.
        RealDiagonalElements;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
