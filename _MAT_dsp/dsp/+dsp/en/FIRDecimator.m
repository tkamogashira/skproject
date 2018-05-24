classdef FIRDecimator< handle
%FIRDecimator Filter and downsample input signals
%   HFIRD = dsp.FIRDecimator returns an FIR decimation System object,
%   HFIRD, which applies an FIR filter to the input signal, then
%   downsamples by an integer value factor. The filter is implemented using
%   an efficient polyphase FIR decimation structure.
%
%   HFIRD = dsp.FIRDecimator ('PropertyName', PropertyValue, ...) returns
%   an FIR decimation object, HFIRD, with each specified property set to
%   the specified value.
%
%   HFIRD = dsp.FIRDecimator(DECIM, NUM, 'PropertyName', PropertyValue,
%   ...) returns an FIR decimation, HFIRD, with the DecimationFactor
%   property set to DECIM, the Numerator property set to NUM and other
%   specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HFIRD, X) outputs the filtered and downsampled values, Y, of
%   the input signal X. A KixN input matrix is treated as N independent
%   channels, and the System object decimates each channel over time and
%   generates a KoxN output matrix. Ko = Ki/M where M is the decimation
%   factor. The object supports real and complex floating-point and
%   fixed-point inputs, except for complex unsigned fixed-point inputs.
%
%   FIRDecimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create FIR decimation object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   FIRDecimator properties:
%
%   DecimationFactor - Decimation factor
%   Numerator        - FIR filter coefficients
%   Structure        - Filter structure
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.FIRDecimator.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.FIRDecimator.helpFixedPoint.
%
%   % EXAMPLE #1: Decimate an input by 2.
%      hfirdec1 = dsp.FIRDecimator;
%      x = (1:100)';
%      y = step(hfirdec1, x); 
%
%   % EXAMPLE #2: Half the sampling rate of an audio signal and play it.
%       hafr = dsp.AudioFileReader('OutputDataType','single');
%       hap  = dsp.AudioPlayer(22050/2);
%       hfirdec = dsp.FIRDecimator;
%       while ~isDone(hafr)
%           frame = step(hafr);
%           y = step(hfirdec, frame);
%           step(hap, y);
%       end
%       release(hafr);   
%       release(hap);
%
%   See also dsp.FIRInterpolator, dsp.FIRRateConverter,
%            dsp.FIRDecimator.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=FIRDecimator
            %FIRDecimator Filter and downsample input signals
            %   HFIRD = dsp.FIRDecimator returns an FIR decimation System object,
            %   HFIRD, which applies an FIR filter to the input signal, then
            %   downsamples by an integer value factor. The filter is implemented using
            %   an efficient polyphase FIR decimation structure.
            %
            %   HFIRD = dsp.FIRDecimator ('PropertyName', PropertyValue, ...) returns
            %   an FIR decimation object, HFIRD, with each specified property set to
            %   the specified value.
            %
            %   HFIRD = dsp.FIRDecimator(DECIM, NUM, 'PropertyName', PropertyValue,
            %   ...) returns an FIR decimation, HFIRD, with the DecimationFactor
            %   property set to DECIM, the Numerator property set to NUM and other
            %   specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HFIRD, X) outputs the filtered and downsampled values, Y, of
            %   the input signal X. A KixN input matrix is treated as N independent
            %   channels, and the System object decimates each channel over time and
            %   generates a KoxN output matrix. Ko = Ki/M where M is the decimation
            %   factor. The object supports real and complex floating-point and
            %   fixed-point inputs, except for complex unsigned fixed-point inputs.
            %
            %   FIRDecimator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create FIR decimation object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   FIRDecimator properties:
            %
            %   DecimationFactor - Decimation factor
            %   Numerator        - FIR filter coefficients
            %   Structure        - Filter structure
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.FIRDecimator.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.FIRDecimator.helpFixedPoint.
            %
            %   % EXAMPLE #1: Decimate an input by 2.
            %      hfirdec1 = dsp.FIRDecimator;
            %      x = (1:100)';
            %      y = step(hfirdec1, x); 
            %
            %   % EXAMPLE #2: Half the sampling rate of an audio signal and play it.
            %       hafr = dsp.AudioFileReader('OutputDataType','single');
            %       hap  = dsp.AudioPlayer(22050/2);
            %       hfirdec = dsp.FIRDecimator;
            %       while ~isDone(hafr)
            %           frame = step(hafr);
            %           y = step(hfirdec, frame);
            %           step(hap, y);
            %       end
            %       release(hafr);   
            %       release(hap);
            %
            %   See also dsp.FIRInterpolator, dsp.FIRRateConverter,
            %            dsp.FIRDecimator.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.FIRDecimator System object
            %               fixed-point information
            %   dsp.FIRDecimator.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.FIRDecimator System object.
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

        %CoefficientsDataType Coefficients word- and fraction-length designations
        %   Specify the coefficients fixed-point data type as one of [{'Same
        %   word length as input'} | 'Custom'].
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

        %CustomCoefficientsDataType Coefficients word and fraction lengths
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

        %DecimationFactor Decimation factor
        %   Specify the factor by which to reduce the sampling rate of the
        %   input signal as a positive integer scalar value. The number of rows
        %   should be a multiple of the decimation factor. The default value of
        %   this property is 2.
        DecimationFactor;

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

        %Numerator FIR filter coefficients
        %   Specify the numerator coefficients of the FIR filter in descending
        %   power of z. To prevent aliasing the filter coefficients should
        %   correspond to a lowpass filter with normalized cutoff frequency no
        %   greater than 1/(Decimation Factor).The default value of this
        %   property is fir1(35,0.4).
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

        %Structure Filter structure
        %   Specify the implementation of the FIR filter as one of [{'Direct
        %   form'} | 'Direct form transposed'].
        Structure;

    end
end
