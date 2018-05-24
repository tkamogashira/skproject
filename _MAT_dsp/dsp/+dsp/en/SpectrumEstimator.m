classdef SpectrumEstimator< handle
%SpectrumEstimator Estimate power spectrum
%   H = dsp.SpectrumEstimator returns a System object, H, that computes the
%   frequency power spectrum of real or complex signals via the periodogram
%   method and Welch's averaged, modified periodogram method.
%
%   H = dsp.SpectrumEstimator('Name', Value, ...) returns a Spectrum
%   Estimator System object, H, with each specified property name set to 
%   the specified value. You can specify additional name-value pair 
%   arguments in any order as (Name1,Value1,...,NameN,ValueN).
%
%   Step method syntax:
%
%   Pxx = step(H, X) computes the frequency spectrum, Pxx, of input X. The
%   columns of X are treated as independent channels.
%
%   SpectrumEstimator methods:
%
%   step                 - Compute power spectrum of input (see above)
%   release              - Allow property value and input characteristics 
%                          changes, and release Spectrum Estimator 
%                          resources
%   clone                - Create Spectrum Estimator object with same 
%                          property values
%   isLocked             - Display locked status (logical)
%   reset                - Reset the sates of the Spectrum Estimator
%   getRBW               - Get the resolution bandwidth of the spectrum
%   getFrequencyVector   - Get the vector of frequencies at which the 
%                          spectrum is estimated 
%
%   SpectrumEstimator properties:
%
%   SampleRate                   - Sample rate of input 
%   SpectrumType                 - Spectrum type
%   SpectralAverages             - Number of spectral averages
%   FFTLengthSource              - Source of the FFT length value
%   FFTLength                    - FFT length
%   Window                       - Window function
%   SidelobeAttenuation          - Sidelobe attenuation of window
%   FrequencyRange               - Frequency range of the Spectrum estimate            
%
%   % Example
%   %  Compute the power spectrum of a noisy sine wave
%   hsin = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
%   hsin.SamplesPerFrame = 1000;
%   hs = dsp.SpectrumEstimator('SampleRate', hsin.SampleRate,...
%                              'SpectrumType','Power',...
%                              'FrequencyRange','centered');
%   hplot = dsp.ArrayPlot('PlotType','Line','XOffset',-500,'YLimits',...
%                         [0 .35],'YLabel','Power Spectrum (Watts)',...
%                         'XLabel','Frequency (Hz)',...
%                         'Title','Power Spectrum of 100 Hz Sine Wave');
%   for ii = 1:10
%     x = step(hsin) + 0.05*randn(1000,1);
%     Pxx = step(hs, x);
%     step(hplot,Pxx);
%   end
%
%   See also dsp.CrossSpectrumEstimator, dsp.TransferFunctionEstimator, 
%            dsp.SpectrumAnalyzer.

 
    %   Copyright 2013 The MathWorks, Inc.

    methods
        function out=SpectrumEstimator
            %SpectrumEstimator   Construct the SpectrumEstimator class. 
        end

        function computeWindowFFT(in) %#ok<MANU>
            % Window the data and compute FFT
        end

        function convertAndScale(in) %#ok<MANU>
        end

        function getInitialPeriodogramMatrix(in) %#ok<MANU>
            % setup running average matrix
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            % Get default parameters group for this System object
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %SpectrumType Spectrum type
        %   Specify the spectrum type as one of 'Power' | 'Power density'. When 
        %   the spectrum type is 'Power', the power spectral density is scaled by 
        %   the equivalent noise bandwidth of the window (in Hz). The default is 
        %   'Power'. This property is tunable.
        SpectrumType;

    end
end
