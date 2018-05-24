classdef SpectrumEstimator < dsp.private.SpectrumEstimatorBase
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
    
%#codegen
%#ok<*EMCLS>

properties
  %SpectrumType Spectrum type
  %   Specify the spectrum type as one of 'Power' | 'Power density'. When 
  %   the spectrum type is 'Power', the power spectral density is scaled by 
  %   the equivalent noise bandwidth of the window (in Hz). The default is 
  %   'Power'. This property is tunable.
  SpectrumType = 'Power';
end

properties (Constant, Hidden)
  % String sets
  SpectrumTypeSet = matlab.system.StringSet({'Power','Power density'});
end

methods
  function obj = SpectrumEstimator(varargin)
    %SpectrumEstimator   Construct the SpectrumEstimator class. 
    obj@dsp.private.SpectrumEstimatorBase(varargin{:})    
  end
end
    
methods(Access = protected)
  function Pxx = computeWindowFFT(obj,x)
     % Window the data and compute FFT
     xout = windowData(obj,x);
     X = computeFFT(obj,xout);
     % Compute power spectrum, use real() to remove type ambiguity in 
     % code generation
     Pxx = real(X.*conj(X));
  end
  
  function  Pout = convertAndScale(obj,P)
    Pout = convertAndScale@dsp.private.SpectrumEstimatorBase(obj,P);
    if strcmp(obj.SpectrumType,'Power')
        Pout = Pout * getRBW(obj);
    end
  end
  
  function avgMatrix = getInitialPeriodogramMatrix(obj)
    % setup running average matrix
    avgMatrix = zeros(getActualFFTLen(obj),...
                      obj.SpectralAverages,...
                      getNumberOfChannels(obj)); 
  end
  
  function s = saveObjectImpl(obj)
     s = saveObjectImpl@dsp.private.SpectrumEstimatorBase(obj);
  end
  
  function loadObjectImpl(obj, s, wasLocked)
     loadObjectImpl@dsp.private.SpectrumEstimatorBase(obj,s,wasLocked);
  end
   
end

methods(Static, Access=protected)
  function group = getPropertyGroupsImpl
     % Get default parameters group for this System object
     group = matlab.system.display.Section('dsp.SpectrumEstimator');   
     ind = find(ismember(group.PropertyList, 'SpectrumType')==1);
     ind2 = setdiff(1:length(group.PropertyList),ind);
     % Modify order of display
     group.PropertyList = [group.PropertyList(ind2), ...
                           group.PropertyList(ind)];
  end
end
    
end