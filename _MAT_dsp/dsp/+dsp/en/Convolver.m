classdef Convolver< handle
%Convolver Compute convolution of two inputs
%   HCONV = dsp.Convolver returns a convolution System object, HCONV, that
%   convolves two inputs in the time domain or frequency domain.
%
%   HCONV = dsp.Convolver('PropertyName', PropertyValue, ...) returns a
%   convolution object, HCONV, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HCONV, A, B) convolves inputs A and B, and returns Y as the
%   convolved output.
%
%   Convolver methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create convolution object with same property values
%   isLocked - Locked status (logical)
%
%   Convolver properties:
%
%   Method - Domain for computing convolutions, time or frequency
%
%   This System object supports fixed-point operations when the property
%   Method is set to 'Time Domain'. For more information, type
%   dsp.Convolver.helpFixedPoint.
%
%   % EXAMPLE: Use the Convolver System object to convolve two rectangular
%   %          sequences to generate a triangular sequence
%       hconv = dsp.Convolver;
%       x = ones(10,1);
%       y = step(hconv, x, x);
%       figure, plot(y);    % triangular sequence
%
%   See also dsp.Autocorrelator, dsp.Crosscorrelator,
%            dsp.Convolver.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Convolver
            %Convolver Compute convolution of two inputs
            %   HCONV = dsp.Convolver returns a convolution System object, HCONV, that
            %   convolves two inputs in the time domain or frequency domain.
            %
            %   HCONV = dsp.Convolver('PropertyName', PropertyValue, ...) returns a
            %   convolution object, HCONV, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCONV, A, B) convolves inputs A and B, and returns Y as the
            %   convolved output.
            %
            %   Convolver methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create convolution object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Convolver properties:
            %
            %   Method - Domain for computing convolutions, time or frequency
            %
            %   This System object supports fixed-point operations when the property
            %   Method is set to 'Time Domain'. For more information, type
            %   dsp.Convolver.helpFixedPoint.
            %
            %   % EXAMPLE: Use the Convolver System object to convolve two rectangular
            %   %          sequences to generate a triangular sequence
            %       hconv = dsp.Convolver;
            %       x = ones(10,1);
            %       y = step(hconv, x, x);
            %       figure, plot(y);    % triangular sequence
            %
            %   See also dsp.Autocorrelator, dsp.Crosscorrelator,
            %            dsp.Convolver.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.Convolver System object
            %               fixed-point information
            %   dsp.Convolver.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.Convolver
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
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as product' | 'Same as first input' |
        %   'Custom']. This property is applicable when the Method property is
        %   'Time Domain' and the FullPrecisionOverride property is false.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property is
        %   false, and the AccumulatorDataType property is 'Custom'. The
        %   default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property  is
        %   false, and the OutputDataType property is 'Custom'.
        %   The default value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths              
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is 'Time Domain', the FullPrecisionOverride property is
        %   false, and the ProductDataType property is 'Custom'.
        %   The default value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

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

        %Method Domain for computing convolutions, time or frequency
        %   Specify the domain in which the System object computes convolutions
        %   as one of [{'Time Domain'} | 'Frequency Domain' | 'Fastest'].
        %   Computing convolutions in the time domain minimizes memory use.
        %   Computing convolutions in the frequency domain might require fewer
        %   computations than computing in the time domain, depending on the
        %   input length. If this property is set to 'Fastest', the object
        %   computes convolutions in the domain which minimizes the number of
        %   computations.
        Method;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as product' | 'Same as first input' |
        %   'Custom']. This property is applicable when the Method property is
        %   'Time Domain' and the FullPrecisionOverride property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as first input' | 'Custom']. This property is
        %   applicable when the Method property is 'Time Domain' and the
        %   FullPrecisionOverride property is false.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the Method property is 'Time Domain'
        %   and the object is not in a full precision configuration.
        RoundingMethod;

    end
end
