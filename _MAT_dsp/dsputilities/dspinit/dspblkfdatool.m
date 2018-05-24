function varargout = dspblkfdatool(varargin)
% DSPBLKFDATOOL DSP System Toolbox digital filter block helper function.
%   This function interacts only with the DSP Block Digital Filter
%   and SLFDATOOLINTERFACE


% Copyright 1995-2011 The MathWorks, Inc.

% The functions in this file are all the calls
% that the block will ever make directly.
%
% Don't put any other functions in here.

[varargout{1:nargout}] = feval(varargin{:});

% ---------------------------------------------------------------
function [icon, errMsg] = initializationCommands %#ok

errMsg = [];
hBlk = gcb;

icon = getIcon(hBlk);

blk_ud = get_param(hBlk, 'UserData');
try

    containedBlockName = 'Digital Filter';
    containedBlockPath = [hBlk '/' containedBlockName];

    % Get the block parameters from the filter object.
    [lib, sourceBlock] = blocklib(blk_ud.current_filt);
    s = blockparams(blk_ud.current_filt, 'off');
    
    % Check if a sidebar is present
    sideBarPresent = true;
    if isfield(blk_ud,'FDATool_sidebar')
      sb = 'FDATool_sidebar';
    elseif isfield(blk_ud,'sidebar')
      sb = 'sidebar';
    else
      sideBarPresent = false;
    end
    
    s.InputProcessing = 'Inherited (this choice will be removed - see release notes)';
    if sideBarPresent
      currentPanel = blk_ud.(sb).currentpanel;
             
      % Check if there is a field named as the current panel in the sidebar
      % user data structure. In models created before R2011b the pzeditor
      % panel was not saved so even though the current panel is 'pzeditor'
      % there will be no 'pzeditor' field in the sidebar user data
      % structure. In those cases, default the input processing mode to
      % 'Inherited'.
      if isfield(blk_ud.(sb),currentPanel) && ...
          isfield(blk_ud.(sb).(currentPanel),'InputProcessing')
        s.InputProcessing = blk_ud.sidebar.(currentPanel).InputProcessing;
      end
    end
    
    if strcmp(s.InputProcessing,'Inherited (this choice will be removed - see release notes)') &&...
            any(strcmp({'Discrete FIR Filter','Discrete Filter','Allpole Filter'}, sourceBlock))
      %Target digital filter block if input processinf is inherited and
      % previous target was one of {'Discrete FIR Filter','Discrete
      % Filter','Allpole Filter'}
      forceDigitalFilterBlock = true;
      [lib, sourceBlock] = blocklib(blk_ud.current_filt,[],forceDigitalFilterBlock);
      s = blockparams(blk_ud.current_filt, 'off',forceDigitalFilterBlock);
      s.InputProcessing = 'Inherited (this choice will be removed - see release notes)';
    end      
    
    % Convert the parameter structure to param value pair
    if ~isempty(s)
        params = fieldnames(s);
        values = struct2cell(s);
        pv     = [params values]';
        pv     = pv(:)';
    else
        pv = {};
    end

    % Fix for g415160: pass block description down to the masked block
    blkDescription = get_param(hBlk,'Description');
    pv = [pv {'Description', blkDescription}];

    % If the reference block of the contained block is the same as that
    % needed by the new filter, just set its properties.
        
    if strcmpi(getReferenceBlock(containedBlockPath), [lib '/' sourceBlock])
        % We used to do this in a loop and set each pair one at a time, but
        % because of g350550 we have to do it all at once to avoid errors
        % from the SOS Matrix and the scale values being out of sync.
        set_param(containedBlockPath, pv{:});
    else
        % TRY/CATCH because we might have a new filter while the model is
        % running.
        try
            
            pos = get_param(containedBlockPath, 'Position');
            % Try to delete the block.  We will be supporting structures which
            % may need different blocks later on.
            delete_block(containedBlockPath);
            
            % Simulink is throwing warnings because the model is in a bad
            % state while we move these blocks around.  We're actually in a
            % good state once we finish so the warning should not be thrown
            % to the customer.
            w = warning('off', 'Simulink:Masking:DispInvalidExpr');            

            switch s.InputProcessing
              case 'Columns as channels (frame based)'
                inputProcessing = 'columnsaschannels';
              case 'Elements as channels (sample based)'
                inputProcessing = 'elementsaschannels';
              case 'Inherited (this choice will be removed - see release notes)'
                inputProcessing = 'inherited';
            end
            
            inputs  = {'Destination', hBlk, 'BlockName', containedBlockName, ...
                'InputProcessing',inputProcessing};
            block(blk_ud.current_filt,inputs{:});
            warning(w);
            set_param(containedBlockPath, 'Position', pos, 'Description', blkDescription);

        catch ME

            if strcmpi(sourceBlock, 'Digital Filter'),

                % We do not want to set the IRType or structure when the model
                % is running.
                pv(1:4) = [];

                % If the try failed, we want to set the parameters directly.  The
                % try failed because the model is being run.  The delete_block
                % cannot operate.  When this happens, we assume that we will be
                % generating a model that will use the same block as before and we
                % just try to set its properties.
                set_param(containedBlockPath, pv{:});
            else
                errMsg = ME;
            end
        end

    end

catch theErr
    errMsg = theErr;
end

% ---------------------------------------------------------------
function OpenFcn %#ok
% OPENFCN calls SLFDATOOLINTERFACE's OPENFDATOOL
%   This happens when the block is double-clicked

hBlk = gcbh;
fcns = slfdatoolinterface;
feval(fcns.slOpenFDATool,hBlk);


% ---------------------------------------------------------------
function CloseFcn %#ok
% CLOSEFCN is called whenever FDATool must be deleted
%   This happens when the model is closed, and when the block is deleted

hBlk = gcbh;
fcns = slfdatoolinterface;
feval(fcns.slCloseFDATool,hBlk);


% ---------------------------------------------------------------
function NameChange %#ok
% NAMECHANGE Changes the name of the block that is stored in FDATOOL's
%   session which will be appended to the title of FDATool.

hBlk = gcbh;
fcns = slfdatoolinterface;
feval(fcns.slNameChange,hBlk);


% ---------------------------------------------------------------
function StartFcn %#ok
% STARTFCN Checks to make sure that the block is set properly

hBlk = gcbh;
fcns = slfdatoolinterface;
feval(fcns.slStartFcn,hBlk);


% ---------------------------------------------------------------
function BlockCopy %#ok
% BLOCKCOPY Block is being copied from the model or a model is
%   being opened

% Clear out stored figure handle
hBlk = gcbh;
blk_ud = get_param(hBlk,'UserData');
blk_ud.hFDA = [];
set_param(hBlk,'UserData',blk_ud);


% ---------------------------------------------------------------
function ModelCloseFcn %#ok
% MODELCLOSEFCN Model containing a digital filter block has been closed
% This is a clean-up routine, which searches for hidden FDATools associated
% with the model and closes them.

hBlk = gcbh;
fcns = slfdatoolinterface;

% Delete all FDATools associated with this model
model_name = bdroot(getfullname(hBlk));
feval(fcns.slModelClose,model_name);

% ---------------------------------------------------------------
%   Utility Functions
% ---------------------------------------------------------------

% ---------------------------------------------------------------
function filterInvalid(hBlk,msg)
% Error mechanism for DSPBlk/FDATool integration

if nargin < 1, hBlk = gcbh; msg = 'is not valid';
elseif nargin < 2
    if ischar(hBlk), msg = hBlk; hBlk = gcbh;
    else msg = 'is not valid'; end
end

name = getfullname(hBlk);
errordlg(['Filter in ' name ' ' msg '.  Please redesign.'], name);


% % ---------------------------------------------------------------
% function dspWarning(hBlk,msg)
% % Warning mechanism for DSPBlk/FDATool integration
%
% fullname = getfullname(hBlk);
% blockname = get_param(hBlk,'name');
% msg = [fullname ' ' msg];
% warndlg(msg,[blockname ' Block']);


% ---------------------------------------------------------------
function h = getIcon(hBlk)
% GETICON returns the coordinates to plot the icon and a string
%   representing the filter structure to place on the icon.

blk_ud = get_param(hBlk,'userdata');

lastwarn('');

try 
    w = warning('off');

    Hd = blk_ud.current_filt;

    [~, den] = tf(Hd);

    if den(1) == 0,
        error(message('dsp:dspblkfdatool:invalidCoefficient'));
    end

    h = 20*log10(abs(freqz(Hd,256)));
    warning(w);

    %check to see if we have had any division by zero or log(0)
    % Fix the magnitude response for the -Inf and Inf cases
    h(isinf(h)) = NaN;

    % If there are no warnings return the magnitude response
    if isempty(lastwarn) && max(h)-min(h) > .01,
        h = h-min(h);
        h = h/max(h)*.75; % Normalize and leave room for FDATool string

        %If difference is below threshold (.01) plot a straight line
    elseif max(h)-min(h) <= .01
        h = [.5 .5];
    else
        % This will cause 3 question marks to be plotted on the Icon
        h = 'Error State';
    end
catch ME %#ok<NASGU>
    filterInvalid(hBlk);
    h = 'Error State';
end

%--------------------------------------------------------------------------
function refBlk = getReferenceBlock(containedBlockPath)

refBlk = get_param(containedBlockPath, 'ReferenceBlock');
if isempty(refBlk)
  refBlk = get_param(containedBlockPath, 'BlockType');
  switch refBlk
    case 'DiscreteFir'
      refBlk = 'simulink/Discrete/Discrete FIR Filter';
    case 'DiscreteFilter'
      refBlk = 'simulink/Discrete/Discrete Filter';
    case 'AllpoleFilter'
      refBlk = 'dsparch4/Allpole Filter';
  end
end

% [EOF]
