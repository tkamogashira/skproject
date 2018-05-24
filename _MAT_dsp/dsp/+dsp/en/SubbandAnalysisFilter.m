classdef SubbandAnalysisFilter< handle
%SubbandAnalysisFilter Decompose signal into high-frequency and low-
%                      frequency subbands
%   HSAF = dsp.SubbandAnalysisFilter returns a two-channel subband analysis
%   filter System object, HSAF, that decomposes the input signal into a
%   high-frequency subband and a low-frequency subband, each with half the
%   bandwidth of the input.
%
%   HSAF = dsp.SubbandAnalysisFilter('PropertyName', PropertyValue, ...)
%   returns a two-channel subband analysis filter System object, HSAF, with
%   each specified property set to the specified value.
%
%   HSAF = dsp.SubbandAnalysisFilter(LPCOEFFS, HPCOEFFS, 'PropertyName',
%   PropertyValue, ...) returns a two-channel subband analysis filter
%   System object, HSAF, with the LowpassCoefficients property set to
%   LPCOEFFS, the HighpassCoefficients property set to HPCOEFFS, and other
%   specified properties set to the specified values.
%
%   Step method syntax:
%
%   [HI, LO] = step(HSAF, SIG) decomposes the input signal, SIG, into a
%   high-frequency subband, HI, and a low-frequency subband, LO.
%
%   SubbandAnalysisFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create two-channel subband analysis filter object with same
%              property values
%   isLocked - Locked status (logical)
%   reset    - Reset states of filter
%
%   SubbandAnalysisFilter properties:
%
%   LowpassCoefficients  - Lowpass FIR filter coefficients
%   HighpassCoefficients - Highpass FIR filter coefficients
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.SubbandAnalysisFilter.helpFixedPoint.
%
%   % EXAMPLE: Use SubbandAnalysisFilter and SubbandSynthesisFilter System
%   % objects to show perfect reconstruction.
%      load dspwlets; % load the filter coefficients lod, hid, lor and hir
%      ha = dsp.SubbandAnalysisFilter(lod, hid);
%      hs = dsp.SubbandSynthesisFilter(lor, hir);
%      u = randn(128,1);
%      [hi, lo] = step(ha, u); % Two channel analysis
%      y = step(hs, hi, lo);   % Two channel synthesis
%      % Plot difference between original and reconstructed signals with 
%      % filter latency compensated
%      plot(u(1:end-7)-y(8:end));
%
%   See also dsp.SubbandSynthesisFilter,
%            dsp.DyadicAnalysisFilterBank,
%            dsp.SubbandAnalysisFilter.helpFixedPoint.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=SubbandAnalysisFilter
            %SubbandAnalysisFilter Decompose signal into high-frequency and low-
            %                      frequency subbands
            %   HSAF = dsp.SubbandAnalysisFilter returns a two-channel subband analysis
            %   filter System object, HSAF, that decomposes the input signal into a
            %   high-frequency subband and a low-frequency subband, each with half the
            %   bandwidth of the input.
            %
            %   HSAF = dsp.SubbandAnalysisFilter('PropertyName', PropertyValue, ...)
            %   returns a two-channel subband analysis filter System object, HSAF, with
            %   each specified property set to the specified value.
            %
            %   HSAF = dsp.SubbandAnalysisFilter(LPCOEFFS, HPCOEFFS, 'PropertyName',
            %   PropertyValue, ...) returns a two-channel subband analysis filter
            %   System object, HSAF, with the LowpassCoefficients property set to
            %   LPCOEFFS, the HighpassCoefficients property set to HPCOEFFS, and other
            %   specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   [HI, LO] = step(HSAF, SIG) decomposes the input signal, SIG, into a
            %   high-frequency subband, HI, and a low-frequency subband, LO.
            %
            %   SubbandAnalysisFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create two-channel subband analysis filter object with same
            %              property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset states of filter
            %
            %   SubbandAnalysisFilter properties:
            %
            %   LowpassCoefficients  - Lowpass FIR filter coefficients
            %   HighpassCoefficients - Highpass FIR filter coefficients
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.SubbandAnalysisFilter.helpFixedPoint.
            %
            %   % EXAMPLE: Use SubbandAnalysisFilter and SubbandSynthesisFilter System
            %   % objects to show perfect reconstruction.
            %      load dspwlets; % load the filter coefficients lod, hid, lor and hir
            %      ha = dsp.SubbandAnalysisFilter(lod, hid);
            %      hs = dsp.SubbandSynthesisFilter(lor, hir);
            %      u = randn(128,1);
            %      [hi, lo] = step(ha, u); % Two channel analysis
            %      y = step(hs, hi, lo);   % Two channel synthesis
            %      % Plot difference between original and reconstructed signals with 
            %      % filter latency compensated
            %      plot(u(1:end-7)-y(8:end));
            %
            %   See also dsp.SubbandSynthesisFilter,
            %            dsp.DyadicAnalysisFilterBank,
            %            dsp.SubbandAnalysisFilter.helpFixedPoint.
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.SubbandAnalysisFilter System 
            %               object fixed-point information
            %   dsp.SubbandAnalysisFilter.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   dsp.SubbandAnalysisFilter System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Input should have even number of rows
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
        %   Specify the FIR filter coefficients fixed-point data type as one of
        %   [{'Same word length as input'} | 'Custom'].
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
        %   Specify the FIR filter coefficients fixed-point type as an
        %   auto-signed numerictype object. This property is applicable when
        %   the CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   FullPrecisionOverride property is false and when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,14).
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

        %HighPassFIRCoeffs  Highpass FIR filter coefficients
        %   Specify a vector of highpass FIR filter coefficients, in descending
        %   powers of z. The highpass filter should be a half-band filter that
        %   passes the frequency band stopped by the filter specified in the
        %   LowpassCoefficients property. The default values of this property
        %   specify a filter based on a 3rd-order Daubechies wavelet.
        HighpassCoefficients;

        %LowpassCoefficients Lowpass FIR filter coefficients
        %   Specify a vector of lowpass FIR filter coefficients, in descending
        %   powers of z. The lowpass filter should be a half-band filter that
        %   passes the frequency band stopped by the filter specified in the
        %   HighpassCoefficients property. The default values of this property
        %   specify a filter based on a 3rd-order Daubechies wavelet.
        LowpassCoefficients;

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
