classdef SpectrumAnalyzerBlockCfg < Simulink.scopes.ScopeBlockSpecification
    %spectrumAnalyzerBlockCfg   Define the spectrumAnalyzerBlockCfg class.
    
    %   Copyright 2009-2013 The MathWorks, Inc.
    
    properties(Transient)        
        executedStartFcn = false;
        executedMdlStart = false;
    end
    
    properties
        OpenAtMdlStart = true;
    end
    
    methods
        
        function this = SpectrumAnalyzerBlockCfg(varargin)
            %SpectrumScopeBlockCfg  Construct the SpectrumScopeBlockCfg class.
            
            % Prevent clear classes warnings
            mlock;
            
            this@Simulink.scopes.ScopeBlockSpecification(varargin{:});
            this.Position = this.getDefaultPosition;
        end
    end
    
    methods
        
        function hCopy = copy(this)
            hCopy = copy@Simulink.scopes.ScopeBlockSpecification(this);
            hCopy.OpenAtMdlStart = this.OpenAtMdlStart;
        end
        
        function openAtMdlStart = getOpenAtMdlStart(this)
            openAtMdlStart = this.OpenAtMdlStart;
        end
        
        function b = getNeedRuntimeCallbacks(~)
            % for core block, no need for an update callback
            b = false;
        end
        
        function setBlockParams(this, varargin)
            if nargin > 1
                setBlockParam(this.Scope, varargin{:});
            end
        end
        
        function setScopeParams(~)
            
        end
        
        function b = showConfiguration(~)
            %showConfiguration - Return false to hide the configuration
            %controls menu item
            b = false;
        end
        
        function appName = getAppName(~)
            %getAppName Returns the simple application name.
            appName = 'Spectrum Analyzer';
        end
        
        function hTypes = getHiddenTypes(~)
            hTypes = {'Sources', 'Visuals'};
        end
        
        function hiddenExts = getHiddenExtensions(~)
            %getHiddenExtensions Returns the extensions to hide.
            
            hiddenExts = {'Core:Source UI', ...
                'Visuals', ...
                'Tools:Instrumentation Sets', ...
                'Tools:Image Tool', ...
                'Tools:Pixel Region', ...
                'Tools:Image Navigation Tools', ...
                };
        end
        
        function measurementTags = getSupportedMeasurements(~)
            measurementTags = {'fcursors','peaks','channel','distortion','ccdf'};
        end
        
        function mdlStart(this)
            
            set(this.Scope.getWidget('Base/Menus/File/Sources/OpenAtMdlStart'), ...
                'Enable', 'off');
            this.executedMdlStart = true;
            startFcn(this);
        end
        

        function onScopeLaunched(this)
            
            hFrameWork = this.Scope.Framework;
            if isempty(hFrameWork)
                return;
            end
            
            hVisual = hFrameWork.Visual;
            if isempty(hVisual)
                return;
            end
            
            % This startup function should not dirty model
            dirtyState = getDirtyStatus(hVisual);
            ccleanup = onCleanup(@()restoreDirtyStatus(hVisual,dirtyState));
            
            if ~this.executedStartFcn && this.executedMdlStart
                startFcn(this);
            end
        end

        
        function mdlTerminate(this)
            
            hFrameWork = this.Scope.Framework;
            if ~isempty(hFrameWork)
                hVisual = hFrameWork.Visual;
                hVisual.DataBuffer.flush;
                
            end
            
            set(this.Scope.getWidget('Base/Menus/File/Sources/OpenAtMdlStart'), ...
                'Enable', 'on');
            this.executedStartFcn = false;
            this.executedMdlStart = false;
        end
        
        function uiInstaller = createGUI(this, ~)
            
            OffOn = {'off', 'on'};
            
            if strcmp(get(bdroot(this.Block.Handle), 'SimulationStatus'), 'stopped')
                enabState = 'on';
            else
                enabState = 'off';
            end
            
            hOpen = uimgr.spctogglemenu('OpenAtMdlStart', 0, getString( ...
                message('Spcuilib:scopes:OpenAtMdlStart')));
            hOpen.setWidgetPropertyDefault(...
                'Checked', OffOn{this.OpenAtMdlStart+1}, ...
                'Callback', @(h, ev) toggleOpenAtMdlStart(this));
            hOpen.Enable = enabState;

            mapFileLocation = fullfile(docroot, 'toolbox', 'dsp' , 'dsp.map');
            mSpectrumanalyzerHelp = uimgr.uimenu('Spectrum Analyzer', getString(message( ...
                'measure:SpectrumAnalyzer:SpectrumAnalyzerBlockHelp')));
            mSpectrumanalyzerHelp.setWidgetPropertyDefault(...
                'Callback', @(hco,ev)helpview(mapFileLocation,'dspspectrumanalyzer'));
            
            mSPBlksHelp = uimgr.uimenu('DSP System Toolbox', getString(message( ...
                'measure:SpectrumAnalyzer:DSPSystemToolboxHelp')));
            mSPBlksHelp.setWidgetPropertyDefault(...
                'Callback', @(hco,ev)helpview(mapFileLocation,'dspinfo'));
            
            % NOTE: The Keyboard Command and Message Log menus are added by the
            % Framework in: ...\@uiscopes\@Framework\Framework.m
            
            mSPBlksDemo = uimgr.uimenu('DSP System Toolbox Demos', getString(message( ...
                'measure:SpectrumAnalyzer:DSPSystemToolboxDemos')));
            mSPBlksDemo.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) demo('toolbox', 'dsp'));
            
            % Want the "About" option separated, so we group everything above
            % into a menugroup and leave "About" as a singleton menu
            mAbout = uimgr.uimenu('About', getString(message( ...
                'Spcuilib:scopes:AboutDSPSystemToolbox')));
            mAbout.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) aboutdspsystbx);

            uiInstaller = uimgr.Installer( { ...
                hOpen,           'Base/Menus/File/Sources'; ...
                mSpectrumanalyzerHelp, 'Base/Menus/Help/Application'; ...
                mSPBlksHelp,     'Base/Menus/Help/Application'; ...
                mSPBlksDemo,     'Base/Menus/Help/Demo'; ...
                mAbout,          'Base/Menus/Help/About'});

        end
        
        function cfgFile = getConfigurationFile(~)
            cfgFile = 'spectrumanalyzerblock.cfg';
        end
        
        function helpArgs = getHelpArgs(~, ~)
            helpArgs = {};
        end
        
        function configClass = getConfigurationClass(~)
            % Class used to define properties of ScopeConfiguration object
            % used for programmatically interacting with the Spectrum
            % Analyzer
            configClass = 'spbscopes.SpectrumAnalyzerConfiguration';
        end
        
        function startFcn(this)
            
            hFrameWork = this.Scope.Framework;
            if ~isempty(hFrameWork)
                
                this.executedStartFcn = true;
                
                hVisual = hFrameWork.Visual;
                hPlotter = [];
                if ~isempty(hVisual)
                    hPlotter = hFrameWork.Visual.Plotter;
                end
                if ~isempty(hPlotter)
                    maxDims   = hPlotter.MaxDimensions;
                    nChannels = prod(maxDims(1, 2:end));
                    % Limit number of input channels to 50
                    if nChannels > 50
                        error(message('measure:SpectrumAnalyzer:TooManyInputChannels',50));
                    end
                end
                
                if ~isempty(hVisual)

                    % This startup function should not dirty model
                    dirtyState = getDirtyStatus(hVisual);
                    c = onCleanup(@()restoreDirtyStatus(hVisual,dirtyState));
                    
                    hVisual.DataBuffer = get_param(this.Block.handle,'Timebuffer');
                    hVisual.SpectrumObject.DataBuffer = get_param(this.Block.handle,'Timebuffer');
                    
                    % setup buffer complexity
                    isInputComplex = logical(hFrameWork.DataSource.BlockHandle.CompiledPortComplexSignals.Inport);
                    nSignals = 1;
                    maxNumTimeSteps = 1; % not used in this scope
                    setupBufferParams(hVisual.DataBuffer,...
                        nSignals, ...
                        [], ...
                        maxNumTimeSteps, ...
                        [], ...
                        isInputComplex);
                    
                    setLegacyMode(this);
                    
                    hVisual.onSourceRun;
                end
            end
        end
        
        function b = showKeyboardCommand(~)
            %showKeyboardCommand - Returns true when the keyboard
            %command help menu item should be shown
            b = false;
        end
        
        function b = showMessageLog(~)
            %showMessageLog - Returns true when the message log help
            %menu item should be shown
            b = false;
        end
        
        function pos = getDefaultPosition(~)
            % Spectrum analyzer uses the matlab figure width and height [560 420]
            pos = uiscopes.getDefaultPosition([560 420]);
        end        
    end
    
    methods(Access = protected)
        
        % cache config params so they are not need to be repeatedly loaded
        function retVal = getDefaultConfigParams(this)
            
            persistent defaultConfigParams;
            
            if isempty(defaultConfigParams) 
                defaultConfigParams = extmgr.ConfigurationSet.createAndLoad(this.getConfigurationFile);
            end
            
            retVal = defaultConfigParams;
        end
    end
        
    methods (Hidden)
        
        function s = saveobj(this)
            s = saveobj@Simulink.scopes.ScopeBlockSpecification(this);
            s.OpenAtMdlStart = this.OpenAtMdlStart;
            s.Version = 'V1'; % V1 means R2013b and future
        end
        
        function setLegacyMode(this)
            
            % For backwards compatibility with models using the
            % Spectrum Scope block, RBW is computed here based on the
            % segment length, the sample rate, and the window
            % constant.
            % We will ensure that the old and new blocks have the
            % same RBW.
            % Since the old block does not perform any
            % downsampling, RBW is given by:
            % RBW = K * Fs / D
            % where K is the window constant and D is the
            % segment length.
            % On the old block, the segment length is
            % determined either by the buffer size or by the
            % input port dimension (when the buffer is
            % bypassed)
            
            hFrameWork = this.Scope.Framework;
            if isempty(hFrameWork)
                return;
            end
            
            hVisual = hFrameWork.Visual;
            if isempty(hVisual)
                return;
            end

           
           s = scopeextensions.ScopeBlock.getScopeConfiguration('nop',this.Block.Handle);

            % Map RBW
            if  s.LegacySetFlag
                
                hPlotter = hFrameWork.Visual.Plotter;
                
                if isempty(hPlotter)
                    return;
                end
                
                maxDims   = hPlotter.MaxDimensions;
                numSamples = maxDims(1);
                if numSamples==0
                    return;
                end
                
                s.FrequencyResolutionMethod = 'WindowLength';	
                if strcmp(s.SegLen,'useInputSize') && numSamples > 2
                    % Get the input frame size
                    s.WindowLength = num2str(numSamples); 
                end  
                s.LegacySetFlag = false;
                
                % Make sure no FFT wrapping occurs
                if strcmp(s.FFTLengthSource,'Property')
                   fftlen = str2double(s.FFTLength); 
                   winlen = str2double(s.WindowLength); 
                   if fftlen < winlen
                      fftlen =   2^ceil(log2(winlen));
                      s.FFTLength = num2str(fftlen);
                   end
                else
                   % Inherit on 12b SpectrumScope means the FFTLength is
                   % equal to the buffer size
                   s.FFTLengthSource = 'Property';
                   s.FFTLength = s.WindowLength; % same as window size                                     
                end
                
                % Protect with a try-catch block to protect against
                % disconnected block/continuous block case
                try
                    synchronizeWithSpectrumObject(hVisual);
                    [~,e2] = validateSpectrumSettings(hVisual);
                    % Bad span, revert to full:
                    if ~isempty(e2)
                        s.FrequencySpan = 'Full';
                    end
                catch e%#ok   
                end
            end
        end  
    end
    
    
    methods (Static, Hidden)
        
        function this = loadobj(s)
            
            this = loadobj@Simulink.scopes.ScopeBlockSpecification(s);
            
            this.OpenAtMdlStart = s.OpenAtMdlStart;
            
            configSet = this.CurrentConfiguration;
            if isempty(configSet)
              return;
            end
                
            cfg = configSet.findConfig('Core', 'Source UI');
            if ~isempty(cfg) && ~isempty(cfg.PropertySet)                           
              prop = cfg.PropertyDb.findProp('ShowPlaybackCmdMode');
              if ~isempty(prop)
                prop.Value = false;
              end
            end
            
            cfg = configSet.findConfig('Visuals', 'Spectrum');
            if ~isempty(cfg) && ~isempty(cfg.PropertySet)                            
              prop = cfg.PropertyDb.findProp('IsValidSettingsDialogReadouts');
              if ~isempty(prop)
                prop.Value = false;
              end
            end
            
            configs = configSet.Children;
            allTypes = {configs.Type};
            allNames = {configs.Name};
            if ~isfield(s, 'Version') % 13a or earlier
              
                if isfield(s,'Position') && isequal(s.Position, [755 450 410 300])
                  this.Position = [680 390 560 420];
                end
                                              
                cfg = configs(strcmp(allTypes, 'Visuals') & strcmp(allNames, 'Spectrum'));
                if ~isempty(cfg) && ~isempty(cfg.PropertySet)
                    prop = cfg.PropertySet.findProp('AxesProperties');
                    if ~isempty(prop)
                        value = prop.Value;                            
                        % Check the colors for old defaults
                        newColor =  0.686274509804*ones(1,3);
                        if isfield(value, 'XColor') && isequal(value.XColor, [0.4 0.4 0.4])
                          value.XColor = newColor;
                        end     
                        if isfield(value, 'YColor') && isequal(value.YColor, [0.4 0.4 0.4])
                          value.YColor = newColor;
                        end                    
                        if isfield(value, 'ZColor') && isequal(value.ZColor, [0.4 0.4 0.4])
                          value.ZColor = newColor;
                        end                                            
                        prop.Value = value;
                    end
    
                end
                cfg = configs(strcmp(allTypes, 'Core') & strcmp(allNames, 'General UI'));
                if ~isempty(cfg) && ~isempty(cfg.PropertySet)
                    prop = cfg.PropertySet.findProperty('FigureColor');
                    if ~isempty(prop)
                        
                        % Check the figure color for old defaults.  Check
                        % for both linux windows and mac.
                        c = [ ...
                            get(0, 'DefaultUIControlBackgroundColor'); ...
                            repmat(0.941176, 1, 3); ...
                            repmat(0.929411, 1, 3)];
                        v = repmat(prop.Value, 3, 1);
                        if any(all(abs(c-v) < 1e-6, 2))
                            prop.Value = 0.156862745098039*ones(1,3);                                                                                  
                        end
                    end
                end
            end
        end
    end
end

% -------------------------------------------------------------------------
function toggleOpenAtMdlStart(this)

this.OpenAtMdlStart = ~this.OpenAtMdlStart;
% Mark the model as 'changed'
set(bdroot(this.Block.handle), 'dirty', 'on');

end

% -------------------------------------------------------------------------


% [EOF]
