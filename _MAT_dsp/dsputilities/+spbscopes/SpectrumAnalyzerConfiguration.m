classdef SpectrumAnalyzerConfiguration < Simulink.scopes.BlockScopeConfiguration
    %SPECTRUMANALYZERCONFIGURATION Scope Configuration object for the
    %Spectrum Analyzer.
    %   This object is used to configure the Spectrum Analyzer
    %   programmatically. Click on a Spectrum Analyzer block and use
    %   get_param(gcb,'ScopeConfiguration') to get the object.
    
    %   Copyright 2012-2013 The MathWorks, Inc.
    
    properties (SetAccess = private, Dependent)
        SampleRate;
    end
    
    properties (Dependent)
        SpectrumType;
        FrequencySpan;
        Span;
        CenterFrequency;
        StartFrequency;
        StopFrequency;
        FrequencyResolutionMethod;
        RBWSource;
        RBW;
        WindowLength;
        FFTLengthSource;
        FFTLength;
        OverlapPercent;
        Window;
        SidelobeAttenuation;
        TimeResolutionSource;
        TimeResolution;
        TimeSpanSource;
        TimeSpan;
        SpectralAverages;
        PowerUnits;
        ReferenceLoad;
        PlotMaxHoldTrace;
        PlotMinHoldTrace;
        PlotNormalTrace;
        PlotAsTwoSidedSpectrum;
        FrequencyScale;
        FrequencyOffset;
        Title;
        YLimits;
        YLabel;
        ShowLegend;
        ShowGrid;
        ReducePlotRate;
        TreatMby1SignalsAsOneChannel;
    end
    
    % Legacy SpectrumScope Parameters for compatibility
    properties (Hidden, Dependent)
        wintypeSpecScope;
        numAvg;
        XRange;
        YUnits;
        AxisGrid;
        AxisLegend;
        Memory;
        inpFftLenInherit;
        FFTlength;
        RsSpecScope;
        betaSpecScope;
        Overlap;
        UseBuffer;
        BufferSize;
        FigPos;
        XLimit;
        XMin;
        XMax;
        YMin;
        YMax;
        OpenScopeAtSimStart;
        OpenScopeImmediately;
        LineDisables;
        LineStyles;
        LineMarkers;
        LineColors;
        TreatMby1Signals;
        WinsampSpecScope;
        FrameNumber;
        AxisZoom;
        InheritXIncr;
        XIncr;
        XDisplay;
        SegLen;
    end
    
    properties (Hidden)
        wintypeSpecScopeLocal = 'unset';
        RsSpecScopeLocal = 'unset';
        betaSpecScopeLocal = 'unset';
        UseBufferLocal = -1;
        BufferSizeLocal = [];
        OverlapLocal    = [];
        XLimitLocal = 'unset';
        XMinLocal = 'unset';
        XMaxLocal = 'unset';
        IsFstartFstopSettingDirty;
        LegacySetFlag = false;
    end
    
    properties(Access=private, Constant)
        VisualName = 'Spectrum';
    end
    
    methods
        function obj = SpectrumAnalyzerConfiguration(varargin)
            %SpectrumAnalyzerConfiguration   Construct the SpectrumAnalyzerConfiguration class.
            obj@Simulink.scopes.BlockScopeConfiguration(varargin{:});
        end
        
        % Get parameter value from scope
        function value = getParameter(obj,parameterName)
            value = getScopeParam(obj.Scope, 'Visuals', obj.VisualName, ...
                parameterName);
        end
        
        % Set scope parameter to value
        function setScopeParameter(obj,propertyName,value)
            if ischar(value)
                datatype = 'string';
            else
                datatype = 'bool';
            end
            
            if isLaunched(obj.Scope)
                setScopeParam(obj.Scope, 'Visuals', obj.VisualName, ...
                    propertyName, value);
            else
                setScopeParamOnConfig(obj.Scope, 'Visuals', ...
                    obj.VisualName, propertyName, datatype, value);
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%  GET/SET METHODS FOR PUBLIC PROPERTIES %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % TITLE SET/GET
        function set.Title(obj, value)
            validateattributes(value,{'char'},{},'','Title');
            setScopeParameter(obj,'Title',value);
        end
        
        function value = get.Title(obj)
            value = getParameter(obj,'Title');
        end
        
        % YLABEL SET/GET
        function set.YLabel(obj, value)
            validateattributes(value,{'char'},{},'','YLabel');
            % SpectrumAnalyzer block adds Power Units at end of string as a
            % convenience for users
            % Legacy SpectrumScope block did not do that. Strip off units 
            % from end of inherited string to avoid units showing up twice
            value = removeLegacyUnits(value);
            setScopeParameter(obj,'YLabel',value);
        end
        
        function value = get.YLabel(obj)
            value = getParameter(obj,'YLabel');
        end
        
        % FREQUENCYRESOLUTIONMETHOD SET/GET
        function set.FrequencyResolutionMethod(obj, strValue)
            strValue = obj.validateEnum(strValue,'FrequencyResolutionMethod',{'RBW','WindowLength'});
            setScopeParameter(obj,'FrequencyResolutionMethod',strValue);
            if strcmp(strValue,'RBW')
                % No legacy mapping if RBW mode is selected
                obj.LegacySetFlag  = false;
            end
        end
        
        function value = get.FrequencyResolutionMethod(obj)
            value =  getParameter(obj,'FrequencyResolutionMethod');
        end        
        
        % RBWSOURCE SET/GET
        function set.RBWSource(obj, strValue)
            strValue = obj.validateEnum(strValue,'RBWSource',{'Auto','Property'});
            setScopeParameter(obj,'RBWSource',strValue);

        end
        
        function value = get.RBWSource(obj)
            value =  getParameter(obj,'RBWSource');
        end
        
        % RBW SET/GET
        function set.RBW(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'RBW');
            if ~variableUndefined
                obj.validateRBW(value);
            end
            setScopeParameter(obj,'RBW',strValue);
        end
        
        function value = get.RBW(obj)
            value =  getParameter(obj,'RBW');
        end
        
        % WINDOWLENGTH SET/GET
        function set.WindowLength(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'WindowLength');
            if ~variableUndefined
                obj.validateWindowLength(value);
            end
            setScopeParameter(obj,'WindowLength',strValue);           
        end
        
        function value = get.WindowLength(obj)
            value =  getParameter(obj,'WindowLength');
        end
        
        %OVERLAPPERCENT set/get
        function set.OverlapPercent(obj, strValue)
            
            [value,variableUndefined] = evaluateString(obj,strValue,'OverlapPercent');
            if ~variableUndefined
                obj.validateOverlapPercent(value);
            end
            setScopeParameter(obj,'OverlapPercent',strValue);
        end
        
        function value = get.OverlapPercent(obj)
            value =  getParameter(obj,'OverlapPercent');
        end
        
        % TIMERESOLUTIONSOURCE SET/GET
        function set.TimeResolutionSource(obj, strValue)
            strValue = obj.validateEnum(strValue,'TimeResolutionSource',{'Auto','Property'});
            setScopeParameter(obj,'TimeResolutionSource',strValue);
        end
        
        function value = get.TimeResolutionSource(obj)
            value =  getParameter(obj,'TimeResolutionSource');
        end
        
        % TIMERESOLUTION SET/GET
        function set.TimeResolution(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'TimeResolution');
            if ~variableUndefined
                obj.validateTimeResolution(value);
            end
            setScopeParameter(obj,'TimeResolution',strValue);
        end
        
        function value = get.TimeResolution(obj)
            value =  getParameter(obj,'TimeResolution');
        end
        
        % TIMESPANSOURCE SET/GET
        function set.TimeSpanSource(obj, strValue)
            strValue = obj.validateEnum(strValue,'TimeSpanSource',{'Auto','Property'});
            setScopeParameter(obj,'TimeSpanSource',strValue);
        end
        
        function value = get.TimeSpanSource(obj)
            value =  getParameter(obj,'TimeSpanSource');
        end
        
        % TIMESPAN SET/GET
        function set.TimeSpan(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'TimeSpan');
            if ~variableUndefined
                obj.validateTimeSpan(value);
            end
            setScopeParameter(obj,'TimeSpan',strValue);
        end
        
        function value = get.TimeSpan(obj)
            value =  getParameter(obj,'TimeSpan');
        end        
        
        % SPECTRALAVERAGES SET/GET
        function set.SpectralAverages(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'SpectralAverages');
            if ~variableUndefined
                obj.validateSpectralAverages(value);
            end
            setScopeParameter(obj,'SpectralAverages',strValue);
        end
        
        function value = get.SpectralAverages(obj)
            value = getParameter(obj,'SpectralAverages');
        end
        
        % REFERENCELOAD SET/GET
        function set.ReferenceLoad(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'ReferenceLoad');
            if ~variableUndefined
                obj.validateReferenceLoad(value);
            end
            setScopeParameter(obj,'ReferenceLoad',strValue);
        end
        
        function value = get.ReferenceLoad(obj)
            value = getParameter(obj,'ReferenceLoad');
        end
        
        % FFTLENGTH SET/GET
        function set.FFTLength(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'FFTLength');
            if ~variableUndefined
                obj.validateFFTLength(value);
            end
            setScopeParameter(obj,'FFTLength',strValue);
        end
        
        function value = get.FFTLength(obj)
            value =  getParameter(obj,'FFTLength');
        end
        
        % FFTLengthSource SET/GET
        function set.FFTLengthSource(obj, strValue)
            strValue = obj.validateEnum(strValue,'FFTLengthSource',{'Auto','Property'});
            setScopeParameter(obj,'FFTLengthSource',strValue);
        end
        
        function value = get.FFTLengthSource(obj)
            value = getParameter(obj,'FFTLengthSource');
        end
        
        % FREQUENCYOFFSET SET/GET
        function set.FrequencyOffset(obj, strValue)
            errorForNonTunableProperty(obj,'FrequencyOffset');
            [value,variableUndefined] = evaluateString(obj,strValue,'FrequencyOffset');
            if ~variableUndefined
                obj.validateFrequencyOffset(value);
            end
            setScopeParameter(obj,'FrequencyOffset',strValue);
        end
        
        function value = get.FrequencyOffset(obj)
            value = getParameter(obj,'FrequencyOffset');
        end
        
        % WINDOW SET/GET
        function set.Window(obj, value)
            value = obj.validateEnum(value,'Window',{'Hann','Hamming',...
                'Kaiser','Chebyshev','Rectangular','Flat Top'});
            setScopeParameter(obj,'Window',value);
        end
        
        function value = get.Window(obj)
            value = getParameter(obj,'Window');
        end
        
        % SIDELOBEATTENUATION SET/GET
        function set.SidelobeAttenuation(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue, ...
                'SidelobeAttenuation');
            if ~variableUndefined
                obj.validateSidelobeAttenuation(value);
            end
            setScopeParameter(obj,'SidelobeAttenuation',strValue);
        end
        
        function value = get.SidelobeAttenuation(obj)
            value =  getParameter(obj,'SidelobeAttenuation');
        end
        
        % SPECTRUMTYPE SET/GET
        function set.SpectrumType(obj, value)
            value = obj.validateEnum(value,'SpectrumType',{'Power','Power density','Spectrogram'});
            setScopeParameter(obj,'SpectrumType',value);
        end
        
        function value = get.SpectrumType(obj)
            value = getParameter(obj,'SpectrumType');
        end
        
        %LegacySetFlag SET/GET	 
         function set.LegacySetFlag(obj, value)	 
             setScopeParameter(obj,'MapLegacyBlock',value);	 
         end	 
 	 
         function value = get.LegacySetFlag(obj)	 
             value = getParameter(obj,'MapLegacyBlock');	 
         end	 
 
        % FREQUENCYSPAN SET/GET
        function set.FrequencySpan(obj, value)
            value = obj.validateEnum(value,'FrequencySpan',{ 'Full',...
                'Start and stop frequencies',...
                'Span and center frequency'});
            setScopeParameter(obj,'FrequencySpan',value);
        end
        
        function value = get.FrequencySpan(obj)
            value = getParameter(obj,'FrequencySpan');
        end
        
        % STARTFREQUENCY SET/GET
        function set.StartFrequency(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'StartFrequency');
            if ~variableUndefined
                obj.validateStartFrequency(value);
            end
            setScopeParameter(obj,'StartFrequency',strValue);
            setScopeParameter(obj,'IsFstartFstopSettingDirty',true);
        end
        
        function value = get.StartFrequency(obj)
            value = getParameter(obj,'StartFrequency');
        end
        
        % STOPFREQUENCY SET/GET
        function set.StopFrequency(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'StopFrequency');
            if ~variableUndefined
                obj.validateStopFrequency(value);
            end
            setScopeParameter(obj,'StopFrequency',strValue);
            setScopeParameter(obj,'IsFstartFstopSettingDirty',true);
        end
        
        function value = get.StopFrequency(obj)
            value = getParameter(obj,'StopFrequency');
        end
        
        % CENTERFREQUENCY SET/GET
        function set.CenterFrequency(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'CenterFrequency');
            if ~variableUndefined
                obj.validateCenterFrequency(value);
            end
            setScopeParameter(obj,'CenterFrequency',strValue);
            setScopeParameter(obj,'IsSpanCFSettingDirty',true);
        end
        
        function value = get.CenterFrequency(obj)
            value = getParameter(obj,'CenterFrequency');
        end
        
        % SPAN SET/GET
        function set.Span(obj, strValue)
            [value,variableUndefined] = evaluateString(obj,strValue,'Span');
            if ~variableUndefined
                obj.validateSpan(value);
            end
            setScopeParameter(obj,'Span',strValue);
            setScopeParameter(obj,'IsSpanCFSettingDirty',true);
        end
        
        function value = get.Span(obj)
            value = getParameter(obj,'Span');
        end
        
        % POWERUNITS SET/GET
        function set.PowerUnits(obj, value)
            value = obj.validateEnum(value,'PowerUnits',{'Watts','dBm','dBW'});
            setScopeParameter(obj,'PowerUnits',value);
        end
        
        function value = get.PowerUnits(obj)
            value = getParameter(obj,'PowerUnits');
        end
        
        % FREQUENCYSCALE SET/GET
        function set.FrequencyScale(obj, value)
            validateFrequencyScale(obj,value);
            setScopeParameter(obj,'FrequencyScale',value);
        end
        
        function value = get.FrequencyScale(obj)
            value = getParameter(obj,'FrequencyScale');
        end
        
        % TWOSIDEDSPECTRUM SET/GET
        function set.PlotAsTwoSidedSpectrum(obj, value)
            errorForNonTunableProperty(obj,'PlotAsTwoSidedSpectrum');
            obj.ValidatePlotAsTwoSidedSpectrum(value);
            setScopeParameter(obj,'TwoSidedSpectrum',value);
        end
        
        function value = get.PlotAsTwoSidedSpectrum(obj)
            value = getParameter(obj,'TwoSidedSpectrum');
        end
        
        % MAXHOLDTRACE SET/GET
        function set.PlotMaxHoldTrace(obj, value)
            validatePlotMaxHoldTrace(obj,value);
            setScopeParameter(obj,'MaxHoldTrace',value);
        end
        
        function value = get.PlotMaxHoldTrace(obj)
            value = getParameter(obj,'MaxHoldTrace');
        end
        
        % MINHOLDTRACE SET/GET
        function set.PlotMinHoldTrace(obj, value)
            validatePlotMinHoldTrace(obj,value);
            setScopeParameter(obj,'MinHoldTrace',value);
        end
        
        function value = get.PlotMinHoldTrace(obj)
            value = getParameter(obj,'MinHoldTrace');
        end
        
        % NORMALTRACE SET/GET
        function set.PlotNormalTrace(obj, value)
            validatePlotNormalTrace(obj,value);
            setScopeParameter(obj,'NormalTrace',value);
        end
        
        function value = get.PlotNormalTrace(obj)
            value = getParameter(obj,'NormalTrace');
        end
        
        % GRID SET/GET
        function set.ShowGrid(obj, value)
            obj.validateGrid(value);
            setScopeParameter(obj,'Grid',value);
        end
        
        function value = get.ShowGrid(obj)
            value = getParameter(obj,'Grid');
        end
        
        % REDUCEPLOTRATE SET/GET
        function set.ReducePlotRate(obj, value)
            obj.validateReduceUpdates(value);
            setScopeParameter(obj,'ReduceUpdates',value);
        end
        
        function value = get.ReducePlotRate(obj)
            value = getParameter(obj,'ReduceUpdates');
        end
        
         % REDUCEPLOTRATE SET/GET
        function set.TreatMby1SignalsAsOneChannel(obj, value)
            errorForNonTunableProperty(obj,'TreatMby1SignalsAsOneChannel');
            obj.validateTreatMby1SignalsAsOneChannel(value);
            setScopeParameter(obj,'TreatMby1SignalsAsOneChannel',value);
        end
        
        function value = get.TreatMby1SignalsAsOneChannel(obj)
            value = getParameter(obj,'TreatMby1SignalsAsOneChannel');
        end
        
        
        % LEGEND SET/GET
        function set.ShowLegend(obj, value)
            obj.validateLegend(value);
            setScopeParameter(obj,'Legend',value);
        end
        
        function value = get.ShowLegend(obj)
            value = getParameter(obj,'Legend');
        end
        
        % YLimits SET/GET
        function set.YLimits(obj, value)
            obj.validateYLimits(value);
            setScopeParameter(obj, 'MinYLim', num2str(value(1)));
            setScopeParameter(obj, 'MaxYLim', num2str(value(2)));
            % Turn off autoscaling options to preserve yLimits on
            % simulation when visual is not loaded up yet
            disableAutoscale(obj);
        end
        
        function value = get.YLimits(obj)
            value = [ obj.evaluateVariable(getParameter(obj,'MinYLim')) ...
                     obj.evaluateVariable(getParameter(obj,'MaxYLim'))];
        end
        
        % SAMPLERATE GET
        function value = get.SampleRate(obj)
            value = getParameter(obj,'SampleRate');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%  GET/SET METHODS FOR LEGACY PROPERTIES %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % WINTYPESPECSCOPE SET/GET
        function set.wintypeSpecScope(obj, strValue)
            % Legacy and new enums are not one-to-one
            strValue_lower = lower(strValue);
            switch strValue_lower
                case {'boxcar'}
                    obj.Window = 'Rectangular';
                case {'chebyshev','hann','hamming','kaiser'}
                    obj.Window = strValue;
                otherwise
                    obj.Window = 'Hann';
            end
            % If the Window is 'Kaiser' or 'Chebyshev', must set legacy
            % sidelobe attenuation
            obj.wintypeSpecScopeLocal = strValue;
            setLegacyAttenation(obj);
        end
        
        function value = get.wintypeSpecScope(obj)
            value = obj.Window;
        end
        
        %RSSPECSCOPE SET/GET
        function set.RsSpecScope(obj, strValue)
            obj.RsSpecScopeLocal = strValue;
            % If the Window is 'Chebyshev', must set sidelobe attenuation
            % to RsSpecScope for backwards compatibility
            setLegacyAttenation(obj);
        end
        
        function value = get.RsSpecScope(obj)
            value = obj.SidelobeAttenuation;
        end
        
        %BETASPECSCOPE SET/GET
        function set.betaSpecScope(obj, strValue)
            obj.betaSpecScopeLocal = strValue;
            % If the Window is 'Kaiser', must set sidelobe attenuation
            % to betaSpecScope for backwards compatibility
            setLegacyAttenation(obj);
        end
        
        function value = get.betaSpecScope(obj)
            value = obj.SidelobeAttenuation;
        end
        
        function  setLegacyAttenation(obj)
            % Set SidelobeAttenuation to the legacy value if Window was set
            % to Kaiser or Chebychev.
            % Setting can occur only after setting the three parameters
            % wintypeSpecScope, betaSpecScope and RsSpecScope is complete
            strValue = '';
            if ~strcmp(obj.wintypeSpecScopeLocal,'unset') && ...
                    ~strcmp(obj.betaSpecScopeLocal,'unset') && ...
                    ~strcmp(obj.RsSpecScopeLocal,'unset')
                if strcmpi(obj.wintypeSpecScopeLocal,'Kaiser')
                    strValue = obj.betaSpecScopeLocal;
                elseif strcmpi(obj.wintypeSpecScopeLocal,'Chebyshev')
                    strValue = obj.RsSpecScopeLocal;
                end
                if ~isempty(strValue)
                    % SidelobeAttenuation for SpectrumAnalyzer cannot be less
                    % than 45 dB
                    % This restriction did not exist for SpectrumScope
                    % If value was less than 45 dB on SpectrumScope, change it
                    % to 45 dB
                    [value,variableUndefined] = evaluateString(obj,strValue, ...
                        'SidelobeAttenuation');
                    if ~variableUndefined
                        if value < 45
                            strValue = '45';
                        end
                    end
                    obj.SidelobeAttenuation = strValue;
                end
            end
        end
        
        % NUMAVG SET/GET
        function set.numAvg(obj, strValue)
            obj.SpectralAverages = strValue;
        end
        
        function value = get.numAvg(obj)
            value = obj.SpectralAverages;
        end
        
        % XRange SET/GET
        function set.XRange(obj, strValue)
            % In 9a and earlier versions, [0...Fs] and [Fs/s...Fs/2] 
            % correspond to two-sided spectrum. [0...Fs/2] corresponds to 
            % one-sided spectrum. 
            % In 9b and later versions, there are only two options
            % (one-sided ([0...Fs/2]) and double-sided ((Fs/2...Fs/2]))
            if ~isempty(strfind(lower(strValue),'-fs/2...fs/2')) || ...
               ~isempty(strfind(lower(strValue),'[0...fs]'))
                obj.PlotAsTwoSidedSpectrum = true;
            else
                obj.PlotAsTwoSidedSpectrum = false;
            end
        end
        
        function value = get.XRange(obj)
            if obj.PlotAsTwoSidedSpectrum
                value = 'Two-sided ((-Fs/2...Fs/2])';
            else
                value = 'One-sided ([0...Fs/2])';
            end
        end
        
        % AXISGRID SET/GET
        function set.AxisGrid(obj, strValue)
            if strcmp(strValue,'on')
                obj.ShowGrid = true;
            else
                obj.ShowGrid = false;
            end
        end
        
        function value = get.AxisGrid(obj)
            if obj.ShowGrid
                value = 'on';
            else
                value = 'off';
            end
        end
        
        % AXISILEGEND SET/GET
        function set.AxisLegend(obj, strValue)
            if strcmp(strValue,'on')
                obj.ShowLegend = true;
            else
                obj.ShowLegend = false;
            end
        end
        
        function value = get.AxisLegend(obj)
            if obj.ShowLegend
                value = 'on';
            else
                value = 'off';
            end
        end
        
        % MEMORY SET/GET
        function set.Memory(obj, strValue)
            if strcmp(strValue,'on')
                obj.PlotMaxHoldTrace = true;
            else
                obj.PlotMaxHoldTrace = false;
            end
        end
        
        function value = get.Memory(obj)
            if obj.PlotMaxHoldTrace
                value = 'on';
            else
                value = 'off';
            end
        end
        
        % INPFFTLENINHERIT SET/GET
        function set.inpFftLenInherit(obj, strValue)
            if strcmp(strValue,'on')
                obj.FFTLengthSource = 'Property';
            else
                obj.FFTLengthSource = 'Auto';
            end
        end
        
        function value = get.inpFftLenInherit(obj)
            if strcmp(obj.FFTLengthSource,'Property')
                value = 'on';
            else
                value = 'off';
            end
        end
        
        % XDisplay SET/GET
        function set.XDisplay(obj, strValue)
            obj.FrequencyOffset = strValue;
        end
        
        function value = get.XDisplay(obj)
            value =  obj.FrequencyOffset;
        end

        % FFTLENGTH SET/GET
        function set.FFTlength(obj, strValue)
            obj.FFTLength = strValue;
        end
        
        function value = get.FFTlength(obj)
            value = obj.FFTLength;
        end
        
        % FIGPOS SET
        function set.FigPos(obj, strValue)
            % Remove comment from the string
            ind = strfind(strValue,'%');
            if ~isempty(ind)
                strValue = strValue(1:ind-1);
            end
            obj.Position = obj.evaluateVariable(strValue);
        end
        
        function value = get.FigPos(obj)
            value = sprintf('[%s]',num2str(obj.Position));
            value = strrep(value,'  ',' ');
        end
        
        % XLIMIT SET
        function set.XLimit(obj, strValue)
            if strcmpi(strValue,'Auto')
                obj.FrequencySpan = 'Full';
                return;
            end
            obj.XLimitLocal = strValue;
            % If legacy frequency limits are set to user-defined, span on
            % new block should be set to [Fstart,Fstop]
            setStartStopFrq(obj);
        end
        
        function value = get.XLimit(obj)
            if strcmp(obj.FrequencySpan,'Full')
                value = 'Auto';
            else
                value = 'User-defined';
            end
        end
        
        function set.XMin(obj, strValue)
            obj.XMinLocal = strValue;
            % If legacy frequency limits are set to user-defined, span on
            % new block should be set to [Fstart,Fstop]
            setStartStopFrq(obj);
        end
        
        function value = get.XMin(obj)
            if strcmp(obj.FrequencySpan,'Start and stop frequencies')
                value = obj.StartFrequency;
            elseif strcmp(obj.FrequencySpan,'Span and center frequency')
                value = sprintf('%s - %s/2',obj.CenterFrequency,obj.Span);
            else
                if obj.PlotAsTwoSidedSpectrum
                    value = sprintf('-%s/2',obj.SampleRate);
                else
                    value = '0';
                end
            end
        end
        
        function set.XMax(obj, strValue)
            obj.XMaxLocal = strValue;
            % If legacy frequency limits are set to user-defined, span on
            % new block should be set to [Fstart,Fstop]
            setStartStopFrq(obj);
        end
        
        function value = get.XMax(obj)
            if strcmp(obj.FrequencySpan,'Start and stop frequencies')
                value = obj.StopFrequency;
            elseif strcmp(obj.FrequencySpan,'Span and center frequency')
                value = sprintf('%s + %s/2',obj.CenterFrequency,obj.Span);
            else
                value = sprintf('%s/2',obj.SampleRate);
            end
        end
        
        function setStartStopFrq(obj)
            % If legacy frequency limits are set to user-defined, span on
            % new block should be set to [Fstart,Fstop]
            % We can only do the check after parameters XLimit, XMin, XMax
            % have been set
            if ~strcmp(obj.XLimitLocal,'unset') && ...
                    ~strcmp(obj.XMinLocal,'unset') && ...
                    ~strcmp(obj.XMaxLocal,'unset')
                if strcmpi(obj.XLimitLocal,'User-defined')
                    % Custom min and max frequencies were specified:
                    obj.FrequencySpan = 'Start and stop frequencies';
                    obj.StartFrequency = obj.XMinLocal;
                    obj.StopFrequency =  obj.XMaxLocal;
                    % Set Dirty flag to true to avoid overwritting to full
                    % span mode on sim start
                    obj.IsFstartFstopSettingDirty = true;
                end
            end
        end
        
        function set.IsFstartFstopSettingDirty(obj,val)
            setScopeParameter(obj,'IsFstartFstopSettingDirty',val);
        end
        
        % YMIN SET
        function set.YMin(obj, strValue)
            % MinYLim does not accept variables that are not defined yet
            % If evaluation fails, do not map the paramter
            [val, errId, errStr]  = obj.evaluateVariable(strValue);
            if isempty(errId) &&  isempty(errStr)
                if isLaunched(obj.Scope)
                    obj.validateYLimits([val,obj.YLimits(2)]);
                end
                setScopeParameter(obj,'MinYLim',strValue);
                % Disable autoscale options since a custom YLimit was
                % specified
                % Default value on old scope is -10. If that's the value
                % being set, skip autoscale disable.
                if ~strcmp(strValue,'-10')
                    disableAutoscale(obj);
                end
            end
        end
        
        function value = get.YMin(obj)
            value = num2str(obj.YLimits(1));
        end
        
        % YMAX SET
        function set.YMax(obj, strValue)
            % MaxYLim does not accept variables that are not defined yet
            % If evaluation fails, do not map the paramter
            [val, errId, errStr]  = obj.evaluateVariable(strValue);
            if isempty(errId) &&  isempty(errStr)
                if isLaunched(obj.Scope)
                    obj.validateYLimits([obj.YLimits(1),val]);
                end
                setScopeParameter(obj,'MaxYLim',strValue);
                % Disable autoscale options since a custom YLimit was
                % specified
                % Default value on old scope is 10. If that's the value
                % being set, skip autoscale disable.
                if ~strcmp(strValue,'10')
                    disableAutoscale(obj);
                end
            end
        end
        
        function value = get.YMax(obj)
            value = num2str(obj.YLimits(2));
        end
        
        %OPENSCOPEATSIMSTART SET
        function set.OpenScopeAtSimStart(obj, strValue)
            if strcmp(strValue,'on')
                obj.OpenAtSimulationStart = true;
            else
                obj.OpenAtSimulationStart = false;
            end
        end
        
        function value = get.OpenScopeAtSimStart(obj)
            if obj.OpenAtSimulationStart
                value = 'on';
            else
                value = 'off';
            end
        end
        
        function set.OpenScopeImmediately(~, ~)
            
        end
        
        function value = get.OpenScopeImmediately(~)
            value = 'off';
        end

        %SEGLEN SET/GET
        function set.SegLen(obj, value)
            setScopeParameter(obj,'SegLen',value);
        end
        
        function value = get.SegLen(obj)
            value = getParameter(obj,'SegLen');
        end
        
        % UseBuffer and BufferSize play role in determining segment
        % length on the new block:
        % If UseBuffer is ON, segmentlength = legacy BufferSize
        % If UseBuffer is OFF, segmentlength = input frame size
        % This segment length will be used to set the RBW.
        % However, since RBW requires compile-time information (sampleRate
        % and input frame size), setting RBW is delayed to mdlStart
        
        % USEBUFFER SET
        function set.UseBuffer(obj, strValue)
            if obj.Scope.ScopeCfg.executedStartFcn
                % Parameter was already mapped to preserve backwards
                % compatibility. Do nothing:
                return;
            end
            if strcmp(strValue,'on')
                obj.UseBufferLocal = true;
            else
                obj.UseBufferLocal = false;
            end
            % If LegacySetFlag = true, mdlStart will calculate RBW based on
            % SegmentLength
            obj.LegacySetFlag  = true;
            setSegmentLengthInfo(obj);
            setLegacyOverlap(obj);
        end
        
        function value = get.UseBuffer(~)
            value = 'on';
        end
        
        function set.BufferSize(obj, strValue)
            if obj.Scope.ScopeCfg.executedStartFcn
                % Parameter was already mapped to preserve backwards
                % compatibility. Do nothing:
                return;
            end
            obj.BufferSizeLocal = strValue;
            obj.FrequencyResolutionMethod = 'WindowLength';
            % If LegacySetFlag = true, mdlStart will calculate RBW based on
            % SegmentLength
            obj.LegacySetFlag          = true;
            setSegmentLengthInfo(obj);
            setLegacyOverlap(obj);
        end
        
        function value = get.BufferSize(obj)
             framework =  obj.Scope.ScopeCfg.Scope.Framework;
             if ~isempty(framework)
                value = framework.visual.DataBuffer.SegmentLength;
                value = num2str(value);
             else % not set yet 
                val = obj.BufferSizeLocal; 
                if isempty(val)
                    val = '';
                end
                value = val;
             end
        end
        
        function setSegmentLengthInfo(obj)
            % Both UseBuffer and BufferSize must be set before we can get
            % the segment length
            if (obj.UseBufferLocal~=-1) && ...
                    ~isempty(obj.BufferSizeLocal)
                if obj.UseBufferLocal % buffer is used
                    obj.SegLen = obj.BufferSizeLocal;
                    obj.WindowLength = obj.BufferSizeLocal;
                else
                    % Must use the size of the input to determine segment
                    % length
                    obj.SegLen = 'useInputSize';
                end
            end
        end
        
        % OVERLAP SET
        function set.Overlap(obj, strValue)
            if obj.Scope.ScopeCfg.executedStartFcn
                % Parameter was already mapped to preserve backwards
                % compatibility. Do nothing:
                return;
            end
            obj.OverlapLocal = strValue;
            % set the overlap percent:
            setLegacyOverlap(obj);
        end
        
        function value = get.Overlap(obj)
            if ~isempty(obj.BufferSize)
                value =sprintf('round(%s * %s / 100)',obj.OverlapPercent,obj.BufferSize);
                value = simplifyString(obj,value);
            else
                value = '';
            end
        end
        
        function setLegacyOverlap(obj)
            % If UseBuffer is false, the overlap is zero
            % If UseBuffer is true, the overlap is determined by the number
            % of buffer samples and the number of overlap samples
            if (obj.UseBufferLocal~=-1) && ...
                    ~isempty(obj.BufferSizeLocal) && ...
                    ~isempty(obj.OverlapLocal)
                if obj.UseBufferLocal
                    val = sprintf('100 * (%s)/(%s)',...
                        obj.OverlapLocal,obj.BufferSizeLocal);
                    [val_eval,~] = obj.evaluateVariable(val);
                    if (~isempty(val_eval) && isscalar(val_eval) && ...
                                isreal(val_eval) && val_eval>=0 && val_eval<100) ...
                            || (isempty(val_eval))
                        obj.OverlapPercent = sprintf('100 * (%s)/(%s)',...
                            obj.OverlapLocal,obj.BufferSizeLocal);
                    end
                else
                    obj.OverlapPercent = '0';
                end
                obj.OverlapPercent = simplifyString(obj,obj.OverlapPercent);
            end
        end
        
        % YUNITS SET
        function set.YUnits(obj, strValue)
            
            strValue_lower = lower(strValue);
            % in 9a, units were dB or Magnitude-squared (per Hertz)
            % In 12b, units can be dBm, dBW, Watts, dBm/Hz, dBW/Hz, Watts/Hz 
            if ~isempty(strfind(strValue_lower,'hertz'))  || ...
                 ~isempty(strfind(strValue_lower,'magnitude-squared')) || ...
                 (isempty(strfind(strValue_lower,'dbw')) && ...
                 isempty(strfind(strValue_lower,'dbm')) && ...
                 ~isempty(strfind(strValue_lower,'db')))
                obj.SpectrumType = 'Power density';
            else
                obj.SpectrumType = 'Power';
            end
            
            if ~isempty(strfind(strValue_lower,'dbw')) 
                obj.PowerUnits = 'dBW';
            elseif ~isempty(strfind(strValue_lower,'dbm'))
                obj.PowerUnits = 'dBm';
            elseif ~isempty(strfind(strValue_lower,'db'))
                obj.PowerUnits = 'dBW';
            else
                obj.PowerUnits = 'Watts';
            end
        end
        
        function value = get.YUnits(obj)
            value = obj.PowerUnits;
            if strcmp(obj.SpectrumType , 'Power density')
                value = sprintf('%s/Hertz',value);
            end
        end
        
        % TreatMby1Signals SET/GET
        function set.TreatMby1Signals(obj, val)
            if strcmp(val,'One channel')
                obj.TreatMby1SignalsAsOneChannel = true;
            else
                obj.TreatMby1SignalsAsOneChannel = false;
            end
        end
        
        function value = get.TreatMby1Signals(obj)
             if obj.TreatMby1SignalsAsOneChannel
                value = 'One channel';
            else
                value = 'M channels';
            end
        end
        
        function set.LineDisables(~, ~)
            % NOT SUPPORTED
        end
        
        function set.LineStyles(~, ~)
            % NOT SUPPORTED
        end
        
        function set.LineMarkers(~, ~)
            % NOT SUPPORTED
        end
        
        function set.LineColors(~, ~)
            % NOT SUPPORTED
        end
        
        function value = get.LineDisables(~)
            % NOT SUPPORTED
            value = '';
        end
        
        function value = get.LineStyles(~)
            % NOT SUPPORTED
            value = '';
        end
        
        function value = get.LineMarkers(~)
            % NOT SUPPORTED
            value = '';
        end
        
        function value = get.LineColors(~)
            % NOT SUPPORTED
            value = '';
        end
        
        function set.WinsampSpecScope(~, ~)
            % NOT SUPPORTED
        end
        
        function value = get.WinsampSpecScope(~)
            value = 'Symmetric';
        end
        
        function set.FrameNumber(~, ~)
            % NO OP
        end
        
        function value = get.FrameNumber(~)
            value = 'on';
        end
        
        function set.AxisZoom(~, ~)
            % NO OP
        end
        
        function value = get.AxisZoom(~)
            value = 'off';
        end
        
        function set.InheritXIncr(~, ~)
            % NO OP
        end
        
        function value = get.InheritXIncr(~)
            value = 'on';
        end
        
        function set.XIncr(~, ~)
            % NO OP
        end
        
        function value = get.XIncr(~)
            value = ''; % not supported
        end
        
        % VALIDATE METHODS
        
        function validatePlotNormalTrace(obj,value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','PlotNormalTrace');
            if ~obj.PlotMinHoldTrace && ~obj.PlotMaxHoldTrace && ~value
                error(message('measure:SpectrumAnalyzer:AllTracesOff'));
            end
        end
        
        function validatePlotMaxHoldTrace(obj,value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','PlotMaxHoldTrace');
            if ~obj.PlotNormalTrace && ~obj.PlotMinHoldTrace && ~value
                error(message('measure:SpectrumAnalyzer:AllTracesOff'));
            end
        end
        
        function validatePlotMinHoldTrace(obj,value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','PlotMinHoldTrace');
            if ~obj.PlotNormalTrace && ~obj.PlotMaxHoldTrace && ~value
                error(message('measure:SpectrumAnalyzer:AllTracesOff'));
            end
        end
        
        function validateFrequencyScale(obj,value)
            value = obj.validateEnum(value,'FrequencyScale',{'Linear','Log'});
            if obj.PlotAsTwoSidedSpectrum && strcmp(value,'Log')
                error(message('measure:SpectrumAnalyzer:InvalidFreqScale'));
            end
        end

    end
    
    methods (Access = protected)
        
        function [value,errorOccured] = evaluateString(obj,strValue,propName)
            
            validateattributes(strValue,{'char'},{},'',propName);
            
            errorOccured = false;
            isSourceRunning = false;
            Framework = obj.Scope.Framework;
            if ~isempty(Framework)
                src = Framework.DataSource;
                if ~isempty(src)
                    if isRunning(src) || isPaused(src)
                        isSourceRunning = true;
                    end
                end
            end
            [value, ~, errStr] = obj.evaluateVariable(strValue);
            if ~isempty(errStr)
                errorOccured = true;
                if isSourceRunning
                    % If we are in a locked state, error out if the specified variable
                    % does not evaluate
                    [errStr, errId] = uiservices.message('EvaluateUndefinedVariable', strValue);
                    throw(MException(errId, errStr)); 
                end
            end
        end
        
        function errorForNonTunableProperty(obj,propertyName)
            % If simulation is running, error out (non-tunable)
            Framework = obj.Scope.Framework;
            if ~isempty(Framework)
                src = Framework.DataSource;
                if ~isempty(src)
                    if isRunning(src) || isPaused(src)
                        error(message('measure:SpectrumAnalyzer:PropertyNotTunable',propertyName));
                    end
                end
            end
        end
        
        function newStrVal = simplifyString(obj,strVal)
            % Preserve variable names (do not evaluate)
            strVal2 = strrep(strVal,'round(',''); % round is OK
            if ~isempty(regexp(strVal2,'[a-zA-Z]', 'once'))
                newStrVal = strVal;
                return;
            end
            [val,errStr] =  obj.evaluateVariable(strVal);
            if isempty(errStr)
                newStrVal = num2str(val);
            else
                newStrVal = strVal;
            end 
        end
        
        function disableAutoscale(obj)
            % turn off autoscaling options to preserve yLimits on 
            % simulation when visual is not loaded up yet.
            % If the scope is already launched, there is no need to perform
            % the disable (it happens automatically). 
            if ~isLaunched(obj.Scope)
                setScopeParamOnConfig(obj.Scope,'Tools','Plot Navigation','OnceAtStop',...
                    'bool',false);
                setScopeParamOnConfig(obj.Scope,'Tools','Plot Navigation','AutoscaleMode',...
                    'string','Manual');
            end
        end

    end
    
    methods (Static)
        function validateRBW(value)
            validateattributes(value,{'double'}, {'real','scalar','>',0,'finite','nonnan'},'','RBW');
        end
        
        function validateWindowLength(value)
            validateattributes(value,{'double'}, {'positive','integer','scalar','real','>',2,'finite','nonnan'},'','WindowLength');
        end
        
        function validateTimeResolution(value)
            validateattributes(value,{'double'}, {'positive','scalar','real','finite','nonnan'},'','TimeResolution');
        end
        
        function validateTimeSpan(value)
            validateattributes(value,{'double'}, {'positive','scalar','real','finite','nonnan'},'','TimeSpan');
        end
        
        function validateSpectralAverages(value)
            validateattributes(value,{'double'},  {'positive','integer','scalar','real','finite','nonnan'},'','SpetralAverages');
        end
        
        function validateReferenceLoad(value)
            validateattributes(value,{'double'}, {'positive','real','scalar','finite','nonnan'},'','ReferenceLoad');
        end
        
        function validateFFTLength(value)
            validateattributes(value,{'double'},  {'positive','integer','scalar','real','finite','nonnan'},'','FFTLength');
        end
        
        function validateFrequencyOffset(value)
            validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','FrequencyOffset');
        end
        
        function ValidatePlotAsTwoSidedSpectrum(value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','PlotAsTwoSidedSpectrum');
        end
        
        function validateGrid(value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','ShowGrid');
        end
        
        function validateReduceUpdates(value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','ReducePlotRate');
        end
        
        function validateTreatMby1SignalsAsOneChannel(value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','TreatMby1SignalsAsOneChannel');
        end
        
        function validateLegend(value)
            validateattributes(value,{'logical'}, {'real','scalar'},'','ShowLegend');
        end
        
        function validateSidelobeAttenuation(value)
            validateattributes(value,{'double'}, {'positive','real','scalar','>=',45,'finite','nonnan'},'','SidelobeAttenuation');
        end
        
        function validateStartFrequency(value)
            validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','StartFrequency');
        end
        
        function validateStopFrequency(value)
            validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','StopFrequency');
        end
        
        function validateCenterFrequency(value)
            validateattributes(value,{'double'}, {'real','scalar','finite','nonnan'},'','CenterFrequency');
        end
        
        function validateSpan(value)
            validateattributes(value,{'double'}, {'real','scalar','>',0,'finite','nonnan'},'','Span');
        end
        
        function validateOverlapPercent(value)
            validateattributes(value,{'double'}, {'real','scalar','>=',0,'<',100,'nonnan'},'','OverlapPercent');
        end
        
        function validateYLimits(value)
            if ~all(isnumeric(value)) || ~all(isfinite(value)) || ...
                    numel(value)~=2 || value(1) >= value(2)
                error(message('measure:SpectrumAnalyzer:InvalidYLimits','YLimits'));
            end
        end
        
        function value = validateEnum(value,propName,ValidValues)
            validateattributes(value,{'char'},{},'',propName);
            ind = find(ismember(lower(ValidValues), lower(value))==1, 1);
            if isempty(ind)
                error(message('measure:SpectrumAnalyzer:InvalidEnumValue',propName));
            end
            % Fix case
            value = ValidValues{ind};
        end
    end


    methods(Hidden)
        function props = getDisplayProperties(this) %#ok<MANU>
            props = {...
                'Name', ...
                'OpenAtSimulationStart', ...
                'Visible',...
                'Position', ...
                'SampleRate', ...
                'SpectrumType', ...
                'FrequencySpan', ...
                'Span', ...
                'CenterFrequency',...
                'StartFrequency', ...
                'StopFrequency', ...
                'FrequencyResolutionMethod',...
                'RBWSource', ...
                'RBW', ...
                'WindowLength',...
                'FFTLengthSource', ...
                'FFTLength', ...                
                'OverlapPercent', ...
                'Window', ...
                'SidelobeAttenuation', ...
                'TimeResolutionSource',...
                'TimeResolution',...
                'TimeSpanSource',...
                'TimeSpan',...                
                'SpectralAverages', ...
                'PowerUnits', ...
                'ReferenceLoad', ...
                'PlotMaxHoldTrace', ...
                'PlotMinHoldTrace', ...
                'PlotNormalTrace', ...
                'PlotAsTwoSidedSpectrum', ...
                'FrequencyScale', ...
                'FrequencyOffset', ...
                'Title', ...
                'YLimits', ...
                'YLabel', ...
                'ShowLegend', ...
                'ShowGrid', ...
                'ReducePlotRate',...
                'TreatMby1SignalsAsOneChannel'};
        end
    end
end

function  value = removeLegacyUnits(value)
% Remove ', Watts/Hz' patterns
value = regexprep(value,',\s*(dBm|dBW|Watts|dB)(\/Hz)?','');
% Remove '(dBm)' patterns
value = regexprep(value,'\(\s*(dBm|dBW|Watts|dB)(\/Hz)?\s*\)','');
end
