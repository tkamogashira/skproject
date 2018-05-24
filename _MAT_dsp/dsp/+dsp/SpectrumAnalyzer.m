classdef SpectrumAnalyzer < matlabshared.scopes.SystemScope & dynamicprops
%SpectrumAnalyzer Display frequency spectrum of time-domain signals
%   H = dsp.SpectrumAnalyzer returns a System object, H, that displays the
%   frequency spectrum of real or complex signals.
%
%   H = dsp.SpectrumAnalyzer('Name', Value, ...) returns a Spectrum
%   Analyzer System object, H, with each specified property name set to the
%   specified value. You can specify additional name-value pair arguments
%   in any order as (Name1,Value1,...,NameN,ValueN).
%
%   Step method syntax:
%
%   step(H, X) displays the frequency spectrum of double, single or
%   fixed-point precision input X, in the Spectrum Analyzer figure. The
%   columns of X are treated as independent channels.
%
%   SpectrumAnalyzer methods:
%
%   step     - Display spectrum of input in figure (see above)
%   release  - Allow property value and input characteristics changes, and
%              release Spectrum Analyzer resources
%   clone    - Create Spectrum Analyzer object with same property values
%   isLocked - Display locked status (logical)
%   reset    - Clear Spectrum Analyzer figure
%   show     - Turn on visibility of Spectrum Analyzer figure
%   hide     - Turn off visibility of Spectrum Analyzer figure
%
%   SpectrumAnalyzer properties:
%
%   Name                          - Caption to display on Spectrum Analyzer 
%                                   window
%   SpectrumType                  - Choose how to visualize spectrum
%   SampleRate                    - Sample rate of input
%   FrequencySpan                 - Frequency span mode
%   Span                          - Frequency span over which spectrum is 
%                                   computed
%   CenterFrequency               - Frequency over which span is centered
%   StartFrequency                - Start frequency over which spectrum is 
%                                   computed
%   StopFrequency                 - Stop frequency over which spectrum is 
%                                   computed
%   FrequencyResolutionMethod     - Control resolution using RBW or window
%                                   length
%   RBWSource                     - Source of resolution bandwidth value
%   RBW                           - Resolution bandwidth
%   WindowLength                  - Window length
%   FFTLengthSource               - Source of the FFT length value
%   FFTLength                     - FFT length
%   OverlapPercent                - Overlap percentage
%   Window                        - Window function
%   SidelobeAttenuation           - Sidelobe attenuation of window
%   TimeResolutionSource          - Source of time resolution value
%   TimeResolution                - Time resolution
%   TimeSpanSource                - Source of time span value
%   TimeSpan                      - Time span
%   SpectralAverages              - Number of spectral averages
%   PowerUnits                    - Power units
%   ReferenceLoad                 - Reference load
%   PlotMaxHoldTrace              - Option to plot Max-hold trace
%   PlotMinHoldTrace              - Option to plot Min-hold trace
%   PlotNormalTrace               - Option to plot Normal trace
%   PlotAsTwoSidedSpectrum        - Option to plot spectrum as two-sided
%   FrequencyScale                - Frequency scale
%   FrequencyOffset               - Frequency offset
%   Title                         - Display title
%   YLimits                       - Y-axis limits
%   YLabel                        - Y-axis label
%   ShowLegend                    - Option to turn on legend
%   ShowGrid                      - Option to turn on grid
%   Position                      - Spectrum analyzer window position in 
%                                   pixels
%   ReducePlotRate                - Reduce plot rate to improve performance
%
%   % Example: 
%   %   View the power spectrum of a noisy sine wave on Spectrum Analyzer.
%   hsin = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
%   hsin.SamplesPerFrame = 1000;
%   hss = dsp.SpectrumAnalyzer('SampleRate', hsin.SampleRate);
%   for ii = 1:250
%     x = step(hsin) + 0.05*randn(1000,1);
%     step(hss, x);
%   end
%   release(hss);
%
%   See also dsp.SpectrumEstimator

    %   Copyright 2011-2013 The MathWorks, Inc.

properties   
  %Name Caption to display on Spectrum Analyzer window
  %   Specify the caption to display on the Spectrum Analyzer window as any
  %   string. The default is 'Spectrum Analyzer'. This property is tunable.
  Name = 'Spectrum Analyzer';
end    

properties (Dependent)
  %SpectrumType Choose how to visualize spectrum
  %   Specify the spectrum type as one of 'Power' | 'Power density' |
  %   'Spectrogram'. The default is 'Power'. This property is tunable.
  SpectrumType  
end
properties (Nontunable, Dependent)
  %SampleRate Sample rate of input
  %   Specify the sampling rate of the input in Hertz as a finite numeric
  %   scalar. The default is 10 kHz.
  SampleRate
end
properties (Dependent)
  %FrequencySpan Frequency span mode
  %   Specify the frequency span mode as one of 'Full' | 'Span and center
  %   frequency' | 'Start and stop frequencies'. The default is 'Full'.
  %   When you set this property to 'Full', the Spectrum Analyzer computes
  %   and plots the spectrum over the entire Nyquist range which equals
  %   [-SampleRate/2, SampleRate/2]+FrequencyOffset Hz when the
  %   PlotAsTwoSidedSpectrum property is set to true, and [0,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAsTwoSidedSpectrum 
  %   property is set to false. When you set this property to 'Span and 
  %   center frequency', the Spectrum Analyzer computes and plots the 
  %   spectrum over the frequency interval specified by the Span and 
  %   CenterFrequency properties. When you set this property to 'Start and 
  %   stop frequencies' the Spectrum Analyzer computes and plots the 
  %   spectrum over the frequency interval specified by the StartFrequency 
  %   and StopFrequency properties. This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.Span, 
  %             dsp.SpectrumAnalyzer.CenterFrequency,
  %             dsp.SpectrumAnalyzer.StartFrequency,
  %             dsp.SpectrumAnalyzer.StopFrequency.
  FrequencySpan
  %Span Frequency span over which spectrum is computed
  %   Specify the frequency span over which the Spectrum Analyzer computes
  %   and plots the spectrum as a real, positive scalar in Hertz. This
  %   property applies when you set the FrequencySpan property to 'Span and
  %   center frequency'. The overall span defined by the Span and
  %   CenterFrequency properties must fall within the Nyquist frequency
  %   interval which equals [-SampleRate/2, SampleRate/2]+FrequencyOffset
  %   Hz when the PlotAsTwoSidedSpectrum property is set to true, and [0,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAsTwoSidedSpectrum 
  %   property is set to false. The default is 10 kHz. This property is 
  %   tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.CenterFrequency,
  %             dsp.SpectrumAnalyzer.PlotAsTwoSidedSpectrum
  Span  
  %CenterFrequency Frequency over which span is centered
  %   Specify the center frequency of the span over which the Spectrum
  %   Analyzer computes and plots the spectrum. CenterFrequency must be a
  %   real scalar in Hertz. This property applies when you set the
  %   FrequencySpan property to 'Span and center frequency'. The overall
  %   span defined by the Span and CenterFrequency properties must fall
  %   within the Nyquist frequency interval which equals [-SampleRate/2,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAsTwoSidedSpectrum 
  %   property is set to true, and [0, SampleRate/2]+FrequencyOffset Hz 
  %   when the PlotAsTwoSidedSpectrum property is set to false. The default 
  %   is 0 Hz. This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.Span,
  %             dsp.SpectrumAnalyzer.PlotAsTwoSidedSpectrum  
  CenterFrequency
  %StartFrequency Start frequency over which spectrum is computed
  %   Specify the start frequency over which the Spectrum Analyzer computes
  %   and plots the spectrum as a real scalar in Hertz. This property
  %   applies when you set the FrequencySpan property to 'Start and stop
  %   frequencies'. The overall span defined by the StartFrequency and
  %   StopFrequency properties must fall within the Nyquist frequency
  %   interval which equals [-SampleRate/2, SampleRate/2]+FrequencyOffset
  %   Hz when the PlotAsTwoSidedSpectrum property is set to true, and [0,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAswoSidedSpectrum
  %   property is set to false. The default is -5 kHz. This property is
  %   tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.StopFrequency, 
  %             dsp.SpectrumAnalyzer.PlotAsTwoSidedSpectrum  
  StartFrequency
  %StopFrequency Stop frequency over which spectrum is computed
  %   Specify the stop frequency over which the Spectrum Analyzer computes
  %   and plots the spectrum as a real scalar in Hertz. This property
  %   applies when you set the FrequencySpan property to 'Start and stop
  %   frequencies'. The overall span defined by the StartFrequency and
  %   StopFrequency properties must fall within the Nyquist frequency
  %   interval which equals [-SampleRate/2, SampleRate/2]+FrequencyOffset
  %   Hz when the PlotAsTwoSidedSpectrum property is set to true, and [0,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAsTwoSidedSpectrum 
  %   property is set to false. The default is 5 kHz. This property is 
  %   tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.StartFrequency, 
  %             dsp.SpectrumAnalyzer.PlotAsTwoSidedSpectrum    
  StopFrequency
  %FrequencyResolutionMethod Control resolution using RBW or window length
  %   Specify how you want to control the frequency resolution of the
  %   spectrum analyzer as one of 'RBW' | 'WindowLength'. The default is
  %   'RBW'. When you set the property to 'RBW' you control the frequency
  %   resolution of the analyzer directly in Hertz using the RBWSource and
  %   RBW properties. When you set the property to 'WindowLength' you
  %   control the frequency resolution of the analyzer indirectly using the
  %   WindowLength property. The frequency resolution of the analyzer is
  %   given as NENBW*Fs/WindowLength where NENBW is the normalized
  %   effective noise bandwidth of the window currently specified in the
  %   Window property. This property is tunable.
  FrequencyResolutionMethod
  %RBWSource Source of resolution bandwidth value
  %   Specify the source of the resolution bandwidth (RBW) as one of 'Auto'
  %   | 'Property'. The default is 'Auto'. This property applies when
  %   FrequencyResolutionMethod is set to 'RBW'. When you set this property
  %   to 'Auto' the Spectrum Analyzer adjusts the spectral estimation
  %   resolution to ensure that there are 1024 RBW intervals over the
  %   defined frequency span. When you set this property to 'Property' then
  %   you specify the resolution bandwidth directly on the RBW property.
  %   This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.RBW
  RBWSource
  %RBW Resolution bandwidth
  %   Specify the resolution bandwidth (RBW) of the Spectrum Analyzer as a
  %   real, positive, scalar in Hertz. This property applies when you set
  %   the FrequencyResolutionMethod property to 'RBW' and the RBWSource
  %   property to 'Property'. The ratio of the specified span and RBW
  %   values must be at least two (i.e. there must be at least two RBW
  %   intervals over the specified frequency span). The default is 9.76 Hz.
  %   This property is tunable.
  RBW
  %WindowLength Window length
  %   Specify the window length, in samples, used to compute spectral
  %   estimates as an integer scalar greater than two. This property
  %   applies when you set the FrequencyResolutionMethod property to
  %   'WindowLength'. The default is 1024. The frequency resolution of the
  %   analyzer is given as NENBW*Fs/WindowLength where NENBW is the
  %   normalized effective noise bandwidth of the window currently
  %   specified in the Window property. This property is tunable.
  WindowLength   
  %FFTLengthSource Source of the FFT length value
  %   Specify the source of the FFT length value as one of 'Auto' |
  %   'Property'. The default is 'Auto'. This property applies when you set
  %   the FrequencyResolutionMethod property to 'WindowLength'. When you
  %   set this property to 'Auto' the Spectrum Analyzer sets the FFT length
  %   to max(1024,WindowLength). When you set this property to 'Property'
  %   then you specify the number of FFT points using the FFTLength
  %   property. The number of FFT points must be equal to or larger than
  %   the value specified in the WindowLength property. This property is
  %   tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.FFTLength
  FFTLengthSource
  %FFTLength FFT length
  %   Specify the length of the FFT that the Spectrum Analyzer uses to
  %   compute spectral estimates as a positive, integer scalar. This
  %   property applies when you set the FrequencyResolutionMethod property
  %   to 'WindowLength' and the FFTLengthSource property to 'Property'. The
  %   default is 1024. FFTLength must be equal to or larger than
  %   WindowLength. This property is tunable.
  FFTLength  
  %OverlapPercent Overalp percentage
  %   Specify the percentage overlap between the current and previous
  %   buffered window segments as a real, scalar value, greater than or
  %   equal to zero and less than 100. The default is 0. This property is
  %   tunable.
  OverlapPercent  
  %Window Window function
  %   Specify a window function for the spectral estimator as one of
  %   'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
  %   'Kaiser'. The default is 'Hann'. This property is tunable.  
  Window
  %SidelobeAttenuation Sidelobe attenuation of window
  %   Specify the sidelobe attenuation of the window as a real, positive
  %   scalar in decibels (dB). This property must be greater than or equal 
  %   to 45 dB. This property applies when you set the Window property to 
  %   'Chebyshev' or 'Kaiser'. The default is 60 dB. This property is 
  %   tunable.
  SidelobeAttenuation
  %TimeResolutionSource Source of the time resolution value
  %   Specify the source for the time resolution of each spectrogram line
  %   as one of 'Auto' | 'Property'. This property applies when you set the
  %   SpectrumType property to 'Spectrogram'. The default is 'Auto'. 
  %
  %   When FrequencyResolutionMethod is 'RBW' the following rules apply:
  %
  %      When both RBWSource and TimeResolutionSource are set to 'Auto'
  %      then RBW is set such that there are 1024 RBW intervals in one
  %      frequency span. The time resolution is set to 1/RBW.
  %      
  %      When RBWSource is set to 'Auto' and TimeResolutionSource is set to
  %      'Property' then time resolution becomes the master control and RBW
  %      is set to 1/TimeResolution Hz.
  %
  %      When RBWSource is set to 'Property' and TimeResolutionSource is
  %      set to 'Auto' then RBW becomes the master control and the time
  %      resolution is set 1/RBW s.
  %
  %      When both RBWSource and TimeResolutionSource are set to 'Property'
  %      then the specified time resolution value must be equal to or
  %      larger than the minimum attainable time resolution which is
  %      defined by 1/RBW. Several spectral estimates are combined into one
  %      spectrogram line to obtain the desired time resolution.
  %
  %   When FrequencyResolutionMethod is 'WindowLength' the following rules
  %   apply:
  %
  %      When TimeResolutionSource is set to 'Auto' then the time
  %      resolution is set to 1/RBW. In this case RBW is computed from the
  %      window length value as RBW = NENBW*Fs/WindowLength where NENBW is
  %      the normalized effective noise bandwidth of the window currently
  %      specified in the Window property.
  %
  %      When TimeResolutionSource is set to 'Property' then the time
  %      resolution value must be equal to or larger than the minimum
  %      attainable time resolution which equals 1/(NENBW*Fs/WindowLength).
  %      In this case several spectral estimates are combined into one
  %      spectrogram line to obtain the desired time resolution.
  %
  %   This property is tunable.
  TimeResolutionSource
  %TimeResolution Time resolution
  %   Specify the time resolution of each spectrogram line as a positive
  %   scalar in seconds. This property applies when you set the
  %   SpectrumType property to 'Spectrogram', and  the TimeResolutionSource
  %   property to 'Property'. The default is 1 ms. This property is
  %   tunable.
  TimeResolution  
  %TimeSpanSource Source of time span value
  %   Specify the source for the time span of the spectrogram as one of
  %   'Auto' | 'Property'. The default is 'Auto'. This property applies
  %   when the SpectrumType property is set to 'Spectrogram'. When set to
  %   'Auto' the spectrogram displays 100 spectrogram lines at any given
  %   time. When set to 'Property' you specify the time duration of the
  %   spectrogram in seconds using the 'TimeSpan' property. The specified
  %   time span must be at least two times larger than the duration of the
  %   number of samples required for a spectral update. This property is
  %   tunable.
  TimeSpanSource
  %TimeSpan Time span
  %   Specify the time span of the spectrogram display as a positive scalar
  %   in seconds. This property applies when you set the SpectrumType
  %   property to 'Spectrogram', and  the TimeSpanSource property to
  %   'Property'. The specified time span must be at least two times larger
  %   than the duration of the number of samples required for a spectral
  %   update. The default is 100 ms. This property is tunable.
  TimeSpan  
  %SpectralAverages Number of spectral averages
  %   Specify the number of spectral averages as a positive, integer
  %   scalar. The Spectrum Analyzer computes the current power spectrum
  %   estimate by averaging the last N power spectrum estimates, where N is
  %   the number of spectral averages defined in the SpectralAverages
  %   property. This property applies when the SpectrumType property is set
  %   to 'Power density' or 'Power'. The default is 1. This property is
  %   tunable.
  SpectralAverages
  %PowerUnits Power units
  %   Specify the units in which the Spectrum Analyzer displays power
  %   values as one of 'dBm' | 'dBW' | 'Watts'. The default is 'dBm'. This
  %   property is tunable.
  PowerUnits
  %ReferenceLoad Reference load
  %   Specify the load that the Spectrum Analyzer uses as a reference to
  %   compute power values as a real, positive scalar in Ohms. The default
  %   is 1 Ohm. This property is tunable.
  ReferenceLoad
  %PlotMaxHoldTrace Max-hold trace flag
  %   Set this property to true so that the Spectrum Analyzer computes and
  %   plots the max-hold spectrum of each input channel. This property
  %   applies when the SpectrumType property is set to 'Power density' or
  %   'Power'. The max-hold spectrum is computed by keeping, at each
  %   frequency bin, the maximum value of all the power spectrum estimates.
  %   Toggling the PlotMaxHoldTrace control resets the max-hold
  %   computations. The default is false. This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.PlotMinHoldTrace,
  %             dsp.SpectrumAnalyzer.PlotNormalTrace  
  PlotMaxHoldTrace
  %PlotMinHoldTrace Min-hold trace flag
  %   Set this property to true so that the Spectrum Analyzer computes and
  %   plots the min-hold spectrum of each input channel. This property
  %   applies when the SpectrumType property is set to 'Power density' or
  %   'Power'. The min-hold spectrum is computed by keeping, at each
  %   frequency bin, the minimum value of all the power spectrum estimates.
  %   Toggling the PlotMinHoldTrace control resets the min-hold
  %   computations. The default is false. This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.PlotMaxHoldTrace,
  %             dsp.SpectrumAnalyzer.PlotNormalTrace    
  PlotMinHoldTrace
  %PlotNormalTrace Normal trace flag
  %   Set this property to false to remove the normal traces (i.e. the
  %   traces displaying the free running spectral estimates) from the
  %   Spectrum Analyzer display. Note that even though the traces are
  %   removed from the display, the spectral computations continue. This
  %   property applies when the SpectrumType property is set to 'Power
  %   density' or 'Power'. The default is true. This property is tunable.
  %
  %   See also: dsp.SpectrumAnalyzer.PlotMaxHoldTrace,
  %             dsp.SpectrumAnalyzer.PlotMinHoldTrace      
  PlotNormalTrace
end
properties (Nontunable, Dependent)
  %PlotAsTwoSidedSpectrum Two sided spectrum flag
  %   Set this property to true so that the Spectrum Analyzer computes two
  %   sided spectral estimates. Set this property to false to obtain one
  %   sided spectral estimates. In this case, the input must be real.
  PlotAsTwoSidedSpectrum
end
properties (Dependent)
  %FrequencyScale Frequency scale
  %   Specify the frequency scale as one of 'Linear' | 'Log'. The default
  %   is linear. You cannot set the frequency scale to 'Log' when the
  %   PlotAsTwoSidedSpectrum property is set to true. This property applies
  %   when the SpectrumType property is set to 'Power density' or 'Power'.
  %   This property is tunable.
  FrequencyScale
end
properties (Nontunable, Dependent)
  %FrequencyOffset Frequency offset
  %   Specify a frequency offset as a real scalar value in Hertz. The
  %   frequency axis values are offset by the value specified in the
  %   FrequencyOffset property. The overall span defined by the Span and
  %   CenterFrequency properties, or by the StartFrequency and
  %   StopFrequency properties must fall within the Nyquist frequency
  %   interval which equals [-SampleRate/2, SampleRate/2]+FrequencyOffset
  %   Hz when the PlotAsTwoSidedSpectrum property is set to true, and [0,
  %   SampleRate/2]+FrequencyOffset Hz when the PlotAsTwoSidedSpectrum 
  %   property is set to false. The default is 0 Hz.
  FrequencyOffset 
end
properties (Dependent)
  %Title Display title
  %   Specify the display title as a string. The default value is ''. This
  %   property is tunable.  
  Title
  %YLimits Y-axis limits
  %   Specify the y-axis limits as a two-element numeric vector: [ymin
  %   ymax]. This property applies when the SpectrumType property is set to
  %   'Power density' or 'Power'. This property is tunable.
  YLimits
  %YLabel Y-axis label
  %   Specify the y-axis label as a string. The default value is ''. This
  %   property applies when the SpectrumType property is set to 'Power
  %   density' or 'Power'. This property is tunable.
  YLabel
  %ShowLegend Show or hide legend
  %   When this property is set to false, no legend is displayed. When this
  %   property is set to true, a legend with automatic string labels for
  %   each input channel is displayed. This property applies when the
  %   SpectrumType property is set to 'Power density' or 'Power'. The
  %   default is false. This property is tunable.
  ShowLegend
  %ShowGrid Option to turn on grid
  %   Set this property to true to turn on the grid. The default is false.
  %   This property is tunable.
  ShowGrid  
  %ReducePlotRate Reduce plot rate to improve performance
  %   Set this property to false to update the plot after each PSD
  %   computation (when the SpectrumType property is set to 'Power density'
  %   or 'Power') or after each spectrogram line computation (when the
  %   SpectrumType property is set to 'Spectrogram'). This will negatively
  %   impact performance. The default is true. This property is tunable.
  ReducePlotRate
end

properties (Constant, Hidden)
  WindowSet = matlab.system.StringSet({...
    'Rectangular', ...
    'Chebyshev', ...
    'Flat Top', ...
    'Hamming', ...
    'Hann', ...
    'Kaiser'});
  FFTLengthSourceSet = matlab.system.StringSet({'Auto','Property'});
  TimeSpanSourceSet = matlab.system.StringSet({'Auto','Property'});
  TimeResolutionSourceSet = matlab.system.StringSet({'Auto','Property'});
  RBWSourceSet = matlab.system.StringSet({'Auto','Property'});
  PowerUnitsSet = matlab.system.StringSet({'dBm', 'dBW', 'Watts'});
  SpectrumTypeSet = matlab.system.StringSet({...
    'Power','Power density','Spectrogram'});
  FrequencySpanSet = matlab.system.StringSet({'Full',...
    'Span and center frequency','Start and stop frequencies'}); 
  FrequencyScaleSet =  matlab.system.StringSet({'Linear','Log'});
  FrequencyResolutionMethodSet = matlab.system.StringSet({'RBW','WindowLength'});
end
    

properties (Access = private)
  %InputFrameSize Cache input frame size
  InputFrameSize
end

%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  %------------------------------------------------------------------------      
  function obj = SpectrumAnalyzer(varargin)
    %SpectrumAnalyzer   Construct the SpectrumAnalyzer class.    
    
    % Prevent accidental usage without DSP toolbox.
    [b, ~, ~, msgObj] = isfdtbxinstalled;
    if ~b
      throwAsCaller(MException(msgObj));
    elseif ~isdeployed
      [tf, msg] = license('checkout','Signal_Blocks');
      if ~tf
        error(msg);
      end
    end
      
    obj@matlabshared.scopes.SystemScope();
    obj.Position = uiscopes.getDefaultPosition([560 420]);
    setProperties(obj, nargin, varargin{:});    
  end  
  
%--------------------------------------------------------------------------
% Set/Get methods
%--------------------------------------------------------------------------  
  function set.Name(obj, value)    
    % Set the name in the scope.
    setScopeName(obj, value);
    obj.Name = value;
  end
  %------------------------------------------------------------------------        
  function set.SpectrumType(obj, value)    
    setVisualProperty(obj, 'SpectrumType', value, false);
  end
  function value = get.SpectrumType(obj)    
    value = getVisualProperty(obj, 'SpectrumType', false);
  end      
  %------------------------------------------------------------------------        
  function set.SampleRate(obj, value)    
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','SampleRate');    
    setVisualProperty(obj, 'SampleRate', value, true);
  end
  function value = get.SampleRate(obj)    
    value = getVisualProperty(obj, 'SampleRate', true);
  end
  %------------------------------------------------------------------------
  function set.FrequencySpan(obj, value)    
    setVisualProperty(obj, 'FrequencySpan', value, false);       
    if isLocked(obj) && ~isCorrectionMode(obj)
      validatePropertiesImpl(obj);
    end                    
  end
  function value = get.FrequencySpan(obj)
    value = getVisualProperty(obj, 'FrequencySpan', false);
  end
  %------------------------------------------------------------------------
  function set.Span(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','Span');    
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj,'Span')
      % Check valid span using the new span value. Do not do cross checking
      % with other properties if property is inactive or if visual is in
      % correction mode.
      span = value;
      Fstart = obj.CenterFrequency - span/2;
      Fstop = obj.CenterFrequency + span/2;
      validateSpan(obj,Fstart,Fstop);      
    end
    setVisualProperty(obj, 'Span', value, true);
  end
  function value = get.Span(obj)
    value = getVisualProperty(obj, 'Span', true);
  end
  %------------------------------------------------------------------------
  function set.CenterFrequency(obj, value)
    validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','CenterFrequency');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj, 'CenterFrequency')
      % Check valid span using the new CF value. Do not do cross checking
      % with other properties if property is inactive or if visual is in
      % correction mode.
      CF = value;
      Fstart = CF - obj.Span/2;
      Fstop = CF + obj.Span/2;
      validateSpan(obj,Fstart,Fstop);      
    end
    setVisualProperty(obj, 'CenterFrequency', value, true);
  end
  function value = get.CenterFrequency(obj)
    value = getVisualProperty(obj, 'CenterFrequency', true);    
  end  
  %------------------------------------------------------------------------
  function set.StartFrequency(obj, value)
    validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','StartFrequency');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj,'StartFrequency')
      % Check valid span using the new Fstart value. Do not do cross
      % checking with other properties if property is inactive or if visual
      % is in correction mode.
      Fstart = value;
      Fstop = obj.StopFrequency;
      validateSpan(obj,Fstart,Fstop);      
    end
    setVisualProperty(obj, 'StartFrequency', value, true);
  end
  function value = get.StartFrequency(obj)
    value = getVisualProperty(obj, 'StartFrequency', true);    
  end    
  %------------------------------------------------------------------------
  function set.StopFrequency(obj, value)
    validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','StopFrequency');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj, 'StopFrequency')
      % Check valid span using the new Fstop value. Do not do cross
      % checking with other properties if property is inactive or if visual
      % is in correction mode.
      Fstart = obj.StartFrequency;
      Fstop = value;
      validateSpan(obj,Fstart,Fstop);
    end
    setVisualProperty(obj, 'StopFrequency', value, true);
  end
  function value = get.StopFrequency(obj)
    value = getVisualProperty(obj, 'StopFrequency', true);    
  end      
  %------------------------------------------------------------------------
  function set.FrequencyResolutionMethod(obj, value)
    setVisualProperty(obj, 'FrequencyResolutionMethod', value, false);
  end
  function value = get.FrequencyResolutionMethod(obj)
    value = getVisualProperty(obj, 'FrequencyResolutionMethod', false);
  end
  %------------------------------------------------------------------------
  function set.RBWSource(obj, value)            
    setVisualProperty(obj, 'RBWSource', value, false);
    if isLocked(obj) && strcmp(value,'Property')  && ~isCorrectionMode(obj) ...
        && ~isInactivePropertyImpl(obj, 'RBW')
      Fstart = getFstart(obj);
      Fstop = getFstop(obj);
      validateSpan(obj,Fstart,Fstop, obj.RBW, value);
    end                        
        
  end
  function value = get.RBWSource(obj)
    value = getVisualProperty(obj, 'RBWSource', false);
  end    
  %------------------------------------------------------------------------
  function set.RBW(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','RBW');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj, 'RBW')
      % Check validity of RBW only if locked, not in correction mode and if
      % property is active.
      Fstart = getFstart(obj);
      Fstop = getFstop(obj);
      RBW = value;
      validateSpan(obj,Fstart,Fstop,RBW);
    end
    setVisualProperty(obj, 'RBW', value, true);
  end
  function value = get.RBW(obj)
    value = getVisualProperty(obj, 'RBW', true);    
  end   
  %------------------------------------------------------------------------
  function set.WindowLength(obj, value)
    validateattributes(value,{'double'}, {'positive','real','integer','scalar','>',2,'finite','nonnan'},'','WindowLength');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj, 'FFTLength')
      NFFT = getVisualProperty(obj, 'FFTLength', true);
      if NFFT < value
        sendError(obj,'measure:SpectrumAnalyzer:InvalidFFTLength')
      end
    end    
    setVisualProperty(obj, 'WindowLength', value, true);
  end
  function value = get.WindowLength(obj)
    value = getVisualProperty(obj, 'WindowLength', true);    
  end     
  %------------------------------------------------------------------------
  function set.TimeSpanSource(obj, value)            
    setVisualProperty(obj, 'TimeSpanSource', value, false);
  end
  function value = get.TimeSpanSource(obj)
    value = getVisualProperty(obj, 'TimeSpanSource', false);
  end    
  %------------------------------------------------------------------------
  function set.TimeSpan(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','TimeSpan'); 
    setVisualProperty(obj, 'TimeSpan', value, true);
  end
  function value = get.TimeSpan(obj)
    value = getVisualProperty(obj, 'TimeSpan', true);    
  end  
  %------------------------------------------------------------------------
  function set.TimeResolutionSource(obj, value)            
    setVisualProperty(obj, 'TimeResolutionSource', value, false);
  end
  function value = get.TimeResolutionSource(obj)
    value = getVisualProperty(obj, 'TimeResolutionSource', false);
  end    
  %------------------------------------------------------------------------
  function set.TimeResolution(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','TimeResolution');
    setVisualProperty(obj, 'TimeResolution', value, true);
  end
  function value = get.TimeResolution(obj)
    value = getVisualProperty(obj, 'TimeResolution', true);    
  end        
  %------------------------------------------------------------------------
  function set.OverlapPercent(obj, value)
   validateattributes(value,{'double'}, {'real','scalar','>=',0,'<',100,'nonnan'},'','OverlapPercent');               
   setVisualProperty(obj, 'OverlapPercent', value, true);
  end
  function value = get.OverlapPercent(obj)
    value = getVisualProperty(obj, 'OverlapPercent', true);    
  end    
  %------------------------------------------------------------------------
  function set.Window(obj, value)    
    if any(strcmp({'Chebyshev','Kaiser'},value))
      % Try to get the visual property SidelobeAttenuation to ensure it can
      % be evaluated (it might be set to a variable undefined in the
      % workspace).
      getVisualProperty(obj, 'SidelobeAttenuation',true);
    end        
    setVisualProperty(obj, 'Window', value, false);    
  end
  function value = get.Window(obj)
    value = getVisualProperty(obj, 'Window', false);
  end      
  %------------------------------------------------------------------------
  function set.SidelobeAttenuation(obj, value)
   validateattributes(value,{'double'}, {'positive','real','scalar','>=',45,'finite','nonnan'},'','SidelobeAttenuation');               
   setVisualProperty(obj, 'SidelobeAttenuation', value, true);
  end
  function value = get.SidelobeAttenuation(obj)
    value = getVisualProperty(obj, 'SidelobeAttenuation', true);    
  end  
  %------------------------------------------------------------------------
  function set.SpectralAverages(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','integer','finite','nonnan'},'','SpectralAverages');
    setVisualProperty(obj, 'SpectralAverages', value, true);
  end
  function value = get.SpectralAverages(obj)
    value = getVisualProperty(obj, 'SpectralAverages', true);
  end  
  %------------------------------------------------------------------------
  function set.FFTLengthSource(obj, value)    
    if strcmp(value,'Property') && ~isInactivePropertyImpl(obj, 'FFTLengthSource')
      % Try to get the visual property FFTLength to ensure it can be
      % evaluated (it might be set to a variable undefined in the
      % workspace).
     getVisualProperty(obj, 'FFTLength',true);
    end
    
    setVisualProperty(obj, 'FFTLengthSource', value, false);
  end
  function value = get.FFTLengthSource(obj)
    value = getVisualProperty(obj, 'FFTLengthSource', false);
  end  
  %------------------------------------------------------------------------
  function set.FFTLength(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','integer','finite','nonnan'},'','FFTLength');
    if isLocked(obj) && ~isCorrectionMode(obj) && ~isInactivePropertyImpl(obj, 'FFTLength')
      WL = getVisualProperty(obj, 'WindowLength', true);
      if value < WL
        sendError(obj,'measure:SpectrumAnalyzer:InvalidFFTLength')
      end
    end
    setVisualProperty(obj, 'FFTLength', value, true);
    
  end
  function value = get.FFTLength(obj)
    value = getVisualProperty(obj, 'FFTLength', true);    
  end    
  %------------------------------------------------------------------------
  function set.PowerUnits(obj, value)
    setVisualProperty(obj, 'PowerUnits', value, false);
  end
  function value = get.PowerUnits(obj)
    value = getVisualProperty(obj, 'PowerUnits', false);
  end  
  %------------------------------------------------------------------------
  function set.ReferenceLoad(obj, value)
    validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','ReferenceLoad');
    setVisualProperty(obj, 'ReferenceLoad', value, true);
  end
  function value = get.ReferenceLoad(obj)
    value = getVisualProperty(obj, 'ReferenceLoad', true);
  end  
  %------------------------------------------------------------------------
  function set.FrequencyOffset(obj, value)
    validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','FrequencyOffset');
    setVisualProperty(obj, 'FrequencyOffset', value, true);
  end
  function value = get.FrequencyOffset(obj)
    value = getVisualProperty(obj, 'FrequencyOffset', true);
  end     
  %------------------------------------------------------------------------
  function set.PlotMaxHoldTrace(obj, value)
      validateattributes(value,{'logical'}, {'scalar'},'','PlotMaxHoldTrace');
      setVisualProperty(obj, 'MaxHoldTrace', value, false);
  end
  function value = get.PlotMaxHoldTrace(obj)
      value = getVisualProperty(obj, 'MaxHoldTrace', false);
  end
  %------------------------------------------------------------------------
  function set.PlotMinHoldTrace(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','PlotMinHoldTrace');
    setVisualProperty(obj, 'MinHoldTrace', value, false);
  end
  function value = get.PlotMinHoldTrace(obj)
    value = getVisualProperty(obj, 'MinHoldTrace', false);
  end
  %------------------------------------------------------------------------
  function set.PlotNormalTrace(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','PlotNormalTrace');
    setVisualProperty(obj, 'NormalTrace', value, false);
  end
  function value = get.PlotNormalTrace(obj)
    value = getVisualProperty(obj, 'NormalTrace', false);
  end 
  %------------------------------------------------------------------------
  function set.PlotAsTwoSidedSpectrum(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','PlotAsTwoSidedSpectrum');
    setVisualProperty(obj, 'TwoSidedSpectrum', value, false);    
    if ~value
      obj.FrequencyScale = 'Linear';
    end        
  end
  function value = get.PlotAsTwoSidedSpectrum(obj)
    value = getVisualProperty(obj, 'TwoSidedSpectrum', false);
  end
  %------------------------------------------------------------------------
  function set.FrequencyScale(obj, value)    
    if obj.PlotAsTwoSidedSpectrum && strcmp(value,'Log')      
      sendError(obj,'measure:SpectrumAnalyzer:InvalidFreqScale')   
    end            
    setVisualProperty(obj, 'FrequencyScale', value, false);     
  end
  function value = get.FrequencyScale(obj)
    value = getVisualProperty(obj, 'FrequencyScale', false);
  end
  %------------------------------------------------------------------------      
  function set.YLimits(obj, value)
    % Check that value is a 2-element numeric vector
    if ~all(isnumeric(value)) || ~all(isfinite(value)) || ...
        numel(value)~=2 || value(1) >= value(2)
       error(getString(message('measure:SpectrumAnalyzer:InvalidYLimits','YLimits')));
    end        
    setVisualProperty(obj, 'MinYLim', value(1), true);
    setVisualProperty(obj, 'MaxYLim', value(2), true);
  end
  function value = get.YLimits(obj)
    value = ...
      [getVisualProperty(obj, 'MinYLim', true) ...
      getVisualProperty(obj, 'MaxYLim', true)];
  end
  %------------------------------------------------------------------------        
  function set.ShowGrid(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','ShowGrid');
    setVisualProperty(obj, 'Grid', value);
  end  
  function value = get.ShowGrid(obj)
    value = getVisualProperty(obj, 'Grid');
  end 
   %------------------------------------------------------------------------        
  function set.ReducePlotRate(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','ReducePlotRate');
    setVisualProperty(obj, 'ReduceUpdates', value);
  end  
  function value = get.ReducePlotRate(obj)
    value = getVisualProperty(obj, 'ReduceUpdates');
  end  
  %------------------------------------------------------------------------
  function set.Title(obj, value)      
    validateattributes(value,{'char'}, {},'','Title');   
    setVisualProperty(obj, 'Title', value, false);
  end  
  function value = get.Title(obj)
    value = getVisualProperty(obj,'Title', false);
  end  
  %------------------------------------------------------------------------
  function set.YLabel(obj, value)   
    validateattributes(value,{'char'}, {},'','YLabel');
    setVisualProperty(obj, 'YLabel', value);
  end  
  function value = get.YLabel(obj)
    value = getVisualProperty(obj,'YLabel');
  end  
  %------------------------------------------------------------------------        
  function set.ShowLegend(obj, value)
    validateattributes(value,{'logical'}, {'scalar'},'','ShowLegend');
    setVisualProperty(obj, 'Legend', value);
  end  
  function value = get.ShowLegend(obj)
    value = getVisualProperty(obj, 'Legend');
  end
end
%--------------------------------------------------------------------------
% Public, hidden methods
%--------------------------------------------------------------------------
methods (Hidden)
  function st = getInputSampleTime(obj)
    % Return frame time
    st = 1./obj.SampleRate;               
    st = st.*obj.InputFrameSize;        
  end
end

%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods (Access = protected)
  function hScopeCfg = getScopeCfg(~)
    hScopeCfg = spbscopes.SpectrumAnalyzerSystemObjectCfg;
  end
  %------------------------------------------------------------------------          
  function num = getNumInputsImpl(~)
    num = 1;
  end
  %------------------------------------------------------------------------          
  function validateInputsImpl(obj,x)
      if ~ismatrix(x)
          sendError(obj,'MATLAB:system:inputDimsMoreThanTwo');
      end
      channLim = 50;
      if size(x,2) > channLim
          sendError(obj,'measure:SpectrumAnalyzer:TooManyInputChannels',channLim);
      end
  end
  %------------------------------------------------------------------------          
  function validatePropertiesImpl(obj)    
    % Verify correct span            

    % Since properties can be set to variables in the visual, we need to
    % check the validity of the types and values.
    validateattributes(obj.SampleRate,{'double'}, {'positive','real','scalar'},'','SampleRate');                
    
    if strcmp(obj.FrequencySpan, 'Span and center frequency')
      validateattributes(obj.Span,{'double'}, {'positive','real','scalar'},'','Span');            
      validateattributes(obj.CenterFrequency,{'double'}, {'real','scalar'},'','CenterFrequency');          
    elseif strcmp(obj.FrequencySpan, 'Start and stop frequencies')
      validateattributes(obj.StartFrequency,{'double'}, {'real','scalar'},'','StartFrequency');  
      validateattributes(obj.StopFrequency,{'double'}, {'real','scalar'},'','StopFrequency');   
    end
    
    if strcmp(obj.RBWSource,'Property')
      validateattributes(obj.RBW,{'double'}, {'positive','real','scalar'},'','RBW');
    end
    
    if strcmp(obj.FFTLengthSource,'Property')
      validateattributes(obj.FFTLength,{'double'}, {'positive','real','scalar','integer'},'','FFTLength');
    end
    
    validateattributes(obj.ReferenceLoad,{'double'}, {'positive','real','scalar'},'','ReferenceLoad');
    
    validateattributes(obj.FrequencyOffset,{'double'}, {'real','scalar'},'','FrequencyOffset');
    
    if any(strcmp({'Chebyshev','Kaiser'},obj.Window))
      validateattributes(obj.SidelobeAttenuation,{'double'}, {'positive','real','scalar'},'','SidelobeAttenuation');
    end
    
    if strcmp(obj.SpectrumType,'Spectrogram')
      % Validate properties relevant when spectrum type is spectrogram
      
      if strcmp(obj.TimeSpanSource,'Property')
        validateattributes(obj.TimeSpan,{'double'}, {'positive','real','scalar'},'','TimeSpan');
      end
      if strcmp(obj.TimeResolutionSource,'Property')
        validateattributes(obj.TimeResolution,{'double'}, {'positive','real','scalar'},'','TimeResolution');
      end
      
    else
      % Validate properties relevant when spectrum type is power or power
      % density
      
      validateattributes(obj.SpectralAverages,{'double'}, {'positive','real','scalar','integer'},'','SpectralAverages');
      
      % All traces cannot be off simultaneously
      if ~obj.PlotMaxHoldTrace && ~obj.PlotMinHoldTrace && ~obj.PlotNormalTrace
        sendError(obj,'measure:SpectrumAnalyzer:AllTracesOff')
      end
      
    end
        
    % Check overall span --> must be within Nyquist interval    
    span = getSpan(obj);
    Fstart = getFstart(obj);
    Fstop = getFstop(obj);               
    if ~strcmp(obj.FrequencySpan,'Full')      
      if (Fstart >= Fstop) && ~isCorrectionMode(obj)
        sendError(obj,'measure:SpectrumAnalyzer:FstartGreaterThanFstop')          
      end
      
      NyquistRange = [(-obj.SampleRate/2)*obj.PlotAsTwoSidedSpectrum obj.SampleRate/2] + obj.FrequencyOffset;      
      if ((Fstart < NyquistRange(1)) || (Fstop > NyquistRange(2))) && ~isCorrectionMode(obj)
        [NyquistRange, ~, unitsNyquistRange] = engunits(NyquistRange);
        sendError(obj,'measure:SpectrumAnalyzer:InvalidSpan',num2str(NyquistRange(1)),num2str(NyquistRange(2)),unitsNyquistRange)
      end      
    end   
    
    % Span/RBW must greater than two
    if  strcmp(obj.RBWSource,'Property')
      if ((span/obj.RBW) <= 2) && ~isCorrectionMode(obj)
        sendError(obj,'measure:SpectrumAnalyzer:InvalidSpanRBW')
      end
    end        
  end
  %------------------------------------------------------------------------

  function setupImpl(obj, x)
	validateInputs(obj,x);
    obj.InputFrameSize = size(x, 1);
    setupImpl@matlabshared.scopes.SystemScope(obj, x);
    onSourceRun(obj.pFramework.Visual);
    % Add a tooltip to the Simulation time in status bar
    statusBar = obj.pFramework.UIMgr.findchild('StatusBar');
    hFrame = statusBar.findwidget('StdOpts','Frame');
    hFrame.Tooltip = obj.pSource.getTimeStatusTooltip;    
  end
  %------------------------------------------------------------------------    
  function S = saveObjectImpl(obj)
    S = saveObjectImpl@matlabshared.scopes.SystemScope(obj);    
    S.CurrentLineProperties = getPropValue(obj.pFramework.Visual, 'LineProperties');
  end  
  %------------------------------------------------------------------------  
  function loadObjectImpl(obj, S, wasLocked)
    loadObjectImpl@matlabshared.scopes.SystemScope(obj, S, wasLocked);    
    if wasLocked
      onSourceRun(obj.pFramework.Visual); 
      if strcmp(obj.SpectrumType,'Spectrogram')
        % Reset to ensure we blank the screen
        reset(obj.pFramework.Visual);
      end
    else
      setPropValue(obj.pFramework.Visual,'IsValidSettingsDialogReadouts',false);
    end
    
    setPropValue(obj.pFramework.Visual, 'LineProperties',S.CurrentLineProperties);
    loadLineProperties(obj.pFramework.Visual);    
  end            
%------------------------------------------------------------------------
  function flag = isInactivePropertyImpl(obj, prop)
      flag = false;
      switch prop
        case {'Span','CenterFrequency'}
          flag = any(strcmp({'Full','Start and stop frequencies'},obj.FrequencySpan));
        case {'StartFrequency','StopFrequency'}
          flag = any(strcmp({'Full','Span and center frequency'},obj.FrequencySpan));          
        case 'RBWSource'
          flag = ~strcmp(obj.FrequencyResolutionMethod,'RBW');
        case 'RBW'
          flag = ~strcmp(obj.FrequencyResolutionMethod,'RBW') | strcmp(obj.RBWSource,'Auto');
        case 'WindowLength'
          flag = ~strcmp(obj.FrequencyResolutionMethod,'WindowLength');
        case 'FFTLengthSource'
          flag = ~strcmp(obj.FrequencyResolutionMethod,'WindowLength');
        case 'FFTLength'
          flag = ~strcmp(obj.FrequencyResolutionMethod,'WindowLength') | strcmp(obj.FFTLengthSource,'Auto');
        case 'SidelobeAttenuation'
          flag = ~any(strcmp({'Chebyshev','Kaiser'},obj.Window));      
        case {'SpectralAverages','PlotMaxHoldTrace','PlotMinHoldTrace',...
            'PlotNormalTrace','FrequencyScale','YLimits','YLabel','ShowLegend'}
          flag = strcmp(obj.SpectrumType,'Spectrogram');    
        case {'TimeSpanSource','TimeResolutionSource'}
          flag = ~strcmp(obj.SpectrumType,'Spectrogram');              
        case 'TimeSpan'
          flag = ~strcmp(obj.SpectrumType,'Spectrogram') | strcmp(obj.TimeSpanSource,'Auto');     
        case 'TimeResolution'
          flag = ~strcmp(obj.SpectrumType,'Spectrogram') | strcmp(obj.TimeResolutionSource,'Auto');               
      end
  end 
  %------------------------------------------------------------------------
  function resetImpl(obj)
    resetImpl@matlabshared.scopes.SystemScope(obj);
    reset(obj.pFramework.Visual.SpectrumObject);
    flush(obj.pFramework.Visual.DataBuffer);
  end 
   %------------------------------------------------------------------------
  function releaseImpl(obj)
    releaseImpl@matlabshared.scopes.SystemScope(obj);
    % Flush buffer only if framework has not been cleared
    if ishandle(obj.pFramework)      
      if obj.ReducePlotRate
        while ~obj.pFramework.Visual.DataBuffer.isTimeUp
          % No op, let the timer time out
        end
        if obj.pFramework.Visual.DataBuffer.IsReady
          % If buffer has data, update display and sim time one more time.
          % This ensures correct simulation time when we are in
          % asynchronous mode.
          update(obj.pFramework.DataSource.Updater);
        end
      end
        flush(obj.pFramework.Visual.DataBuffer);
    end
  end 
end
%--------------------------------------------------------------------------
% Private methods
%--------------------------------------------------------------------------
 methods(Access = private)
  %------------------------------------------------------------------------     
  function sendError(~,id,varargin)
    error(message(id,varargin{:}));
  end
  %------------------------------------------------------------------------       
  function span = getSpan(obj)    
    span = getFstop(obj) - getFstart(obj);
  end
  %------------------------------------------------------------------------       
  function fstart = getFstart(obj)
    Fs = obj.SampleRate;
    if strcmp(obj.FrequencySpan,'Full')
      fstart = -Fs/2*obj.PlotAsTwoSidedSpectrum;        
    elseif strcmp(obj.FrequencySpan,'Span and center frequency') 
      fstart = obj.CenterFrequency - obj.Span/2;
    else
      fstart = obj.StartFrequency;
    end      
  end
  %------------------------------------------------------------------------       
  function fstop = getFstop(obj)
    Fs = obj.SampleRate;
    if strcmp(obj.FrequencySpan,'Full')
      fstop = Fs/2;
    elseif strcmp(obj.FrequencySpan,'Span and center frequency') 
      fstop = obj.CenterFrequency + obj.Span/2;
    else
      fstop = obj.StopFrequency;
    end      
  end      
  %------------------------------------------------------------------------         
  function flag = isCorrectionMode(obj)
    flag = isCorrectionMode(obj.pFramework.Visual);
  end
end

methods(Static, Hidden)
  function a = getAlternateBlock
   a = 'dspsnks4/Spectrum Analyzer';
  end
end
end

%-------------------------------------------------------------------------
% Helper functions
%-------------------------------------------------------------------------
function validateSpan(obj,Fstart,Fstop, RBW, rbwSrc)

if nargin < 4
  RBW = obj.RBW;
end

if nargin < 5
  rbwSrc = obj.RBWSource;
end

if Fstart >= Fstop
  sendError(obj,'measure:SpectrumAnalyzer:FstartGreaterThanFstop')
end

NyquistRange = [(-obj.SampleRate/2)*obj.PlotAsTwoSidedSpectrum obj.SampleRate/2] + obj.FrequencyOffset;
if (Fstart < NyquistRange(1)) || (Fstop > NyquistRange(2))
  [NyquistRange, ~, unitsNyquistRange] = engunits(NyquistRange);
  sendError(obj,'measure:SpectrumAnalyzer:InvalidSpan',num2str(NyquistRange(1)),num2str(NyquistRange(2)),unitsNyquistRange)
end

% Span/RBW must be greater than 2
if  strcmp(rbwSrc,'Property')
  span = Fstop - Fstart;
  if (span/RBW) <= 2
    sendError(obj,'measure:SpectrumAnalyzer:InvalidSpanRBW')
  end
end
end

% [EOF]


