classdef TransferFunctionEstimator< handle
%TransferFunctionEstimator Estimate frequency-domain transfer function
%   H = dsp.TransferFunctionEstimator returns a System object, H, that 
%   computes the transfer function of real or complex input and output 
%   signals via the periodogram method and Welch's averaged, modified 
%   periodogram method.
%
%   H = dsp.TransferFunctionEstimator('Name', Value, ...) returns a
%   Transfer Fucntion Estimator System object, H, with each specified 
%   property name set to the specified value. You can specify additional 
%   name-value pair arguments in any order as (Name1,Value1,...,NameN,
%   ValueN).
%
%   Step method syntax:
%
%   Txy = step(H, X, Y) computes the transfer function , Txy, of the system 
%   with input X and output Y using Welch's averaged periodogram method.
%   Txy is the quotient of cross power spectral density of X and Y and the 
%   power spectral density of X. X and Y must be of the same size. The 
%   columns of X and Y are treated as independent channels.
%
%   TransferFunctionEstimator methods:
%
%   step                 - Compute Transfer Function of inputs (see above)
%   release              - Allow property value and input characteristics 
%                          changes, and release Transfer Function resources
%   clone                - Create Transfer Function object with same 
%                          property values
%   isLocked             - Display locked status (logical)
%   reset                - Reset the sates of the Transfer Function
%                          Estimator
%   getRBW               - Get the resolution bandwidth of the spectrum
%   getFrequencyVector   - Get the vector of frequencies at which the
%                          spectrum is estimated
%
%   TransferFunctionEstimator properties:
%
%   SpectralAverages             - Number of spectral averages
%   FFTLengthSource              - Source of the FFT length value
%   FFTLength                    - FFT length
%   Window                       - Window function
%   SidelobeAttenuation          - Sidelobe attenuation of window
%   FrequencyRange               - Frequency range of the Spectrum estimate
%
%   % Example
%   % Estimate transfer function of system represented by order-64 FIR 
%   % filter
%   hsin = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
%   hsin.SamplesPerFrame = 1000;
%   hs = dsp.TransferFunctionEstimator('FrequencyRange','centered');
%   hplot = dsp.ArrayPlot('PlotType','Line',...
%                         'XOffset',-500,...
%                         'YLimits',[-120 5],...
%                         'YLabel','Frequency Response (dB)',...
%                         'XLabel','Frequency (Hz)',...
%                         'Title','System Transfer Function');
%   hfilt = dsp.FIRFilter('Numerator',fir1(63,1/4));
%   for ii = 1:100
%      % generate input
%      x = step(hsin) + 0.05*randn(1000,1);
%      % pass through FIR filter
%      y = step(hfilt,x);
%      % estimate transfer function
%      Txy = step(hs,x,y);
%      % plot transfer function
%      step(hplot,20*log10(abs(Txy)))
%   end
%
%   See also dsp.SpectrumEstimator, dsp.CrossSpectrumEstimator, 
%            dsp.SpectrumAnalyzer.

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=TransferFunctionEstimator
            %TransferFunctionEstimator Construct the TransferFunctionEstimator 
            % class. 
        end

        function getFrequencyVector(in) %#ok<MANU>
            % getFrequencyVector Get the vector of frequencies at which the 
            % transfer function is estimated, in Hz. 
            %   getFrequencyVector(Fs) returns the vector of frequencies at which 
            %   the transfer function is estimated, in Hz. Fs is the input sample 
            %   rate, in Hz. Fs is the input sample rate, in Hz.  
            %   If you set the FrequencyRange to 'onesided' and the FFT length, 
            %   NFFT, is even, the frequency vector is of length NFFT/2+1 and it 
            %   covers the interval [0,SampleRate/2]. If you set the FrequencyRange 
            %   to 'onesided' and NFFT is odd, the frequency vector is of length 
            %   (NFFT+1)/2 and it covers the interval [0,SampleRate/2).
            %   If you set the FrequencyRange to 'twosided', the frequency vector is 
            %   of length NFFT and it covers the interval [0, SampleRate). 
            %   If you set the FrequencyRange to 'centered', the frequency vector is 
            %   of length NFFT and it covers the range (-SampleRate/2, SampleRate/2] 
            %   for even length NFFT, and (-SampleRate/2, SampleRate/2) for odd 
            %   length NFFT.
        end

        function getHeaderImpl(in) %#ok<MANU>
        end

        function getIconImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Two inputs: x (input system data) and y (output system data)
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            %Get default parameters group for this System object
        end

        function getRBW(in) %#ok<MANU>
            % getRBW Get the resolution bandwidth of the transfer function 
            %   estimate, in Hz. 
            %   getRBW(Fs) returns the resolution bandwidth, RBW, of the transfer 
            %   function estimate, in Hz. Fs is the input sample rate, in Hz.  
            %   The resolution bandwidth, RBW, is the smallest positive frequency, 
            %   or frequency interval, that can be resolved. It is equal to 
            %   ENBW * Fs/ L, where L is the input length, and ENBW is the
            %   two-sided equivalent noise bandwidth of the window (in Hz). For
            %   example, if Fs = 100, L = 1024, and Window = 'Hann', 
            %   RBW =  enbw(hann(1024)) * 100 / 1024
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
            % The segment length depends on the input frame size, so variable-size
            % inputs are not allowed. 
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
            % Release the Spectrum and cross-spectrum objects
        end

        function resetImpl(in) %#ok<MANU>
            % Reset the Spectrum and cross-spectrum objects
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Setup the Spectrum and cross-Spectrum objects
        end

        function stepImpl(in) %#ok<MANU>
            % Compute the spectrum estimate of x
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %FFTLength FFT length
        %   Specify the length of the FFT that the Transfer Function Estimator 
        %   uses to compute spectral estimates as a positive, integer scalar. 
        %   This property applies when you set the FFTLengthSource property to
        %   'Property'. The default is 128.
        FFTLength;

        %FFTLengthSource Source of the FFT length value
        %   Specify the source of the FFT length value as one of 'Auto' |
        %   'Property'. The default is 'Auto'. When you set this property to
        %   'Auto' the Transfer function Estimator sets the FFT length to the 
        %   input frame size. When you set this property to 'Property' then you 
        %   specify the number of FFT points using the FFTLength property.
        FFTLengthSource;

        % FrequencyRange Frequency range
        %   Specify the frequency range of the transfer function estimator as one 
        %   of 'twosided' | 'onesided' | 'centered'. 
        %   If you set the FrequencyRange to 'onesided', the transfer function 
        %   estimator computes the one-sided transfer function of real input 
        %   signals X and Y. When the FFT length, NFFT, is even, the transfer
        %   function estimate length is NFFT/2+1 and is computed over the 
        %   interval [0,SampleRate/2]. If NFFT is odd, the length of the transfer 
        %   function estimate is equal to (NFFT+1)/2 and the interval is 
        %   [0,SampleRate/2).
        %   If you set the FrequencyRange to 'twosided', the transfer function 
        %   estimator computes the two-sided transfer function of complex or real 
        %   inputs signals X and Y. The length of the transfer function estimate
        %   is equal to NFFT and is computed over [0, SampleRate). 
        %   If you set the FrequencyRange to 'centered', the transfer function 
        %   estimator computes the centered two-sided transfer function of 
        %   complex or real inputs signals X and Y. The length of the transfer 
        %   function estimate is equal to NFFT and is computed over 
        %   (-SampleRate/2, SampleRate/2] and (-SampleRate/2, SampleRate/2) for 
        %   even and odd length NFFT, respectively. 
        %   The default is 'twosided'
        FrequencyRange;

        %SidelobeAttenuation Sidelobe attenuation of window
        %   Specify the sidelobe attenuation of the window as a real, positive
        %   scalar in decibels (dB). This property applies when you set the 
        %   Window property to 'Chebyshev' or 'Kaiser'. The default is 60 dB. 
        SidelobeAttenuation;

        %SpectralAverages Number of spectral averages
        %   Specify the number of spectral averages as a positive, integer
        %   scalar. The Transfer Function Estimator computes the current estimate 
        %   by averaging the last N estimates, where N is
        %   the number of spectral averages defined in the SpectralAverages
        %   property. The default is 8.
        SpectralAverages;

        %Window Window function
        %   Specify a window function for the Transfer Function estimator as one 
        %   of 'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
        %   'Kaiser'. The default is 'Hann'.
        Window;

    end
end
