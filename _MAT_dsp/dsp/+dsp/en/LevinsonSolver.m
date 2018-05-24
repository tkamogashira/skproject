classdef LevinsonSolver< handle
%LevinsonSolver Solve linear system of equations using Levinson-Durbin
%recursion
%   HLEVINSON = dsp.LevinsonSolver returns a System object, HLEVINSON, that
%   solves a Hermitian Toeplitz system of equations using the
%   Levinson-Durbin recursion.
%
%   HLEVINSON = dsp.LevinsonSolver('PropertyName', PropertyValue, ...)
%   returns a Levinson-Durbin object, HLEVINSON, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   K = step(HLEVINSON, X) returns reflection coefficients K corresponding
%   to the columns of input X. X is typically a column or matrix of
%   autocorrelation coefficients with lag 0 as the first element.
%
%   A = step(HLEVINSON, X) returns polynomial coefficients A when the
%   AOutputPort property is true and KOutputPort property is false.
%
%   [A, K] = step(HLEVINSON, X) returns polynomial coefficients A and
%   reflection coefficients K when both the AOutputPort and KOutputPort
%   properties are true.
%
%   [..., P] = step(HLEVINSON, X) also returns the error power P when the
%   PredictionErrorOutputPort property is true.
%
%   LevinsonSolver methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Levinson-Durbin object with same property values
%   isLocked - Locked status (logical)
%
%   LevinsonSolver properties:
%
%   AOutputPort               - Enables polynomial coefficients output
%   KOutputPort               - Enables reflection coefficients output
%   PredictionErrorOutputPort - Enables prediction error output
%   ZerothLagZeroAction       - Action when value of lag zero is zero
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.LevinsonSolver.helpFixedPoint.
%
%   % EXAMPLE:
%       hlevinson = dsp.LevinsonSolver;
%       hlevinson.AOutputPort = true;
%       hlevinson.KOutputPort = false;
%       x = (1:100)';
%       hac = dsp.Autocorrelator(...
%               'MaximumLagSource', 'Property', ...
%               'MaximumLag', 10);
%       a = step(hac, x);
%       c = step(hlevinson, a);      % Compute polynomial coefficients
%
%   See also dsp.Autocorrelator, 
%            dsp.LevinsonSolver.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=LevinsonSolver
            %LevinsonSolver Solve linear system of equations using Levinson-Durbin
            %recursion
            %   HLEVINSON = dsp.LevinsonSolver returns a System object, HLEVINSON, that
            %   solves a Hermitian Toeplitz system of equations using the
            %   Levinson-Durbin recursion.
            %
            %   HLEVINSON = dsp.LevinsonSolver('PropertyName', PropertyValue, ...)
            %   returns a Levinson-Durbin object, HLEVINSON, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   K = step(HLEVINSON, X) returns reflection coefficients K corresponding
            %   to the columns of input X. X is typically a column or matrix of
            %   autocorrelation coefficients with lag 0 as the first element.
            %
            %   A = step(HLEVINSON, X) returns polynomial coefficients A when the
            %   AOutputPort property is true and KOutputPort property is false.
            %
            %   [A, K] = step(HLEVINSON, X) returns polynomial coefficients A and
            %   reflection coefficients K when both the AOutputPort and KOutputPort
            %   properties are true.
            %
            %   [..., P] = step(HLEVINSON, X) also returns the error power P when the
            %   PredictionErrorOutputPort property is true.
            %
            %   LevinsonSolver methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Levinson-Durbin object with same property values
            %   isLocked - Locked status (logical)
            %
            %   LevinsonSolver properties:
            %
            %   AOutputPort               - Enables polynomial coefficients output
            %   KOutputPort               - Enables reflection coefficients output
            %   PredictionErrorOutputPort - Enables prediction error output
            %   ZerothLagZeroAction       - Action when value of lag zero is zero
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.LevinsonSolver.helpFixedPoint.
            %
            %   % EXAMPLE:
            %       hlevinson = dsp.LevinsonSolver;
            %       hlevinson.AOutputPort = true;
            %       hlevinson.KOutputPort = false;
            %       x = (1:100)';
            %       hac = dsp.Autocorrelator(...
            %               'MaximumLagSource', 'Property', ...
            %               'MaximumLag', 10);
            %       a = step(hac, x);
            %       c = step(hlevinson, a);      % Compute polynomial coefficients
            %
            %   See also dsp.Autocorrelator, 
            %            dsp.LevinsonSolver.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.LevinsonSolver System object 
            %               fixed-point information
            %   dsp.LevinsonSolver.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.LevinsonSolver System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %ACoefficientDataType A coefficient word- and fraction-length
        %                     designations
        %   This is a constant property with value 'Custom'.
        ACoefficientDataType;

        %AOutputPort Enables polynomial coefficients output
        %   Set this property to true to output the polynomial coefficients A.
        %   Both AOutputPort and KOutputPort properties cannot be false at the
        %   same time. For scalar inputs AOutputPort property must be true. The
        %   default value of this property is false.
        AOutputPort;

        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the Accumulator fixed-point data type as one of ['Same as
        %   input' | 'Same as product' | {'Custom'}].
        AccumulatorDataType;

        %CustomACoefficientDataType A coefficient word and fraction lengths
        %   Specify the A coefficient fixed-point type as an auto-signed scaled
        %   numerictype object. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomACoefficientDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomKCoefficientDataType K coefficient word and fraction lengths
        %   Specify the K coefficient fixed-point type as an auto-signed scaled
        %   numerictype object. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomKCoefficientDataType;

        %CustomPredictionErrorDataType Prediction error power word and fraction
        %                              lengths
        %   Specify the prediction error power fixed-point type as an
        %   auto-signed scaled numerictype object. This property is applicable
        %   when the PredictionErrorDataType property is 'Custom'. The default
        %   value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomPredictionErrorDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %KCoefficientDataType K coefficient word- and fraction-length
        %                     designations
        %   This is a constant property with value 'Custom'.
        KCoefficientDataType;

        %KOutputPort Enables reflection coefficients output
        %   Set this property to true to output the reflection coefficients K.
        %   Both AOutputPort and KOutputPort properties cannot be false at the
        %   same time. For scalar inputs KOutputPort property must be false.
        %   The default value of this property is true.
        KOutputPort;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %PredictionErrorDataType Prediction error power word- and 
        %                        fraction-length designations
        %   Specify the prediction error power fixed-point data type as one of
        %   [{'Same as input'} | 'Custom'].
        PredictionErrorDataType;

        %PredictionErrorOutputPort Enables prediction error output
        %   Set this property to true to output the prediction error. The
        %   default value of this property is false.
        PredictionErrorOutputPort;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as
        %   input' | {'Custom'}].
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %ZerothLagZeroAction Action when value of lag zero is zero
        %   Specify the output for inputs with first coefficient as zero as one
        %   of ['Ignore' | {'Use zeros'}].
        ZerothLagZeroAction;

    end
end
