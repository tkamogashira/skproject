classdef ArrayPlotSysObjCfg < scopeextensions.AbstractSystemObjectScopeCfg
  %ArrayPlotSysObjCfg   Define the ArrayPlotSysObjCfg class.
  
  %   Copyright 2012 The MathWorks, Inc.
 
  
  methods
    function this = ArrayPlotSysObjCfg(varargin)
      %ArrayPlotSysObjCfg   Construct the ArrayPlotSysObjCfg class.
      
      % Prevent clear classes warnings
      mlock;
      this@scopeextensions.AbstractSystemObjectScopeCfg(varargin{:});
    end
  end
  
  methods
    function appName = getAppName(~)
      %getAppName Returns the simple application name.
      appName = 'Array Plot';
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
      measurementTags = {'acursors','signalstats','peaks'};
    end
    
    function uiInstaller = createGUI(~, hScope)
      Checked = [1 zeros(1,3)];     
      OffOn = {'off', 'on'};
      CheckedValue = OffOn(Checked+1);
      
      enabState = 'on';
      hNumInPorts = uimgr.uimenugroup('NumberOfInputs', 1, ...
          getString(message( ...
          'dsp:system:ArrayPlot:NumInputsWithKBShortcut')));
      hNumInPorts.setWidgetPropertyDefault(...
        'Callback', @(h, ev) numInputPortsCB(h, hScope));
      
      hOne = uimgr.spctogglemenu('1InputPort', 0, '1');
      hOne.setWidgetPropertyDefault(...
        'Checked', CheckedValue{1}, ...
        'Callback', @(h, ev) oneInputPortCB(hScope));
      
      hTwo = uimgr.spctogglemenu('2InputPort', 1, '2');
      hTwo.setWidgetPropertyDefault(...
        'Checked', CheckedValue{2}, ...
        'Callback', @(h, ev) twoInputPortsCB(hScope));
      
      hThree = uimgr.spctogglemenu('3InputPort', 2, '3');
      hThree.setWidgetPropertyDefault(...
        'Checked', CheckedValue{3}, ...
        'Callback', @(h, ev) threeInputPortsCB(hScope));
      
      hMore = uimgr.spctogglemenu('CustomInputPorts', 3, getString(message( ...
          'Spcuilib:scopes:MenuMore')));
      hMore.setWidgetPropertyDefault(...
        'Checked', CheckedValue{4}, ...
        'Callback', @(h, ev) moreInputPortsCB(hScope));
      hNumInPorts.add(hOne);
      hNumInPorts.add(hTwo);
      hNumInPorts.add(hThree);
      hNumInPorts.add(hMore);
      hNumInPorts.Enable = enabState;
      
      % Help menus
      mapFileLocation = fullfile(docroot,'toolbox','dsp','dsp.map');
      
      mTimeScope = uimgr.uimenu('dsp.ArrayPlot', ...     
          getString(message( ...
          'dsp:system:ArrayPlot:SystemObjectHelp')));
      mTimeScope.Placement = -inf;
      mTimeScope.setWidgetPropertyDefault(...
        'Callback', @(hco,ev) helpview(mapFileLocation, 'dsparrayplot'));
      
      mSPBlksHelp = uimgr.uimenu('DSP System Toolbox', ...
          getString(message( ...
          'Spcuilib:scopes:DSPSystemToolboxHelp')));
      mSPBlksHelp.setWidgetPropertyDefault(...
        'Callback', @(hco,ev) helpview(fullfile(docroot, ...
        'toolbox', 'dsp', 'dsp_product_page.html')));
      
      % NOTE: The Keyboard Command and Message Log menus are added by the
      % Framework in: ...\@uiscopes\@Framework\Framework.m
      
      mSPBlksDemo = uimgr.uimenu('DSP System Toolbox Examples', ...
          getString(message( ...
          'dsp:system:ArrayPlot:DSPSystemToolboxExamples')));
      mSPBlksDemo.setWidgetPropertyDefault(...
        'Callback', @(hco,ev) demo('toolbox', 'dsp'));
      
      % Want the "About" option separated, so we group everything above
      % into a menugroup and leave "About" as a singleton menu
      mAbout = uimgr.uimenu('About', getString(message( ...
          'Spcuilib:scopes:AboutDSPSystemToolbox')));
      mAbout.setWidgetPropertyDefault(...
          'Callback', @(hco,ev) aboutdspsystbx);
      
      mDataHistory = uimgr.uimenu('DataHistoryOptions', uiscopes.message('TitleDatHistOpt'));
      mDataHistory.Placement = 10;
      mDataHistory.setWidgetPropertyDefault(...
          'Callback', @(hco, ev) editOptions(hScope.ExtDriver, hScope.DataSource));
      
      uiInstaller = uimgr.Installer( { ...
        hNumInPorts, 'Base/Menus/File/Sources'; ...
        mTimeScope,  'Base/Menus/Help/Application'; ...
        mSPBlksHelp, 'Base/Menus/Help/Application'; ...
        mSPBlksDemo, 'Base/Menus/Help/Demo'; ...
        mDataHistory, 'Base/Menus/View'; ...
        mAbout,      'Base/Menus/Help/About'});
    end
    
    function cfgFile = getConfigurationFile(~)
      cfgFile = 'arrayplotsysobj.cfg';
    end        
    
    function helpArgs = getHelpArgs(this,key) %#ok
      helpArgs = [];
    end 
    
    function b = showPrintAction(~)
        b = true;
    end
       
end
  
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
      numInputPorts = inputdlg(getString(message('dsp:system:ArrayPlot:NumInputs')),...
          getString(message('Spcuilib:scopes:DialogTitleSourceUIOptions')), ...
          1, {num2str(pSource.NumInputPorts)}, options);
      
      evalAndSetNumInputPorts(hScope, numInputPorts);
  end
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
  if ~isscalar(numInputPortsVal) || ~isnumeric(numInputPortsVal) ...
      ||  ~isfinite(numInputPortsVal) ...
      || ~isreal(numInputPortsVal) || (floor(numInputPortsVal) ~= numInputPortsVal) ...
      || (numInputPortsVal < 1) || (numInputPortsVal > 50)
    uiscopes.errorHandler(DAStudio.message(...
      'dsp:system:ArrayPlot:invalidNumberOfInputs'));
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

function value = isLocked(value)
if value
    uiscopes.errorHandler(getString(message('Spcuilib:scopes:PropertySetWhenLocked')));
end 

end

% -------------------------------------------------------------------------

% [EOF]
