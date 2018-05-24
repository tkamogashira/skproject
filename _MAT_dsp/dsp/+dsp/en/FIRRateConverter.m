classdef FIRRateConverter< handle
%FIRRateConverter Upsample, filter and downsample input signals
%   HFIRRC = dsp.FIRRateConverter returns a System object, HFIRRC, that
%   resamples an input signal by upsampling by an integer factor L,
%   applying an FIR filter and downsampling by another integer factor M.
%
%   HFIRRC = dsp.FIRRateConverter('PropertyName', PropertyValue, ...)
%   returns an FIR rate conversion System object, HFIRRC, with each
%   specified property set to the specified value.
%
%   HFIRRC = dsp.FIRRateConverter(L, M, NUM, 'PropertyName', PropertyValue,
%   ...) returns an FIR rate conversion System object, HFIRRC, with the
%   InterpolationFactor property set to L, the DecimationFactor property
%   set to M, the Numerator property set to NUM and other specified
%   properties set to the specified values.
%
%   The FIR rate conversion filter is implemented using an efficient
%   polyphase structure. Rate change factors L and M must be relatively
%   prime. The filter coefficients are scaled by the upsample factor L. For
%   some combinations of upsample and downsample factors, there will be a
%   delay in the filtered output due to causality in the polyphase network.
%
%   Step method syntax:
%
%   Y = step(HFIRRC, X) resamples input X and returns the resampled signal
%   Y. An M-by-N matrix input is treated as N independent channels.
%
%   FIRRateConverter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create FIR rate conversion object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   FIRRateConverter properties:
%
%   InterpolationFactor - Interpolation factor
%   DecimationFactor    - Decimation factor
%   Numerator           - FIR filter coefficients
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.FIRRateConverter.helpFilterAnalysis.
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.FIRRateConverter.helpFixedPoint.
%
%       % EXAMPLE 1: Resample a 100 Hz sine wave signal by a factor of 3:2.
%       hsin = dsp.SineWave(1, 100, ...
%                    'SampleRate', 5000, ...
%                    'SamplesPerFrame', 50);
%         % Create a FIR rate converter filter. To obtain a resampled rate
%         % of 3:2, set the interpolation factor to 3 and the decimation 
%         % factor to 2. 
%         hfirrc = dsp.FIRRateConverter(3,2);
%         input = step(hsin);
%         output = step(hfirrc, input);
%
%         % Plot the original and resampled signals.
%         ndelay = round(length(hfirrc.Numerator)/2/hfirrc.DecimationFactor);
%         indx = ndelay+1:length(output);
%         x = (0:length(indx)-1)/hsin.SampleRate*hfirrc.DecimationFactor/hfirrc.InterpolationFactor;
%         stem((0:38)/hsin.SampleRate, input(1:39)); hold on;
%         stem(x, hfirrc.InterpolationFactor*output(indx),'r');
%         legend('Original','Resampled');
%         
%         % EXAMPLE 2: Resample and play an audio signal from 48 kHz to 32 kHz
%         hmfr = dsp.AudioFileReader('audio48kHz.wav', ...
%             'OutputDataType', 'single', ...
%             'SamplesPerFrame', 300);
%         hap = dsp.AudioPlayer(32000);
%         % Create an FIRRateConverter System object with interpolation
%         % factor = 2 and decimation factor = 3. Set FIR filter coefficients
%         % to a lowpass filter with normalized cutoff frequency of 1/3.
%         hfirrc = dsp.FIRRateConverter(2,3,firpm(70,[0 .28 .32 1],[1 1 0 0]));
%         
%         while ~isDone(hmfr)
%             % Read audio from file
%             audio1 = step(hmfr);
%             % Convert rate
%             audio2 = step(hfirrc, audio1);
%             % Play converted audio
%             step(hap, audio2);
%         end
%         
%         release(hmfr);
%         release(hap);
%
%   See also dsp.FIRInterpolator, dsp.FIRDecimator,
%            dsp.FIRRateConverter.helpFixedPoint.

   
  %   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=FIRRateConverter
            %FIRRateConverter Upsample, filter and downsample input signals
            %   HFIRRC = dsp.FIRRateConverter returns a System object, HFIRRC, that
            %   resamples an input signal by upsampling by an integer factor L,
            %   applying an FIR filter and downsampling by another integer factor M.
            %
            %   HFIRRC = dsp.FIRRateConverter('PropertyName', PropertyValue, ...)
            %   returns an FIR rate conversion System object, HFIRRC, with each
            %   specified property set to the specified value.
            %
            %   HFIRRC = dsp.FIRRateConverter(L, M, NUM, 'PropertyName', PropertyValue,
            %   ...) returns an FIR rate conversion System object, HFIRRC, with the
            %   InterpolationFactor property set to L, the DecimationFactor property
            %   set to M, the Numerator property set to NUM and other specified
            %   properties set to the specified values.
            %
            %   The FIR rate conversion filter is implemented using an efficient
            %   polyphase structure. Rate change factors L and M must be relatively
            %   prime. The filter coefficients are scaled by the upsample factor L. For
            %   some combinations of upsample and downsample factors, there will be a
            %   delay in the filtered output due to causality in the polyphase network.
            %
            %   Step method syntax:
            %
            %   Y = step(HFIRRC, X) resamples input X and returns the resampled signal
            %   Y. An M-by-N matrix input is treated as N independent channels.
            %
            %   FIRRateConverter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create FIR rate conversion object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states
            %
            %   FIRRateConverter properties:
            %
            %   InterpolationFactor - Interpolation factor
            %   DecimationFactor    - Decimation factor
            %   Numerator           - FIR filter coefficients
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.FIRRateConverter.helpFilterAnalysis.
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.FIRRateConverter.helpFixedPoint.
            %
            %       % EXAMPLE 1: Resample a 100 Hz sine wave signal by a factor of 3:2.
            %       hsin = dsp.SineWave(1, 100, ...
            %                    'SampleRate', 5000, ...
            %                    'SamplesPerFrame', 50);
            %         % Create a FIR rate converter filter. To obtain a resampled rate
            %         % of 3:2, set the interpolation factor to 3 and the decimation 
            %         % factor to 2. 
            %         hfirrc = dsp.FIRRateConverter(3,2);
            %         input = step(hsin);
            %         output = step(hfirrc, input);
            %
            %         % Plot the original and resampled signals.
            %         ndelay = round(length(hfirrc.Numerator)/2/hfirrc.DecimationFactor);
            %         indx = ndelay+1:length(output);
            %         x = (0:length(indx)-1)/hsin.SampleRate*hfirrc.DecimationFactor/hfirrc.InterpolationFactor;
            %         stem((0:38)/hsin.SampleRate, input(1:39)); hold on;
            %         stem(x, hfirrc.InterpolationFactor*output(indx),'r');
            %         legend('Original','Resampled');
            %         
            %         % EXAMPLE 2: Resample and play an audio signal from 48 kHz to 32 kHz
            %         hmfr = dsp.AudioFileReader('audio48kHz.wav', ...
            %             'OutputDataType', 'single', ...
            %             'SamplesPerFrame', 300);
            %         hap = dsp.AudioPlayer(32000);
            %         % Create an FIRRateConverter System object with interpolation
            %         % factor = 2 and decimation factor = 3. Set FIR filter coefficients
            %         % to a lowpass filter with normalized cutoff frequency of 1/3.
            %         hfirrc = dsp.FIRRateConverter(2,3,firpm(70,[0 .28 .32 1],[1 1 0 0]));
            %         
            %         while ~isDone(hmfr)
            %             % Read audio from file
            %             audio1 = step(hmfr);
            %             % Convert rate
            %             audio2 = step(hfirrc, audio1);
            %             % Play converted audio
            %             step(hap, audio2);
            %         end
            %         
            %         release(hmfr);
            %         release(hap);
            %
            %   See also dsp.FIRInterpolator, dsp.FIRDecimator,
            %            dsp.FIRRateConverter.helpFixedPoint.
        end

        function convertToDFILT(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.FIRRateConverter System object
            %               fixed-point information
            %   dsp.FIRRateConverter.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.FIRRateConverter System object.
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
        %   CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype([],16,15).
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
        %   Specify the integer factor, by which to downsample the signal after
        %   filtering. The default value of this property is 2.
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

        %InterpolationFactor Interpolation factor
        %   Specify the integer factor, by which to upsample the signal before
        %   filtering. The default value of this property is 3.
        InterpolationFactor;

        %Numerator FIR filter coefficients
        %   Specify the FIR filter coefficients in descending powers of z. The
        %   filter coefficients can be generated by one of the Signal
        %   Processing Toolbox filter design functions (such as fir1), and
        %   should have a length greater than the interpolation factor. The
        %   filter should be lowpass with normalized cutoff frequency no
        %   greater than min(1/InterpolationFactor, 1/DecimationFactor). All
        %   filter states are internally initialized to zero. The default value
        %   of this property is firpm(70,[0 .28 .32 1],[1 1 0 0]).
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
