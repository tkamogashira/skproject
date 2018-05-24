classdef SpectrumAnalyzer< handle
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

    methods
        function out=SpectrumAnalyzer
            %SpectrumAnalyzer   Construct the SpectrumAnalyzer class.    
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getScopeCfg(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Verify correct span            
        end

    end
    methods (Abstract)
    end
    properties
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
        CenterFrequency;

        %FFTLength FFT length
        %   Specify the length of the FFT that the Spectrum Analyzer uses to
        %   compute spectral estimates as a positive, integer scalar. This
        %   property applies when you set the FrequencyResolutionMethod property
        %   to 'WindowLength' and the FFTLengthSource property to 'Property'. The
        %   default is 1024. FFTLength must be equal to or larger than
        %   WindowLength. This property is tunable.
        FFTLength;

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
        FFTLengthSource;

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
        FrequencyOffset;

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
        FrequencyResolutionMethod;

        %FrequencyScale Frequency scale
        %   Specify the frequency scale as one of 'Linear' | 'Log'. The default
        %   is linear. You cannot set the frequency scale to 'Log' when the
        %   PlotAsTwoSidedSpectrum property is set to true. This property applies
        %   when the SpectrumType property is set to 'Power density' or 'Power'.
        %   This property is tunable.
        FrequencyScale;

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
        FrequencySpan;

        %Name Caption to display on Spectrum Analyzer window
        %   Specify the caption to display on the Spectrum Analyzer window as any
        %   string. The default is 'Spectrum Analyzer'. This property is tunable.
        Name;

        %OverlapPercent Overalp percentage
        %   Specify the percentage overlap between the current and previous
        %   buffered window segments as a real, scalar value, greater than or
        %   equal to zero and less than 100. The default is 0. This property is
        %   tunable.
        OverlapPercent;

        %PlotAsTwoSidedSpectrum Two sided spectrum flag
        %   Set this property to true so that the Spectrum Analyzer computes two
        %   sided spectral estimates. Set this property to false to obtain one
        %   sided spectral estimates. In this case, the input must be real.
        PlotAsTwoSidedSpectrum;

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
        PlotMaxHoldTrace;

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
        PlotMinHoldTrace;

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
        PlotNormalTrace;

        %PowerUnits Power units
        %   Specify the units in which the Spectrum Analyzer displays power
        %   values as one of 'dBm' | 'dBW' | 'Watts'. The default is 'dBm'. This
        %   property is tunable.
        PowerUnits;

        %RBW Resolution bandwidth
        %   Specify the resolution bandwidth (RBW) of the Spectrum Analyzer as a
        %   real, positive, scalar in Hertz. This property applies when you set
        %   the FrequencyResolutionMethod property to 'RBW' and the RBWSource
        %   property to 'Property'. The ratio of the specified span and RBW
        %   values must be at least two (i.e. there must be at least two RBW
        %   intervals over the specified frequency span). The default is 9.76 Hz.
        %   This property is tunable.
        RBW;

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
        RBWSource;

        %ReducePlotRate Reduce plot rate to improve performance
        %   Set this property to false to update the plot after each PSD
        %   computation (when the SpectrumType property is set to 'Power density'
        %   or 'Power') or after each spectrogram line computation (when the
        %   SpectrumType property is set to 'Spectrogram'). This will negatively
        %   impact performance. The default is true. This property is tunable.
        ReducePlotRate;

        %ReferenceLoad Reference load
        %   Specify the load that the Spectrum Analyzer uses as a reference to
        %   compute power values as a real, positive scalar in Ohms. The default
        %   is 1 Ohm. This property is tunable.
        ReferenceLoad;

        %SampleRate Sample rate of input
        %   Specify the sampling rate of the input in Hertz as a finite numeric
        %   scalar. The default is 10 kHz.
        SampleRate;

        %ShowGrid Option to turn on grid
        %   Set this property to true to turn on the grid. The default is false.
        %   This property is tunable.
        ShowGrid;

        %ShowLegend Show or hide legend
        %   When this property is set to false, no legend is displayed. When this
        %   property is set to true, a legend with automatic string labels for
        %   each input channel is displayed. This property applies when the
        %   SpectrumType property is set to 'Power density' or 'Power'. The
        %   default is false. This property is tunable.
        ShowLegend;

        %SidelobeAttenuation Sidelobe attenuation of window
        %   Specify the sidelobe attenuation of the window as a real, positive
        %   scalar in decibels (dB). This property must be greater than or equal 
        %   to 45 dB. This property applies when you set the Window property to 
        %   'Chebyshev' or 'Kaiser'. The default is 60 dB. This property is 
        %   tunable.
        SidelobeAttenuation;

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
        Span;

        %SpectralAverages Number of spectral averages
        %   Specify the number of spectral averages as a positive, integer
        %   scalar. The Spectrum Analyzer computes the current power spectrum
        %   estimate by averaging the last N power spectrum estimates, where N is
        %   the number of spectral averages defined in the SpectralAverages
        %   property. This property applies when the SpectrumType property is set
        %   to 'Power density' or 'Power'. The default is 1. This property is
        %   tunable.
        SpectralAverages;

        %SpectrumType Choose how to visualize spectrum
        %   Specify the spectrum type as one of 'Power' | 'Power density' |
        %   'Spectrogram'. The default is 'Power'. This property is tunable.
        SpectrumType;

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
        StartFrequency;

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
        StopFrequency;

        %TimeResolution Time resolution
        %   Specify the time resolution of each spectrogram line as a positive
        %   scalar in seconds. This property applies when you set the
        %   SpectrumType property to 'Spectrogram', and  the TimeResolutionSource
        %   property to 'Property'. The default is 1 ms. This property is
        %   tunable.
        TimeResolution;

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
        TimeResolutionSource;

        %TimeSpan Time span
        %   Specify the time span of the spectrogram display as a positive scalar
        %   in seconds. This property applies when you set the SpectrumType
        %   property to 'Spectrogram', and  the TimeSpanSource property to
        %   'Property'. The specified time span must be at least two times larger
        %   than the duration of the number of samples required for a spectral
        %   update. The default is 100 ms. This property is tunable.
        TimeSpan;

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
        TimeSpanSource;

        %Title Display title
        %   Specify the display title as a string. The default value is ''. This
        %   property is tunable.  
        Title;

        %Window Window function
        %   Specify a window function for the spectral estimator as one of
        %   'Rectangular' | 'Chebyshev' | 'Flat Top' | 'Hamming' | 'Hann' |
        %   'Kaiser'. The default is 'Hann'. This property is tunable.  
        Window;

        %WindowLength Window length
        %   Specify the window length, in samples, used to compute spectral
        %   estimates as an integer scalar greater than two. This property
        %   applies when you set the FrequencyResolutionMethod property to
        %   'WindowLength'. The default is 1024. The frequency resolution of the
        %   analyzer is given as NENBW*Fs/WindowLength where NENBW is the
        %   normalized effective noise bandwidth of the window currently
        %   specified in the Window property. This property is tunable.
        WindowLength;

        %YLabel Y-axis label
        %   Specify the y-axis label as a string. The default value is ''. This
        %   property applies when the SpectrumType property is set to 'Power
        %   density' or 'Power'. This property is tunable.
        YLabel;

        %YLimits Y-axis limits
        %   Specify the y-axis limits as a two-element numeric vector: [ymin
        %   ymax]. This property applies when the SpectrumType property is set to
        %   'Power density' or 'Power'. This property is tunable.
        YLimits;

    end
end
