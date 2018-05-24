classdef TransferFunctionEstimator < matlab.System & matlab.system.mixin.CustomIcon 
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
  
%#codegen
%#ok<*EMCLS>

properties (Nontunable, Dependent, Hidden)
  %SampleRate Sample rate of input
  %   Specify the sample rate of the input in Hertz as a finite numeric
  %   scalar. The default is 1 Hz.
  SampleRate;
end

properties (Nontunable, Dependent)
  %SpectralAverages Number of spectral averages
  %   Specify the number of spectral averages as a positive, integer
  %   scalar. The Transfer Function Estimator computes the current estimate 
  %   by averaging the last N estimates, where N is
  %   the number of spectral averages defined in the SpectralAverages
  %   property. The default is 8.
  SpectralAverages;
  %FFTLengthSource Source of the FFT length value
  %   Specify the source of the FFT length value as one of 'Auto' |
  %   'Property'. The default is 'Auto'. When you set this property to
  %   'Auto' the Transfer function Estimator sets the FFT length to the 
  %   input frame size. When you set this property to 'Property' then you 
  %   specify the number of FFT points using the FFTLength property.
  FFTLengthSource;
  %FFTLength FFT length
  %   Specify the length of the FFT that the Transfer Function Estimator 
  %   uses to compute spectral estimates as a positive, integer scalar. 
  %   This property applies when you set the FFTLengthSource property to
  %   'Property'. The default is 128.
  FFTLength;
  %Window Window function
  %   Specify a window function for the Transfer Function estimator as one 
  %   of 'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
  %   'Kaiser'. The default is 'Hann'.
  Window;
  %SidelobeAttenuation Sidelobe attenuation of window
  %   Specify the sidelobe attenuation of the window as a real, positive
  %   scalar in decibels (dB). This property applies when you set the 
  %   Window property to 'Chebyshev' or 'Kaiser'. The default is 60 dB. 
  SidelobeAttenuation;
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
end

properties (Constant, Hidden)
  % String sets
  FFTLengthSourceSet = matlab.system.StringSet({'Auto','Property'});
  WindowSet = matlab.system.StringSet({...
        'Rectangular', ...
        'Chebyshev', ...
        'Flat Top', ...
        'Hamming', ...
        'Hann', ...
        'Kaiser'});
  FrequencyRangeSet = matlab.system.StringSet({'onesided','twosided','centered'});
end

properties (Access = private)
  % Handle to Spectrum Estimator object
  pSpectrumEstimator;
  % Handle to Cross-Spectrum Estimator object
  pCrossSpectrumEstimator;
end
    
%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  % Constructor
  function obj = TransferFunctionEstimator(varargin)
    %TransferFunctionEstimator Construct the TransferFunctionEstimator 
    % class. 
    coder.allowpcode('plain');
    obj.pSpectrumEstimator = dsp.SpectrumEstimator('SpectrumType',...
                                                   'Power density');
    obj.pCrossSpectrumEstimator = dsp.CrossSpectrumEstimator;
    setProperties(obj, nargin, varargin{:});
  end
  
  % Dependent properties set/get
  
  function set.SampleRate(obj,val)
     coder.internal.warning('dsp:system:SpectrumEstimatorBase:SampleRateDeprecated');
     obj.pSpectrumEstimator.SampleRate = val; 
     obj.pCrossSpectrumEstimator.SampleRate = val;  
  end
  function val = get.SampleRate(obj)
    coder.internal.warning('dsp:system:SpectrumEstimatorBase:SampleRateDeprecated');
    val = obj.pSpectrumEstimator.SampleRate;
  end
  
  function set.SpectralAverages(obj,val)
     obj.pSpectrumEstimator.SpectralAverages = val;  
     obj.pCrossSpectrumEstimator.SpectralAverages = val;  
  end
  function val = get.SpectralAverages(obj)
    val = obj.pSpectrumEstimator.SpectralAverages;
  end
  
  function set.FFTLengthSource(obj,val)
     obj.pSpectrumEstimator.FFTLengthSource = val;  
     obj.pCrossSpectrumEstimator.FFTLengthSource = val;  
  end
  function val = get.FFTLengthSource(obj)
    val = obj.pSpectrumEstimator.FFTLengthSource;
  end
  
  function set.FFTLength(obj,val)
     obj.pSpectrumEstimator.FFTLength = val;  
     obj.pCrossSpectrumEstimator.FFTLength = val;  
  end
  function val = get.FFTLength(obj)
    val = obj.pSpectrumEstimator.FFTLength;
  end
  
  function set.Window(obj,val)
     obj.pSpectrumEstimator.Window = val;  
     obj.pCrossSpectrumEstimator.Window = val;  
  end
  function val = get.Window(obj)
    val = obj.pSpectrumEstimator.Window;
  end
  
  function set.SidelobeAttenuation(obj,val)
     obj.pSpectrumEstimator.SidelobeAttenuation = val;  
     obj.pCrossSpectrumEstimator.SidelobeAttenuation = val;  
  end
  function val = get.SidelobeAttenuation(obj)
    val = obj.pSpectrumEstimator.SidelobeAttenuation;
  end
  
  function set.FrequencyRange(obj,val)
     obj.pSpectrumEstimator.FrequencyRange = val;  
     obj.pCrossSpectrumEstimator.FrequencyRange = val;  
  end
  function val = get.FrequencyRange(obj)
    val = obj.pSpectrumEstimator.FrequencyRange;
  end
  
end

%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods(Access = protected)

  function num = getNumInputsImpl(~)
    % Two inputs: x (input system data) and y (output system data)
    num = 2;
  end

 function num = getNumOutputsImpl(~)
    num = 1;
 end

 function flag = isInputSizeLockedImpl(~,varargin)
    % The segment length depends on the input frame size, so variable-size
    % inputs are not allowed. 
    flag = true;
 end
 
 function H = stepImpl(obj, x,y)
    % Compute the spectrum estimate of x
    pxx = step(obj.pSpectrumEstimator,x);
    % Compute the spectrum estimate of y
    pyx = step(obj.pCrossSpectrumEstimator,y,x);
    % Transfer function estimation
    H = pyx ./ pxx;
 end

 function setupImpl(obj, x , y)
     % Setup the Spectrum and cross-Spectrum objects
    setup(obj.pSpectrumEstimator,x);
    setup(obj.pCrossSpectrumEstimator,y,x);
 end

 function  resetImpl(obj)
    % Reset the Spectrum and cross-spectrum objects
    reset(obj.pSpectrumEstimator);
    reset(obj.pCrossSpectrumEstimator);
 end

 function  releaseImpl(obj)
    % Release the Spectrum and cross-spectrum objects
    release(obj.pSpectrumEstimator);
    release(obj.pCrossSpectrumEstimator);
 end
 
 function validateInputsImpl(obj,x,y)
    validateInputsImpl(obj.pSpectrumEstimator,x);
    validateInputsImpl(obj.pCrossSpectrumEstimator,x,y);
 end

 function flag = isInactivePropertyImpl(obj, prop)
    flag = false;
    switch prop
        case 'SidelobeAttenuation'
            flag = ~strcmp('Chebyshev',obj.Window) && ...
                   ~strcmp('Kaiser',obj.Window);
        case 'FFTLength'
            flag = strcmp(obj.FFTLengthSource,'Auto');
    end
 end

 function s = saveObjectImpl(obj)
    s = saveObjectImpl@matlab.System(obj);
    s.pSpectrumEstimator  = matlab.System.saveObject(obj.pSpectrumEstimator);
    s.pCrossSpectrumEstimator  = matlab.System.saveObject(obj.pCrossSpectrumEstimator);
 end
  
  function loadObjectImpl(obj, s, ~)
      obj.pSpectrumEstimator = matlab.System.loadObject(s.pSpectrumEstimator);
      obj.pCrossSpectrumEstimator =  matlab.System.loadObject(s.pCrossSpectrumEstimator);
      loadObjectImpl@matlab.System(obj, s);
  end
  
  function flag = isInputComplexityLockedImpl(~,~) 
      flag = true; 
  end
  
  function icon = getIconImpl(~)
    icon = sprintf('Discrete\nTransfer Function\nEstimator');
  end

end

methods
  function RBW = getRBW(obj,varargin)
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
    assertScalar(obj);
    if (nargin==1)
        % Deprecated syntax - uses value of deprecated property SampleRate
        % for Fs
        coder.internal.warning('dsp:system:SpectrumEstimatorBase:FunctionSignatureChanged','getRBW','getRBW');
        RBW = obj.pSpectrumEstimator.getRBW();
    else
        RBW = obj.pSpectrumEstimator.getRBW(varargin{:});
    end
  end
  
  function w = getFrequencyVector(obj,varargin)
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
    assertScalar(obj);
   if (nargin==1)
       % Deprecated syntax - uses value of deprecated property SampleRate
       % for Fs
       coder.internal.warning('dsp:system:SpectrumEstimatorBase:FunctionSignatureChanged','getFrequencyVector','getFrequencyVector');
       w = obj.pSpectrumEstimator.getFrequencyVector();
   else
       w = obj.pSpectrumEstimator.getFrequencyVector(varargin{:});
   end
  end
end

methods(Static, Access=protected)
  function group = getPropertyGroupsImpl
    %Get default parameters group for this System object
    
    propertyList = {'SpectralAverages',...
                   'FFTLengthSource','FFTLength',...
                   'Window','SidelobeAttenuation','FrequencyRange'};%#ok<EMCA>
    group = matlab.system.display.Section('Title', 'Parameters', ...
                   'PropertyList', propertyList,...
                   'DependOnPrivatePropertyList',propertyList);
        
  end
  
  function header = getHeaderImpl
    header = matlab.system.display.Header('dsp.TransferFunctionEstimator', ...
        'ShowSourceLink', true, ...
        'Title', 'Discrete Transfer Function Estimator');
  end
end

end
