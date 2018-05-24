classdef FFT< handle
%FFT    Fast Fourier transform (FFT)
%   HFFT = dsp.FFT returns a System object, HFFT, that calculates the
%   complex fast Fourier transform (FFT) of a real or complex input.
%
%   HFFT = dsp.FFT('PropertyName', PropertyValue, ...) returns a fast
%   Fourier transform object, HFFT, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HFFT, X) computes the FFT, Y, of input X along the first
%   dimension of X, of length N. When the FFTLengthSource property is
%   'Auto', the length of the FFT is N. When the FFTLengthSource property
%   is 'Property', N can be any positive integer value, and the length of
%   the FFT is determined by the FFTLength property. The length of the FFT
%   must be a power of two if any of the following is true:
%   * the input is a fixed-point data type;
%   * the 'BitReversedOutput' property is true; or
%   * the 'FFTImplementation' property is 'Radix-2'.
%
%   FFT methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create fast Fourier transform object with same property
%              values
%   isLocked - Locked status (logical)
%
%   FFT properties:
%
%   FFTImplementation        - FFT implementation choice
%   BitReversedOutput        - Order of output elements relative to input
%                              elements
%   Normalize                - Enables dividing butterfly outputs by two
%   FFTLengthSource          - Source of FFT length
%   FFTLength                - FFT length as an integer value
%   WrapInput                - Wrap input data when FFT length is shorter 
%                              than input length
%
%   This System object supports fixed-point operations when the
%   'FFTImplementation' property is set to 'Auto' or 'Radix-2'. For more
%   information, type dsp.FFT.helpFixedPoint.
%
%   % EXAMPLE: Use FFT to find frequency components of a signal buried in
%   %          noise. 
%      % Consider a signal with two sinusoids at 250 Hz and 340 Hz,
%      % sampled at 800 Hz and corrupted with additive zero-mean random 
%      % noise.
%      Fs = 800; L = 1000; 
%      t = (0:L-1)'/Fs;  
%      x = sin(2*pi*250*t) + 0.75*cos(2*pi*340*t); 
%      y = x + .5*randn(size(x));  % noisy signal
%      hfft = dsp.FFT('FFTLengthSource', 'Property', 'FFTLength', 1024);
%      Y = step(hfft, y);
%      % Plot the single-sided amplitude spectrum
%      plot(Fs/2*linspace(0,1,512), 2*abs(Y(1:512)/1024));
%      title('Single-sided amplitude spectrum of noisy signal y(t)');
%      xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
%
%   See also dsp.IFFT, dsp.DCT, dsp.IDCT, 
%            dsp.FFT.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=FFT
            %FFT    Fast Fourier transform (FFT)
            %   HFFT = dsp.FFT returns a System object, HFFT, that calculates the
            %   complex fast Fourier transform (FFT) of a real or complex input.
            %
            %   HFFT = dsp.FFT('PropertyName', PropertyValue, ...) returns a fast
            %   Fourier transform object, HFFT, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HFFT, X) computes the FFT, Y, of input X along the first
            %   dimension of X, of length N. When the FFTLengthSource property is
            %   'Auto', the length of the FFT is N. When the FFTLengthSource property
            %   is 'Property', N can be any positive integer value, and the length of
            %   the FFT is determined by the FFTLength property. The length of the FFT
            %   must be a power of two if any of the following is true:
            %   * the input is a fixed-point data type;
            %   * the 'BitReversedOutput' property is true; or
            %   * the 'FFTImplementation' property is 'Radix-2'.
            %
            %   FFT methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create fast Fourier transform object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   FFT properties:
            %
            %   FFTImplementation        - FFT implementation choice
            %   BitReversedOutput        - Order of output elements relative to input
            %                              elements
            %   Normalize                - Enables dividing butterfly outputs by two
            %   FFTLengthSource          - Source of FFT length
            %   FFTLength                - FFT length as an integer value
            %   WrapInput                - Wrap input data when FFT length is shorter 
            %                              than input length
            %
            %   This System object supports fixed-point operations when the
            %   'FFTImplementation' property is set to 'Auto' or 'Radix-2'. For more
            %   information, type dsp.FFT.helpFixedPoint.
            %
            %   % EXAMPLE: Use FFT to find frequency components of a signal buried in
            %   %          noise. 
            %      % Consider a signal with two sinusoids at 250 Hz and 340 Hz,
            %      % sampled at 800 Hz and corrupted with additive zero-mean random 
            %      % noise.
            %      Fs = 800; L = 1000; 
            %      t = (0:L-1)'/Fs;  
            %      x = sin(2*pi*250*t) + 0.75*cos(2*pi*340*t); 
            %      y = x + .5*randn(size(x));  % noisy signal
            %      hfft = dsp.FFT('FFTLengthSource', 'Property', 'FFTLength', 1024);
            %      Y = step(hfft, y);
            %      % Plot the single-sided amplitude spectrum
            %      plot(Fs/2*linspace(0,1,512), 2*abs(Y(1:512)/1024));
            %      title('Single-sided amplitude spectrum of noisy signal y(t)');
            %      xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
            %
            %   See also dsp.IFFT, dsp.DCT, dsp.IDCT, 
            %            dsp.FFT.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.FFT System object fixed-point
            %               information
            %   dsp.FFT.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.FFT
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
        %   Specify the accumulator data type as one of [{'Full precision'} |
        %   'Same as input' | 'Same as product' | 'Custom']. This property is
        %   applicable when the 'FFTImplementation' property is 'Auto' or
        %   'Radix-2'.
        AccumulatorDataType;

        %BitReversedOutput Order of output elements relative to input elements
        %   Designate order of output channel elements relative to order of input
        %   elements. Set this property to true to output the frequency indices
        %   in bit-reversed order. The default value of this property is false,
        %   which denotes linear ordering of frequency indices. This property is
        %   applicable when the FFTImplementation property is set to 'Auto' or
        %   'Radix-2'. When this property is true, the FFT length must be a power
        %   of two.
        BitReversedOutput;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom' and the 'FFTImplementation'
        %   property is 'Auto' or 'Radix-2'. The default value of this property
        %   is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when OutputDataType
        %   property is 'Custom' and the 'FFTImplementation' property is 'Auto'
        %   or 'Radix-2'. The default value of this property is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom' and the 'FFTImplementation'
        %   property is 'Auto' or 'Radix-2'. The default value of this property
        %   is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomSineTableDataType Sine table word and fraction lengths
        %   Specify the sine table fixed-point type as an auto-signed unscaled
        %   numerictype object. This property is applicable when the
        %   SineTableDataType property is 'Custom' and the 'FFTImplementation'
        %   property is 'Auto' or 'Radix-2'. The default value of this property
        %   is numerictype([],16).
        %
        %   See also numerictype.
        CustomSineTableDataType;

        %FFTImplementation FFT implementation choice
        %   Specify the implementation used for the FFT as one of [{'Auto'} | 
        %   'Radix-2' | 'FFTW']. When this property is set to 'Radix-2', the
        %   FFT length must be a power of two.
        FFTImplementation;

        %FFTLength FFT length as an integer value
        %   Specify the FFT length. This property is applicable when the
        %   FFTLengthSource property is 'Property'. The default value of this
        %   property is 64. This property must be a power of two when the input
        %   is a fixed-point data type, or when the 'BitReversedOutput' property
        %   is true, or when the FFTImplementation property is set to 'Radix-2'.
        FFTLength;

        %FFTLengthSource Source of FFT length
        %   Specify how to determine the FFT length as one of [{'Auto'} |
        %   'Property']. When this property is set to 'Auto', the FFT length is
        %   equal to the number of rows of the input signal.
        FFTLengthSource;

        %Normalize Enables dividing butterfly outputs by two
        %   Set this property to true if the output of each butterfly of the FFT
        %   should be divided by two. The default value of this property is false
        %   and no scaling occurs.
        Normalize;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output data type as one of [{'Full precision'} | 'Same as
        %   input' | 'Custom']. This property is applicable when the
        %   'FFTImplementation' property is 'Auto' or 'Radix-2'.
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the 'FFTImplementation' property is
        %   'Auto' or 'Radix-2'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product data type as one of [{'Full precision'} | 'Same
        %   as input' | 'Custom'].  This property is applicable when the
        %   'FFTImplementation' property is 'Auto' or 'Radix-2'.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This property
        %   is applicable when the 'FFTImplementation' property is 'Auto' or
        %   'Radix-2'.
        RoundingMethod;

        %SineTableDataType Sine table word- and fraction-length designations
        %   Specify the sine table data type as one of [{'Same word length as
        %   input'} | 'Custom']. This property is applicable when the
        %   'FFTImplementation' property is 'Auto' or 'Radix-2'.
        SineTableDataType;

        % WrapInput Wrap input data when FFT length is shorter than input length
        % When this property is set to true, modulo-length data wrapping occurs 
        % before the FFT operation when the FFT length is shorter than the input 
        % length. When this property is set to false, truncation of the input 
        % data to the FFT length occurs before the FFT operation. The default is
        % true. 
        WrapInput;

    end
end
