classdef Normalizer< handle
%Normalizer Perform vector normalization along rows, columns, or
%specified dimension
%   HNORM = dsp.Normalizer returns a normalization System object, HNORM,
%   that normalizes the input over the specified dimension by the vector
%   2-norm, sqrt(u'u) + b, or by the squared 2-norm, u'u + b, where u is
%   the input vector and b is a bias used to protect against
%   divide-by-zero.
%
%   HNORM = dsp.Normalizer('PropertyName', PropertyValue, ...) returns a
%   normalization System object, HNORM, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(HNORM, X) returns a normalized signal Y. The input X must be
%   floating-point signals for the 2-norm mode, and can be both fixed-point
%   and floating-point signals for the squared 2-norm mode.
%
%   Normalizer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create normalization object with same property values
%   isLocked - Locked status (logical)
%
%   Normalizer properties:
%
%   Method               - Type of normalization to perform
%   Bias                 - Real value to be added in denominator to avoid
%                          division by zero
%   Dimension            - Dimension to operate along
%   CustomDimension      - Numerical dimension to operate along
%
%   This System object supports fixed-point operations when the property
%   Method is set to 'Squared 2-norm'. For more information, type
%   dsp.Normalizer.helpFixedPoint.
%
%   % EXAMPLE: Use Normalizer System object to normalize a matrix.
%       hnorm = dsp.Normalizer;
%       x = magic(3);
%       y = step(hnorm, x)
%
%   See also dsp.ArrayVectorMultiplier, 
%            dsp.Normalizer.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Normalizer
            %Normalizer Perform vector normalization along rows, columns, or
            %specified dimension
            %   HNORM = dsp.Normalizer returns a normalization System object, HNORM,
            %   that normalizes the input over the specified dimension by the vector
            %   2-norm, sqrt(u'u) + b, or by the squared 2-norm, u'u + b, where u is
            %   the input vector and b is a bias used to protect against
            %   divide-by-zero.
            %
            %   HNORM = dsp.Normalizer('PropertyName', PropertyValue, ...) returns a
            %   normalization System object, HNORM, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HNORM, X) returns a normalized signal Y. The input X must be
            %   floating-point signals for the 2-norm mode, and can be both fixed-point
            %   and floating-point signals for the squared 2-norm mode.
            %
            %   Normalizer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create normalization object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Normalizer properties:
            %
            %   Method               - Type of normalization to perform
            %   Bias                 - Real value to be added in denominator to avoid
            %                          division by zero
            %   Dimension            - Dimension to operate along
            %   CustomDimension      - Numerical dimension to operate along
            %
            %   This System object supports fixed-point operations when the property
            %   Method is set to 'Squared 2-norm'. For more information, type
            %   dsp.Normalizer.helpFixedPoint.
            %
            %   % EXAMPLE: Use Normalizer System object to normalize a matrix.
            %       hnorm = dsp.Normalizer;
            %       x = magic(3);
            %       y = step(hnorm, x)
            %
            %   See also dsp.ArrayVectorMultiplier, 
            %            dsp.Normalizer.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Normalizer System object 
            %               fixed-point information
            %   dsp.Normalizer.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Normalizer
            %   System object.
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
        %   Specify the accumulator fixed-point data type as one of [{'Same as
        %   product'} | 'Same as input' | 'Custom'].
        AccumulatorDataType;

        %Bias Real value to be added in denominator to avoid division by zero
        %   Specify the real value to be added in the denominator to avoid
        %   division by zero. The default value of this property is 1e-10. This
        %   property is tunable.
        Bias;

        %CustomAccumulatorDataType Accumulator  word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomDimension Numerical dimension to operate along
        %   Specify the one-based value of the dimension over which to
        %   normalize. The value of this property cannot exceed the number of
        %   dimensions in the input signal. This property is applicable when
        %   Dimension property is 'Custom'. The default value of this property
        %   is 1.
        CustomDimension;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,32).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,32).
        %
        %   See also numerictype.
        CustomProductDataType;

        %Dimension Dimension to operate along
        %   Specify whether to normalize along [{'Column'} | 'Row' | 'Custom'].
        Dimension;

        %Method Type of normalization to perform
        %   Specify the type of normalization to perform as one of ['2-norm' |
        %   {'Squared 2-norm'}]. '2-norm' mode supports floating-point signals
        %   only. 'Squared 2-norm' supports both fixed-point and floating-point
        %   signals.
        Method;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of ['Same as
        %   accumulator' | {'Same as product'} | 'Same as input' | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Same as
        %   input'} | 'Custom'].
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
