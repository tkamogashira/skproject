classdef TimeScope< handle
%TimeScope Display time-domain signals
%   H = dsp.TimeScope returns a System object, H, that can display
%   real and complex valued floating and fixed-point signals in the time
%   domain.
%
%   H = dsp.TimeScope('Name', Value, ...) returns a Time Scope System
%   object, H, with each specified property name set to the specified
%   value. You can specify name-value pair arguments in any order as
%   (Name 1, Value 1, ..., Name N, Value N).
%
%   H = dsp.TimeScope(NUMINPUTS, SAMPLERATE, 'PropertyName',
%   PropertyValue, ...) returns a Time Scope System object, H, with the
%   NumInputPorts property set to NUMINPUTS, the SampleRate property set to
%   SAMPLERATE, and other specified properties set to the specified values.
%   NUMINPUTS and SAMPLERATE are value-only arguments. To specify a
%   value-only argument, you must also specify all preceding value-only
%   arguments. You can specify name-value pair arguments in any order.
%
%   Step method syntax:
%
%   step(H, X) displays the signal, X, in the Time Scope figure.
%
%   step(H, X1, X2, ..., XN) displays the signals X1, X2, ..., XN in the
%   Time Scope figure when the NumInputPorts property is set to N. X1, X2,
%   ... XN can have different data types and dimensions.
%
%   TimeScope methods:
%
%   step     - Display signal in the Time Scope figure (see above)
%   release  - Allow property value and input characteristics changes, and
%              release Time Scope resources
%   clone    - Create Time Scope object with same property values
%   isLocked - Display locked status (logical)
%   reset    - Clear Time Scope figure
%   show     - Turn on visibility of Time Scope figure
%   hide     - Turn off visibility of Time Scope figure
%
%   TimeScope properties:
%
%   Name                  - Caption to display on Time Scope window
%   NumInputPorts         - Number of input signals
%   BufferLength          - Length of the buffer used for each input signal
%   SampleRate            - Sample rate of inputs
%   Position              - Scope window position in pixels
%   PlotType              - Option to control the type of plot
%   ReduceUpdates         - Reduce updates to improve performance
%   FrameBasedProcessing  - Process input in frames or as samples
%   TimeSpanSource        - Source of time span
%   TimeSpan              - Time span
%   TimeSpanOverrunAction - Wrap or scroll when the TimeSpan is overrun
%   TimeUnits             - Units of the time axis
%   TimeDisplayOffset     - Time display offset
%   TimeAxisLabels        - Time-axis labels
%   MaximizeAxes          - Maximize axes control
%   LayoutDimensions      - Layout grid dimensions
%   ActiveDisplay         - Active display for display-specific properties
%   Title                 - Display title
%   ShowLegend            - Option to turn on legend
%   ShowGrid              - Option to turn on grid
%   PlotAsMagnitudePhase  - Plot signal as Magnitude-and-Phase
%   YLimits               - Y-axis limits
%   YLabel                - Y-axis label
%
%   % EXAMPLE #1: View a sine wave on the Time Scope.
%      hsin = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
%      hsin.SamplesPerFrame = 10;
%      hts1 = dsp.TimeScope('SampleRate', hsin.SampleRate,'TimeSpan', 0.1);
%      for ii = 1:10
%         x = step(hsin);
%         step(hts1, x);
%      end
%      release(hts1);
%
%   % EXAMPLE #2: View two sine waves with different sample rates and
%   %             time offsets.
%       Fs = 1000;  % Sampling frequency
%       hsin1 = dsp.SineWave('Frequency',50,...
%                            'SampleRate',Fs, ...
%                            'SamplesPerFrame', 100);
%
%       % Use an FIRDecimator System object to decimate the signal by 2.
%       hfilt = dsp.FIRDecimator;
%
%       % Create and configure a TimeScope System object with 2 input ports
%       % (channels).
%       hts2 = dsp.TimeScope(2, [Fs Fs/2], ...
%                            'TimeDisplayOffset', [0 38/Fs], ...
%                            'TimeSpan', 0.25, ...
%                            'YLimits',[-1 1], ...
%                            'ShowLegend', true);
%       for ii = 1:2
%         xsine = step(hsin1);
%         xdec = step(hfilt,xsine);
%         step(hts2, xsine, xdec);
%       end
%       release(hts2);
%
%   See also dsp.ArrayPlot, dsp.SpectrumAnalyzer

   
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=TimeScope
            %TimeScope Display time-domain signals
            %   H = dsp.TimeScope returns a System object, H, that can display
            %   real and complex valued floating and fixed-point signals in the time
            %   domain.
            %
            %   H = dsp.TimeScope('Name', Value, ...) returns a Time Scope System
            %   object, H, with each specified property name set to the specified
            %   value. You can specify name-value pair arguments in any order as
            %   (Name 1, Value 1, ..., Name N, Value N).
            %
            %   H = dsp.TimeScope(NUMINPUTS, SAMPLERATE, 'PropertyName',
            %   PropertyValue, ...) returns a Time Scope System object, H, with the
            %   NumInputPorts property set to NUMINPUTS, the SampleRate property set to
            %   SAMPLERATE, and other specified properties set to the specified values.
            %   NUMINPUTS and SAMPLERATE are value-only arguments. To specify a
            %   value-only argument, you must also specify all preceding value-only
            %   arguments. You can specify name-value pair arguments in any order.
            %
            %   Step method syntax:
            %
            %   step(H, X) displays the signal, X, in the Time Scope figure.
            %
            %   step(H, X1, X2, ..., XN) displays the signals X1, X2, ..., XN in the
            %   Time Scope figure when the NumInputPorts property is set to N. X1, X2,
            %   ... XN can have different data types and dimensions.
            %
            %   TimeScope methods:
            %
            %   step     - Display signal in the Time Scope figure (see above)
            %   release  - Allow property value and input characteristics changes, and
            %              release Time Scope resources
            %   clone    - Create Time Scope object with same property values
            %   isLocked - Display locked status (logical)
            %   reset    - Clear Time Scope figure
            %   show     - Turn on visibility of Time Scope figure
            %   hide     - Turn off visibility of Time Scope figure
            %
            %   TimeScope properties:
            %
            %   Name                  - Caption to display on Time Scope window
            %   NumInputPorts         - Number of input signals
            %   BufferLength          - Length of the buffer used for each input signal
            %   SampleRate            - Sample rate of inputs
            %   Position              - Scope window position in pixels
            %   PlotType              - Option to control the type of plot
            %   ReduceUpdates         - Reduce updates to improve performance
            %   FrameBasedProcessing  - Process input in frames or as samples
            %   TimeSpanSource        - Source of time span
            %   TimeSpan              - Time span
            %   TimeSpanOverrunAction - Wrap or scroll when the TimeSpan is overrun
            %   TimeUnits             - Units of the time axis
            %   TimeDisplayOffset     - Time display offset
            %   TimeAxisLabels        - Time-axis labels
            %   MaximizeAxes          - Maximize axes control
            %   LayoutDimensions      - Layout grid dimensions
            %   ActiveDisplay         - Active display for display-specific properties
            %   Title                 - Display title
            %   ShowLegend            - Option to turn on legend
            %   ShowGrid              - Option to turn on grid
            %   PlotAsMagnitudePhase  - Plot signal as Magnitude-and-Phase
            %   YLimits               - Y-axis limits
            %   YLabel                - Y-axis label
            %
            %   % EXAMPLE #1: View a sine wave on the Time Scope.
            %      hsin = dsp.SineWave('Frequency',100, 'SampleRate', 1000);
            %      hsin.SamplesPerFrame = 10;
            %      hts1 = dsp.TimeScope('SampleRate', hsin.SampleRate,'TimeSpan', 0.1);
            %      for ii = 1:10
            %         x = step(hsin);
            %         step(hts1, x);
            %      end
            %      release(hts1);
            %
            %   % EXAMPLE #2: View two sine waves with different sample rates and
            %   %             time offsets.
            %       Fs = 1000;  % Sampling frequency
            %       hsin1 = dsp.SineWave('Frequency',50,...
            %                            'SampleRate',Fs, ...
            %                            'SamplesPerFrame', 100);
            %
            %       % Use an FIRDecimator System object to decimate the signal by 2.
            %       hfilt = dsp.FIRDecimator;
            %
            %       % Create and configure a TimeScope System object with 2 input ports
            %       % (channels).
            %       hts2 = dsp.TimeScope(2, [Fs Fs/2], ...
            %                            'TimeDisplayOffset', [0 38/Fs], ...
            %                            'TimeSpan', 0.25, ...
            %                            'YLimits',[-1 1], ...
            %                            'ShowLegend', true);
            %       for ii = 1:2
            %         xsine = step(hsin1);
            %         xdec = step(hfilt,xsine);
            %         step(hts2, xsine, xdec);
            %       end
            %       release(hts2);
            %
            %   See also dsp.ArrayPlot, dsp.SpectrumAnalyzer
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getScopeCfg(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function loadObjectPreStart(in) %#ok<MANU>
            % Set the SampleRate before starting so that the correct value is
            % used.
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % add checks for TimeDisplayOffset, Legend
        end

    end
    methods (Abstract)
    end
    properties
        %ActiveDisplay Active display for display-specific properties
        %   Specify the active display for getting and setting relevant
        %   properties as a number, where a display number corresponds to its
        %   column-wise placement index. The default value of this property is
        %   1.  Setting this property controls which display is used for the
        %   following properties: YLimits, YLabel, ShowLegend, ShowGrid, Title,
        %   PlotAsMagnitudePhase. This property is tunable.
        ActiveDisplay;

        %BufferLength Buffer length
        %    Specify length of the buffer used for each input signal. This
        %    property is tunable.
        BufferLength;

        %FrameBasedProcessing Process input in frames or as samples
        %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %   property to false to enable sample-based processing. The default
        %   value of this property is true.
        FrameBasedProcessing;

        %LayoutDimensions Layout grid dimensions
        %   Specify the layout grid dimensions as two-element vector:
        %   [numberOfRows numberOfColumns]. The default value of this property
        %   is [1 1]. No greater than 4 rows or columns may be specified in a
        %   layout. This property is tunable.
        LayoutDimensions;

        %MaximizeAxes Maximize axes contro
        %   Specify how axes should appear in the Time Scope's displays as one 
        %   of [{'Auto'} | 'On' | 'Off']. When this property is set to 'Auto', 
        %   axes are maximized only if no displays contain label or title 
        %   annotations.  When this property is set to 'On', axes are maximized 
        %   in all displays.  When this property is set to 'Off', axes are not
        %   maximized in any display. This property is tunable.
        MaximizeAxes;

        %Name Caption to display on Time Scope window
        %   Specify the caption to display on the Time Scope window as any
        %   string. The default value of this property is 'Time Scope'. This
        %   property is tunable.
        Name;

        %NumInputPorts Number of input signals
        %   Specify the number of input signals to display on the Time Scope as
        %   a positive integer. You must invoke the step method with the same
        %   number of inputs as the value of this property. The default value
        %   of this property is 1.
        NumInputPorts;

        %PlotAsMagnitudePhase Plot signal as Magnitude-and-Phase
        %   Set this property to true to plot magnitude and phase of the
        %   signal. The default value is false. When set, ActiveDisplay
        %   controls which displays are updated. This property is tunable.
        PlotAsMagnitudePhase;

        %PlotType Option to control the type of plot
        %   Specify the type of plot to be used.  Valid types are 'Line'
        %   and 'Stairs'. The default is 'Line'. This property is tunable.
        PlotType;

        %ReduceUpdates Reduce updates to improve performance
        %   Set this property to false to update the scope every time the step
        %   method is called. This will negatively impact performance. The
        %   default is true. This property is tunable.
        ReduceUpdates;

        %SampleRate Sample rate of inputs
        %   Specify the sampling rate of the input signal(s) in Hz as a
        %   finite numeric scalar, or a numeric vector of length equal to the
        %   NumInputPorts property value. The inverse of the sample rate
        %   determines the x-axis (time axis) spacing between points in the
        %   displayed signal. When the NumInputPorts property value is more
        %   than 1, and this property is set to a scalar, the same sample rate
        %   is used for all inputs. The default value of this property is 1.
        SampleRate;

        %ShowGrid Option to turn on grid
        %   Set this property to true to turn on the grid. The default value is
        %   false. When set, ActiveDisplay controls which displays are updated
        %   This property is tunable.
        ShowGrid;

        %ShowLegend Show or hide legend
        %   When this property is set to false, no legend is displayed. When
        %   this property is set to true, a legend with automatic string
        %   labels for each input channel is displayed. See the documentation
        %   for the FrameBasedProcessing property on more information about
        %   input channels. When set, ActiveDisplay controls which displays are
        %   updated. This property is tunable.
        %
        %   See also: dsp.TimeScope.FrameBasedProcessing.
        ShowLegend;

        %TimeAxisLabels Time-axis labels
        %   Specify how time-axis labels should appear in the Time Scope's
        %   displays as one of [{'All'} | 'None' | 'Bottom']. When this
        %   property is set to 'All', time-axis labels appear in all displays.
        %   When this property is set to 'None', time-axis labels appear in no
        %   displays. When this property is set to 'Bottom', time-axis labels
        %   appear in the bottom display of each column. This property is
        %   tunable.
        TimeAxisLabels;

        %TimeDisplayOffset
        %   Specify the offset to apply to the time axis (x-axis) in units of
        %   seconds. This property can either be set to a numeric scalar, or a
        %   vector of length equal to the number of input channels. If this
        %   property is set to a scalar, the same time display offset is used
        %   for all channels. If it is set to a vector, each element is used as
        %   the time offset for the corresponding channel. For vector lengths
        %   less than the number of input channels, the time display offset for
        %   the remaining channels is assumed to be 0. For vector lengths
        %   greater than the number of input channels, the extra vector
        %   elements are ignored. For more information on input channels, see
        %   <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. The default value of this property is 0.
        %   This property is tunable.
        %
        %   See also: dsp.TimeScope.TimeSpanSource, dsp.TimeScope.TimeSpan.
        TimeDisplayOffset;

        %TimeSpan Time span
        %   Specify the time span as a positive numeric scalar in units of
        %   seconds. This property is applicable when the FrameBasedProcessing
        %   property is false. It is also applicable when the
        %   FrameBasedProcessing property is true and the TimeSpanSource
        %   property is 'Property'. The time span value determines the x-axis
        %   limits of the Time Scope as follows:
        %   Minimum X-axis limit: min(TimeDisplayOffset)
        %   Maximum X-axis limit: max(TimeDisplayOffset) + TimeSpan
        %
        %   Here, TimeDisplayOffset is the value of the TimeDisplayOffset
        %   property, and TimeSpan is the value of the TimeSpan property.
        %   The default value of the property is 10. This property is tunable.
        TimeSpan;

        %TimeSpanOverrunAction Wrap or scroll when the Time Span is overrun
        %   Specify whether the Time Scope will display the data as one of
        %   [{'Wrap'} | 'Scroll'].  When this property is set to 'Wrap', the
        %   Time Scope will add data to the left side of the Time Scope after
        %   overrunning the right side of the Time Scope.  When this property
        %   is set to 'Scroll', old data will be moved to the left when the
        %   data overruns the right hand side of the screen.  This property is
        %   tunable.
        TimeSpanOverrunAction;

        %TimeSpanSource Source of time span
        %   Specify the source of time span for frame-based input as one of
        %   ['Auto' | {'Property'}]. The time span determines the x-axis limits
        %   of the Time Scope. When this property is set to 'Auto', the x-axis
        %   limits are derived from the input signals' sample times, frame
        %   sizes and time display offsets as follows:
        %   Minimum X-axis limit: min(TimeDisplayOffset)
        %   Maximum X-axis limit: max(TimeDisplayOffset) +
        %                         max(1/SampleRate.*FrameSize)
        %
        %   Here, TimeDisplayOffset is the value of the TimeDisplayOffset
        %   property, SampleRate is the value of the SampleRate property, and
        %   FrameSize is a vector equal to the number of rows in each input
        %   signal.
        %
        %   When this property is set to 'Property', the x-axis limits are
        %   derived from the TimeDisplayOffset and TimeSpan properties. This
        %   property is applicable when the FrameBasedProperty is true. This
        %   property is tunable.
        TimeSpanSource;

        %TimeUnits Units of the time axis
        %   Specify the units used to describe the time-axis.  'None' will
        %   use no units, 'Metric' will convert the time to milliseconds,
        %   microseconds, etc., 'Seconds' will always leave the units as
        %   seconds.  'Metric' is the default.  This property is tunable.
        TimeUnits;

        %Title Display title
        %   Specify the display title as a string. The default value of this
        %   property is ''. When set, ActiveDisplay controls which displays
        %   are updated. This property is tunable.
        Title;

        %YLabel Y-axis label
        %   Specify the y-axis label as a string. The default value of this
        %   property is 'Amplitude'. This property is applicable when the
        %   PlotAsMagnitudePhase property is false. When the PlotAsMagnitudePhase property
        %   is true, the y-axes labels are read-only values which are set to
        %   'Magnitude' and 'Phase' for magnitude plot and phase plot,
        %   respectively. When set, ActiveDisplay controls which displays are
        %   updated. This property is tunable.
        YLabel;

        %YLimits Y-axis limits
        %   Specify the y-axis limits as a two-element numeric vector: [ymin
        %   ymax]. When the PlotAsMagnitudePhase property is false, the default value
        %   of this property is [-10 10]. When the PlotAsMagnitudePhase property is
        %   true, the default value of this property is [0 10] and it specifies
        %   the y-axis limits of magnitude plot. When set, ActiveDisplay
        %   controls which displays are updated. This property is tunable.
        YLimits;

    end
end
