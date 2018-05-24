classdef TimeScopeSystemObjectCfg < matlabshared.scopes.SystemObjectScopeSpecification
  %TimeScopeSystemObjectCfg   Define the TimeScopeSystemObjectCfg class.
  
  %   Copyright 2009-2012 The MathWorks, Inc.
 
  methods
    function this = TimeScopeSystemObjectCfg(varargin)
      %TimeScopeSystemObjectCfg   Construct the TimeScopeSystemObjectCfg class.
      
      % Prevent clear classes warnings
      mlock;
      this@matlabshared.scopes.SystemObjectScopeSpecification(varargin{:});
    end
    
    function appName = getAppName(~)
      %getAppName Returns the simple application name.
      appName = 'Time Scope';
    end
    
    function b = isToolbarCompact(~, toolbarName)
        b = ~strcmp(toolbarName, 'measurements');
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
      measurementTags = {'triggers','tcursors','signalstats','peaks','bilevel'};
    end
    
    function uiInstaller = createGUI(~, hScope)    
      Checked = [1 zeros(1,3)];     
      OffOn = {'off', 'on'};
      CheckedValue = OffOn(Checked+1);
      
      enabState = 'on';
      hNumInPorts = uimgr.uimenugroup('NumberOfInputPorts', 1, ...
          getString(message( ...
          'Spcuilib:scopes:NumInputPortsWithKBShortcut')));
      hNumInPorts.setWidgetPropertyDefault(...
        'Callback', makeNumInputPortsCallback(hScope));
      
      hOne = uimgr.spctogglemenu('1InputPort', 0, '1');
      hOne.setWidgetPropertyDefault(...
        'Checked', CheckedValue{1}, ...
        'Callback', uiservices.makeCallback(@oneInputPortCB, hScope));
      
      hTwo = uimgr.spctogglemenu('2InputPort', 1, '2');
      hTwo.setWidgetPropertyDefault(...
        'Checked', CheckedValue{2}, ...
        'Callback', uiservices.makeCallback(@twoInputPortsCB, hScope));
      
      hThree = uimgr.spctogglemenu('3InputPort', 2, '3');
      hThree.setWidgetPropertyDefault(...
        'Checked', CheckedValue{3}, ...
        'Callback', uiservices.makeCallback(@threeInputPortsCB, hScope));
      
      hMore = uimgr.spctogglemenu('CustomInputPorts', 3, getString(message( ...
          'Spcuilib:scopes:MenuMore')));
      hMore.setWidgetPropertyDefault(...
        'Checked', CheckedValue{4}, ...
        'Callback', uiservices.makeCallback(@moreInputPortsCB, hScope));
      hNumInPorts.add(hOne);
      hNumInPorts.add(hTwo);
      hNumInPorts.add(hThree);
      hNumInPorts.add(hMore);
      hNumInPorts.Enable = enabState;
      
      % Help menus
      mapFileLocation = fullfile(docroot,'toolbox','dsp','dsp.map');
      
      mTimeScope = uimgr.uimenu('dsp.TimeScope', ...
          getString(message( ...
          'Spcuilib:scopes:TimeScopeSystemObjectHelp')));
      mTimeScope.Placement = -inf;
      mTimeScope.setWidgetPropertyDefault(...
        'Callback', uiservices.makeCallback(@helpview, mapFileLocation, 'sigblkstimescope'));
      
      mSPBlksHelp = uimgr.uimenu('DSP System Toolbox', ...
          getString(message( ...
          'Spcuilib:scopes:DSPSystemToolboxHelp')));
      mSPBlksHelp.setWidgetPropertyDefault(...
        'Callback', uiservices.makeCallback(@helpview, mapFileLocation,'dspinfo'));
      
      % NOTE: The Keyboard Command and Message Log menus are added by the
      % Framework in: ...\@uiscopes\@Framework\Framework.m
      
      mSPBlksDemo = uimgr.uimenu('DSP System Toolbox Demos', ...
          getString(message( ...
          'Spcuilib:scopes:DSPSystemToolboxDemos')));
      mSPBlksDemo.setWidgetPropertyDefault(...
        'Callback', uiservices.makeCallback(@demo, 'toolbox', 'dsp'));
      
      % Want the "About" option separated, so we group everything above
      % into a menugroup and leave "About" as a singleton menu
      mAbout = uimgr.uimenu('About', getString(message( ...
          'Spcuilib:scopes:AboutDSPSystemToolbox')));
      mAbout.setWidgetPropertyDefault(...
          'Callback', uiservices.makeCallback(@aboutdspsystbx));
      
      mDataHistory = uimgr.uimenu('DataHistoryOptions', uiscopes.message('TitleDatHistOpt'));
      mDataHistory.Placement = 10;
      mDataHistory.setWidgetPropertyDefault(...
          'Callback', uiservices.makeCallback(@onEditOptions, hScope));
      
      uiInstaller = uimgr.Installer( { ...
        hNumInPorts, 'Base/Menus/File/Sources'; ...
        mTimeScope,  'Base/Menus/Help/Application'; ...
        mSPBlksHelp, 'Base/Menus/Help/Application'; ...
        mSPBlksDemo, 'Base/Menus/Help/Demo'; ...
        mDataHistory, 'Base/Menus/View'; ...
        mAbout,      'Base/Menus/Help/About'});
    end
    
    function cfgFile = getConfigurationFile(~)
      cfgFile = 'timescopesysobj.cfg';
    end        
    
    function helpArgs = getHelpArgs(this,key) %#ok
      helpArgs = [];
    end 
    
    function b = showConfiguration(~)
      b = false;
    end
    
    function b = showPrintAction(~)
      b = true;
    end
    
    function b = showKeyboardCommand(~)
      b = false;
    end
  end

  methods (Hidden)
    function b = useMCOSExtMgr(this)
      b = this.useMCOS();
    end
    
    function hgRoot = getHGRoot(~)
      if scopesfeature('TimeScopeBlockUsesHg2') 
        hgRoot = groot; 
      else 
        hgRoot = 0; 
      end 
    end 
  end
  
  methods (Hidden, Static)
    function varargout = useMCOS(flag)
      persistent usemcos;
      
      if nargin
        usemcos = flag;
      end
      
      if nargout
        if isempty(usemcos)
          usemcos = true;
        end
        varargout = {usemcos};
      end
    end
    function this = loadobj(s)
        this = loadobj@matlabshared.scopes.SystemObjectScopeSpecification(s);

        configSet = this.CurrentConfiguration;
        if isempty(configSet)
            return;
        end
        configs = configSet.Children;
        if isempty(configs)
            return;
        end
        allTypes = {configs.Type};
        allNames = {configs.Name};
        if ~isfield(s, 'Version') % 13a or earlier
            cfg = configs(strcmp(allTypes, 'Visuals') & strcmp(allNames, 'Time Domain'));
            if ~isempty(cfg) && ~isempty(cfg.PropertySet)
                prop = cfg.PropertySet.findProp('SerializedDisplays');
                if ~isempty(prop)
                    value = prop.Value;
                    for indx = 1:numel(value)
                        
                        % Check the axes color for old defaults
                        if isfield(value{indx}, 'AxesColor') && isequal(value{indx}.AxesColor, [0 0 0])
                            value{indx} = rmfield(value{indx}, 'AxesColor');
                        end
                        
                        % Check the axestickcolor for old defaults
                        defaultATColor = [.3137 .3137 .3137];
                        if isfield(value{indx}, 'AxesTickColor') && all(value{indx}.AxesTickColor - defaultATColor < 1e-4)
                            value{indx} = rmfield(value{indx}, 'AxesTickColor');
                        end
                        
                        % Check the color order for old defaults
                        if isfield(value{indx}, 'ColorOrder') && isequal(value{indx}.ColorOrder, [1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; .75 .75 .75])
                            value{indx} = rmfield(value{indx}, 'ColorOrder');
                        end
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
                        remove(cfg.PropertySet, prop);
                    end
                end
            end
        end
    end
  end
end

function onEditOptions(hScope)
editOptions(hScope.ExtDriver, hScope.DataSource);
end

% -------------------------------------------------------------------------
function oneInputPortCB(hScope)
  % Callback for File->Number of Input Ports->1 submenu  
  pSource = hScope.getExtInst('Sources','Streaming');
  if ~isLocked(pSource.DataSpecsLocked)
      pSource.NumInputPorts = 1;
  end
end

% -------------------------------------------------------------------------
function twoInputPortsCB(hScope)
  % Callback for File->Number of Input Ports->2 submenu  
  pSource = hScope.getExtInst('Sources','Streaming');
  if ~isLocked(pSource.DataSpecsLocked)
      pSource.NumInputPorts = 2;  
  end
end

% -------------------------------------------------------------------------
function threeInputPortsCB(hScope)
  % Callback for File->Number of Input Ports->3 submenu
  pSource = hScope.getExtInst('Sources','Streaming');
  if ~isLocked(pSource.DataSpecsLocked)
      pSource.NumInputPorts = 3;  
  end
end

% -------------------------------------------------------------------------
function moreInputPortsCB(hScope)
  % Callback for File->Number of Input Ports->More... submenu
  options.Resize = 'on';
  options.WindowStyle = 'normal';
  options.Interpreter = 'none';
  
  pSource = hScope.getExtInst('Sources','Streaming');
  
  if ~isLocked(pSource.DataSpecsLocked)
      numInputPorts = inputdlg(getString(message('Spcuilib:scopeblock:NumInputPorts')),...
          getString(message('Spcuilib:scopes:DialogTitleSourceUIOptions')), ...
          1, {num2str(pSource.NumInputPorts)}, options);
      
      evalAndSetNumInputPorts(hScope, numInputPorts);
  end
end

% -------------------------------------------------------------------------
function cb = makeNumInputPortsCallback(hScope)

cb = @(h, ~) numInputPortsCB(h, hScope);
end

% -------------------------------------------------------------------------
function numInputPortsCB(h, hScope)
% Callback for File->Number of Input Ports submenu

children = get(h, 'Children');
pSource = hScope.getExtInst('Sources','Streaming');  
numInputPorts = pSource.NumInputPorts;

if numInputPorts > 3
  child = findobj(children, 'tag', 'uimgr.spctogglemenu_CustomInputPorts');
else
  child = findobj(children, 'tag', ['uimgr.spctogglemenu_' num2str(numInputPorts) 'InputPort']);
end

siblings = children(children ~= child);

set(child, 'Checked', 'on');
for idx = 1:length(siblings)
  set(siblings(idx), 'Checked', 'off');
end
end

% -------------------------------------------------------------------------
function evalAndSetNumInputPorts(hScope, numInputPorts)

if ~isempty(numInputPorts) && ~isempty(numInputPorts{1})
  % isempty(numInputPorts) = true, if 'Cancel' button is hit
  % isempty(numInputPorts{1}) = true, if the edit field is left empty
  % and OK is hit
  % numInputPorts is a string - it could be a valid numerical value or a
  % variable name
  
  numInputPortsVal = str2num(numInputPorts{1}); %#ok<ST2NM>
  
  if isempty(numInputPortsVal)
    % numInputPorts contains a variable name
    % make sure variable name is valid
    if ~isvarname(numInputPorts{1})
      uiscopes.errorHandler(DAStudio.message(...
        'Spcuilib:scopes:InvalidVariableName', numInputPorts{1}));
      return;
    end    
  end
  
  % validate the value before setting it
  if ~isscalar(numInputPortsVal) ...
      || ~isnumeric(numInputPortsVal) ...
      ||  ~isfinite(numInputPortsVal) ...
      || ~isreal(numInputPortsVal) ...
      || (floor(numInputPortsVal) ~= numInputPortsVal) ...
      || (numInputPortsVal < 1) ...
      || (numInputPortsVal > 96)
    uiscopes.errorHandler(DAStudio.message(...
      'Spcuilib:scopeblock:invalidNumberOfInputPorts'));
  else
    % valid value - set System object property 
    pSource = hScope.getExtInst('Sources','Streaming');  
    pSource.NumInputPorts = numInputPortsVal;
  end
  
  %else
  % 'Cancel' button hit or edit field left empty - do not set block's
  % NumInputPorts parameter i.e. do nothing
end
end

% -------------------------------------------------------------------------
function value = isLocked(value)
if value
    uiscopes.errorHandler(getString(message('Spcuilib:scopes:PropertySetWhenLocked')));
end 
end

% [EOF]
