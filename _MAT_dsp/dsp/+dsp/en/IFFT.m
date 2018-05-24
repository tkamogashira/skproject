classdef IFFT< handle
%IFFT   Inverse fast Fourier transform (IFFT)
%   HIFFT = dsp.IFFT returns a System object, HIFFT, that calculates the
%   inverse fast Fourier transform (IFFT) of a real or complex input.
%
%   HIFFT = dsp.IFFT('PropertyName', PropertyValue, ...) returns an inverse
%   fast Fourier transform object, HIFFT, with each specified property set
%   to the specified value.
%
%   Step method syntax:
%
%   Y = step(HIFFT, X) computes the IFFT, Y, of input X along the first
%   dimension of X, of length N. When the FFTLengthSource property is
%   'Auto', the length of the transform is N. When the FFTLengthSource
%   property is 'Property', N can be any positive integer value, and the
%   length of the transform is determined by the FFTLength property. The
%   length of the transform must be a power of two if any of the following
%   is true:
%   * the input is a fixed-point data type;
%   * the 'BitReversedInput' property is true; or
%   * the 'FFTImplementation' property is 'Radix-2'.
%
%   IFFT methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create inverse fast Fourier transform object with same
%              property values
%   isLocked - Locked status (logical)
%
%   IFFT properties:
%
%   FFTImplementation        - FFT implementation choice
%   BitReversedInput         - Enables bit-reversed order interpretation of
%                              input elements
%   ConjugateSymmetricInput  - Enables conjugate symmetric interpretation
%                              of input
%   Normalize                - Enables dividing output by FFT length
%   FFTLengthSource          - Source of FFT length
%   FFTLength                - FFT length as an integer value
%   WrapInput               -  Wrap input data when FFT length is shorter 
%                              than input length
%
%   This System object supports fixed-point operations when the
%   'FFTImplementation' property is set to 'Auto' or 'Radix-2'. For more
%   information, type dsp.IFFT.helpFixedPoint.
%
%   % EXAMPLE: Use FFT to analyze the energy content in a sequence. Set
%   % the FFT coefficients which represent less than 0.1% of the total  
%   % energy to 0 and reconstruct the sequence using IFFT. 
%       Fs = 40; L = 128; 
%       t = (0:L-1)'/Fs;  
%       x = sin(2*pi*10*t) + 0.75*cos(2*pi*15*t); 
%       y = x + .5*randn(size(x));  % noisy signal
%       hfft = dsp.FFT;
%       hifft = dsp.IFFT('ConjugateSymmetricInput', true);
%       X = step(hfft, x);
%       [XX, ind] = sort(abs(X),1,'descend');
%       XXn = sqrt(cumsum(XX.^2))/norm(XX);
%       ii = find(XXn > 0.999, 1);
%       disp(['Number of FFT coefficients that represent 99.9% of the ', ...
%       'total energy in the sequence: ', num2str(ii)]);  
%
%       XXt = zeros(128,1);
%       XXt(ind(1:ii)) = X(ind(1:ii));
%       xt = step(hifft, XXt);
%       % Verify the reconstructed signal matches the original
%       norm(x-xt)
%
%   See also dsp.FFT, dsp.DCT, dsp.IDCT, 
%            dsp.IFFT.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=IFFT
            %IFFT   Inverse fast Fourier transform (IFFT)
            %   HIFFT = dsp.IFFT returns a System object, HIFFT, that calculates the
            %   inverse fast Fourier transform (IFFT) of a real or complex input.
            %
            %   HIFFT = dsp.IFFT('PropertyName', PropertyValue, ...) returns an inverse
            %   fast Fourier transform object, HIFFT, with each specified property set
            %   to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HIFFT, X) computes the IFFT, Y, of input X along the first
            %   dimension of X, of length N. When the FFTLengthSource property is
            %   'Auto', the length of the transform is N. When the FFTLengthSource
            %   property is 'Property', N can be any positive integer value, and the
            %   length of the transform is determined by the FFTLength property. The
            %   length of the transform must be a power of two if any of the following
            %   is true:
            %   * the input is a fixed-point data type;
            %   * the 'BitReversedInput' property is true; or
            %   * the 'FFTImplementation' property is 'Radix-2'.
            %
            %   IFFT methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create inverse fast Fourier transform object with same
            %              property values
            %   isLocked - Locked status (logical)
            %
            %   IFFT properties:
            %
            %   FFTImplementation        - FFT implementation choice
            %   BitReversedInput         - Enables bit-reversed order interpretation of
            %                              input elements
            %   ConjugateSymmetricInput  - Enables conjugate symmetric interpretation
            %                              of input
            %   Normalize                - Enables dividing output by FFT length
            %   FFTLengthSource          - Source of FFT length
            %   FFTLength                - FFT length as an integer value
            %   WrapInput               -  Wrap input data when FFT length is shorter 
            %                              than input length
            %
            %   This System object supports fixed-point operations when the
            %   'FFTImplementation' property is set to 'Auto' or 'Radix-2'. For more
            %   information, type dsp.IFFT.helpFixedPoint.
            %
            %   % EXAMPLE: Use FFT to analyze the energy content in a sequence. Set
            %   % the FFT coefficients which represent less than 0.1% of the total  
            %   % energy to 0 and reconstruct the sequence using IFFT. 
            %       Fs = 40; L = 128; 
            %       t = (0:L-1)'/Fs;  
            %       x = sin(2*pi*10*t) + 0.75*cos(2*pi*15*t); 
            %       y = x + .5*randn(size(x));  % noisy signal
            %       hfft = dsp.FFT;
            %       hifft = dsp.IFFT('ConjugateSymmetricInput', true);
            %       X = step(hfft, x);
            %       [XX, ind] = sort(abs(X),1,'descend');
            %       XXn = sqrt(cumsum(XX.^2))/norm(XX);
            %       ii = find(XXn > 0.999, 1);
            %       disp(['Number of FFT coefficients that represent 99.9% of the ', ...
            %       'total energy in the sequence: ', num2str(ii)]);  
            %
            %       XXt = zeros(128,1);
            %       XXt(ind(1:ii)) = X(ind(1:ii));
            %       xt = step(hifft, XXt);
            %       % Verify the reconstructed signal matches the original
            %       norm(x-xt)
            %
            %   See also dsp.FFT, dsp.DCT, dsp.IDCT, 
            %            dsp.IFFT.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.IFFT System object fixed-point
            %               information
            %   dsp.IFFT.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.IFFT
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

        %BitReversedInput Enables bit-reversed order interpretation of input 
        %                 elements
        %   Set this property to true if the order of FFT transformed input
        %   elements to the IFFT System object are in bit-reversed order. The
        %   default value of this property is false, which denotes linear
        %   ordering. This property is applicable when the FFTLengthSource
        %   property is 'Auto' and the FFTImplementation property is set to
        %   'Auto' or 'Radix-2'. When this property is true, the FFT length must
        %   be a power of two.
        BitReversedInput;

        %ConjugateSymmetricInput Enables conjugate symmetric interpretation of 
        %                        input 
        %   Set this property to true if the input is conjugate symmetric to
        %   yield real-valued outputs. The FFT of a real valued signal is
        %   conjugate symmetric, and setting this property to true optimizes the
        %   IFFT computation method. Setting this property to false for conjugate
        %   symmetric inputs results in complex output values with small
        %   imaginary parts. Setting this property to true for non-conjugate
        %   symmetric inputs results in invalid outputs. The default value of
        %   this property is false. This property is applicable when the
        %   FFTLengthSource property is 'Auto'.
        ConjugateSymmetricInput;

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
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom' and the 'FFTImplementation'
        %   property is 'Auto' or 'Radix-2'. The default value of this property
        %   is numerictype([],16,15).
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
        %   Specify the FFT length as a numeric scalar. This property is
        %   applicable when the BitReversedInput and ConjugateSymmetricInput
        %   properties are false, and the FFTLengthSource property is 'Property'.
        %   The default value of this property is 64. This property must be a
        %   power of two when the input is a fixed-point data type, or when the
        %   FFTImplementation property is set to 'Radix-2'.
        FFTLength;

        %FFTLengthSource Source of FFT length
        %   Specify how to determine the FFT length as one of [{'Auto'} |
        %   'Property']. When this property is set to 'Auto', the FFT length is
        %   equal to the number of rows of the input signal. This property is
        %   applicable when both the BitReversedInput and ConjugateSymmetricInput
        %   properties are false.
        FFTLengthSource;

        %Normalize Enables dividing output by FFT length
        %   Specify if the IFFT output should be divided by the FFT length. The
        %   default value of this property is true which denotes that the output
        %   is divided by the FFT length.
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
        %   as input' | 'Custom']. This property is applicable when the
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
