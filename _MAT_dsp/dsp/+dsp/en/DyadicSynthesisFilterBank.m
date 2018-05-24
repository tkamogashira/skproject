classdef DyadicSynthesisFilterBank< handle
%DyadicSynthesisFilterBank Reconstruct signals from subbands with smaller
%bandwidths and smaller sample rates
%   HDYDSYN = dsp.DyadicSynthesisFilterBank returns a System object,
%   HDYDSYN, that reconstructs a signal from its subbands with smaller
%   bandwidths and smaller sample rates. The System object uses a series of
%   highpass and lowpass FIR filters to repeatedly reconstruct the signal.
%
%   HDYDSYN = dsp.DyadicSynthesisFilterBank('PropertyName', PropertyValue,
%   ...) returns a dyadic synthesis filter bank object, HDYDSYN, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   X = step(HDYDSYN, S) reconstructs the concatenated subband input S to
%   output X. Each column of input S contains the subbands for an
%   independent signal, with upper rows containing the high-frequency
%   subbands and lower rows containing the low-frequency subbands. The
%   number of rows of S must be a multiple of 2^N, where N is the value of
%   the NumLevels property.
%
%   DyadicSynthesisFilterBank methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create dyadic synthesis filter bank object with same
%              property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   DyadicSynthesisFilterBank properties:
%
%   Filter               - Type of filter used in filter bank
%   CustomLowpassFilter  - Lowpass FIR filter coefficients
%   CustomHighpassFilter - Highpass FIR filter coefficients
%   WaveletOrder         - Wavelet order
%   FilterOrder          - Wavelet order for synthesis filter stage
%   NumLevels            - Number of filter bank levels
%   TreeStructure        - Structure of filter bank as asymmetric, or
%                          symmetric
%
%   % EXAMPLE: Use DyadicAnalysisFilterBank and DyadicSynthesisFilterBank
%   % System objects for denoising a signal.
%       t = 0:.0001:.0511;
%       x= square(2*pi*30*t);
%       xn = x' + 0.08*randn(length(x),1);
%       hdydanl = dsp.DyadicAnalysisFilterBank;
%       % The filter coefficients correspond to a 'haar' wavelet.
%       hdydanl.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
%       hdydanl.CustomHighpassFilter = [-1/sqrt(2) 1/sqrt(2)];
%       hdydsyn = dsp.DyadicSynthesisFilterBank;
%       hdydsyn.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
%       hdydsyn.CustomHighpassFilter = [1/sqrt(2) -1/sqrt(2)];
%       C = step(hdydanl, xn);
%       % Subband outputs
%       C1 = C(1:256); C2 = C(257:384); C3 = C(385:512);
%       % Set higher frequency coefficients to zero to remove the noise.
%       x_den = step(hdydsyn, [zeros(length(C1),1);zeros(length(C2),1);C3]);
%       subplot(2,1,1), plot(xn); title('Original noisy Signal');
%       subplot(2,1,2), plot(x_den); title('Denoised Signal');
%
%   See also dsp.DyadicAnalysisFilterBank,
%            dsp.SubbandSynthesisFilter.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=DyadicSynthesisFilterBank
            %DyadicSynthesisFilterBank Reconstruct signals from subbands with smaller
            %bandwidths and smaller sample rates
            %   HDYDSYN = dsp.DyadicSynthesisFilterBank returns a System object,
            %   HDYDSYN, that reconstructs a signal from its subbands with smaller
            %   bandwidths and smaller sample rates. The System object uses a series of
            %   highpass and lowpass FIR filters to repeatedly reconstruct the signal.
            %
            %   HDYDSYN = dsp.DyadicSynthesisFilterBank('PropertyName', PropertyValue,
            %   ...) returns a dyadic synthesis filter bank object, HDYDSYN, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   X = step(HDYDSYN, S) reconstructs the concatenated subband input S to
            %   output X. Each column of input S contains the subbands for an
            %   independent signal, with upper rows containing the high-frequency
            %   subbands and lower rows containing the low-frequency subbands. The
            %   number of rows of S must be a multiple of 2^N, where N is the value of
            %   the NumLevels property.
            %
            %   DyadicSynthesisFilterBank methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create dyadic synthesis filter bank object with same
            %              property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states
            %
            %   DyadicSynthesisFilterBank properties:
            %
            %   Filter               - Type of filter used in filter bank
            %   CustomLowpassFilter  - Lowpass FIR filter coefficients
            %   CustomHighpassFilter - Highpass FIR filter coefficients
            %   WaveletOrder         - Wavelet order
            %   FilterOrder          - Wavelet order for synthesis filter stage
            %   NumLevels            - Number of filter bank levels
            %   TreeStructure        - Structure of filter bank as asymmetric, or
            %                          symmetric
            %
            %   % EXAMPLE: Use DyadicAnalysisFilterBank and DyadicSynthesisFilterBank
            %   % System objects for denoising a signal.
            %       t = 0:.0001:.0511;
            %       x= square(2*pi*30*t);
            %       xn = x' + 0.08*randn(length(x),1);
            %       hdydanl = dsp.DyadicAnalysisFilterBank;
            %       % The filter coefficients correspond to a 'haar' wavelet.
            %       hdydanl.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
            %       hdydanl.CustomHighpassFilter = [-1/sqrt(2) 1/sqrt(2)];
            %       hdydsyn = dsp.DyadicSynthesisFilterBank;
            %       hdydsyn.CustomLowpassFilter = [1/sqrt(2) 1/sqrt(2)];
            %       hdydsyn.CustomHighpassFilter = [1/sqrt(2) -1/sqrt(2)];
            %       C = step(hdydanl, xn);
            %       % Subband outputs
            %       C1 = C(1:256); C2 = C(257:384); C3 = C(385:512);
            %       % Set higher frequency coefficients to zero to remove the noise.
            %       x_den = step(hdydsyn, [zeros(length(C1),1);zeros(length(C2),1);C3]);
            %       subplot(2,1,1), plot(xn); title('Original noisy Signal');
            %       subplot(2,1,2), plot(x_den); title('Denoised Signal');
            %
            %   See also dsp.DyadicAnalysisFilterBank,
            %            dsp.SubbandSynthesisFilter.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomHighpassFilter Highpass FIR filter coefficients
        %   Specify a vector of highpass FIR filter coefficients, in descending
        %   powers of z. The highpass filter should be a half-band filter that
        %   passes the frequency band stopped by the filter specified in the
        %   CustomLowpassFilter property. This property is applicable when the
        %   Filter property is 'Custom'. To perfectly reconstruct a signal
        %   decomposed by the Dyadic Analysis Filter Bank, the filters in this
        %   System object must be designed to perfectly reconstruct the outputs
        %   of the analysis filter bank. Otherwise, the reconstruction is not
        %   perfect. The default values of this property specify a perfect
        %   reconstruction filter for the default settings of the Dyadic
        %   Analysis Filter Bank (based on a 3rd-order Daubechies wavelet).
        CustomHighpassFilter;

        %CustomLowpassFilter Lowpass FIR filter coefficients
        %   Specify a vector of lowpass FIR filter coefficients, in descending
        %   powers of z. The lowpass filter should be a half-band filter that
        %   passes the frequency band stopped by the filter specified in the
        %   CustomHighpassFilter property. This property is applicable when the
        %   Filter property is 'Custom'. To perfectly reconstruct a signal
        %   decomposed by the Dyadic Analysis Filter Bank, the filters in this
        %   System object must be designed to perfectly reconstruct the outputs
        %   of the analysis filter bank. Otherwise, the reconstruction is not
        %   perfect. The default values of this property specify a perfect
        %   reconstruction filter for the default settings of the Dyadic
        %   Analysis Filter Bank (based on a 3rd-order Daubechies wavelet).
        CustomLowpassFilter;

        %Filter Type of filter used in filter bank
        %   Specify the type of filter used to determine the high- and low-pass
        %   FIR filters in the dyadic synthesis filter bank as one of
        %   [{'Custom'} | 'Haar' | 'Daubechies' | 'Symlets' | 'Coiflets' |
        %   'Biorthogonal' | 'Reverse Biorthogonal' | 'Discrete Meyer']. If
        %   this property is set to 'Custom', the filter coefficients are
        %   specified by the CustomLowpassFilter and CustomHighpassFilter
        %   properties. Otherwise, the System object uses the Wavelet Toolbox
        %   function wfilters to construct the filters. Extra properties such
        %   as WaveletOrder or FilterOrder might become applicable. For a list
        %   of the supported wavelets, see the table below.
        %   ------------------------------------------------------------------
        %   |Filter              |Example Setting        |Corresponding Syntax|
        %   ------------------------------------------------------------------
        %   |Haar                |None                   |wfilters('haar')    |
        %   |Daubechies          |WaveletOrder = 4       |wfilters('db4')     |
        %   |Symlets             |WaveletOrder = 3       |wfilters('sym3')    |
        %   |Coiflets            |WaveletOrder = 1       |wfilters('coif1')   |
        %   |Biorthogonal        |FilterOrder = '[3 / 1]'|wfilters('bior3.1') |
        %   |Reverse Biorthogonal|FilterOrder = '[3 / 1]'|wfilters('rbior3.1')|
        %   |Discrete Meyer      |None                   |wfilters('dmey')    |
        %   ------------------------------------------------------------------
        %   Note that the Wavelet Toolbox product needs to be installed in
        %   order to automatically design wavelet-based filters. Otherwise, use
        %   CustomLowpassFilter and CustomHighpassFilter properties to specify
        %   lowpass and highpass FIR filters.
        %
        %   See also wfilters.
        Filter;

        %FilterOrder Wavelet order for synthesis filter stage
        %   Specify the order of the wavelet for the synthesis filter stage as
        %   one of 
        %   [{'[1 / 1]'}, '[1 / 3]', '[1 / 5]', '[2 / 2]', '[2 / 4]', 
        %     '[2 / 6]',  '[2 / 8]', '[3 / 1]', '[3 / 3]', '[3 / 5]', 
        %     '[3 / 7]',  '[3 / 9]', '[4 / 4]', '[5 / 5]', '[6 / 8]']. 
        %   This property is applicable when the Filter property is
        %   'Biorthogonal' or 'Reverse Biorthogonal'. 
        FilterOrder;

        %NumLevels Number of filter bank levels
        %   Specify the number of filter bank levels as a scalar integer. An
        %   N-level asymmetric structure has N+1 input subbands, and an N-level
        %   symmetric structure has 2^N input subbands. The default value of
        %   this property is 2.
        NumLevels;

        %TreeStructure Structure of filter bank as Asymmetric, or Symmetric
        %   Specify the structure of the filter bank as one of [{'Asymmetric'}
        %   | 'Symmetric']. In the asymmetric structure, the low-frequency
        %   subband input to each level is the output of the previous level,
        %   while the high-frequency subband input to each level is an input to
        %   the filter bank. In the symmetric structure, both the low- and
        %   high-frequency subband inputs to each level are outputs from the
        %   previous level.
        TreeStructure;

        %WaveletOrder Wavelet order 
        %   Specify the order of the wavelet selected in the Filter property.
        %   This property is applicable when the Filter property is
        %   'Daubechies', 'Symlets' or 'Coiflets'. The default value of this
        %   property is 2.
        WaveletOrder;

    end
end
