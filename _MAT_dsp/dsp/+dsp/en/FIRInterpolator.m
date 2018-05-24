classdef FIRInterpolator< handle
%FIRInterpolator Upsample and filter input signals
%   HFIRINT = dsp.FIRInterpolator returns an FIR interpolation System
%   object, HFIRINT, which upsamples an input signal by an integer value
%   factor, and then applies an FIR filter. The filter is implemented using
%   a polyphase interpolation structure and the filter coefficients are
%   scaled by the interpolation factor.
%
%   HFIRINT = dsp.FIRInterpolator('PropertyName', PropertyValue, ...)
%   returns an FIR interpolation object, HFIRINT, with each specified
%   property set to the specified value.
%
%   HFIRINT = dsp.FIRInterpolator(INTERP, NUM, 'PropertyName',
%   PropertyValue, ...) returns an FIR interpolation object, HFIRINT, with
%   the InterpolationFactor property set to INTERP, the Numerator property
%   set to NUM and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HFIRINT, X) outputs the upsampled and filtered values, Y, of
%   the input signal X. A Ki-by-N input matrix is treated as N independent
%   channels, and the System object interpolates each channel over the
%   first dimension and generates a Ko-by-N output matrix, where Ko = Ki*L
%   and L is the interpolation factor.
%
%   FIRInterpolator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create FIR interpolation object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states
%
%   FIRInterpolator properties:
%
%   InterpolationFactor - Interpolation factor
%   Numerator           - FIR filter coefficients
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.FIRInterpolator.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.FIRInterpolator.helpFixedPoint.
%
%   % EXAMPLE: Double the sampling rate of an audio signal from 22050 Hz to
%   %          44100 kHz and play it.
%       hafr = dsp.AudioFileReader('OutputDataType','single');
%       hap  = dsp.AudioPlayer(44100);
%       hfirint = dsp.FIRInterpolator(2, ...
%                            firpm(30, [0 0.45 0.55 1], [1 1 0 0]));
%       while ~isDone(hafr)
%           frame = step(hafr);
%           y = step(hfirint, frame);
%           step(hap, y);
%       end
%       release(hafr);   
%       release(hap);
%
%   See also dsp.FIRDecimator, dsp.FIRRateConverter,
%            dsp.FIRInterpolator.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=FIRInterpolator
            %FIRInterpolator Upsample and filter input signals
            %   HFIRINT = dsp.FIRInterpolator returns an FIR interpolation System
            %   object, HFIRINT, which upsamples an input signal by an integer value
            %   factor, and then applies an FIR filter. The filter is implemented using
            %   a polyphase interpolation structure and the filter coefficients are
            %   scaled by the interpolation factor.
            %
            %   HFIRINT = dsp.FIRInterpolator('PropertyName', PropertyValue, ...)
            %   returns an FIR interpolation object, HFIRINT, with each specified
            %   property set to the specified value.
            %
            %   HFIRINT = dsp.FIRInterpolator(INTERP, NUM, 'PropertyName',
            %   PropertyValue, ...) returns an FIR interpolation object, HFIRINT, with
            %   the InterpolationFactor property set to INTERP, the Numerator property
            %   set to NUM and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HFIRINT, X) outputs the upsampled and filtered values, Y, of
            %   the input signal X. A Ki-by-N input matrix is treated as N independent
            %   channels, and the System object interpolates each channel over the
            %   first dimension and generates a Ko-by-N output matrix, where Ko = Ki*L
            %   and L is the interpolation factor.
            %
            %   FIRInterpolator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create FIR interpolation object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states
            %
            %   FIRInterpolator properties:
            %
            %   InterpolationFactor - Interpolation factor
            %   Numerator           - FIR filter coefficients
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.FIRInterpolator.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.FIRInterpolator.helpFixedPoint.
            %
            %   % EXAMPLE: Double the sampling rate of an audio signal from 22050 Hz to
            %   %          44100 kHz and play it.
            %       hafr = dsp.AudioFileReader('OutputDataType','single');
            %       hap  = dsp.AudioPlayer(44100);
            %       hfirint = dsp.FIRInterpolator(2, ...
            %                            firpm(30, [0 0.45 0.55 1], [1 1 0 0]));
            %       while ~isDone(hafr)
            %           frame = step(hafr);
            %           y = step(hfirint, frame);
            %           step(hap, y);
            %       end
            %       release(hafr);   
            %       release(hap);
            %
            %   See also dsp.FIRDecimator, dsp.FIRRateConverter,
            %            dsp.FIRInterpolator.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.FIRInterpolator System object
            %               fixed-point information
            %   dsp.FIRInterpolator.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.FIRInterpolator System object.
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Cache input data type for filter analysis
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Full
        %   precision'} | 'Same as product' | 'Same as input' | 'Custom'].
        %   This property is applicable when the  FullPrecisionOverride
        %   property is false.
        AccumulatorDataType;

        %CoefficientsDataType Coefficient word- and fraction-length designations
        %   Specify the coefficients fixed-point data type as one of [{'Same word
        %   length as input'} | 'Custom'].
        CoefficientsDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomCoefficientsDataType Coefficient word and fraction lengths
        %   Specify the coefficients fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   CoefficientsDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,30).
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

        %InterpolationFactor Interpolation factor
        %   Specify the factor by which to increase the sampling rate of the
        %   input signal, as scalar integer value. The default value of this
        %   property is 3.
        InterpolationFactor;

        %Numerator FIR filter coefficients
        %   Specify the numerator coefficients of the FIR filter in descending
        %   power of z. To act as an effective anti-imaging filter, the
        %   coefficients must correspond to a lowpass filter with a normalized
        %   cutoff frequency no greater than 1/(InterpolationFactor). The filter
        %   coefficients are scaled by the value of the InterpolationFactor
        %   property before filtering the signal. The default value of this
        %   property is the output of fir1(15,0.25);
        Numerator;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as product' | 'Same as input' | 'Custom'].
        %   This property is applicable when the FullPrecisionOverride
        %   property is false.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Full
        %   precision'} | 'Same as input' | 'Custom']. This property is
        %   applicable when the FullPrecisionOverride property is false.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the object is not in a full precision
        %   configuration.
        RoundingMethod;

    end
end
