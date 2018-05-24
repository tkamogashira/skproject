classdef ArrayPlot< handle
%ArrayPlot Display vectors or arrays
%   H = dsp.ArrayPlot returns a System object(TM) , H, that can show
%   real and complex valued floating and fixed-point data on a two 
%   dimensional display.
%
%   H = dsp.ArrayPlot('Name', Value, ...) returns a ArrayPlot System
%   object, H, with each specified property name set to the specified
%   value. You can specify name-value pair arguments in any order as (Name
%   1, Value 1, ..., Name N, Value N).
%
%   H = dsp.ArrayPlot(NUMINPUTS, 'PropertyName', PropertyValue, ...)
%   returns an ArrayPlot System object, H, with the NumInputPorts property
%   set to NUMINPUTS and other specified properties set to the specified
%   values. NUMINPUTS is a value-only argument. Specify NUMINPUTS first.
%   You can specify name-value pair arguments in any order.
%
%   Step method syntax:
%
%   step(H, X) displays the signal, X, in the ArrayPlot figure.
%
%   step(H, X1, X2, ..., XN) displays the signals X1, X2, ..., XN in the
%   ArrayPlot figure when the NumInputPorts property is set to N.
%   X1, X2, ... XN can have different data types and dimensions.
%
%   ArrayPlot methods:
%
%   step     - Display signal in the ArrayPlot figure (see above)
%   release  - Allow property value and input characteristics changes, and
%              release ArrayPlot resources
%   clone    - Create ArrayPlot object with same property values
%   isLocked - Display locked status (logical)
%   reset    - Clear ArrayPlot figure
%   show     - Turn on visibility of ArrayPlot figure
%   hide     - Turn off visibility of ArrayPlot figure
%
%   ArrayPlot properties:
%
%   NumInputPorts        - Number of input signals
%   SampleIncrement      - X-axis sample spacing
%   Name                 - Caption to display on ArrayPlot window
%   Position             - Scope window position in pixels
%   XOffset              - X-axis display offset
%   XLabel               - X-axis label
%   PlotType             - Option to control the type of plot
%   MaximizeAxes         - Maximize axes control
%   Title                - Display title
%   PlotAsMagnitudePhase - Plot signal as Magnitude-and-Phase
%   YLimits              - Y-axis limits
%   YLabel               - Y-axis label
%   ShowLegend           - Show or hide channel legends
%   ShowGrid             - Show or hide grid
%   ReduceUpdates        - Reduce updates to improve performance
%
%   % Example #1: Plot a Gaussian distribution
%       % Create a dsp.ArrayPlot System object.
%       h=dsp.ArrayPlot;
%
%       % Set ArrayPlot properties to display a Gaussian distribution.
%       h.YLimits = [-0.1 1.1];
%       h.XOffset = -2.5;    
%       h.SampleIncrement = 0.1;
%       h.Title = 'Gaussian distribution';
%       h.XLabel = 'X';
%       h.YLabel = 'f(X)';
%
%       % Plot a Gaussian distribution by calling the step function.
%       step(h, exp(-[-2.5:.1:2.5].*[-2.5:.1:2.5])');
%
%   % EXAMPLE #2: View LMS adaptive filter weights
%
%       % In this example the weights of an adaptive LMS filter are plotted
%       % as they adapt to filter a noisy input signal.
%
%       % Create an LMS adaptive filter System object.
%       hlms = dsp.LMSFilter(40,'Method', 'Normalized LMS', ...
%               'StepSize', .002);
%
%       % Create and configure an audio file reader System object to read 
%       % the input signal from the specified audio file.
%       hsigsource = dsp.AudioFileReader('dspafxf_8000.wav',  ...
%             'SamplesPerFrame', 40, ...
%             'PlayCount', Inf,...
%             'OutputDataType', 'double');
%
%       % Create and configure a fixed-point FIR digital filter System 
%       % object to filter random white noise to create colored noise.          
%       hfilt = dsp.FIRFilter('Numerator', fir1(39, .25));
%
%       % Create and configure an ArrayPlot System object to display the 
%       % adaptive filter weights.          
%       harrayplot = dsp.ArrayPlot('XLabel', 'Filter Tap', ...
%             'YLabel', 'Filter Weight', ...
%             'YLimits', [-.05 .2]');
%
%       % Plot the LMS filter weights as they adapt to a desired signal.
%
%       numplays = 0;
%       while numplays < 3
%           [y, eof]    = step(hsigsource);   % Read from audio file
%           noise       = rand(40,1);         % Produce random data
%           noisefilt   = step(hfilt, noise); % Filter the random data
%
%           % For this example, a 'desired' signal is a noisy version
%           % of the input signal 
%           desired     = y + noisefilt;
%
%           % Stepping the LMS filter updates the filter weights
%           [~, ~, wts] = step(hlms, noise, desired);
%
%           % Plot the filter weights after each step
%           step(harrayplot, wts);
%
%           numplays = numplays + eof;        % Update number of plays
%       end
%
%   See also dsp.TimeScope, dsp.LMSFilter, dsp.AudioFileReader,
%   dsp.FIRFilter

 
%   Copyright 2012-2013 The MathWorks, Inc.

    methods
        function out=ArrayPlot
            %ArrayPlot Display vectors or arrays
            %   H = dsp.ArrayPlot returns a System object(TM) , H, that can show
            %   real and complex valued floating and fixed-point data on a two 
            %   dimensional display.
            %
            %   H = dsp.ArrayPlot('Name', Value, ...) returns a ArrayPlot System
            %   object, H, with each specified property name set to the specified
            %   value. You can specify name-value pair arguments in any order as (Name
            %   1, Value 1, ..., Name N, Value N).
            %
            %   H = dsp.ArrayPlot(NUMINPUTS, 'PropertyName', PropertyValue, ...)
            %   returns an ArrayPlot System object, H, with the NumInputPorts property
            %   set to NUMINPUTS and other specified properties set to the specified
            %   values. NUMINPUTS is a value-only argument. Specify NUMINPUTS first.
            %   You can specify name-value pair arguments in any order.
            %
            %   Step method syntax:
            %
            %   step(H, X) displays the signal, X, in the ArrayPlot figure.
            %
            %   step(H, X1, X2, ..., XN) displays the signals X1, X2, ..., XN in the
            %   ArrayPlot figure when the NumInputPorts property is set to N.
            %   X1, X2, ... XN can have different data types and dimensions.
            %
            %   ArrayPlot methods:
            %
            %   step     - Display signal in the ArrayPlot figure (see above)
            %   release  - Allow property value and input characteristics changes, and
            %              release ArrayPlot resources
            %   clone    - Create ArrayPlot object with same property values
            %   isLocked - Display locked status (logical)
            %   reset    - Clear ArrayPlot figure
            %   show     - Turn on visibility of ArrayPlot figure
            %   hide     - Turn off visibility of ArrayPlot figure
            %
            %   ArrayPlot properties:
            %
            %   NumInputPorts        - Number of input signals
            %   SampleIncrement      - X-axis sample spacing
            %   Name                 - Caption to display on ArrayPlot window
            %   Position             - Scope window position in pixels
            %   XOffset              - X-axis display offset
            %   XLabel               - X-axis label
            %   PlotType             - Option to control the type of plot
            %   MaximizeAxes         - Maximize axes control
            %   Title                - Display title
            %   PlotAsMagnitudePhase - Plot signal as Magnitude-and-Phase
            %   YLimits              - Y-axis limits
            %   YLabel               - Y-axis label
            %   ShowLegend           - Show or hide channel legends
            %   ShowGrid             - Show or hide grid
            %   ReduceUpdates        - Reduce updates to improve performance
            %
            %   % Example #1: Plot a Gaussian distribution
            %       % Create a dsp.ArrayPlot System object.
            %       h=dsp.ArrayPlot;
            %
            %       % Set ArrayPlot properties to display a Gaussian distribution.
            %       h.YLimits = [-0.1 1.1];
            %       h.XOffset = -2.5;    
            %       h.SampleIncrement = 0.1;
            %       h.Title = 'Gaussian distribution';
            %       h.XLabel = 'X';
            %       h.YLabel = 'f(X)';
            %
            %       % Plot a Gaussian distribution by calling the step function.
            %       step(h, exp(-[-2.5:.1:2.5].*[-2.5:.1:2.5])');
            %
            %   % EXAMPLE #2: View LMS adaptive filter weights
            %
            %       % In this example the weights of an adaptive LMS filter are plotted
            %       % as they adapt to filter a noisy input signal.
            %
            %       % Create an LMS adaptive filter System object.
            %       hlms = dsp.LMSFilter(40,'Method', 'Normalized LMS', ...
            %               'StepSize', .002);
            %
            %       % Create and configure an audio file reader System object to read 
            %       % the input signal from the specified audio file.
            %       hsigsource = dsp.AudioFileReader('dspafxf_8000.wav',  ...
            %             'SamplesPerFrame', 40, ...
            %             'PlayCount', Inf,...
            %             'OutputDataType', 'double');
            %
            %       % Create and configure a fixed-point FIR digital filter System 
            %       % object to filter random white noise to create colored noise.          
            %       hfilt = dsp.FIRFilter('Numerator', fir1(39, .25));
            %
            %       % Create and configure an ArrayPlot System object to display the 
            %       % adaptive filter weights.          
            %       harrayplot = dsp.ArrayPlot('XLabel', 'Filter Tap', ...
            %             'YLabel', 'Filter Weight', ...
            %             'YLimits', [-.05 .2]');
            %
            %       % Plot the LMS filter weights as they adapt to a desired signal.
            %
            %       numplays = 0;
            %       while numplays < 3
            %           [y, eof]    = step(hsigsource);   % Read from audio file
            %           noise       = rand(40,1);         % Produce random data
            %           noisefilt   = step(hfilt, noise); % Filter the random data
            %
            %           % For this example, a 'desired' signal is a noisy version
            %           % of the input signal 
            %           desired     = y + noisefilt;
            %
            %           % Stepping the LMS filter updates the filter weights
            %           [~, ~, wts] = step(hlms, noise, desired);
            %
            %           % Plot the filter weights after each step
            %           step(harrayplot, wts);
            %
            %           numplays = numplays + eof;        % Update number of plays
            %       end
            %
            %   See also dsp.TimeScope, dsp.LMSFilter, dsp.AudioFileReader,
            %   dsp.FIRFilter
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getScopeCfg(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Empty function
        end

    end
    methods (Abstract)
    end
    properties
        %MaximizeAxes Maximize axes control
        %   Specify how axes should appear in the ArrayPlot's display as one of
        %   [{'Auto'} | 'On' | 'Off']. When this property is set to 'Auto',
        %   axes are maximized only the display does not contain label or title
        %   annotations.  When this property is set to 'On', axes are
        %   maximized.  When this property is set to 'Off', axes are not
        %   maximized. This property is tunable.
        MaximizeAxes;

        %Name Caption to display on the ArrayPlot window
        %   Specify the caption to display on the ArrayPlot window as any
        %   string. The default value of this property is 'Array Plot' This
        %   property is tunable.
        Name;

        %NumInputPorts Number of input signals
        %   Specify the number of input signals to display on the ArrayPlot as
        %   a positive integer. You must invoke the step method with the same
        %   number of inputs as the value of this property. The default value
        %   of this property is 1.
        NumInputPorts;

        %PlotAsMagnitudePhase Plot signal as Magnitude-and-Phase
        %   Set this property to true to plot magnitude and phase of the
        %   signal. The default value is false. This property is tunable.
        PlotAsMagnitudePhase;

        %PlotType Option to control the type of plot
        %   Specify the type of plot to be used. Valid types are 'Line'
        %   'Stairs' and 'Stem'. The default is 'Stem'. This property is
        %   tunable.
        PlotType;

        %ReduceUpdates Reduce updates to improve performance
        %   Set this property to false to update the scope every time the step
        %   method is called. This will negatively impact performance. The
        %   default is true. This property is tunable.
        ReduceUpdates;

        %SampleIncrement X-axis sample spacing
        %   Specify the spacing between samples along the X-axis as a finite
        %   numeric scalar. The default value of this property is 1.
        SampleIncrement;

        %ShowGrid Show or hide grid
        %   Set this property to true to turn on the grid. The default value is
        %   false. This property is tunable.
        ShowGrid;

        %ShowLegend Specify if legends are to be displayed  
        %   When this property is set to false, no legend is displayed. When
        %   this property is set to true, a legend with automatic string
        %   labels for each input channel is displayed. This property is
        %   tunable.
        %    
        ShowLegend;

        %Title Display title
        %   Specify the display title as a string. The default value of this
        %   property is ''. This property is tunable.
        Title;

        %XLabel X-axis label
        %   Specify the x-axis label as a string. The default value of this
        %   property is ''. This property is tunable.
        XLabel;

        %XOffset
        %   Specify the offset to apply to the x-axis. This property is a
        %   numeric scalar with default value 0. This property is tunable.
        XOffset;

        %YLabel Y-axis label
        %   Specify the y-axis label as a string. The default value of this
        %   property is 'Amplitude'. This property is applicable when the
        %   PlotAsMagnitudePhase property is false. When the
        %   PlotAsMagnitudePhase property is true, the y-axes labels are
        %   read-only values which are set to 'Magnitude' and 'Phase' for
        %   magnitude plot and phase plot, respectively. This property is
        %   tunable.
        YLabel;

        %YLimits Y-axis limits
        %   Specify the y-axis limits as a two-element numeric vector: [ymin
        %   ymax]. When the PlotAsMagnitudePhase property is false, the default
        %   value of this property is [-10 10]. When the PlotAsMagnitudePhase
        %   property is true, the default value of this property is [0 10] and
        %   it specifies the y-axis limits of magnitude plot. This property is
        %   tunable.
        YLimits;

    end
end
