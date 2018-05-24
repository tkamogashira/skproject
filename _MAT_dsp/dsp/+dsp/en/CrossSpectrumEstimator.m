classdef CrossSpectrumEstimator< handle
%CrossSpectrumEstimator Estimate cross-power spectrum density
%   H = dsp.CrossSpectrumEstimator returns a System object, H, that 
%   computes the frequency cross-power spectrum density of real or complex 
%   signals via the periodogram method and Welch's averaged, modified 
%   periodogram method.
%
%   H = dsp.CrossSpectrumEstimator('Name', Value, ...) returns a Cross-
%   Spectrum Estimator System object, H, with each specified property name 
%   set to the specified value. You can specify additional name-value pair 
%   arguments in any order as (Name1,Value1,...,NameN,ValueN).
%
%   Step method syntax:
%
%   Pxy = step(H, X, Y) computes the frequency cross power spectrum 
%   density , Pxy, of X and Y. X and Y must be of the same size. The 
%   columns of X and Y are treated as independent channels.
%
%   CrossSpectrumEstimator methods:
%
%   step                 - Compute cross power spectrum of inputs (see 
%                          above)
%   release              - Allow property value and input characteristics 
%                          changes, and release Cross Spectrum Estimator 
%                          resources
%   clone                - Create Cross Spectrum Estimator object with same 
%                          property values
%   isLocked             - Display locked status (logical)
%   reset                - Reset the sates of the Cross Spectrum Estimator
%   getRBW               - Get the resolution bandwidth of the spectrum
%   getFrequencyVector   - Get the vector of frequencies at which the
%                          spectrum is estimated
%
%   CrossSpectrumEstimator properties:
%
%   SampleRate                   - Sample rate of input 
%   SpectralAverages             - Number of spectral averages
%   FFTLengthSource              - Source of the FFT length value
%   FFTLength                    - FFT length
%   Window                       - Window function
%   SidelobeAttenuation          - Sidelobe attenuation of window
%   FrequencyRange               - Frequency range of the Spectrum estimate
%
%   % Example
%   %  Compute the cross power spectrum of two noisy sine waves
%   hsin1 = dsp.SineWave('Frequency',200, 'SampleRate', 1000);
%   hsin1.SamplesPerFrame = 1000;
%   hsin2 = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
%   hsin2.SamplesPerFrame =  1000;
%   hs = dsp.CrossSpectrumEstimator('SampleRate', hsin1.SampleRate,...
%                                   'FrequencyRange','centered');
%   hplot = dsp.ArrayPlot('PlotType','Line','XOffset',-500,'YLimits',...
%                       [-150 -60],'YLabel','Power Spectrum Density (Watts/Hz)',...
%                       'XLabel','Frequency (Hz)',...
%                       'Title','Cross Power Spectrum of Two Signals');
%   for ii = 1:10
%     x = step(hsin1) + 0.05*randn(1000,1);
%     y = step(hsin2) + 0.05*randn(1000,1);
%     Pxy = step(hs, x, y);
%     step(hplot,20*log10(abs(Pxy)));
%   end
%
%   See also dsp.SpectrumEstimator, dsp.TransferFunctionEstimator,
%            dsp.SpectrumAnalyzer.

 
    %   Copyright 2013 The MathWorks, Inc.

    methods
        function out=CrossSpectrumEstimator
            %CrossSpectrumEstimator   Construct the CrossSpectrumEstimator class.
        end

        function computeWindowFFT(in) %#ok<MANU>
            % Window the X data
        end

        function getInitialPeriodogramMatrix(in) %#ok<MANU>
            % setup running average matrix
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Two inputs x and y
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
