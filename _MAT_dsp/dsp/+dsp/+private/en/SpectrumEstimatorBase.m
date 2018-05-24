classdef SpectrumEstimatorBase< handle
%SpectrumEstimatorBase Abstract base class for spectrum estimation
%   dsp.spectrumEstimator and dsp.CrossSpectrumEstimator inherit from this 
%   base class.  

 
        %   Copyright 2013 The MathWorks, Inc.

    methods
        function out=SpectrumEstimatorBase
            %SpectrumEstimatorBase   Construct the SpectrumEstimatorBase class. 
        end

        function computeFFT(in) %#ok<MANU>
            % Compute FFT
        end

        function convertAndScale(in) %#ok<MANU>
            %convertAndScale Convert to one sided and center DC if needed, scale by
            %Fs to convert to density
        end

        function getActualFFTLen(in) %#ok<MANU>
        end

        function getFrequencyVector(in) %#ok<MANU>
            % getFrequencyVector Get the vector of frequencies at which the spectrum 
            %   is estimated, in Hz. 
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

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function getNumberOfChannels(in) %#ok<MANU>
        end

        function getRBW(in) %#ok<MANU>
            % getRBW Get the resolution bandwidth of the Spectrum, in Hz. 
            %   The resolution bandwidth, RBW, is the smallest positive frequency, 
            %   or frequency interval, that can be resolved. It is equal to 
            %   ENBW * SampleRate/ L, where L is the input length, and ENBW is the
            %   two-sided equivalent noise bandwidth of the window (in Hz). For
            %   example, if SampleRate = 100, L = 1024, and Window = 'Hann', 
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
        end

        function resetImpl(in) %#ok<MANU>
            % Reset the running average counter and index
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Get the segment length and the number of channels from the input. 
        end

        function stepImpl(in) %#ok<MANU>
            % Compute periodogram of new segment
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function windowData(in) %#ok<MANU>
            % Multiply input by the window vector
        end

    end
    methods (Abstract)
        % Abstract method. Children objects redifine this method. 
        computeWindowFFT; %#ok<NOIN>

        getInitialPeriodogramMatrix; %#ok<NOIN>

    end
    properties
        %FFTLength FFT length
        %   Specify the length of the FFT that the Spectrum Estimator uses to
        %   compute spectral estimates as a positive, integer scalar. This
        %   property applies when you set the FFTLengthSource property to
        %   'Property'. The default is 128.
        FFTLength;

        %FFTLengthSource Source of the FFT length value
        %   Specify the source of the FFT length value as one of 'Auto' |
        %   'Property'. The default is 'Auto'. When you set this property to
        %   'Auto' the Spectrum Estimator sets the FFT length to the input frame
        %   size. When you set this property to 'Property' then you specify the 
        %   number of FFT points using the FFTLength property.
        FFTLengthSource;

        % FrequencyRange Frequency range of the spectrum estimate
        %   Specify the frequency range of the spectrum estimator as one 
        %   of 'twosided' | 'onesided' | 'centered'. 
        %   If you set the FrequencyRange to 'onesided', the spectrum estimator 
        %   computes the one-sided spectrum of real input signals. When the FFT 
        %   length, NFFT, is even, the spectrum estimate length is NFFT/2+1 and 
        %   is computed over the interval [0,SampleRate/2]. If NFFT is odd, the 
        %   length of the spectrum estimate is equal to (NFFT+1)/2 and the 
        %   interval is [0,SampleRate/2).
        %   If you set the FrequencyRange to 'twosided', the spectrum estimate
        %   computes the two-sided spectrum of complex or real inputs signals. 
        %   The length of the spectrum estimate is equal to NFFT and is computed 
        %   over [0, SampleRate). 
        %   If you set the FrequencyRange to 'centered', the spectrum estimate 
        %   computes the centered two-sided spectrum of complex or real 
        %   input signals. The length of the spectrum estimate is equal to NFFT 
        %   and is computed over (-SampleRate/2, SampleRate/2] and 
        %   (-SampleRate/2, SampleRate/2) for even and odd length NFFT, 
        %   respectively. 
        %   The default is 'twosided'
        FrequencyRange;

        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite numeric
        %   scalar. The default is 1 Hz.
        SampleRate;

        %SidelobeAttenuation Sidelobe attenuation of window
        %   Specify the sidelobe attenuation of the window as a real, positive
        %   scalar in decibels (dB). This property applies when you set the 
        %   Window property to 'Chebyshev' or 'Kaiser'. The default is 60 dB.
        SidelobeAttenuation;

        %SpectralAverages Number of spectral averages
        %   Specify the number of spectral averages as a positive, integer
        %   scalar. The Spectrum Estimator computes the current power spectrum
        %   estimate by averaging the last N power spectrum estimates, where N is
        %   the number of spectral averages defined in the SpectralAverages
        %   property. The default is 8.
        SpectralAverages;

        %Window Window function
        %   Specify a window function for the spectral estimator as one of
        %   'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
        %   'Kaiser'. The default is 'Hann'.
        Window;

    end
end
