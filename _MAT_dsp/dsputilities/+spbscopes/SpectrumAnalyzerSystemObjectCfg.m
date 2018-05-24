classdef SpectrumAnalyzerSystemObjectCfg < matlabshared.scopes.SystemObjectScopeSpecification
    %SpectrumAnalyzerSystemObjectCfg   Define the SpectrumAnalyzerSystemObjectCfg class.
    
    %   Copyright 2011-2013 The MathWorks, Inc.
    
    
    methods
        
        function this = SpectrumAnalyzerSystemObjectCfg(varargin)
            
            mlock
            this@matlabshared.scopes.SystemObjectScopeSpecification(varargin{:});
        end
        
        function b = getShowWaitbar(~)
            b = false;
        end
        
        function appname = getAppName(~)
            appname = 'Spectrum Analyzer';
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
        
        function uiInstaller = createGUI(~, ~)
          % Help menus
          mapFileLocation = fullfile(docroot,'toolbox','dsp','dsp.map');
          
          mSpectrumAnalyzer = uimgr.uimenu('dsp.SpectrumAnalyzer', ...
            getString(message( ...
            'measure:SpectrumAnalyzer:SpectrumAnalyzerSystemObjectHelp')));
          mSpectrumAnalyzer.Placement = -inf;
          mSpectrumAnalyzer.setWidgetPropertyDefault(...
            'Callback', @(hco,ev) helpview(mapFileLocation, 'sigblksspectrumanalyzer'));
          
          mSPBlksHelp = uimgr.uimenu('DSP System Toolbox', ...
            getString(message( ...
            'measure:SpectrumAnalyzer:DSPSystemToolboxHelp')));
          mSPBlksHelp.setWidgetPropertyDefault(...
            'Callback', @(hco,ev) helpview(mapFileLocation,'dspinfo'));
          
          % NOTE: The Keyboard Command and Message Log menus are added by the
          % Framework in: ...\@uiscopes\@Framework\Framework.m
          
          mSPBlksDemo = uimgr.uimenu('DSP System Toolbox Demos', ...
            getString(message( ...
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
            mSpectrumAnalyzer, 'Base/Menus/Help/Application'; ...
            mSPBlksHelp,       'Base/Menus/Help/Application'; ...
            mSPBlksDemo,       'Base/Menus/Help/Demo'; ...
            mAbout,            'Base/Menus/Help/About'});
        end
        
        function cfgFile = getConfigurationFile(~)
            cfgFile = 'spectrumanalyzersysobj.cfg';
        end
        
        function helpArgs = getHelpArgs(this,key) %#ok
            helpArgs = [];
        end
        
        function b = showPrintAction(~)
            b = true;
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
    end
end

% [EOF]
