function sdspfscope2(varargin)
%SDSPFSCOPE2 Frame- and vector-display block for the DSP System Toolbox.
%  The DSP System Toolbox provides several scopes useful for visualizing
%  frame- or vector-based signals in a Simulink model.
%  The Communications System Toolbox uses this SFunction to render frames
%  of data for the Communication Scopes
%
%  The following blocks in the "DSP Sinks" library utilize this
%  scope display:
%    - Vector Scope
%    - Spectrum Scope
%
%  The following blocks in the "Communication Sinks" library utilize this
%  scope display:
%    - Discrete-Time Eye Diagram Scope
%    - Discrete-Time Signal Trajectory Scope
%
%  These blocks accept 2-D signals, where an MxN input matrix is
%  interpreted as N channels of data, each presenting M consecutive
%  time samples of data.  A 1-D signal is interpreted as a single
%  channel of data.
%
%  Most menu options are duplicated in a context menu, accessible
%  by right-clicking within the scope display.  Depending upon the
%  scope block, and the number of data channels entering the block,
%  different options are provided.
%
%  See also DSPLIB, COMMLIB.

%  This is a MATLAB file S-Function used by the DSP System Toolbox that
%  implements a frame- or vector-based scope display.

% Copyright 1995-2013 The MathWorks, Inc.


% Syntax:
%
%   sdspfscope2(params);
%
% where params is a structure containing all block dialog parameters.
%
% What's in the Figure userdata:
% ------------------------------
% Main scope figure handles:
%   fig_data.block                 block name
%   fig_data.hfig                  handle to figure
%   fig_data.hcspec                handle to non-displayed line for color translation
%
% - Related to Zoom feature:
%   fig_data.zoomActivated         flag that indicates that the zoom feature is activated 
%                                  yet (TRUE) or not (FALSE)  
%   fig_data.zoomInUse             flag that indicates whether current view is zoomed-in (along 
%                                  any direction) (TRUE) or not (FALSE)
%   fig_data.originalXLimits       Original XLimits 
%   fig_data.originalYLimits       Original YLimits 
%   fig_data.zoomedXLimits         XLimits when in zoom mode
%   fig_data.zoomedYLimits         YLimits when in zoom mode
%   fig_data.originalScalingFactor Original scaling factor from engunits
%   fig_data.zoomedScalingFactor   scaling factor, from engunits, when in zoom mode
%   fig_data.zoomedPrefix          prefix for xLabel when in zoom mode
%   fig_data.XAxisParamsChanged    flag that indicates that any parameter related to X-axis 
%                                  changed (TRUE) or not (FALSE)
%   fig_data.originalXDisplay      Original 'Frequency display offset' (XDisplay)
%
%   fig_data.main.haxis         handle to axes
%   fig_data.main.hline         Nx1 vector of line handles
%   fig_data.main.hstem         scalar stem line handle
%   fig_data.main.hgrid         vector of handles to axis grid lines
%   fig_data.main.axiszoom.on   P/V cell-array pairs to turn on
%   fig_data.main.axiszoom.off  and off full-axis zoom
%
% Handles to menu items:
%   - appearing only in figure menu:
%       fig_data.menu.recpos      record position
%       fig_data.menu.axislegend  (checkable)
%       fig_data.menu.framenumber (checkable)
%       fig_data.menu.axisgrid    (checkable)
%       fig_data.menu.memory      (checkable)
%       fig_data.menu.refresh
%
%   - appearing in both figure and context menu:
%       fig_data.menu.top         top-level Axes and Lines in Figure
%       fig_data.menu.context     context menu
%       fig_data.menu.linestyle    2xN, [fig;context] x [one per display line]
%       fig_data.menu.linemarker   2xN        (children are individual submenu options)
%       fig_data.menu.linecolor    2xN
%       fig_data.menu.linedisable  2x1
%       fig_data.menu.axiszoom     2x1, [fig;context] (checkable)
%       fig_data.menu.autoscale
%       fig_data.menu.saveAxes    save axes settings
%
%
% What's in the Block userdata:
% -----------------------------
%   block_data.firstcall    flag for first call to function
%   block_data.autoscaling  indicates autoscale computation in progress
%   block_data.hfig         handle to figure
%   block_data.hcspec       handle to non-displayed line for color translation
%   block_data.haxis        handle to axes
%   block_data.hline        Nx1 vector of line handles
%   block_data.hstem        scalar line handle
%   block_data.hgrid        handles to axis grid lines
%   block_data.hgridtext    vector of handles
%   block_data.hlegend      handle to legend itself
%   block_data.hframenum    handle to frame number text indicator
%   block_data.params       structure of cached block dialog parameters
%   block_data.Ts           updated sample time for block
%   block_data.inputDims    dimension vector of input to scope
%   block_data.NChans       Number of frames (columns) in input matrix
%
%
%
% Parameters structure fields:
% ----------------------------
% .SpectrumScope: Presence of this field indicates the caller is Spectrum Scope block
% .SpectrumScope.isInputComplex: Indicates if input is complex valued
% .SpectrumScope.scaleYAxis: Indicates if Y-axis limits need to be scaled so as to ease
%                            user transition from previous releases to R2009b
% .ScopeParams
% .Domain: 1=Time, 2=Frequency, 3=User Defined
% .XLabel:
%     Time, Frequency: ignored
%     User: displayed
% .XUnits:
%     User, Time: ignored
%     Freq: 1=Hz, 2=rad/s
% .InheritXIncr: checkbox
% .XIncr: increment of x-axis samples, used for x-axis display
%     Time: ignored (assumes frame-based)
%     User, Freq: seconds per sample
% .XRange:
%   Vector Scope:-
%     User, Time: ignored
%     Freq: 1=[0,Fn] , 2=[-Fn,Fn], 3=[0, Fs]
%                (Fn=Nyquist rate, Fs=Sample rate)
%   Spectrum Scope:-
%     Spectrum type: 1=One-sided([0...Fs/2]) , 2=Two-sided((-Fs/2...Fs/2])
% .YLabel:
% .YUnits:
%      User, Time: ignored
%      Freq: 1=Magnitude, 2=dB
%
% .HorizSpan: Horizontal time span (number of frames)
%             Only displayed for Time and User-defined
%
% Optionally displayed in dialog:
% .AxisParams: indicates whether the Axis Settings are
%              currently displayed in block dialog.
% .YMin: Minimum y-limit
% .YMax: Maximum y-limit
% .FigPos: figure position
%
% .AxisGrid:   Current setting, on or off
% .AxisZoom:    similar
% .FrameNumber: similar
% .AxisLegend:  similar
% .Memory: checkbox
%
% .LineParams:
% .LineDisables:
% .LineColors: pipe-delimited string of colors, one per channel
% .LineStyles: similar
% .LineMarkers: similar
%
% .WindowParams: indicates whether the Scope Settings are
%                currently displayed in block dialog.
% .OpenScopeAtSimStart: checkbox
% .OpenScopeImmediately: checkbox
%
% Communications Scopes fields are listed here
%
%    Field                          Usage
%    ============================   ==============================================
%    <struct>.openScopeAtSimStart   Open simulation at start
%    <struct>.sampPerSymb           Samples Per Symbol
%    <struct>.offsetEye             Offset (in samples)
%    <struct>.symbPerTrace          Symbols Per Traces/Points/Symbols
%    <struct>.numTraces             Number of Traces/Points/Symbols
%    <struct>.numNewFrames          Number of New Traces/Points/Symbols per Display
%    <struct>.LineMarkers           Line Marker string
%    <struct>.LineStyles            Line Style string
%    <struct>.LineColors            Line Color string
%    <struct>.fading                Color Fading Enable
%    <struct>.render                High Quality Rendering Enable
%    <struct>.AxisGrid              Grid lines display enable
%    <struct>.dispDiagram           Eyediagram to display (I or I + Q)
%    <struct>.yMin                  Minimum value for y-axis
%    <struct>.yMax                  Maximum value for y-axis
%    <struct>.xMin                  Minimum value for x-axis
%    <struct>.xMax                  Maximum value for x-axis
%    <struct>.FrameNumber           Frame Number display enabled
%    <struct>.FigPos                Figure Position
%    <struct>.block_type_           Type of block 1, 3
%
%  The value of <struct> depends on the use in the code.
%
%    <struct>                       Usage
%    ==========================     ============================================
%    block_data.cparams.str         current dialog values from 'maskvalues'.
%    block_data.cparams_old.str     previous dialog values from 'maskvalues'.
%    block_data.cparams.ws          current dialog values from 'maskwsvariables'.
%    block_data.cparams_old.ws      previous dialog values from 'maskwsvariables'.
%
%
%    comms data                         Usage
%    ============================       ============================================
%    block_data.comm.tracesPerLine      number of traces per line object
%    block_data.comm.numLines           number of line objects used to render
%    block_data.comm.tracesPerLastLine  number of traces in the last line object
%    block_data.comm.tempFigPos         temporary figure position
%    block_data.comm.emode              erase mode for the axes object in Graphics Version 1
%    block_data.comm.renderer           rendering mode for the figure
%    block_data.comm.sampPerTrace       number of samples per trace
%    block_data.comm.pointsPerLine      number of points per line
%    block_data.comm.halfwidth          half of the port width (number of 'channels')
%    block_data.comm.hwSize             half width size variable
%    block_data.comm.extraIdxR          index vector for the last line
%    block_data.comm.idxR               index vector for all lines but the last
%    block_data.comm.rsFact0            column factor for resizing the data for all but the last line
%    block_data.comm.rsFact1            row factor for resizing the data for all but the last line
%    block_data.comm.idxC0              column index of the target vector for plotting
%    block_data.comm.idxDR              row index of the target vector for plotting
%    block_data.comm.idxDC0             column index of the target vector for plotting the last line
%    block_data.comm.rsFactD0           index vector for last line
%    block_data.comm.rsFactD1           column factor for resizing the data for last line
%    block_data.comm.block              the S-fcn block
%    block_data.comm.params             parameters used in Create_or_RestartScope

if nargin==1,
    mdlInitializeSizes(varargin{1});  % block
else
    %    varargin{4} => CopyFcn       = BlockCopy;
    %                   DeleteFcn     = BlockDelete;
    %                   NameChangeFcn = BlockNameChange;
    %                   MaskParameterChangeCallback = DialogApply(params,blkh);
    %                   OpenScope     = when 'Open scope immediately' push button is pressed in SP Scopes;
    %                                   For Comms Scopes, with mask open, block is double-clicked, 
    %                   ScopeUpdate   = Used by Open/Close Scopes blocks (in some Comms demos) 
    %                                   in their OpenFcn callback. A set of scopes are opened/closed
    %                                   when these blocks are double-clicked. varargin{5} is the 
    %                                   corresponding scope block and varargin{6} is 
    %                                   'OpenFig' or 'CloseFig' string
    feval(varargin{4:end});% GUI callback
end

% -----------------------------------------------------------
function mdlInitializeSizes(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 0;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Complexity   = 0;  % Real

% Register parameters
block.NumDialogPrms =1; % coming from mask (identifier: vector scope(1) or spectrum scope(2))

% sampling mode
block.SampleTimes = [-1 0]; %Port-based sample time

% % Specify if Accelerator should use TLC or call back into MATLAB file
block.SetAccelRunOnTLC(false);
block.SetSimViewingDevice(true);% no TLC required

% Specify that the block will work with context save/restore
block.SimStateCompliance = 'DefaultSimState';

% Reg methods
block.RegBlockMethod('CheckParameters',          @mdlCheckParameters);% C-Mex: mdlCheckParameters

block.RegBlockMethod('SetInputPortSamplingMode', @mdlSetInputPortFrameData);
block.RegBlockMethod('SetInputPortDimensions',   @mdlSetInputPortDimensions);
block.RegBlockMethod('SetInputPortDataType',     @mdlSetInputPortDataType);

block.RegBlockMethod('PostPropagationSetup',    @mdlPostPropSetup); %C-Mex: mdlSetWorkWidths
%block.RegBlockMethod('ProcessParameters',       @mdlProcessParameters);%(update of RTPs)

block.RegBlockMethod('Start',                   @mdlStart);
%block.RegBlockMethod('Update',                 @mdlUpdate); % registered in mdlPostPropSetup
block.RegBlockMethod('Terminate',               @mdlTerminate);

function b=isVectorScope(block)
b = (block.DialogPrm(1).Data == 1);

function b=isSpectrumScope(block)
b = (block.DialogPrm(1).Data == 2);

function errorIfComplexInputAndOneSidedSpectrumType(block)
% For Spectrum Scope, error if One-sided Spectrum type is requested for complex input
if isSpectrumScope(block)
    sfcnh = block.BlockHandle;
    blk = get_param(sfcnh,'parent');
    inBlk = [blk '/In1'];
    inBlkPorth = get_param(inBlk,'Porthandles');
    isComplex = get_param(inBlkPorth.Outport(1),'CompiledPortComplexSignal');
    block_data = get_param(blk,'UserData');
    if (isComplex == 1) && (block_data.params.XRange == 1)
        error(message('dsp:sdspfscope2:invalidBlkInput1'));
    end
    % Store info about input complexity for later use.
    block_data.params.SpectrumScope.isInputComplex = isComplex;
    set_param(blk,'UserData',block_data);
end

%% ------------------------------------------------
function mdlPostPropSetup(block)

errorIfComplexInputAndOneSidedSpectrumType(block);

% Register model update method
setUpdateMethod(block);

%% ------------------------------------------------
function setUpdateMethod(block)
% Function to register correct Update method for each block

% Register model update function
simMode = get(bdroot(block.BlockHandle),'simulationMode');
if strcmpi(simMode, 'normal') || strcmpi(simMode, 'accelerator')    
    if isVectorScope(block) %% vector scope
        if (block.InputPort(1).DatatypeID < 2) %% double or single
            block.RegBlockMethod('Update', @mdlUpdate_vscope_DblSgl);
        else %% non double and non-single
            block.RegBlockMethod('Update', @mdlUpdate_vscope_fixedptDT);
        end
    else %% spectrum scope
        if (block.InputPort(1).DatatypeID < 2) %% double or single
            block.RegBlockMethod('Update', @mdlUpdate_sscope_DblSgl);
        else %% non double and non-single
            block.RegBlockMethod('Update', @mdlUpdate_sscope_fixedptDT);
        end
    end
else
    % non-normal and non-accelerator sim modes i.e. Rapid-accelerator,
    % external and PIL modes
    if isVectorScope(block) %% vector scope
        if (block.InputPort(1).DatatypeID < 2) %% double or single
            block.RegBlockMethod('Update', @mdlUpdate_nonNormalAccel_vscope_DblSgl);
        else %% non double and non-single
            block.RegBlockMethod('Update', @mdlUpdate_nonNormalAccel_vscope_fixedptDT);
        end
    else %% spectrum scope
        if (block.InputPort(1).DatatypeID < 2) %% double or single
            block.RegBlockMethod('Update', @mdlUpdate_nonNormalAccel_sscope_DblSgl);
        else %% non double and non-single
            block.RegBlockMethod('Update', @mdlUpdate_nonNormalAccel_sscope_fixedptDT);
        end
    end
end

%% ------------------------------------------------
% function mdlProcessParameters(block)
%

%% ------------------------------------------------
function mdlSetInputPortFrameData(block, idx, fd)
block.InputPort(idx).SamplingMode = fd;

%% ------------------------------------------------
function mdlSetInputPortDataType(block, idx, dtid)
block.InputPort(idx).DatatypeID = dtid;

%% ------------------------------------------------
function mdlSetInputPortDimensions(block,idx,di)
block.InputPort(idx).Dimensions = di;

%% -----------------------------------------------------------
function mdlStart(block)

sfcnh   = block.BlockHandle;
if isVectorScope(block) %% vector scope
    blk    = [get_param(sfcnh,'parent') '/' get_param(sfcnh,'Name')];
else %% spectrum scope
    blk    = get_param(sfcnh,'parent');
end

codeGenMode = strcmp(get_param(bdroot(blk),'buildingrtwcode'),'on');
accelMode   = strcmp(get_param(bdroot(blk),'simulationmode'),'accelerator');
if (codeGenMode && ~accelMode)
    return;
end

resetToFirstCall(blk);
block_data = get_param(blk,'UserData');
params = block_data.params;
% Put some data in block_data.comm to enable run-time switching between
% "In-Phase Only" and "In-Phase and Quadrature" for the Eye Diagram scope.  See
% g214535.
block_data.comm.block  = block;
block_data.comm.params = params;
set_param(blk, 'UserData', block_data);


% if 'OpenScopeAtStart' is on/off, firstcall is true/false
if block_data.firstcall
    Create_or_Restart_Scope(blk, block, params); %% blk, sfcn<-- change to blkh
else
    % if firstcall ('OpenScopeAtStart') is false ...
    if isempty(block_data.hfig)
        % ... and figure does not exist, shut down 'Update' method
        block.RegBlockMethod('Update', []);
    end
end
% mdlUpdate will update the lines with valid data (update_lines)


%% ------------------------------------------------------------
function mdlUpdate_vscope_DblSgl(block)

update_lines(get_param(block.BlockHandle, 'UserData'), block.InputPort(1).Data);%update_lines(block_data, u);

%% ------------------------------------------------------------
function mdlUpdate_nonNormalAccel_vscope_DblSgl(block)

block_data = get_param(block.BlockHandle, 'UserData');
if ~isempty(block_data.hfig)
    block_data.comm.block = block;
    set_param(block.BlockHandle, 'UserData', block_data);
    mdlUpdate_vscope_DblSgl(block);
end

%% ------------------------------------------------------------
function mdlUpdate_vscope_fixedptDT(block)

update_lines(get_param(block.BlockHandle, 'UserData'), block.InputPort(1).DataAsDouble);%update_lines(block_data, u);

%% ------------------------------------------------------------
function mdlUpdate_nonNormalAccel_vscope_fixedptDT(block)

block_data = get_param(block.BlockHandle, 'UserData');
if ~isempty(block_data.hfig)
    block_data.comm.block = block;
    set_param(block.BlockHandle, 'UserData', block_data);
    mdlUpdate_vscope_fixedptDT(block);
end

%% ------------------------------------------------------------
function mdlUpdate_sscope_DblSgl(block)

sfcnh = block.BlockHandle;
blk    = get_param(sfcnh,'parent');
update_lines(get_param(blk, 'UserData'), block.InputPort(1).Data);%update_lines(block_data, u);

%% ------------------------------------------------------------
function mdlUpdate_nonNormalAccel_sscope_DblSgl(block)

sfcnh = block.BlockHandle;
blk   = get_param(sfcnh,'parent');
block_data = get_param(blk, 'UserData');
if ~isempty(block_data.hfig)
    block_data.comm.block = block;
    set_param(blk, 'UserData', block_data);
    mdlUpdate_sscope_DblSgl(block);
end

%% ------------------------------------------------------------
function mdlUpdate_sscope_fixedptDT(block)

sfcnh = block.BlockHandle;
blk    = get_param(sfcnh,'parent');
update_lines(get_param(blk, 'UserData'), block.InputPort(1).DataAsDouble);%update_lines(block_data, u);

%% ------------------------------------------------------------
function mdlUpdate_nonNormalAccel_sscope_fixedptDT(block)

block_data = get_param(block.BlockHandle, 'UserData');
if ~isempty(block_data.hfig)
    block_data.comm.block = block;
    set_param(block.BlockHandle, 'UserData', block_data);
    mdlUpdate_sscope_fixedptDT(block);
end

% ---------------------------------------------------------------
function update_lines(block_data, u)
% UPDATE_LINES Update the lines in the scope display

% u: one frame of data
% Does not alter block_data

% If the user closed the figure window while the simulation
% was running, then hfig has been reset to empty.
%
% Allow the simulation to continue, do not put up a new figure
% window, and do not generate an error if window closes early.
%

% Call update_lines function:
feval(block_data.UpdateLinesFcn, block_data, u);
drawnow('update');  % for quicker gui response

% Update frame number display:
% if there is a valid frame number string, update it - it is invisible unless feature is enabled
if isfield(block_data,'hframenum') && all(ishghandle(block_data.hframenum))
    d = get(block_data.hframenum(2),'userdata');
    set(block_data.hframenum(2), 'userdata', d+block_data.inc, 'string', sprintf('%d',d+block_data.inc));
end

% Check if autoscaling is in progress:
if isfield(block_data,'autoscaling') && ~isempty(block_data.autoscaling)
    Autoscale([],[], block_data, u);  % next frame of data
end

% ---------------------------------------------------------------
function fcn = select_UpdateLinesFcn(blk, block_data)
% blk is the name of the sdspfscope2 block.
% Note that for comms scopes, blk is STILL the name of the
% fscope2 block, and NOT the name of the top-level comms
% block.  This could be confusing!

freqDomain = (block_data.params.Domain==2);
oneChan    = (block_data.NChans==1);

% Try to find block_type_. Success occurs only for Comms scopes.
% For DSP scopes, it returns empty.
block_type = getfromancestor(blk,'block_type_',1);
switch block_type,
    case 'eye',
        fcn = @update_lines_eyediagram_onechan;
    case 'xy',
        fcn = @update_lines_sigtraj_onechan;
    otherwise,
        if freqDomain,
            % Frequency domain:
            if oneChan,
                fcn = @update_lines_freq_oneframe_onechan;
            else
                fcn = @update_lines_freq_oneframe_multichan;
            end
        else
            % Time domain:
            oneFrame = (block_data.params.HorizSpan==1);
            if oneFrame,
                if oneChan,
                    fcn = @update_lines_time_oneframe_onechan;
                else
                    fcn = @update_lines_time_oneframe_multichan;
                end
            else
                % Use the frame counter to determine where we are:
                % Counter starts at 0, since it is incremented after
                % update_lines occurs.
                nframes = block_data.params.HorizSpan;
                d = get(block_data.hframenum(2),'userdata');
                useInit = (d < nframes);

                if oneChan,
                    if useInit,
                        fcn = @init_lines_time_multiframe_onechan;
                    else
                        fcn = @update_lines_time_multiframe_onechan;
                    end
                else
                    if useInit,
                        fcn = @init_lines_time_multiframe_multichan;
                    else
                        fcn = @update_lines_time_multiframe_multichan;
                    end
                end
            end
        end
end
% ---------------------------------------------------------------
function update_lines_eyediagram_onechan(block_data, u)

% If a new eye diagram scope must be generated (e.g. "In-Phase Only" to
% "In-Phase and Quadrature"), then start it up from scratch.  See g214535.
sfcnh  = block_data.comm.block.BlockHandle;
blk    = [get_param(sfcnh,'parent') '/' get_param(sfcnh,'Name')];
block  = block_data.comm.block;
params = block_data.comm.params;
if block_data.firstcall
    % Cache the # of traces before a new scope is generated.  See g126103.
    numTraces = get(block_data.hframenum(2), 'userdata');

    Create_or_Restart_Scope(blk, block, params);
    block_data = get_param(blk, 'UserData');  % get new block_data after Create_or_Restart_Scope

    set(block_data.hframenum(2), 'userdata', numTraces);  % reset # of traces
end

% One frame per horizontal span

hline = block_data.hline;

% processing for update_lines
uNaN = NaN;
comm = block_data.comm;

% copy over values from u to u0
% Permute the values in u to correctly select every tracesPerLine'th column
% Split the target locations in u0 to allow for duplicated points at the
% trace boundary and a NaN in between traces.
switch block_data.cparams.str.dispDiagram,
    case 'In-phase Only',
        % Create array of Nan's, overwrite data segment from u, excluding duplicate points
        u0 = uNaN(ones(comm.pointsPerLine,comm.numLines));
        u0(comm.idxC0,:) = reshape([u(:, comm.idxR) uNaN(ones(comm.sampPerTrace,comm.extraIdxR))], ...
            comm.rsFact0, comm.rsFact1);

        % Processing for duplicated data in the last element of each trace
        if isOn(block_data.cparams.str.dupPoints),

            % copy over duplicate points at trace boundary from u to u0
            u0(comm.idxDC0,:) = reshape([u(1, comm.idxDR) uNaN(ones(1,comm.extraIdxR+1))], ...
                comm.rsFactD0, comm.rsFactD1);
        end

        % end of change ????
        for i = 1:comm.numLines,
            set(hline(i,1), 'YData', u0(:,i));
        end
    case 'In-phase and Quadrature',
        % Create array of Nan's, overwrite data segment from u to u0, excluding duplicate points, In-phase
        u0 = uNaN(ones(comm.pointsPerLine,comm.numLines));
        u0(comm.idxC0,:) = reshape([u(:, comm.idxR) uNaN(ones(comm.sampPerTrace,comm.extraIdxR))], ...
            comm.rsFact0, comm.rsFact1);

        % Create array of Nan's, overwrite data segment from u to u1, excluding duplicate points, Quadrature
        u1 = uNaN(ones(comm.pointsPerLine,comm.numLines));
        u1(comm.idxC0,:) = reshape([u(:,comm.idxR+comm.halfwidth) uNaN(ones(comm.sampPerTrace,comm.extraIdxR))], ...
            comm.rsFact0, comm.rsFact1);

        % Processing for duplicated data in the last element of each trace
        if isOn(block_data.cparams.str.dupPoints),

            % copy over duplicate points at trace boundary from u to u0, In-phase
            u0(comm.idxDC0,:) = reshape([u(1,comm.idxDR) uNaN(ones(1,comm.extraIdxR+1))], ...
                comm.rsFactD0, comm.rsFactD1);
            % copy over duplicate points at trace boundary from u to u1, Quadrature
            u1(comm.idxDC0,:) = reshape([u(1,comm.idxDR+comm.halfwidth) uNaN(ones(1,comm.extraIdxR+1))], ...
                comm.rsFactD0, comm.rsFactD1);
        end

        % Plot the data in u0 and u1 against time
        for i = 1:comm.numLines,
            set(hline(i,1), 'YData', u0(:,i));
            set(hline(i,2), 'YData', u1(:,i));
        end
    otherwise
end

% ---------------------------------------------------------------
function update_lines_sigtraj_onechan(block_data, u)

% One frame per horizontal span
% Multiple channels (matrix input):

hline = block_data.hline;

% processing for update_lines
uNaN = NaN;
comm = block_data.comm;

% Create array of Nan's, overwrite data segment from u to u0, excluding duplicate points, In-phase
u0 = uNaN(ones(comm.pointsPerLine,comm.numLines));
u0(comm.idxC0,:) = reshape([u(:, comm.idxR) uNaN(ones(comm.sampPerTrace,comm.extraIdxR))], ...
    comm.rsFact0, comm.rsFact1);

% Create array of Nan's, overwrite data segment from u to u1, excluding duplicate points, Quadrature
u1 = uNaN(ones(comm.pointsPerLine,comm.numLines));
u1(comm.idxC0,:) = reshape([u(:,comm.idxR+comm.halfwidth) uNaN(ones(comm.sampPerTrace,comm.extraIdxR))], ...
    comm.rsFact0, comm.rsFact1);

% Processing for duplicated data in the last element of each trace

% copy over duplicate points at trace boundary form u to u0, In-phase
u0(comm.idxDC0,:) = reshape([u(1,comm.idxDR) uNaN(ones(1,comm.extraIdxR+1))], ...
    comm.rsFactD0, comm.rsFactD1);
% copy over duplicate points at trace boundary form u to u1, Quadrature
u1(comm.idxDC0,:) = reshape([u(1,comm.idxDR+comm.halfwidth) uNaN(ones(1,comm.extraIdxR+1))], ...
    comm.rsFactD0, comm.rsFactD1);

% Plot the data in u0 against u1
for i = 1:comm.numLines,
    set(hline(i,1), 'XData', u0(:,i), 'YData', u1(:,i));
end

% ---------------------------------------------------------------
function update_lines_freq_oneframe_onechan(block_data, u)

% Single channel
% One frame per horizontal span

nrows = size(u, 1);

% Frequency domain conversions
if isfield(block_data.params,'SpectrumScope')

    if (block_data.params.XRange==1 && nrows > 2)
        % Spectrum type = One-sided
        % Compute full-power one-sided spectrum     
        u = computeOneSidedSpectrum(u, nrows);
    
    elseif (block_data.params.XRange==2 && nrows > 2)
        % Spectrum type = Two-sided
        % Compute two-sided spectrum
        u = computeTwoSidedSpectrum(u, nrows);
    end

    % Convert to dBW if required:
    if (any(block_data.params.YUnits==(3:6)))
        u = lin2dB(u);
        if (any(block_data.params.YUnits==[5 6]))
            % convert dBW to dBm
            u = u + 30;
        end        
    end   
    
else % Vector Scope
    
    % Convert to dB if required:
    if(block_data.params.YUnits==2)
        u = lin2dB(u);
    end

    % Rotate data if display range is [-Fn, Fn]:
    if (block_data.params.XRange==2 && nrows > 1)
        % rotate each channel of data:
        p = nrows/2;  % all FFTs are a power of 2 here
        u = u([p+1:nrows 1:p],:);
    end

end

set(block_data.hline, 'YData', u);

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    ystem = get(block_data.hstem,'ydata');
    ystem((0:nrows-1)*3 + 2) = u;
    set(block_data.hstem,'ydata',ystem);
end


% ---------------------------------------------------------------
function update_lines_freq_oneframe_multichan(block_data, u)

% One frame per horizontal span
% Multiple channels (matrix input)

[nrows,nchans] = size(u);

% Frequency domain conversions
if isfield(block_data.params,'SpectrumScope')

    if (block_data.params.XRange==1 && nrows > 2)
        % Spectrum type = One-sided
        % Compute full-power one-sided spectrum
        u = computeOneSidedSpectrum(u, nrows);
       
    elseif (block_data.params.XRange==2 && nrows > 2)
        % Spectrum type = Two-sided
        % Compute two-sided spectrum
        u = computeTwoSidedSpectrum(u, nrows);
    
    end

    % Convert to dBW if required:
    if (any(block_data.params.YUnits==(3:6)))
        u = lin2dB(u);
        if (any(block_data.params.YUnits==[5 6]))
            % convert dBW to dBm
            u = u + 30;
        end        
    end   
    
else % Vector Scope
    
    % Convert to dB if required:
    if(block_data.params.YUnits==2)
        u = lin2dB(u);
    end

    % Rotate data if display range is [-Fn, Fn]:
    if (block_data.params.XRange==2 && nrows > 1)
        % rotate each channel of data:
        p = nrows/2;  % all FFTs are a power of 2 here
        u = u([p+1:nrows 1:p],:);
    end

end

hline = block_data.hline;

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    ystem = get(block_data.hstem,'ydata');
    kup = (0:length(u)-1)*3 + 2;  % index to top of stems
    kdn = kup-1;                  % index to bottom of stems
    ystem(kup) = 0;
    ystem(kdn) = 0;
    markerpipestr = block_data.params.LineMarkers;

    for i = 1:nchans, % block_data.NChans
        val = u(:,i)';
        set(hline(i), 'YData', val);

        if strcmp(get_pipestr(markerpipestr, i,1), 'stem'),
            ystem(kup) = max(ystem(kup), val);
            ystem(kdn) = min(ystem(kdn), val);
        end
    end
    set(block_data.hstem,'ydata',ystem);

else
    for i = 1:nchans, % block_data.NChans
        set(hline(i), 'YData', u(:,i));
    end
end


% ---------------------------------------------------------------
function update_lines_time_oneframe_onechan(block_data, u)

% One frame per horizontal span
% Single channel

set(block_data.hline, 'YData', u);

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    nrows = size(u, 1);
    ystem = get(block_data.hstem,'ydata');
    ystem((0:nrows-1)*3 + 2) = u;
    set(block_data.hstem,'ydata',ystem);
end


% ---------------------------------------------------------------
function update_lines_time_oneframe_multichan(block_data, u)

% One frame per horizontal span
% Multiple channels (matrix input):

nchans = size(u, 2);
hline = block_data.hline;

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    ystem = get(block_data.hstem,'ydata');
    kup = (0:length(u)-1)*3 + 2;  % index to top of stems
    kdn = kup-1;                  % index to bottom of stems
    ystem(kup) = 0;
    ystem(kdn) = 0;
    markerpipestr = block_data.params.LineMarkers;

    for i = 1:nchans, % block_data.NChans
        val = u(:,i)';
        set(hline(i), 'YData', val);

        if strcmp(get_pipestr(markerpipestr, i,1), 'stem'),
            ystem(kup) = max(ystem(kup), val);
            ystem(kdn) = min(ystem(kdn), val);
        end
    end
    set(block_data.hstem,'ydata',ystem);
else
    for i = 1:nchans, % block_data.NChans
        set(hline(i), 'YData', u(:,i));
    end
end


% ---------------------------------------------------------------
function init_lines_time_multiframe_onechan(block_data, u)

% differs from update_lines_time_multiframe_onechan in that
% this begins rendering data from the LEFT side of the display.
% Used at the start (or re-start) of a simulation, and
% is only used for nframes number of input frames.  After that,
% the non-init version is installed and used thereafter.

% Multiple frames per horiz span
% Single channel

nrows = size(u, 1);
nframes = block_data.params.HorizSpan;

% Use the frame counter to determine where we are:
% Counter starts at 0, since it is incremented after
% update_lines occurs.
d = get(block_data.hframenum(2),'userdata');
y = get(block_data.hline,'YData')';
y(d*nrows+1 : (d+1)*nrows, :) = u;
set(block_data.hline, 'YData', y);

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    ystem = get(block_data.hstem,'ydata');
    ystem( 3*nrows*d + (0:length(u)-1)*3 + 2  ) = u;
    set(block_data.hstem,'ydata',ystem);
end

if (d >= nframes-1),
    % install non-init update fcn:
    % Cache the appropriate line-update function:
    block_data.UpdateLinesFcn = @update_lines_time_multiframe_onechan;
    ud=get(block_data.hfig,'userdata');
    set_param(ud.block,'userdata',block_data);
end


% ---------------------------------------------------------------
function update_lines_time_multiframe_onechan(block_data, u)

% Multiple frames per horiz span
% Single channel

nrows = size(u, 1);
nframes = block_data.params.HorizSpan;

y = get(block_data.hline,'YData')';
y(1 : nrows*(nframes-1)) = y(nrows+1:nrows*nframes);
y(nrows*(nframes-1)+1 : end) = u;
set(block_data.hline, 'YData', y);

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:
    ystem = get(block_data.hstem,'ydata');
    ystem(1 : 3*nrows*(nframes-1)) = ystem(3*nrows+1:3*nrows*nframes);
    ystem( 3*nrows*(nframes-1) + (0:length(u)-1)*3 + 2  ) = u;
    set(block_data.hstem,'ydata',ystem);
end


% ---------------------------------------------------------------
function init_lines_time_multiframe_multichan(block_data, u)

% Multiple frames per horiz span
% Multiple channels, multiple frames (matrix input)

[nrows,nchans] = size(u);
nframes = block_data.params.HorizSpan;
hline   = block_data.hline;

% Use the frame counter to determine where we are:
% Counter starts at 0, since it is incremented after
% update_lines occurs.
d = get(block_data.hframenum(2),'userdata');
if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:

    % ystem contains "triplets" of data
    % [y1top y1bottom NaN y2top y2bottom NaN ...]
    ystem = get(block_data.hstem,'ydata');

    % k = indices of (d+1)th frame
    k = nrows*d+1 : nrows*(d+1);
    k = (k-1)*3+2;
    kdn = k-1;
    ystem(k) = 0;
    ystem(kdn) = 0;
    markerpipestr = block_data.params.LineMarkers;

    for i = 1:nchans,
        y = get(hline(i),'YData');
        val = u(:,i)';
        y(d*nrows+1 : (d+1)*nrows) = val;
        set(hline(i), 'YData', y);

        if strcmp(get_pipestr(markerpipestr, i,1), 'stem'),
            ystem(k)   = max(ystem(k), val);
            ystem(kdn) = min(ystem(kdn), val);
        end
    end
    set(block_data.hstem,'ydata',ystem);

else
    for i = 1:nchans,
        y = get(hline(i),'YData')';
        y(d*nrows+1 : (d+1)*nrows, :) = u(:,i);
        set(hline(i), 'YData', y);
    end
end

if (d >= nframes-1),
    % install non-init update fcn:
    % Cache the appropriate line-update function:
    block_data.UpdateLinesFcn = @update_lines_time_multiframe_multichan;
    ud=get(block_data.hfig,'userdata');
    set_param(ud.block,'userdata',block_data);
end


% ---------------------------------------------------------------
function update_lines_time_multiframe_multichan(block_data, u)

% Multiple frames per horiz span
% Multiple channels, multiple frames (matrix input)

[nrows,nchans] = size(u);
nframes = block_data.params.HorizSpan;
hline   = block_data.hline;

if strcmp(get(block_data.hstem,'vis'),'on'),
    % using stem plots:

    % ystem contains "triplets" of data
    % [y1top y1bottom NaN y2top y2bottom NaN ...]
    ystem = get(block_data.hstem,'ydata');

    % copy stem values from last (span-1) frames to first (span-1) frames
    ystem(1 : 3*nrows*(nframes-1)) = ystem(3*nrows+1:end);

    % k = indices of last frame
    k = nrows*(nframes-1)+1 : nrows*nframes;
    k = (k-1)*3+2;
    kdn = k-1;
    ystem(k) = 0;
    ystem(kdn) = 0;
    markerpipestr = block_data.params.LineMarkers;

    for i = 1:nchans,
        y = get(hline(i),'YData');
        y(1 : nrows*(nframes-1)) = y(nrows+1:end);
        val = u(:,i)';
        y(nrows*(nframes-1)+1 : end) = val;
        set(hline(i), 'YData', y);

        if strcmp(get_pipestr(markerpipestr, i,1), 'stem'),
            ystem(k)   = max(ystem(k), val);
            ystem(kdn) = min(ystem(kdn), val);
        end
    end
    set(block_data.hstem,'ydata',ystem);

else
    for i = 1:nchans,
        y = get(hline(i),'YData');
        y(1 : nrows*(nframes-1)) = y(nrows+1:end);
        y(nrows*(nframes-1)+1 : end) = u(:,i);
        set(hline(i), 'YData', y);
    end
end

% ---------------------------------------------------------------
function openDialogWhileRunning(blk)

% Processing based on whether or not the scope type is one that
% requires an open dialog
switch getfromancestor(blk,'block_type_',1),
    case {'eye','xy'},
        % Open parent dialog while running (vector scope is in a subsystem)
        parent = get_param(blk,'Parent');
        open_system(parent,'mask');
    otherwise,
        % No open dialog while running
end

% ---------------------------------------------------------------
function OpenScope(blk, hDialog) %#ok
% Open the scope in response to the 'OpenScopeImmediately' dialog
% checkbox being pressed.
if(nargin>1)
    if hDialog.hasUnappliedChanges
        questStr = ['You have unapplied changes in the Spectrum Scope dialog box.', ...
            'Would you like to apply the changes before opening the scope?'];
        unappliedChangesButtonName = questdlg(questStr, 'Unapplied Changes');
        switch unappliedChangesButtonName,
            case 'Yes',
                hDialog.apply;
            case 'No',
                % NO OP
            case 'Cancel',
                return;
        end % switch
    end
end

block_data = get_param(blk,'UserData');

if ~isfield(block_data,'hfig'),
    % the only way to get here is if the scope was closed from the beginning and you do one of these:
    % a) manually call this MATLAB sfcn this way: sdspfscope2([],[],[],'OpenScope', gcb)
    % b) double click a Comms block scope
    % Because, it is impossible to be here 'running' and hfig not defined!
    openDialogWhileRunning(blk);

elseif ~isempty(block_data.hfig),
    % Scope exists
    % three options:
    % 1 - Simply bring existing scope forward and return:
    % figure(block_data.hfig);
    % 2 - do nothing
    % 3 - bring up the mask dialog
    openDialogWhileRunning(blk);
    
else
    % hfig exists && isempty
    
    status    =  get_param(bdroot(blk),'simulationstatus');
    isRunning = strcmp(status,'running') || strcmp(status,'initializing') ...
        || strcmp(status,'updating');
    isExternal = strcmp(status,'external');

    % Need to open/re-open scope:
    if isRunning,
        % only reason to check isRunning is for when called from command line like:
        %          sdspfscope2([],[],[],'OpenScope', gcb)
        openScopeWhileRunning(blk);
        % setup 'Update' method, in case it was shut down due to absence of figure
        setUpdateMethod(block_data.comm.block);
    elseif isExternal
        % External or Rapid-accelerator sim modes
        % Do not call setUpdateMethod as the runtimeblock object is not guaranteed to be 
        % valid unless being called during simulation
        openScopeWhileRunning(blk);
    else
        openDialogWhileRunning(blk);
    end

    if strcmp(status,'running') || isExternal
        if strcmpi(get_param(blk,'BlockType'),'M-S-Function') % vector scope
            sfcn = blk;
        else  %%  'SubSystem' %% spectrum scope
            sfcn = [blk '/' 'Frame Scope'];
        end
        block = get_param(sfcn,'runtimeobject');
        % need to read the block_data again; as block_data.firstcall might get reset
        block_data = get_param(blk, 'UserData');
        if block_data.firstcall,
            params = block_data.params;
            Create_or_Restart_Scope(blk, block, params); %% blk, sfcn<-- change to blkh
                                                         % mdlUpdate will update the lines with valid data (update_lines)
        end
        
    end

end

% ---------------------------------------------------------------
function openScopeWhileRunning(blk)

% Respond to user request to open the scope
% (eg, user pressed button in block dialog)
%
% We must open GUI; thus, we ignore "OpenScopeAtSimStart" setting in dialog
% (pass flag=1 to force GUI to open)
resetToFirstCall(blk,1);

% nothing else to do
% scope will re-open at next time step

% ---------------------------------------------------------------
function resetToFirstCall(blk, mustOpen,delayReset)
% Sets up block and GUI prior to opening the scope
%
% Resets hfig handle if not present
% Sets firstcall flag to either open the gui on the next
%   time step, or keep it closed, according to the block
%   parameter "OpenScopeAtSimStart".
%
% If mustOpen is passed in, the decision to open a GUI
% will come from mustOpen instead of the dialog param.

block_data = get_param(blk,'UserData');

% setup an extra flag to delay the resetting of the firstcall variable by
% one more call
if nargin>2,
    block_data.delayReset = delayReset;
    block_data.firstcall = mustOpen;
else
    if isfield(block_data,'delayReset'),
        if block_data.delayReset,
            block_data.delayReset = max(0, block_data.delayReset-1);
            set_param(blk,'UserData',block_data);
            return;
        end
    end
end

% Determine if scope should open at next time step:
if nargin>1,
    block_data.firstcall = mustOpen;
else
    % NOTE: This is called before params are set into block_data
    switch getfromancestor(blk,'block_type_',2),
        case {1,3},
            parent = get_param(blk,'parent');
            block_data.firstcall = isOn(get_param(parent,'OpenScopeAtSimStart'));
        otherwise,
            block_data.firstcall = isOn(get_param(blk,'OpenScopeAtSimStart'));
    end
end

% Setup empty figure handle if handle not recorded:
if ~isfield(block_data,'hfig'),
    block_data.hfig = [];
end

set_param(blk,'UserData',block_data);


% ---------------------------------------------------------------
function startLineEraseMode(blk)
% Set channel lines to proper erase mode at start of simulation.
% This function is called only for Graphics Version 1

% The lines are set to 'normal' mode when a simulation terminates;
% when lines redraw over themselves in "xor" mode, dots are left at
% peaks without lines connecting to them.  This can be visually misleading.

block_data = get_param(blk,'UserData');

status    =  get_param(bdroot(blk),'simulationstatus');
isRunning = strcmp(status,'running') || strcmp(status,'initializing') ...
    || strcmp(status,'updating');
isPaused = strcmp(status,'paused');

% If simulation is stopped, then the erase mode is set to 'normal' (in mdlTerminate). 
% No need to change it as performance is not an issue in stopped state. Also, changing
% 'Persistence' or rendering qualify (Comms Scopes) has no effect during stopped state. 
% Hence, not changing erase mode has no effect. In fact, it (not changing erase mode from
% 'normal' to 'xor') provides more accurate line - see g495649 for the side effect of 
% changing erase mode when simulation is stopped.

if isRunning || isPaused

    if isOn(block_data.params.Memory),
        emode='none';    % Memory mode
    else
        switch getfromancestor(blk,'block_type_',2),
          case {1,3},
            emode= block_data.comm.emode;
            set(block_data.hfig, 'renderer',block_data.comm.renderer);
          otherwise,
            if ~ismac
                emode='xor';
            else
                emode = 'normal';
            end
        end
    end
    set([block_data.hline(:) ; block_data.hstem(:)], 'EraseMode',emode);
    set(block_data.hframenum, 'EraseMode','xor');
    
end

% ---------------------------------------------------------------
function terminateLineEraseMode(blk)
% Set channel line erase mode at simulation termination
% This function is called only for Graphics Version 1

block_data = get_param(blk,'UserData');

% Skip if HG window is closed or was never opened:
if ~isfield(block_data,'hfig') || isempty(block_data.hfig),
    return;
end

if isOn(block_data.params.Memory),
    emode='none';    % Memory mode
else
    emode='normal';
end
set([block_data.hline(:) ; block_data.hstem(:)], 'EraseMode',emode);
set(block_data.hframenum, 'EraseMode',emode);

% ---------------------------------------------------------------
function Create_or_Restart_Scope(blk, block, params)
% FIRST_UPDATE Called the first time the update function is executed
%   in a simulation run.  Creates a new scope GUI if it does not exist,
%   or restarts an existing scope GUI.

% blk: masked subsystem block (sdspfscope2)
% sfcn_blk: name of s-function block under the masked subsystem

block_data = get_param(blk,'UserData');
block_data.inputDims  = block.InputPort(1).Dimensions;
ts = block.SampleTimes;
if isSpectrumScope(block)
    bufferOn = strcmp(block_data.params.UseBuffer, 'on');
    specifyFFTlen = (block_data.params.inpFftLenInherit == 1);
else
    bufferOn = 0;
    specifyFFTlen = 0;
end

%comm scopes will not use block_data.Ts parameter
if  bufferOn
     block_data.Ts = ts(1) / (block_data.params.BufferSize - block_data.params.Overlap);
elseif (~bufferOn) && (specifyFFTlen)
    %get original input signal dimension from 'in1' block of the parent 
    inBlk = [blk '/In1'];
    inBlkPorth = get_param(inBlk,'Porthandles');
    inSignalDim = get_param(inBlkPorth.Outport(1),'CompiledPortDimensions');
    block_data.Ts = ts(1) / inSignalDim(2);
else
    %vector scope or spectrum scope with buffer off and inherited FFT Len
    block_data.Ts = ts(1) / block_data.inputDims(1);
end

% Check sample time:
% - disallow continuous signals
% - disallow constant sample time (might be seen if scope is unconnected and inline parameters is on)
% - allow fixed- and variable-step discrete
if ts(1)==0
    error(message('dsp:sdspfscope2:invalidBlkInput2'));
elseif ts(1) == inf 
    error(message('dsp:sdspfscope2:invalidBlkInput3'));
end

% Construct new scope figure window, or bring up old one:
if isfield(block_data,'hfig'),
    hfig = block_data.hfig; % scope already exists
else
    hfig = [];              % scope was never run before
end

dispDiagram = getfromancestor(blk,'dispDiagram');
block_type = getfromancestor(blk,'block_type_',2);

inDims = block_data.inputDims;
if length(inDims) > 1
    rowsU = inDims(2);
else
    rowsU = 1;
end
switch block_type,
    case {1,3},
        if ~isfield(block_data,'comm') || ~isfield(block_data.comm,'tempFigPos')
            block_data.comm.tempFigPos = [];
        end
        rowsU = rowsU/2;
end

switch block_type,
    case 1,
        if (isfield(block_data,'hfig') && ~isempty(block_data.hfig)) && ...
                (~isempty(block_data.comm.dispDiagram) && ...
                strcmp(block_data.cparams.str.dispDiagram, block_data.comm.dispDiagram)) && ...
                ~(isfield(block_data,'NChans') && (block_data.NChans ~= rowsU))

            block_data.comm.tempFigPos = [];
            block_data.comm.dispDiagram = block_data.cparams.str.dispDiagram;
        else
            CloseFigure([],[],blk);
            hfig=[];
        end
        block_data.strFrame = 'Trace';
        
    case 3,
        if ~isfield(block_data.comm,'numTraces') || ...
                (block_data.comm.numTraces ~= block_data.cparams.ws.numTraces)

            block_data.comm.numTraces = block_data.cparams.ws.numTraces;
            block_data.comm.tempFigPos = get(block_data.hfig,'position');
            CloseFigure([],[],blk);
            block_data.hfig=[];
        end

        if (isfield(block_data,'hfig') && ~isempty(block_data.hfig)) && ...
                ~(isfield(block_data,'NChans') && (block_data.NChans ~= rowsU))

            block_data.comm.tempFigPos = [];
        else
            CloseFigure([],[],blk);
            hfig=[];
        end

        block_data.strFrame = 'Symbol';        

    otherwise,
        if isfield(block_data,'NChans') && (block_data.NChans ~= rowsU)
            % Close the figure if the # of channels has changed
            % The GUI may need to be reconfigured significantly for
            % a change in channel count.
            CloseFigure([],[],blk);
            hfig=[];
        end
        block_data.strFrame = 'Frame';
end

block_data.samples_per_frame = block_data.inputDims(1);
block_data.NChans = rowsU;

set_param(blk, 'UserData', block_data);

% Establish a valid scope GUI:
if ~isempty(hfig),
    % Found existing scope figure window:

    % Prepare to re-start with existing scope window:
    fig_data = restart_scope(blk);

    % If things did not go well during restart, say the axis
    % was somehow deleted from the existing scope figure, etc.,
    % then hfig is left empty, and a new scope must be created.
    % Get hfig, then check if it is empty later:
    hfig = fig_data.hfig;
end

switch block_type,
    case 1,
        % Restart the scope if it is an eye diagram
        %        ~strcmp(block_data.cparams.str.fading,block_data.cparams_old.str.fading),
        if  (isfield(block_data.comm,'fading') && strcmp(block_data.cparams.str.fading,block_data.comm.fading)) && ...
                (isfield(block_data.comm,'dispDiagram') && strcmp(block_data.cparams.str.dispDiagram,block_data.comm.dispDiagram))

            block_data.comm.tempFigPos = [];
        else
            if ishghandle(block_data.hfig),
                block_data.comm.tempFigPos = get(block_data.hfig,'position');
                CloseFigure([],[],blk);
                hfig=[];
            end
        end
        %    if ~strcmp(block_data.cparams.str.dispDiagram, ...
        %        block_data.cparams_old.str.dispDiagram) | isempty(hfig),
        if isempty(hfig),
            % Initialize new figure window:
            [fig_data, comm] = create_scope(blk, params, block_data.NChans, block_data.comm.tempFigPos);
            comm.tempFigPos = [];
            block_data.comm = comm;
        end
        % update data in block_data.comm structure
        block_data.comm.fading = block_data.cparams.str.fading;
        block_data.comm.dispDiagram = block_data.cparams.str.dispDiagram;
    case 3,
        if  isfield(block_data.comm,'fading') && ...
                strcmp(block_data.cparams.str.fading,block_data.comm.fading) && ...
                ~isempty(block_data.hfig)

            block_data.comm.tempFigPos = [];
        else
            if ishghandle(block_data.hfig),
                block_data.comm.tempFigPos = get(block_data.hfig,'position');
                CloseFigure([],[],blk);
                hfig=[];
            end
        end
        if isempty(hfig),
            [fig_data, comm] = create_scope(blk, params, block_data.NChans, block_data.comm.tempFigPos);
            comm.tempFigPos = [];
            block_data.comm = comm;
        end
        % update data in block_data.comm structure
        block_data.comm.fading = block_data.cparams.str.fading;
    otherwise,
        if isempty(hfig),
            % Initialize new figure window:
            % Create the scope GUI
            fig_data = create_scope(blk, params, block_data.NChans);
        end
end


% Get line handle:
hline = fig_data.main.hline;
hstem = fig_data.main.hstem;
hgrid = fig_data.main.hgrid;

% Retain the name of the figure window for use when the
% block's name changes. Name is retained in S-fcn block's
% user-data:
block_data.firstcall   = 0;   % reset "new simulation" flag
block_data.hfig      = fig_data.hfig;
block_data.params    = params;

block_data.hcspec    = fig_data.hcspec;
block_data.haxis     = fig_data.main.haxis;
block_data.hline     = hline;
block_data.hstem     = hstem;
block_data.hgrid     = hgrid;
block_data.hframenum = fig_data.main.hframenum;
block_data.autoscaling = []; % turn off any autoscaling, if in progress

if ~isfield(block_data,'hgridtext'),
    block_data.hgridtext = [];   % only exists in block_data, not fig_data
end
if ~isfield(block_data,'hlegend'),
    block_data.hlegend   = [];   % ditto
end

% Cache the appropriate line-update function:
block_data.UpdateLinesFcn = select_UpdateLinesFcn(blk, block_data);
switch block_type,
    case {1,3},
        % Comms Processing.
        parent = get_param(block.BlockHandle,'Parent');
        parent = get_param(parent,'Parent');

        % Update the diagram type - FIX do we need this in all cases
        if strcmp(block_type,1),
            block_data.cparams.str.dispDiagram = get_param(parent,'dispDiagram');
        end

        % set up rendering quality mode
        if block_data.cparams.ws.render,
            block_data.comm.emode = 'normal';
            block_data.comm.renderer = 'zbuffer';
        else
            block_data.comm.emode = 'xor';
            block_data.comm.renderer = 'painters';
        end        
        % Update hgrid erase mode when using Graphics Version 1
        if matlab.graphics.internal.isGraphicsVersion1
            set(block_data.hgrid,'erasemode',block_data.comm.emode)
        end
        comm = block_data.comm;
        switch block_type,
            case 1,
                comm.sampPerTrace = block_data.cparams.ws.sampPerSymb * block_data.cparams.ws.symbPerTrace;
            otherwise,
                comm.sampPerTrace = block_data.cparams.ws.sampPerSymb;
        end

        %    comm.dataPointsPerLine = comm.tracesPerLine * comm.sampPerTrace;
        comm.pointsPerLine = comm.tracesPerLine * (comm.sampPerTrace + 2);

        % this stuff goes in first update
        comm.halfwidth = rowsU; %% rowsU defined as half nRows above (for comms scopes)
        comm.hwSize = ceil(comm.halfwidth/comm.numLines)*comm.numLines;
        comm.extraIdxR = comm.hwSize - comm.halfwidth;
        comm.idxR = 1:comm.hwSize-comm.extraIdxR;
        sz = [block_data.samples_per_frame comm.hwSize];
        comm.rsFact0 = sz(1)*comm.tracesPerLine;
        comm.rsFact1 = sz(2)/comm.tracesPerLine;

        % this stuff goes in first update
        size1u0 = comm.pointsPerLine;
        comm.idxC0 = reshape(1:size1u0, size1u0/comm.tracesPerLine, ...
            comm.tracesPerLine);
        comm.idxC0(end-1:end,:) = [];
        comm.idxC0 = comm.idxC0(:);
        comm.idxDR = (1:comm.hwSize-comm.extraIdxR-1)+1;

        % Processing for duplicated data in the last element of each trace
        switch block_type,
            case 1,
                % eye diagram specific initialization
                comm.idxDC0 = reshape(1:size1u0, size1u0/comm.tracesPerLine, ...
                    comm.tracesPerLine);
                comm.idxDC0(2:end,:) = [];
                comm.idxDC0 = comm.idxDC0(:)+comm.sampPerTrace;
            case 3,
                % signal trajectory specific initialization
                comm.idxDC0 = reshape(1:size1u0, size1u0/comm.tracesPerLine, ...
                    comm.tracesPerLine);
                comm.idxDC0(2:end,:) = [];
                comm.idxDC0 = comm.idxDC0(:)+comm.sampPerTrace;
        end

        szD = [1 comm.hwSize];
        comm.rsFactD0 = szD(1)*comm.tracesPerLine;
        comm.rsFactD1 = szD(2)/comm.tracesPerLine;
        block_data.comm = comm;
        block_data.inc = block_data.cparams.ws.numNewFrames;
    otherwise,
        block_data.inc = 1;
end

% Set block's user data:
set_param(blk, 'UserData', block_data);

% The following block callbacks are assumed to be set
% in the library block:
%
%   CopyFcn		      "<sfunname>([],[],[],'BlockCopy');"
%   DeleteFcn		  "<sfunname>([],[],[],'BlockDelete');"
%   NameChangeFcn     "<sfunname>([],[],[],'NameChange');"

% set up the axes and menus as necessary
SetMenuChecks(blk);  % update state of menu items
setup_axes(blk,1);  % send one frame of data for axis setup
switch dispDiagram,
    case 'In-phase and Quadrature',
        setup_axes(blk,2);  % send one frame of data for axis setup
    otherwise,
end

% ---------------------------------------------------------------
function h = getDisableMenuHandles(blk, lineNum)

block_data = get_param(blk,'UserData');
hfig = block_data.hfig;
fig_data = get(hfig,'UserData');

% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

h = fig_data.menu.linedisable(:,lineNum);

% ---------------------------------------------------------------
function h = getMarkerMenuHandlesFromMarker(blk, lineNum, marker)

% If marker is empty, we won't find any match
% Just return a quick empty:
if isempty(marker),
    h=[]; return;
end

block_data = get_param(blk,'UserData');
hfig = block_data.hfig;
fig_data = get(hfig,'UserData');

% Get handles to just one of the options menu line style items.
% The context (and other line #) menus simply contain redundant info.
%
% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

hmenus  = fig_data.menu.linemarker;        % [options;context] x [line1 line2 ...]
hmarkers = get(hmenus(:,lineNum),'child');  % marker menu items for lineNum menu, options/context
hmarkers = cat(2,hmarkers{:});               % matrix of handles: markers x [options context]
menuMarkers = get(hmarkers(:,1),'UserData'); % cell array of marker strings just for options menu

h = [];  % in case no match is found
for i=1:size(hmarkers,1),
    if isequal(marker, menuMarkers{i}),
        % Found a matching marker entry
        % Return both Options and Context menu handles for
        %   corresponding style entry for line number lineNum
        h = hmarkers(i,:);
        return;
    end
end

% ---------------------------------------------------------------
function retLineNum = modifyLineIdx(oldLineNum,modLineNum, blk)

% FIX should blk be changed to a parameter passed in ???
switch getfromancestor(blk, 'block_type_',2),
    case {1,3},
        retLineNum= modLineNum;
    otherwise,
        retLineNum = oldLineNum;
end


% ---------------------------------------------------------------
function h = getStyleMenuHandlesFromStyle(blk, lineNum, style)

% If style is empty, we won't find any match
% Just return a quick empty:
if isempty(style),
    h=[]; return;
end
% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

block_data = get_param(blk,'UserData');
hfig = block_data.hfig;
fig_data = get(hfig,'UserData');

% Get handles to just one of the options menu line style items.
% The context (and other line #) menus simply contain redundant info.
%
% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

hmenus  = fig_data.menu.linestyle;         % [options;context] x [line1 line2 ...]
hstyles = get(hmenus(:,lineNum),'child');  % style menu items for lineNum menu, options/context
hstyles = cat(2,hstyles{:});               % matrix of handles: styles x [options context]
menuStyles = get(hstyles(:,1),'UserData'); % cell array of style strings just for options menu

h = [];  % in case no match is found
for i=1:size(hstyles,1),
    if isequal(style, menuStyles{i}),
        % Found a matching style entry
        % Return both Options and Context menu handles for
        %   corresponding style entry for line number lineNum
        h = hstyles(i,:);
        return;
    end
end


% ---------------------------------------------------------------
function h = getColorMenuHandlesFromRGB(blk, lineNum, rgb)
% Maps an RGB color spec to a color menu index.
% The userdata fields of color menu objects contain RGB specs.
% Returns an empty handle vector if no match is found.

% If RGB is empty, we won't find any match
% Just return a quick empty:
if isempty(rgb),
    h=[]; return;
end

block_data = get_param(blk,'UserData');
hfig = block_data.hfig;
fig_data = get(hfig,'UserData');

% Get handles to just one of the options menu line color items.
% The context (and other line #) menus simply contain redundant info.
%

% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

hmenus  = fig_data.menu.linecolor;    % [options;context] x [line1 line2 ...]
hclrs   = get(hmenus(:,lineNum),'child'); % color menu items for lineNum menu, options/context
hclrs   = cat(2,hclrs{:});            % matrix of handles: colors x [options context]
menuRGB = get(hclrs(:,1),'UserData'); % cell array of RGB vectors just for options menu

h = [];  % in case no match is found
for i=1:size(hclrs,1),
    if isequal(rgb, menuRGB{i}),
        % Found a matching RGB entry
        % Return both Options and Context menu handles for
        %   corresponding color entry for line number lineNum
        h = hclrs(i,:);
        return;
    end
end

% ---------------------------------------------------------------
function rgb = mapCSpecToRGB(blk, user_cspec)
% Maps a user-defined color spec (CSpec) to an RGB triple
% An empty string maps to black (so unspecified lines are simply black)
% User-define color spec can be 'r' or 'red' or [1 0 0], etc.

% If user-spec is an empty, it is mapped to black
if isempty(user_cspec),
    rgb=[0 0 0];  % black
    return;
end

% Before using str2num find if there is any numerical number.
user_cspec_rgbNumericValue = 0;
for i=0:9
    % This check is to prevent the case where the user_spec string
    % is a variable, since that is not presently supported
    if any(user_cspec == num2str(i))
        user_cspec_rgbNumericValue=1;
        break
    end
end
if user_cspec_rgbNumericValue
    % If user-spec is an RGB triple encoded as a string,
    % convert to numeric and return:
    rgb = str2num(user_cspec); %#ok
else
    rgb =[];
end


if ~isempty(rgb),
    return;
end

% User spec is not an RGB triple.
% As a favor to the user, remove any apostrophes from the spec.
% The user might have accidentally entered:
%   'c'|'y'  (for example)
% instead of
%    c|y     (which is what is required since this is a 'literal' edit box)
%
% If any apostrophes were detected, remove them:
i = find(user_cspec == '''');
if ~isempty(i),
    user_cspec(i)=''; % remove apostrophes
    %warning('dsp:sdspfscope2:noApostrophes','Channel color specs are literal strings - do not use apostrophes.');
end


% If user-defined color spec is invalid, return an empty
block_data = get_param(blk,'UserData');
hcspec = block_data.hcspec;
try
    set(hcspec,'color',user_cspec);
    rgb = get(hcspec,'color');
catch %#ok
    warning(message('dsp:sdspfscop2:InvalidLineColor'));
    rgb = zeros(0,3);  % empty RGB spec
end


% ---------------------------------------------------------------
function [rgb,h] = getDialogLineColor(blk,lineNum)
% Determine RGB vector corresponding to user-specified color.
%  - If user-specified color is empty, black is substituted.
%  - If user-specified color is not found, RGB is set to empty.
%
% Optionally returns vector of 2 handles, H, for corresponding
%   line color menu items in the Options and Context menus.
switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        % FIX( this does some MC processing -- needs to be merged with modifyLineIdx
        block_data = get_param(blk,'userdata');
        parent = get_param(blk,'parent');
        pipestr = get_param(parent,'LineColors');        % get all user-specified color specs
        numTraces = block_data.comm.numLines;               % get all user-specified color specs
        lineNumMod = rem(lineNum-1, numTraces)+1;
        chanNumES = floor((lineNum-1)/numTraces)+1;
        user_cspec = get_pipestr(pipestr,chanNumES,1);  % cspec for line lineNum

        rgb = mapCSpecToRGB(blk, user_cspec);         % find RGB representation - empty if no match
        if strcmp(get_param(parent,'fading'),'on')        % get all user-specified color specs
            rgb = fadeColors(numTraces, rgb, lineNumMod);
        end
        if nargout>1,
            h = getColorMenuHandlesFromRGB(blk, lineNum, rgb); % get handles - may be empty
        end
    otherwise,
        pipestr = get_param(blk,'LineColors');        % get all user-specified color specs
        user_cspec = get_pipestr(pipestr,lineNum,1);  % cspec for line lineNum
        rgb = mapCSpecToRGB(blk, user_cspec);         % find RGB representation - empty if no match
        if nargout>1,
            h = getColorMenuHandlesFromRGB(blk, lineNum, rgb); % get handles - may be empty
        end
end

% ---------------------------------------------------------------
function fadedCol = fadeColors(numColors, colFirst,idx)

colLast = [ 1 1 1];

fadedCol = (colFirst(1)-colLast(1)).*idx./numColors + colLast(1);
fadedCol = [fadedCol (colFirst(2)-colLast(2)).*idx./numColors + colLast(2)];
fadedCol = [fadedCol (colFirst(3)-colLast(3)).*idx./numColors + colLast(3)];

fadedCol = max(fadedCol, 0);
fadedCol = min(fadedCol, 1);

% ---------------------------------------------------------------
function [style,h] = getDialogLineStyle(blk,lineNum)
% Determine style string corresponding to user-specified color.
%  - If user-specified style is empty, solid is substituted.
%  - If user-specified style is not found, style is set to empty.
%
% Optionally returns vector of 2 handles, H, for corresponding
%   line style menu items in the Options and Context menus.

% FIX( this does some MC processing -- needs to be merged with modifyLineIdx

switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        block_data = get_param(blk,'userdata');
        parent = get_param(blk,'parent');
        pipestr = get_param(parent,'LineStyles');        % get all user-specified color specs
        numTraces = block_data.cparams.ws.numTraces;        % get all user-specified color specs
        chanNumES = floor((lineNum-1)/numTraces)+1;
        style = get_pipestr(pipestr,chanNumES,1);  % style for line lineNum
    otherwise
        pipestr = get_param(blk,'LineStyles');   % get all user-specified style specs
        style = get_pipestr(pipestr,lineNum,1);  % style for line lineNum
end
% Map from user-specified style to actual style string:
if isempty(style),
    style='-';
end

% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

h = getStyleMenuHandlesFromStyle(blk, lineNum, style); % get handles - may be empty


% ---------------------------------------------------------------
function y = anyStemMarkers(blk)
% Determine if any lines have a Stem marker selected

block_data = get_param(blk,'UserData');
nchans = block_data.NChans;
pipestr = get_param(blk,'LineMarkers');   % get all user-specified marker specs
y = 0;  % assume no stem markers selected

% process index for comms scopes
nchans = modifyLineIdx(nchans, 1,blk);

for lineNum=1:nchans,
    marker = get_pipestr(pipestr, lineNum,1);
    y = strcmp(marker,'stem');
    if y, return; end
end


% ---------------------------------------------------------------
function [marker,h] = getDialogLineMarker(blk,lineNum)
% Determine RGB vector corresponding to user-specified color.
%  - If user-specified marker is empty, 'none' is substituted.
%  - If user-specified marker is not found, marker is set to empty.
%
% Optionally returns vector of 2 handles, H, for corresponding
%   line marker menu items in the Options and Context menus.

% FIX( this does some MC processing -- needs to be merged with modifyLineIdx

switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        block_data = get_param(blk,'userdata');
        parent = get_param(blk,'parent');
        pipestr = get_param(parent,'LineMarkers');        % get all user-specified color specs
        numTraces = block_data.cparams.ws.numTraces;        % get all user-specified color specs
        chanNumES = floor((lineNum-1)/numTraces)+1;
        marker = get_pipestr(pipestr,chanNumES,1);  % marker for line lineNum
    otherwise
        pipestr = get_param(blk,'LineMarkers');   % get all user-specified marker specs
        marker = get_pipestr(pipestr,lineNum,1);  % marker for line lineNum
end

% Map from user-specified marker to actual style string:
if isempty(marker),
    marker='None';
end

% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

h = getMarkerMenuHandlesFromMarker(blk, lineNum, marker); % get handles - may be empty


% ---------------------------------------------------------------
function [disable,h] = getDialogLineDisable(blk,lineNum)
% Determine channel disable setting
%
% Optionally returns vector of 2 handles, H, for corresponding
%   line marker menu items in the Options and Context menus.

% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);

pipestr = get_param(blk,'LineDisables');   % get all user-specified disable specs
disable = get_pipestr(pipestr,lineNum,1);  % disable for line lineNum

% Map from user-specified disable to actual disable string:
if isempty(disable),
    disable='on';
end

h = getDisableMenuHandles(blk, lineNum);


% ---------------------------------------------------------------
function SetMenuChecks(blk)
% Called only from Create_or_Restart_Scope to preset menu checks

% blk: masked subsystem block

block_data = get_param(blk,'UserData');
fig_data   = get(block_data.hfig,'UserData');

% Update AxisZoom menu check:
%
opt = get_param(blk,'AxisZoom');
set(fig_data.menu.axiszoom, 'Checked',opt);

block_type = getfromancestor(blk,'block_type_',2);
switch block_type,
    case {1,3},
        parent = get_param(blk,'parent');
        % Update AxisGrid menu check:
        %
        opt = get_param(parent,'AxisGrid');
        set(fig_data.menu.axisgrid, 'Checked',opt);

        % Update Frame Number menu check:
        %
        opt = get_param(parent,'FrameNumber');
        set(fig_data.menu.framenumber, 'Checked',opt);

    otherwise,
        % Update AxisGrid menu check:
        %
        opt = get_param(blk,'AxisGrid');
        set(fig_data.menu.axisgrid, 'Checked',opt);

        % Update Frame Number menu check:
        %
        opt = get_param(blk,'FrameNumber');
        set(fig_data.menu.framenumber, 'Checked',opt);

        % Update Legend menu check:
        %
        opt = get_param(blk,'AxisLegend');
        set(fig_data.menu.axislegend, 'Checked',opt);

        % Update Memory menu check:
        %
        opt = get_param(blk,'Memory');
        set(fig_data.menu.memory, 'Checked',opt);
end

% Update line color menu checks:
%

% Reset all checks for this line in both the options and
%   context menus for line styles/colors/markers:
switch block_type,
    case 3,
        h=[fig_data.menu.linecolor fig_data.menu.linestyle];
    otherwise,
        h=[fig_data.menu.linecolor fig_data.menu.linestyle fig_data.menu.linemarker];
end
hc=get(h,'child');
hc=cat(1,hc{:});
set(hc,'check','off');

% process index for comms scopes
numChans = modifyLineIdx(block_data.NChans, 1, blk);

for i = 1 : numChans,
    % If item corresponds to a valid index, turn on check-marks
    %   for that item in both the options and context menus:
    % Handle will be empty if menu does not contain user-specified choice

    % Update line disable menu checks:
    [status, h] = getDialogLineDisable(blk, i);
    set(h,'check',status);

    % Update line colors menu checks:
    [~, h] = getDialogLineColor(blk, i);
    set(h,'check','on');

    % Populate the context menu with Style/Color/Marker menus:
    switch block_type,
        case 3,
            % Update line styles menu checks:
            [~, h] = getDialogLineStyle(blk, i);
            set(h,'check','on');
        otherwise,
            % Update line styles menu checks:
            [~, h] = getDialogLineStyle(blk, i);
            set(h,'check','on');

            % Update line markers menu checks:
            [~, h] = getDialogLineMarker(blk, i);
            set(h,'check','on');
    end

end

%% ---------------------------------------------------------------
function okflag = OK_TO_CHECK_PARAM(p)

okflag = ~isempty(p);
if ~okflag
    ss = get_param(bdroot,'simulationstatus');
    okflag = strcmp(ss, 'initializing') || ...
        strcmp(ss, 'updating')     || ...
        strcmp(ss, 'running')      || ...
        strcmp(ss, 'paused');
end

%% ---------------------------------------------------------------
function  mdlCheckParameters(block)
sfcnh = block.BlockHandle;
block_type = getfromancestor(gcb,'block_type_',2);
switch block_type,
    case {1,3},
        return;
    otherwise,
        if isVectorScope(block) %% vector scope
            blk    = [get_param(sfcnh,'parent') '/' get_param(sfcnh,'Name')];
        else %% spectrum scope
            blk    = get_param(sfcnh,'parent');
        end

        block_data = get_param(blk, 'UserData');
        CheckParams(blk, block_data.params);
end

% ---------------------------------------------------------------
function CheckParams(~, params)

% Check XLabel:
% -------------
if OK_TO_CHECK_PARAM(params.XLabel)
    if ~ischar(params.XLabel),
        error(message('dsp:sdspfscope2:paramDTypeError1'));
    end
end

% Check XIncr:
% -------------
if OK_TO_CHECK_PARAM(params.XIncr)
    if ~isOn(params.InheritXIncr),
        x = params.XIncr;
        if (numel(x) ~= 1) || issparse(x) || ~isfinite(x) || ~isa(x,'double') ||  ...
                ~isreal(x) || (x <= 0)
            if (params.Domain == 3) % User-defined
                error(message('dsp:sdspfscope2:paramRealScalarError'));                
            else
                 error(message('dsp:sdspfscope2:paramRealScalarError1'));
            end
        end
    end
end

% Check XStart (X display offset (sampled)):
% ------------------------------------------
if (params.Domain == 3) % User-defined
    if OK_TO_CHECK_PARAM(params.XStart)
        if ~isOn(params.InheritXIncr),
            x = params.XStart;
            if (numel(x) ~= 1) || issparse(x) || ~isfinite(x) || ...
                    ~isa(x,'double') ||  ~isreal(x)
                error(message('dsp:sdspfscope2:paramRealScalarError8'));
            end
        end
    end
end


% Check YLabel:
% -------------
if OK_TO_CHECK_PARAM(params.YLabel)
    if ~ischar(params.YLabel),
        error(message('dsp:sdspfscope2:paramDTypeError2'));
    end
end

% Check horizontal span:
% ----------------------
if (params.Domain ~= 2)
    %% check params.HorizSpan only if domain is time or 'user-defined'
    x = params.HorizSpan;
    if OK_TO_CHECK_PARAM(x)
        if ~isa(x,'double') || issparse(x) || ~isreal(x) || ...
                (numel(x) ~= 1) || (x ~= floor(x)) || (x <= 0)
            error(message('dsp:sdspfscope2:paramRealScalarError2'));
        end
    end
end

% Check XMin:
% -----------
if (params.XLimit == 2) % User-defined
    if isfield(params, 'XMin') % Presence of XMin guarantees presence of XMax.
        x = params.XMin;
        if OK_TO_CHECK_PARAM(x)
            if ~isa(x,'double') || issparse(x) || ~isreal(x) || (numel(x) ~= 1)
                error(message('dsp:sdspfscope2:paramRealScalarError3'));
            end
        end
        ymin = x;

        % Check XMax:
        % -----------
        x = params.XMax;
        if OK_TO_CHECK_PARAM(x)
            if ~isa(x,'double') || issparse(x) || ~isreal(x) || (numel(x) ~= 1)
                error(message('dsp:sdspfscope2:paramRealScalarError4'));
            end
            if x<=ymin,
                error(message('dsp:sdspfscope2:paramOutOfRange'));
            end
        end
    end
end

% Check YMin:
% -----------
x = params.YMin;
if OK_TO_CHECK_PARAM(x)
    if ~isa(x,'double') || issparse(x) || ~isreal(x) || (numel(x) ~= 1)
        error(message('dsp:sdspfscope2:paramRealScalarError5'));
    end
end
ymin = x;

% Check YMax:
% -----------
x = params.YMax;
if OK_TO_CHECK_PARAM(x)
    if ~isa(x,'double') || issparse(x) || ~isreal(x) || (numel(x) ~= 1)
        error(message('dsp:sdspfscope2:paramRealScalarError6'));
    end
    if x<=ymin,
        error(message('dsp:sdspfscope2:paramRealScalarError7'));
    end
end

% Check FigPos:
% -------------
x = params.FigPos;
if OK_TO_CHECK_PARAM(x)
    if ~isa(x,'double') || issparse(x) || ~isreal(x) || ...
            size(x,1)~= 1 || size(x,2)~=4
        error(message('dsp:sdspfscope2:invalidFigureParameter'));
    end
end

% Check LineColors/Styles/Markers:
% ----------------
x = params.LineColors;
if OK_TO_CHECK_PARAM(x)
    if ~ischar(params.LineColors) || ...
            ~ischar(params.LineStyles) || ...
            ~ischar(params.LineMarkers) || ...
            ~ischar(params.LineDisables)
        error(message('dsp:sdspfscope2:paramDTypeError3'));
    end
end

% Spectrum Scope specific checks
%-------------------------------
if isfield(params,'SpectrumScope')
    % Spectrum Scope
    %
    % Check Buffer size in Spectrum Scope, if needed:
    %------------------------------------------------
    x = params.BufferSize;
    if strcmp(params.UseBuffer, 'on') && OK_TO_CHECK_PARAM(x) && ...
            (x == 1)
        error(message('dsp:sdspfscope2:invalidParam'));
    end
    
    % For PSD (Spectrum units = {Watts/Hertz, dBW/Hertz, dBm/Hertz}), if
    % Buffer overlap is non-zero, input sample time must be specified
    %-------------------------------------------------------------------
    x = params.Overlap;
    if any(params.YUnits == [1 3 5]) && ...
            strcmp(params.UseBuffer, 'on') && ...
            OK_TO_CHECK_PARAM(x) && (x ~= 0) && ...
            strcmp(params.InheritXIncr, 'on')
        
        spectrumType = {'Watts/Hertz', 'Watts', 'dBW/Hertz', 'dBW', ...
            'dBm/Hertz', 'dBm'};
        
        error(message('dsp:sdspfscope2:invalidParam1', spectrumType{params.YUnits}));
    end
    
end
% ---------------------------------------------------------------
function DialogApply(params,block_name)

% Called from MaskInitialization command via:
%   sdspfscope2([],[],[],'DialogApply',params);

% Updates block_data
block_fscope = gcb;
% In case of call from an internal method (not a callback)
% For example, SetAndApply calls us directly, and gcb might
% not be correct
if nargin<2,
    block_name = block_fscope;
end
block_data = get_param(block_name, 'UserData');

block_type = getfromancestor(block_name,'block_type_',2);
if ~isfield(block_data,'hfig') || isempty(block_data.hfig),
    block_data.params = params;
    set_param(block_name, 'UserData', block_data);
    return;  % System has not run yet
end

% Update menu checks:
SetMenuChecks(block_name);

% Handle figure position changes here:
% Only update if the current block dialog FigPos differs from
% the cached block_data FigPos.  The figure itself might be at
% a different position, which we should not change UNLESS the
% user actually made an explicit change in the mask (or, hit
% the RecordFigPos menu item, which simply changes the mask).

switch block_type,
    case 1,
        if isfield(params,'FigPos') && isfield(block_data.cparams,'ws')
            if  ~isequal(block_data.cparams_old.ws.FigPos, params.FigPos),
                set(block_data.hfig,'Position',block_data.cparams.ws.FigPos);
            end
        end
    case 3,
        if isfield(params,'FigPos') && isfield(block_data.cparams,'ws') && ...
                isfield(block_data.cparams_old,'ws') && ...
                ~isequal(block_data.cparams.ws.FigPos, block_data.cparams_old.ws.FigPos)

            set(block_data.hfig,'Position',block_data.cparams.ws.FigPos);
        end
    otherwise,
        if isfield(params,'FigPos') && ~isequal(block_data.params.FigPos, params.FigPos)
            set(block_data.hfig,'Position',params.FigPos);
        end
end

% Could check for a change in YUnits (Amplitude <-> dB)
% Start autoscale if changed
% start_autoscale = ~isequal(block_data.params.YUnits, params.YUnits);

% OBJECTIVES:
%
% 1 - formulate a "u" vector that emulates that which Simulink
%     would have passed in on a standard "mdlUpdate" call.
% 2 - update the display if the number of horiz frames has changed
% 3 - call setup_axes

switch block_type,
  case 3,
  otherwise,
    u_disp = get(block_data.hline, 'ydata');
    switch block_type,
      case {1,3},
        numTraces = block_data.cparams.ws.numTraces;      % get all user-specified color specs
      otherwise,
        numTraces = 1;
    end

    if iscell(u_disp),
        % If we have a cell, then length(block_data.hline) > 1
        % This was caused by a multi-channel display
        %
        nchans = length(u_disp);    % number of channels
        ndepc  = length(u_disp{1}); % (# display elements per chan) = (samples/frame)*(nframes)
        u_disp = [u_disp{:}];       % make it one long vector
        u_disp = reshape(u_disp,ndepc, nchans);
        %    elseif block_data.cparams.ws.block_type_ ~= 0

    elseif block_type == 1,
    else
        % Reshape in case of multiple channels (matrix input)
        % Also, corrects for HG giving us a 1xN when it should be Nx1 per channel
        nchans = 1;
        if (block_data.NChans ~= nchans),
            error(message('dsp:sdspfscope2:unhandledCase1'));
        end
        ndepc  = length(u_disp(:));
        u_disp = reshape(u_disp, ndepc/numTraces, numTraces*block_data.NChans);
    end

    % Determine samples per frame
    % NOTE: could be multiple channels of data,
    %  and multiple horizontal frames per channel.
    %  Disregard param if freq domain
    orig_horizspan = block_data.params.HorizSpan;
    orig_samples_per_frame = block_data.samples_per_frame;

    % Formulate "emulated input, u" from u_disp
    %
    if (orig_horizspan == 1),
        % Only one frame in display span
        % The input, u, to mdlUpdate is u_disp itself
        u = u_disp;
    else
        % More than one frame in horiz span
        % The input, u, from Simulink is only one frame
        % Hence, we must keep only one frame from u_disp
        % We choose to keep the most recent:
        u = u_disp(end - orig_samples_per_frame+1:end, :);
    end

    % Update displayed data
    %
    % xxx must also update stem lines
    %
    if isfield(params,'HorizSpan'),
        if params.HorizSpan ~= orig_horizspan,
            % Number of displayed frames has changed

            if params.HorizSpan > orig_horizspan,
                % new horiz span exceeds span in current display
                % we need to "manufacture" additional input data
                ydata = u_disp;
                padframes = params.HorizSpan - orig_horizspan;
                prepad = NaN * ones(padframes*orig_samples_per_frame, nchans);
                ydata = [prepad; ydata];

            else % if params.HorizSpan < orig_horizspan,
                 % new horiz span is less than span in current display
                 %
                 % retain only the most recent frames for the display
                f1 = orig_horizspan - (params.HorizSpan-1); % first frame
                f2 = orig_horizspan;                        % last frame
                s1 = (f1-1)*orig_samples_per_frame+1;       % 1st sample in 1st frame
                s2 = f2*orig_samples_per_frame;             % last sample of last frame
                ydata = u_disp(s1:s2,:);
            end

            % We can make up any xdata, as long as it has the right length,
            % since setup_axes will correct the values:
            xdata = (1:size(ydata,1))';
            switch block_type,
              case {1,3},
                halfnchans = nchans/2;
                switch block_data.cparams.str.dispDiagram,
                  case 'In-phase Only',
                    for i=1:halfnchans,
                        set(block_data.hline(i,1),'xdata',xdata, 'ydata',ydata(:,i));
                    end
                  case 'In-phase and Quadrature',
                    for i=1:halfnchans,
                        set(block_data.hline(i,1),'xdata',xdata, 'ydata',ydata(:,i));
                        set(block_data.hline(i,2), ...
                            'xdata',xdata, 'ydata',ydata(:,i+halfnchans));
                    end
                  otherwise,
                end
              otherwise,
                for i=1:nchans,
                    set(block_data.hline(i,1),'xdata',xdata, 'ydata',ydata(:,i));
                end
            end
        end
    end
    % Must "undo" any preprocessing performed on data
    % to emulate Simulink's input data to block
    %
    % Use "old" params to determine how to undo processing.
    % Rule: At the end of this IF-block, "u" is in the same form and has same value as the input
    % data to the (MATLAB sfcn) block from Simulink. Except for one optimization - see EXCEPTION
    % below
    if isfield(block_data.params,'Domain'),
        oldYUnits = block_data.params.YUnits;

        if (block_data.params.Domain==2),
            
            if isfield(block_data.params,'SpectrumScope')
                
                % This list must match the 'Spectrum units' parameter options and must be
                % in the same order
                spectrumType = {'Watts/Hertz', 'Watts', 'dBW/Hertz', 'dBW', ...
                                'dBm/Hertz', 'dBm'};
                tstr = get(get(block_data.haxis,'Title'), 'String');

                % If post-processing, detect if changing from PSD to MSS (or vice versa) makes
                % currently visualizing data stale. Take actions accordingly.
                if strcmpi(get_param(bdroot(block_name), 'SimulationStatus'), 'initializing')
                    % Initializing - changing from PSD to MSS (or vice versa) doesn't matter as
                    % new data will be obtained as per the latest setting.
                    % However, if 'stale data' message exists, remove it as it is not needed anymore
                    % Note that SimulationStatus must be 'initializing' here - not 'updating' which
                    % is the status at ctrl-D time - the message must stay at the end of ctrl-D
                    % time. Only when simulation is run (status would be 'initializing' then), 
                    % the message needs to be removed.
                    
                    if ~isempty(strfind(tstr, spectrumType{block_data.params.YUnits}))
                        % found the message - this message was added when data became stale
                        % before current change. Running simulation again makes it current again.
                        set(get(block_data.haxis,'Title'), 'String', '');
                    end                    
                    
                else
                    % Post-processing
                    
                    % if changing from PSD to MSS (or vice versa), place a message on the scope 
                    % figure indicating that the currently displayed data is out-of-date
                    
                    % Get the setting of underlying Periodogram block
                    periodogramMeasurement = get_param([block_name '/Periodogram'], 'measurement');
                    if ( strcmpi(periodogramMeasurement, 'Power spectral density') ... % Old setting is PSD
                         && any(params.YUnits == [2 4 6]) ) ... % New setting is MSS
                            || ...
                            ( strcmpi(periodogramMeasurement, 'Mean-square spectrum') ... % Old setting is MSS
                              && any(params.YUnits == [1 3 5]) ) % New setting is PSD
                        
                        % Changing from PSD to MSS (or vice versa). Now, check if the corresponding
                        % message exists. 
                        if ~isempty(strfind(tstr, spectrumType{block_data.params.YUnits}))
                            % found the message - this message was added when data became stale
                            % before current change. Hence, current change makes data valid again.
                            % So, remove the message.
                            set(get(block_data.haxis,'Title'), 'String', '');
                        else
                            % message not found. Add the message.
                            colTitle = 'b';
                            tstr = sprintf('Run simulation to display the spectrum in %s units.', ...
                                           spectrumType{params.YUnits});
                            set(get(block_data.haxis,'Title'), 'String', tstr, 'color',colTitle);
                        end                    
                    else
                        
                        % if not changing from PSD to MSS (or vice versa), check if the corresponding
                        % message exists.
                        
                        % look for unit value in the title string
                        if ~isempty(strfind(tstr, spectrumType{block_data.params.YUnits}))
                            % found the message. Now check if the old unit and the new unit are of
                            % the same type (PSD or MSS)
                            
                            if ( any(block_data.params.YUnits == [1 3 5]) ...
                                 && any(params.YUnits == [1 3 5]) ) ... % Both PSD
                                    || ...
                                    ( any(block_data.params.YUnits == [2 4 6]) ...
                                      && any(params.YUnits == [2 4 6]) ) % Both MSS
                                
                                % Yes - old and new unit are of same type. The message is still valid.
                                % Just update the unit in the message.
                                colTitle = 'b';
                                tstr = sprintf('Run simulation to display the spectrum in %s units.', ...
                                               spectrumType{params.YUnits});
                                set(get(block_data.haxis,'Title'), 'String', tstr, 'color',colTitle);
                            else
                                % No - old and new unit are of different type. Now, the data is valid.
                                % So, remove the message.
                                set(get(block_data.haxis,'Title'), 'String', '');
                            end
                            
                        end
                        
                    end
                end % if 'initializing'
                
                
                % Convert from dB back to linear, if required:
                % Do this data conversion and rotation only if line has enough data
                if ~strcmpi(get_param(bdroot(block_name), 'SimulationStatus'), 'initializing')
                    
                    if any(block_data.params.YUnits == (3:6)) && ...
                        ( isfield(params,'YUnits') && ...
                          (params.YUnits ~= block_data.params.YUnits) ) 
                        if any(block_data.params.YUnits == [5 6])
                            % dBm/Hertz or dBm - Convert it to dBW first
                            u = u - 30;
                        end
                        u = dB2lin(u);
                    end
                    % Unrotate data 
                    if orig_samples_per_frame > 2
                        
                        if mod(orig_samples_per_frame,2)
                            % odd FFT length
                            p = (orig_samples_per_frame+1)/2;                            
                        else
                            % even FFT length
                            p = orig_samples_per_frame/2;
                        end

                        if block_data.params.XRange == 2
                            % Spectrum type = Two-sided (i.e. (-Fn, Fn])
                            % unrotate & re-scale each channel of data:
                            u = u([p:orig_samples_per_frame 1:p-1],:);

                        elseif block_data.params.XRange == 1
                            % Spectrum type = one-sided spectrum
                            if any(block_data.params.YUnits == (3:6)) && ...
                                    ( isfield(params,'YUnits') && ...
                                      (params.YUnits == block_data.params.YUnits) )
                                % Subtraction in log domain is equivalent to division in linear domain
                                u(2:p,:) = u(2:p,:) - 3.0103; % (3.0103 = 10*log10(2));
                            else
                                u(2:p,:) = u(2:p,:)./2;
                            end 
                            
                            if mod(orig_samples_per_frame,2)
                                % odd FFT length
                                u = u([1:p p:-1:2],:);
                            else
                                % even FFT length
                                u = u([1:p+1 p:-1:2],:);
                            end
                            
                        end
                    end
                    
                end % if (length(u) ...
                
                % The correct value of SpectrumScope.isInputComplex is always computed
                % in the mdlPostPropSetup() method of the s-fcn. The mask init function
                % passes in just a dummy value. So, over write this field of the 'params'
                % structure pass into this function by the value fetched from block's 
                % UserData.
                params.SpectrumScope.isInputComplex = block_data.params.SpectrumScope.isInputComplex;
                
            else % Vector Scope->Frequency domain
                
                % Convert from dB back to linear, if required:
                if block_data.params.YUnits == 2 && ...
                        ( isfield(params,'YUnits') && (params.YUnits ~= 2) )
                    u = dB2lin(u);
                end
                % Unrotate data if display range is [-Fn, Fn]:
                if (block_data.params.XRange == 2 && orig_samples_per_frame > 1)
                    % unrotate each channel of data:
                    p = orig_samples_per_frame/2;  % all FFTs are a power of 2 here
                    u = u([p+1:orig_samples_per_frame 1:p],:);
                end
                
            end % if 'SpectrumScope'
            
        end % if 'Frequency domain'
    end % if 'Domain' field exists
    
end % switch-case

% Record new param info:
switch block_type
    
  case {1,3}
    
    struct_names = fieldnames(block_data.cparams.ws);
    setfieldindexnumbers(block_name);
    
    % Set irrelevant parameters so that DSP Vector Scope params don't get
    % written into Comms scope data structures
    paramIrrel = {'openScopeAtSimStart', 'FrameNumber'};
    for i=1:length(struct_names),
        if ~isfield(params,struct_names{i}) || ...
                ~isempty(strmatch(struct_names{i},paramIrrel))
            continue;
        end
        srcParam = params.(struct_names{i});
        block_data.cparams.ws.(struct_names{i}) = srcParam;
    end
    
  otherwise
    
    fig_data = get(block_data.hfig, 'UserData');
    fig_data.XAxisParamsChanged = false;
        
    % Detect change in any parameter related to X-axis or Y-axis. If change is detected, store the
    % potentially new axes limits for later use
    % Some parameters only exist for Spectrum Scope (but not for Vector Scope), hence first
    % check that the block_data.params has that particular field before accessing it.
    if ( (block_data.params.XLimit ~= params.XLimit) || ...
         (~isempty(block_data.params.XMin) && ~isempty(params.XMin) && ...
          (block_data.params.XMin ~= params.XMin)) || ...
         (~isempty(block_data.params.XMax) && ~isempty(params.XMax) && ...
          (block_data.params.XMax ~= params.XMax)) || ...
         (isfield(block_data.params, 'XRange')   && block_data.params.XRange ~= params.XRange) || ...
         (isfield(block_data.params, 'XUnits')   && block_data.params.XUnits ~= params.XUnits) || ...
         (isfield(block_data.params, 'XDisplay') && block_data.params.XDisplay ~= params.XDisplay) )
        
        fig_data.zoomedXLimits            = [params.XMin params.XMax];
        fig_data.XAxisParamsChanged = true;
        
    end

    if (block_data.params.YMin ~= params.YMin) || (block_data.params.YMax ~= params.YMax)
        fig_data.zoomedYLimits = [params.YMin params.YMax];
    end
        
    set(block_data.hfig, 'UserData', fig_data);
    
    block_data.params = params;

    % Cache the appropriate line-update function
    % If HorizSpan, NChans, or Domain changed, this will need updating:
    block_data.UpdateLinesFcn = select_UpdateLinesFcn(block_fscope, block_data);
end

%following code are for G249759 fix
if (nargin < 2) && (block_type == 0)
    if isfield(block_data.params,'Domain') 
        if (block_data.params.Domain==2),        
            % Frequency Domain conversion
            
            if isfield(block_data.params,'SpectrumScope')
                
                % Rotate and convert data, as needed, only if line has enough data
                if ~strcmpi(get_param(bdroot(block_name), 'SimulationStatus'), 'initializing')
                    
                    % Rotate data for two-sided spectrum (i.e. (-Fn, Fn])
                    if (block_data.params.XRange == 2 && orig_samples_per_frame > 2)
                        % Rotate each channel of data: 
                        % no need to re-scaling here as original u contains two-sided spectrum
                        
                        u = computeTwoSidedSpectrum(u, orig_samples_per_frame);
                        
                    elseif (block_data.params.XRange == 1 && orig_samples_per_frame > 2)
                        % one-sided spectrum - fold data. 
                        % First verify input complexity. If input is complex, but simulation has been
                        % stopped, just return without making any changes. Erroring out at runtime.
                        
                        if (block_data.params.SpectrumScope.isInputComplex == 1)
                            simStatus = get_param(bdroot(block_name), 'SimulationStatus');
                            if any(strcmpi(simStatus, {'running', 'paused'}))
                                error(message('dsp:sdspfscope2:invalidBlkInput1'));
                            elseif strcmpi(simStatus, 'stopped')
                                return;
                            end
                        end
                        
                        if mod(orig_samples_per_frame,2)
                            % odd FFT length
                            p = (orig_samples_per_frame+1)/2;
                        else
                            % even FFT length
                            p = orig_samples_per_frame/2;
                        end
        
                        if any(block_data.params.YUnits == (3:6)) && ...
                                (oldYUnits == block_data.params.YUnits) 
                            u(2:p,:) = u(2:p,:) + 10*log10(2);
                        else
                            u(2:p,:) = 2.*u(2:p,:);
                        end
                        
                        if mod(orig_samples_per_frame,2)
                            % odd FFT length
                            u = u(1:p,:);
                        else
                            % even FFT length
                            u = u(1:p+1,:);
                        end
                        
                    end

                    % Convert from linear to dB, if required:
                    % If the old and new YUnits (Spectrum type) is same, no need to do the conversion as
                    % the "u" received here has correct value. It was not converted to linear (from dB)
                    % as mentioned in EXCEPTION above.
                    if any(block_data.params.YUnits == (3:6)) && ...
                        (oldYUnits ~= block_data.params.YUnits) 
                        u = lin2dB(u);
                        if (any(block_data.params.YUnits==[5 6]))
                            % convert dBW to dBm
                            u = u + 30;
                        end        
                    end
                    
                end % if (length(u) ...
                
            else % Vector Scope -> Frequency domain
                
                % Rotate data if display range is [-Fn, Fn]:
                if (block_data.params.XRange == 2 && orig_samples_per_frame > 1) ,
                    % Rotate each channel of data: 
                    % following two lines can be replaced by 1D FFT shift u=fftshift(u);
                    p = orig_samples_per_frame/2;  % all FFTs are a power of 2 here
                    u = u([p+1:orig_samples_per_frame 1:p],:);
                end
                % Convert from linear to dB, if required:
                if (block_data.params.YUnits == 2) && (oldYUnits ~= 2)
                    u = lin2dB(u);
                end
                
            end % if Spectrum Scope

            % yData length may have changed due to conversion between one-sided and 
            % two-sided spectrum for Spectrum Scope. So re-create xData
            % We can make up any xdata, as long as it has the right length,
            % since setup_axes will correct the values:
            xData = (1:size(u,1))';
            [~, nchans] = size(u);
            if nchans == 1
                % one Channel
                set(block_data.hline, 'XData', xData, 'YData', u); 
            else
                % multi-Channel
                hline = block_data.hline;
                for i = 1:nchans, % block_data.NChans
                    set(hline(i), 'XData', xData, 'YData', u(:,i));
                end
            end %%  if nchans == 1
            
        end % if Freq Domain
    end    % if isfield(block_data.params,'Domain') 
end % outer 'if' statement

set_param(block_name, 'UserData', block_data);

% Adjust the GUI axes, line styles, etc,
setup_axes(block_name);
switch block_type,
    case 1,
        if block_data.cparams.ws.dispDiagram == 2 && length(block_data.haxis) == 2
            setup_axes(block_name,block_data.cparams.ws.dispDiagram);
        end
end

% ---------------------------------------------------------------
function setup_axes(block_name,axIdx)
% Setup scope x- and y-axes

% default value for index
if nargin < 2,
    axIdx = 1;
end

% Does not alter block_data
% u = input data, one frame of data

block_data = get_param(block_name,'UserData');
hfig    = block_data.hfig;
hax     = block_data.haxis(axIdx);
hline   = block_data.hline(:,axIdx);
hstem   = block_data.hstem;
nframes = block_data.params.HorizSpan;
samples_per_channel = block_data.samples_per_frame;

% Clear memory (persistence):
% ---------------------------
FigRefresh([],[],block_data.hfig);

% Assign line colors and styles:
% ------------------------------
stem_rgb = 'k';  % in case no lines use stem plots

count = length(hline);

block_type = getfromancestor(block_name,'block_type_',2);
switch block_type,
    case 1,
        for i=1:count,
            rgb        = getDialogLineColor(block_name, i);
            style      = getDialogLineStyle(block_name, i);
            marker     = getDialogLineMarker(block_name, i);
            disable    = getDialogLineDisable(block_name, i);
            markerface = 'auto'; % rgb;

            set(hline(i), ...
                'Color', rgb, ...
                'linestyle', style, ...
                'Visible', disable, ...
                'Marker', marker, ...
                'MarkerFaceColor',markerface);
        end
    case 3,
        for i=1:count,
            rgb        = getDialogLineColor(block_name, i);
            style      = getDialogLineStyle(block_name, i);
            disable    = getDialogLineDisable(block_name, i);
            markerface = 'auto'; % rgb;

            set(hline(i), ...
                'Color', rgb, ...
                'linestyle', style, ...
                'Visible', disable, ...
                'MarkerFaceColor',markerface);
        end
    otherwise,
        for i=1:count,
            rgb        = getDialogLineColor(block_name, i);
            style      = getDialogLineStyle(block_name, i);
            marker     = getDialogLineMarker(block_name, i);
            disable    = getDialogLineDisable(block_name, i);
            markerface = 'auto'; % rgb;

            % There is only one set of stem lines, so we need to deduce
            % which line color/style to set it to.  We could use multiple
            % stem lines, but that seems like it would use significantly
            % more time/memory without much improvement.
            % marker2{i}=marker;
            if strcmp(marker,'stem'),
                % Set stem line style
                % If style is 'none', use solid:
                if strcmpi(style, 'none')
                    style='-';
                end
                if strcmp(disable,'off'), %<-----------------------------NEW LINE ADDED(1)
                    style='none';         %<-----------------------------NEW LINE ADDED(2)
                end                       %<-----------------------------NEW LINE ADDED(3)
                set(hstem,'linestyle',style);
                stem_rgb = rgb;  % use the "last" stem color

                % Reset some properties for stem markers:
                style='none';
                marker='o';
            end
            try
                set(hline(i), ...
                    'Color', rgb, ...
                    'linestyle', style, ...
                    'Visible', disable, ...
                    'Marker', marker, ...
                    'MarkerFaceColor',markerface);
            catch %#ok
                error(message('dsp:sdspfscope2:unhandledCase2'));
            end
        end
end


% Setup vertical stem lines:
if anyStemMarkers(block_name),
    stemVis='on';
else
    stemVis='off';
end
set(hstem, ...
    'color',     stem_rgb, ...
    'visible',   stemVis, ...
    'marker',    'none');

% Determine x-axis limits:
% ------------------------
switch block_data.params.Domain
    case 1
        % Time-domain:

        if block_data.Ts<0,
            % Triggered:
            ts = 1;
            xLabel = 'Trigger events (samples)';
        else
            ts = block_data.Ts;
            xLabel = 'Time (s)';
        end

        %	xData  = (0:samples_per_channel*nframes-1)' * ts;
        if (samples_per_channel==1) && (nframes==1)
            xData  = (0:samples_per_channel*nframes-1)' * ts;
            xLimits = [-ts ts];  % prevent problems
        else
            switch getfromancestor(block_name,'block_type_',2),
                case 1,
                    symbPerTrace = block_data.cparams.ws.symbPerTrace;
                    numTraces = block_data.cparams.ws.numTraces;
                    numNewFrames = block_data.cparams.ws.numNewFrames;

                    xData1  = (0:samples_per_channel)' * symbPerTrace * ts;
                    xData = xData1 ./ (numNewFrames + (symbPerTrace-1) * numTraces);
                    xLimits = [0 xData(end)];
                    xData = repmat([xData; NaN],block_data.comm.tracesPerLine,1);
                otherwise,
                    xData  = (0:samples_per_channel*nframes-1)' * ts;
                    xLimits = [-ts xData(end)+ts];
            end
        end

    case 2
        % Frequency domain:

        % Disregard # horiz frames (nframes) for freq domain
        % sample time can be inherited, but is usually overridden by user
        if isOn(block_data.params.InheritXIncr),
            % Inherited sample rate:
            if block_data.Ts==-1,
                Fs = samples_per_channel;  % unusual, but we'll allow it

            else
                % This is either the Spectrum Scope, or the Vector Scope
                % set to the Freq domain.
                %
                % We may have a buffer of data here, due to:
                %  - an inherited frame, or
                %  - explicit buffering parameters
                %
                % NOTE: .Ts is the per-frame time, not per-sample time

                Fs = 1 ./ block_data.Ts;  % sample rate
            end
        else
            % User-defined sample time for frequency domain:
            Fs = 1 ./ block_data.params.XIncr;  % sample rate
        end

        Fn = Fs/2;  % Nyquist rate

        xData = (0 : samples_per_channel-1)' .* Fs ./ samples_per_channel;

        switch block_data.params.XRange
            case 1,
                xLimits = [0 Fn];
                if isfield(block_data.params,'SpectrumScope')
                    xData = (0 : samples_per_channel/2)' .* Fs ./ samples_per_channel;
                end                
            case 2,
                xLimits = [-Fn Fn];
                if isfield(block_data.params,'SpectrumScope')
                     % For Spectrum Scope, the two-sided range is (-Fs/2,Fs/2] - (-Fs/2) 
                     % frequency point is NOT included. This change was made in R2009b.
                    xData = (1:samples_per_channel)' .* Fs ./ samples_per_channel - Fn;                    
                else % Spectrum Scope
                    xData = (0:samples_per_channel-1)' .* Fs ./ samples_per_channel - Fn;
                end                
            otherwise,
                xLimits = [0 Fs];
        end
        
        if block_data.params.XUnits == 1,
            xLabel  = 'Frequency (Hz)';
        else
            xLabel  = 'Frequency (rad/s)';
            xLimits = 2*pi * xLimits;
            xData   = 2*pi * xData;
        end

        if isfield(block_data.params, 'XDisplay')       % Spectrum scope has a "Frequency display offset:" field,
            f1 =  block_data.params.XDisplay;           % which sets the XDisplay field for the spectrum scope.
        else                                            % In R2008a: Vector scope does not have X display offset for 
            f1 = 0;                                     % frequency domains: to be implemented later in a later release.
        end
    otherwise
        % User-defined

        % Determine sample increment if inherited:
        if isOn(block_data.params.InheritXIncr),
            if block_data.Ts==-1,  % triggered system?
                incr = 1; % unusual, but we'll allow it
            else
                incr = block_data.Ts;
            end
        else
            incr = block_data.params.XIncr;
        end

        xLabel = block_data.params.XLabel;
        if ~ischar(xLabel), xLabel = 'X-Axis'; end
        
        % auto X (inherited sample) increment
        xData  = (0:samples_per_channel*nframes-1)' * incr;
        
        % user defined sample increment
        if ~isOn(block_data.params.InheritXIncr)
            if isfield(block_data.params, 'XStart')  % user defined X Display offset
             %xData = (block_data.params.XStart:block_data.params.XStart + samples_per_channel*nframes -1)'*incr;
                % g408913: Fixing the equation in the above line of code
                xData = (block_data.params.XStart:incr:block_data.params.XStart + incr*(samples_per_channel*nframes -1))';
            end
        end
        
        switch getfromancestor(block_name,'block_type_',2),
            case 3,
                xLimits = [block_data.cparams.ws.xMin ...
                    block_data.cparams.ws.xMax];
            otherwise,
                if (samples_per_channel==1) && (nframes==1)
                    xLimits = [-incr incr];  % prevent problems
                else
                    xLimits = [-incr xData(end)+incr]; 
                    
                    if isfield(block_data.params, 'XLimit')  % user defined x limit
                       if block_data.params.XLimit == 2 
                           xLimits = [block_data.params.XMin, block_data.params.XMax];
                       else 
                           if ~isOn(block_data.params.InheritXIncr) % recal xlimit 
                            % xLimits = [block_data.params.XStart block_data.params.XStart+samples_per_channel*nframes-1]*incr;
                            % g408913: Fixing the equation in the above line of code
                            xLimits = [block_data.params.XStart block_data.params.XStart+(samples_per_channel*nframes-1)*incr];
                           end
                       end
                    end
                end
        end

end

% Adjust x-axes for engineering units:
% ------------------------------------
% Allow scalar
if xLimits(2)==0,
    xLimits=[0 1];
elseif (xLimits(1) > xLimits(2)),
    warning(message('dsp:sdspfscope2:invalidFigureParameterReverse', block_name));
    xLimits(1:2)=xLimits([2 1]);
end
set(hax,'xLim',xLimits);  % preliminary gridding of limits

% Don't adjust the user-defined domain:
if (block_data.params.Domain ~= 3),

    if isfield(block_data.params, 'XLimit')  && (block_data.params.XLimit == 2)
        % 'Time/Frequency display limits' = 'User-defined'
        xlim = [block_data.params.XMin, block_data.params.XMax];
    else
        xlim = get(hax,'xlim');
    end   

    if block_data.params.Domain==1,

        % engunits will use us/ms, and s/mins/hrs where applicable
        [~,xunits_exp,xunits_prefix] = engunits(max(abs(xlim)),'latex','time');
        % When engunits function is modified to return 'secs' instead of 's'
        % delete the following line.
        if strcmp(xunits_prefix,'secs'), xunits_prefix = 's'; end
    
    elseif block_data.params.Domain==2

        % offset X data and X limits according to the value obtained from the 
        % "Frequency display offset:" and "X display offset" fields respectively. 
        % However, note that in R2008a, f1=0 for vector scope as "X display offset" 
        % has not been added to vector scope for frequency domains.
        xData = xData + f1;
        
        if ~(isfield(block_data.params, 'XLimit') && (block_data.params.XLimit == 2))
            % ONLY add 'Frequency display offset' param value to xlim if 
            % 'Frequency display limits' ~= 'User-defined'
            xlim  = xlim + f1; 
        end
        
        [~,xunits_exp,xunits_prefix] = engunits(max(abs(xlim)),'latex','freq');
            
    end

    if all(block_type ~= [1 3])
        % Vector/Spectrum Scope
        
        fig_data = get(hfig, 'UserData');

        if ( fig_data.zoomActivated && (fig_data.zoomedScalingFactor ~= xunits_exp) && ...
             ~fig_data.XAxisParamsChanged )
            xunits_exp    = fig_data.zoomedScalingFactor;
            xunits_prefix = fig_data.zoomedPrefix;
        else
            % store xunits_exp & xunits_prefix for later use
            fig_data.zoomedScalingFactor = xunits_exp;
            fig_data.zoomedPrefix        = xunits_prefix;
            
        end
        if fig_data.XAxisParamsChanged
            fig_data.zoomedXLimits = fig_data.zoomedXLimits .* fig_data.zoomedScalingFactor;
        end
        set(hfig, 'UserData', fig_data);
        
    end    
    
    xData = xData .* xunits_exp;
    xlim  = xlim .* xunits_exp;
    
    set(hax, 'xlim', xlim);    
    
end

% Setup X-axis label:
% -------------------
% Don't modify user-defined domain:
if block_data.params.Domain == 2,
    % Freq - insert units only  'Freq (Hz)' => 'Freq (kHz)'
    i = find(xLabel=='(');
    s = [xLabel(1:i) xunits_prefix xLabel(i+1:end)];
    xLabel = s;
elseif block_data.params.Domain==1,
    % Time - remove everything between parens  'Horiz (s)' => 'Horiz (days)'
    i = find(xLabel=='('); j = find(xLabel==')');
    s = [xLabel(1:i) xunits_prefix xLabel(j:end)];
    xLabel = s;
end

hxLabel = get(hax, 'XLabel');


% Setup Y-axis label and limits:
% ------------------------------
yLabel = block_data.params.YLabel;

if ~ischar(yLabel), yLabel='Y-Axis'; end
hyLabel = get(hax,'YLabel');
block_type = getfromancestor(block_name,'block_type_',2);

switch block_type
    
  case 1
    
    if axIdx == 2,
        set(hyLabel, 'String', block_data.cparams.ws.quadratureLabel);
    else
        set(hyLabel, 'String', block_data.cparams.ws.inphaseLabel);
    end
    yLimits = [block_data.cparams.ws.yMin block_data.cparams.ws.yMax];
    set(hax(:), 'ylimmode','manual', 'ylim',yLimits, 'xlimmode', 'manual', ...
                'climmode', 'manual', 'zlimmode', 'manual', 'alimmode', 'manual');

    xLen=length(xData);
    uNaN = NaN;
    for i=1:length(hline),
        yData = get(hline(i),'YData')';
        % Manufacture the right yData if default is present:
        if length(yData) ~= xLen,
            yData = uNaN(ones(xLen,1));
        end
        set(hline(i),'XData',xData, 'YData',yData);
    end
    set(hxLabel, 'String', xLabel);
  
  case 3
    
    yLimits = [block_data.cparams.ws.yMin block_data.cparams.ws.yMax];
    set(hyLabel, 'String', block_data.cparams.ws.quadratureLabel);
    set(hax, 'xlimmode', 'manual', 'ylimmode', 'manual', 'zlimmode', 'manual',...
             'climmode', 'manual', 'alimmode', 'manual', 'ylim',yLimits);
    set(hxLabel, 'String', block_data.cparams.ws.inphaseLabel);
    
  otherwise
    
    set(hyLabel, 'String', yLabel);

    % if zoom is in use or zoom activated and none of the X-axis related parameters have changed, 
    % maintain the current view of the axis
    fig_data = get(hfig,'UserData');
    if (fig_data.zoomInUse || fig_data.zoomActivated) && ~fig_data.XAxisParamsChanged
        set(hax, 'xlimmode', 'manual', 'ylimmode', 'manual', 'zlimmode', 'manual',  ...
                 'climmode', 'manual', 'alimmode', 'manual', 'xlim', fig_data.zoomedXLimits, ...
                 'ylim', fig_data.zoomedYLimits);
    else
        
        if isfield(block_data.params,'SpectrumScope') && (block_data.params.SpectrumScope.scaleYAxis == 1)
            % Need to scale Y-axis limits due to change in Spectrum Scope output in R2009b
            
            if (any(block_data.params.YUnits==(3:6)))
                FsIndBScale = lin2dB(Fs);
                
                % No need to convert to dBm as dBm options were added in R2009b. For a model 
                % created in R2009a (or previous release) and never saved in R20099b, 
                % YUnits = dBm (or dBm/Hertz) would never happen!!
                
                % Subtraction in log domain is equivalent to division in linear domain
                yLimits = [block_data.params.YMin block_data.params.YMax] - FsIndBScale;
            else
                yLimits = [block_data.params.YMin block_data.params.YMax] ./ Fs;
            end   
            % Update block parameters with new Y-axis limits. Need to update YUnits (Spectrum units)
            % parameter too so as to indicate that this Y-axis range scaling is not needed anymore.
            % Note that in mask initialization function, YUnits is converted from 7 (Magnitude-squared)
            % to 1 (Watts/Hertz) and 8 (dB) to 3 (dB/Hertz) - hence look for these new values here. As
            % scaleYAxis == 1 (because of which we are here), the new values imply that YUnits had
            % old values to begin with.
            if block_data.params.YUnits == 1
                YUnits = 'Watts/Hertz';
            elseif block_data.params.YUnits == 3
                YUnits = 'dBW/Hertz';
            end
            set_param(block_name, 'YUnits', YUnits, 'YMin', num2str(yLimits(1)), 'YMax', num2str(yLimits(2)));
            block_data.params.YMin = yLimits(1);
            block_data.params.YMax = yLimits(2);

        else
            yLimits = [block_data.params.YMin block_data.params.YMax];
        end
        
        set(hax, 'xlimmode', 'manual', 'ylimmode', 'manual', 'zlimmode', 'manual', ...
                 'climmode', 'manual', 'alimmode', 'manual', ...
                 'ylim', yLimits);

        if ~fig_data.zoomActivated
            % if zoom is activated, do not update the original scaling factor
            fig_data.originalScalingFactor = fig_data.zoomedScalingFactor;
        end

        set(hfig,'UserData',fig_data);
    end

    % Setup line data:
    % ----------------
    % Don't draw anything, so use NaN's for Y-data.
    % Can use vectorized set since all x/y data are identical.
    %
    % NOTE: update_lines() does NOT alter/update the x-data,
    %       so it needs to be set up once here, correctly.
    %       The y-data is not significant ... just needs to be
    %       sized appropriately:

    xLen=length(xData);
    uNaN = NaN;
    for i=1:length(hline),
        yData = get(hline(i),'YData')';
        % Manufacture the right yData if default is present:            
        if length(yData) ~= xLen,      
            yData = uNaN(ones(xLen,1));
        end
        set(hline(i),'XData',xData, 'YData',yData);
    end
    set(hxLabel, 'String', xLabel);
end

% Setup "stem" line data:
% -----------------------
% Stems are implemented as a SECOND line
% The usual data plotting occurs, but with a circle ('o')
%   substituted for the marker.
% In addition, a second line is set up for the vertical
%   stems themselves.
%
% We only need to set up ONE stem line.
% The vertical extent will reach to the "highest" point
%   at each sample time, effectively providing a stem for
%   *all* data channels at one time.
%
% Vertical stem data:
%
%    [x1 x1 x1   x2 x2 x2   x3 x3 x3  ....]
%    [0  y1 NaN  0  y2 NaN  0  y3 NaN ...]

xstem = [xData';xData';xData'];
xstem = xstem(:)'; % triplicate each value
ymin = 0;  % stems originate from y=0, not block_data.params.YMin
ystem = [ymin;0;NaN];  % assume y values are 0 for now
ystem = ystem(:,ones(size(xData)));
ystem = ystem(:)';
set(hstem, 'xdata', xstem, 'ydata', ystem);
if strcmp(get(block_data.hstem,'vis'),'on')
    update_lines(block_data, yData);
end
% instead of the above line use the following piece of code
% to get vertical lines for stem plot(but the following piece of code needs
% to be modified for freq/time 1ch/multiCh 1fr/multiFrame cases

% see line 2850 for 'marker2{i}=marker;'
% set(hstem, 'xdata', xstem);
% for i=1:count
%     if strcmp(marker2{i},'stem'),
%         uu=get(hline(i),'ydata');
%         nrows = length(uu);
%         ystem((0:nrows-1)*3 + 2) = uu;
%     end
%     set(hstem, 'ydata', ystem);
% end

% Perform AxisZoom:
% -----------------
%
% Put axis into correct zoom state:
fig_data = get(hfig,'UserData');
if strcmp(block_data.params.AxisZoom,'off'),
    % Turn off AxisZoom:
    % - turn on menus
    set(fig_data.menu.top,'vis','on');
    % - reset axis position
    zoomVar = fig_data.main.axiszoom.off{axIdx};
else
    % Turn on AxisZoom:
    % - turn off top-level menus
    set(fig_data.menu.top,'vis','off');
    zoomVar = fig_data.main.axiszoom.on{axIdx};
end
set(hax, 'units', 'normalized', 'outerposition', [0 0 1 1]);
set(hax, zoomVar{:});

% Turn on scalar warning message, if appropriate:
% ------------------------------
isScalarPlot = (samples_per_channel==1) & (nframes==1);
if isScalarPlot,
    if block_data.params.Domain==2,
        colTitle = 'b';
        tstr='[Plotting single points - consider using a vector input]';
    else
        switch getfromancestor(block_name,'block_type_',1),
            case {'xy','eye'},
                colTitle = 'k';
                tstr=block_data.cparams.str.figTitle;
            otherwise,
                colTitle = 'b';
                tstr='[Plotting single points - consider increasing the display span]';
        end
    end
else
    switch getfromancestor(block_name,'block_type_',1),
        case {'xy','eye'},
            colTitle = 'k';
            tstr=block_data.cparams.str.figTitle;
        otherwise,
            colTitle = 'b';
            tstr='';
    end
end
if axIdx == 1
    if isfield(block_data.params,'SpectrumScope')
        % Spectrum Scope
        % avoid overwriting existing title, add to it.
        currentTitle = get(get(hax,'Title'), 'String');
        tmpTStr = '[Plotting single points - consider using a vector input]';
        if ~isempty(currentTitle) && isempty(strfind(currentTitle, tstr)) ...
                && ~strcmpi(currentTitle, tmpTStr)
            tstr = sprintf('%s %s', tstr, currentTitle);
        end
    end
    set(get(hax,'Title'), 'String', tstr, 'color',colTitle);
end

% Update Frame Number display:
% ----------------------------
%
switch block_type,
    case {1,3},
        frameNumber = block_data.cparams.ws.FrameNumber;
    otherwise
        frameNumber = block_data.params.FrameNumber;
end
if isOn(frameNumber)
    % Move frame # text depending on axis zoom (on or off)
    % The frame handle vector contains:
    %   .hframenum(1) = "Frame:"
    %   .hframenum(2) = "###"
    % NOTE: Position of frame readout is updated in figresize
    %
    if isOn(block_data.params.AxisZoom),
        % Axis zoom on - x-axis is not visible
        ltgrayt = ones(1,3)*.6;  % slightly darker for grid labels
        set(block_data.hframenum, ...
            'verticalalignment','bottom', ...
            'color',ltgrayt, 'vis','on');
    else
        % Axis zoom off - x-axis is visible
        set(block_data.hframenum, ...
            'verticalalignment','cap', ...
            'color','k', 'vis','on');
    end
else
    set(block_data.hframenum,'vis','off');
end

% Update line erase mode (Persistence) when using Graphics Version 1
if matlab.graphics.internal.isGraphicsVersion1
    startLineEraseMode(block_name);
end

UpdateLegend(block_name);

% Manually call the resize fcn:
FigResize([],[],hfig);


% ---------------------------------------------------------------
function UpdateLegend(blk)

switch getfromancestor(blk,'block_type_',2),
    case {1,3},
    otherwise
        block_data = get_param(blk,'UserData');
        hlegend    = block_data.hlegend;
        useLegend  = isOn(block_data.params.AxisLegend);

        if ishghandle(hlegend),
            delete(hlegend);
        end
        hlegend = [];

        if useLegend,
            hlines = block_data.hline;

            % Get signal names:
            names = getInputSignalNames(blk);

            % Prevent failures in legend:
            prop = 'ShowHiddenHandles';
            old_state = get(0,prop);
            set(0,prop,'on');
            axes(block_data.haxis); %#ok
            hlegend = legend(hlines, names{:});
            % hlegend = legend(block_data.haxis, hlines, str{:});
            set(0,prop,old_state);
        end

        % Store changes to legend handle:
        block_data.hlegend = hlegend;
        set_param(blk,'UserData',block_data);

end
% ---------------------------------------------------------------
function UpdateFrameNumPos(blk,numAxes)

if nargin < 2,
    numAxes = 1;
end

block_data = get_param(blk,'UserData');

switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        frameNumber = block_data.cparams.ws.FrameNumber;
    otherwise
        frameNumber = block_data.params.FrameNumber;
end

if isOn(frameNumber),
    if isOn(block_data.params.AxisZoom),
        % Axis zoom on - x-axis is not visible
        %
        % Position "Frame: #" text above the x-axis tick numbers
        % and to the right of the y-axis tick numbers
        %
        hgridtxt = block_data.hgridtext;
        grid_ext = get(hgridtxt(1),'extent');
        ypos     = grid_ext(2)+grid_ext(4);
        grid_ext = get(hgridtxt(end),'extent');
        xpos     = grid_ext(1)+grid_ext(3);

        set(block_data.hframenum(1), ...
            'units','data', 'pos',[xpos ypos]);
        ex=get(block_data.hframenum(1),'extent');
        set(block_data.hframenum(2), ...
            'units','data', 'pos',[ex(1)+ex(3) ypos]);
    else
        % Axis zoom off - x-axis is visible
        %
        % Position "Frame: #" at the same y-level as the x-axis label
        % and flush with the start of the x-axis.
        hax = block_data.haxis;
        hxtitle = get(hax(numAxes),'xlabel');
        set(hxtitle','units','data');
        xtpos = get(hxtitle,'pos');
        xlim = get(hax(numAxes),'xlim');
        set(block_data.hframenum(1), 'units','data', ...
            'pos',[xlim(1) xtpos(2)]);
        ex=get(block_data.hframenum(1),'extent');
        frpos = [ex(1)+ex(3) xtpos(2)];

        set(block_data.hframenum(2), 'units','data', ...
            'pos',frpos);

        % If xlabel overlaps frame label, turn off frame label:
        xtitle_ex = get(hxtitle,'extent');
        fr_ex = get(block_data.hframenum(2),'extent');
        overlap = xtitle_ex(1) < (fr_ex(1)+fr_ex(3));
        if overlap, vis='off'; else vis='on'; end
        set(block_data.hframenum,'vis',vis);
    end
end


% ---------------------------------------------------------------
function FigResize(hcbNotUsed, eventStructNotUsed, hfig) %#ok
% Callback from window resize function

if nargin<3, hfig = gcbf; end
fig_data = get(hfig,'UserData');
if isempty(fig_data), return; end

blk = fig_data.block;
block_data = get_param(blk,'UserData');
block_type = getfromancestor(blk,'block_type_',2);

%disp('In FigResize')
switch block_type,
    case 1,
        %     switch getfromancestor(blk,'dispDiagram'),
        %     case 'In-phase Only',
        DispDiagram = block_data.cparams.str.dispDiagram;
        size(block_data.haxis,2);
        switch size(block_data.haxis,2),
            case 1,
                % Processing just like the vector scope
                if strcmp(DispDiagram,'In-phase Only'),
                    % Resize the axis when not in "compact display" (axis zoom) mode:
                    if ~isOn(block_data.params.AxisZoom)
                        fig_pos = get(hfig,'pos');
                        ax_pos = [60 40 max([1 1], fig_pos([3 4])-[80 60])];
                        set(block_data.haxis(1), 'pos',ax_pos);  
                    end
                end
                UpdateGrid(blk);  % Do this prior to repositioning frame # text
                UpdateFrameNumPos(blk);
            case 2,
                % Processing for two axes for I + Q eye diagram
                if strcmp(DispDiagram,'In-phase and Quadrature'),
                    % Resize the axis when not in "compact display" (axis zoom) mode:
                    if ~isOn(block_data.params.AxisZoom),
                        fig_pos = get(hfig,'pos');
                        a1_pos = [60 (40+fig_pos(4)/2) [max(1, fig_pos(3)-80), max(1,fig_pos(4)/2-65)]];
                        a2_pos = [60 40 [max(1, fig_pos(3)-80), max(1,fig_pos(4)/2-65)]];
                        set(block_data.haxis(1), 'pos',a1_pos);
                        set(block_data.haxis(2), 'pos',a2_pos);
                    end
                end
                UpdateGrid(blk);  % Do this prior to repositioning frame # text
                UpdateGrid(blk,2);  % Do this prior to repositioning frame # text
                UpdateFrameNumPos(blk,2);
            otherwise,
        end
    case 3
        % Resize the axis when not in "compact display" (axis zoom) mode:
        if ~isOn(block_data.params.AxisZoom),     
            set(block_data.haxis(1), 'units', 'normalized', 'outerposition', [0 0 1 1]);
        end
        UpdateGrid(blk);  % Do this prior to repositioning frame # text
        UpdateFrameNumPos(blk);
    otherwise
        % Resize the axis when not in "compact display" (axis zoom) mode:
        if ~isOn(block_data.params.AxisZoom),
            fig_pos = get(hfig,'pos');
            % Leave 40 pixels at the bottom & 20 pixels at the top to ensure that 
            % the frame counter at the bottom and the amplitude value (e.g. 10^6) 
            % at the top are not chopped off even when the figure is resized to a 
            % small size.
            ax_pos = [60 40 max([1 1], fig_pos([3 4])-[80 60])];
            set(block_data.haxis, 'pos',ax_pos);
        end

        UpdateGrid(blk);  % Do this prior to repositioning frame # text
        UpdateFrameNumPos(blk);

        % Update legend, if it is on:
        if isOn(block_data.params.AxisLegend),
            %legend('ResizeLegend', block_data.haxis);
            legend(block_data.haxis, 'ResizeLegend');
        end
end

% ---------------------------------------------------------------
function [fig_data, comm] = create_scope(block_name, params, nchans, tempFigPos)
% CREATE_SCOPE Create new scope GUI

% Initialize empty settings:
fig_data.main  = [];  % until we move things here
fig_data.menu  = [];

block_data = get_param(block_name,'userdata');
block_type = getfromancestor(block_name,'block_type_',2);
switch block_type,
    case 1,
        parent   = get_param(block_name,'parent');
        fig_name = parent;
        iotype   = get_param(parent,'iotype');
        if strcmp(iotype,'viewer')
            fig_name = viewertitle(parent,false);
        end

        if (nargin) >= 4 && ~isempty(tempFigPos)
            params.FigPos = tempFigPos;
        else
            params.FigPos = block_data.cparams.ws.FigPos;
        end
        switch block_data.cparams.str.dispDiagram,
            case 'In-phase Only',
                numAxes = 1;
                posAxes = [0.155 0.1350 0.7800 0.8000];
            case 'In-phase and Quadrature',
                numAxes = 2;
                posAxes = [0.155 0.5960 0.7800 (0.8000-0.45); ...
                    0.155 0.1380 0.7800 (0.8000-0.45)];
            otherwise,
        end
        % set up rendering quality mode
        if block_data.cparams.ws.render,
            block_data.comm.emode = 'normal';
            block_data.comm.renderer = 'zbuffer';
        else
            block_data.comm.emode = 'xor';
            block_data.comm.renderer = 'painters';
        end
        comm = block_data.comm;

    case 3,
        parent   = get_param(block_name,'parent');
        fig_name = parent;
        iotype   = get_param(parent,'iotype');
        if strcmp(iotype,'viewer')
            fig_name = viewertitle(parent,false);
        end

        numAxes = 1;
        posAxes = [0.1300 0.1450 0.7800 0.8000];
        if (nargin) >= 4 && ~isempty(tempFigPos)
            params.FigPos = tempFigPos;
        else
            params.FigPos = block_data.cparams.ws.FigPos;
        end
        % set up rendering quality mode
        if block_data.cparams.ws.render,
            block_data.comm.emode = 'normal';
            block_data.comm.renderer = 'zbuffer';
        else
            block_data.comm.emode = 'xor';
            block_data.comm.renderer = 'painters';
        end
        comm = block_data.comm;
    otherwise,
        numAxes = 1;
        posAxes = [0.1 0.1 0.87 0.85];
        fig_name = block_name;
        iotype   = get_param(block_name,'iotype');
        if strcmp(iotype,'viewer')
            fig_name = viewertitle(block_name,false);
        end
end

hfig = figure('numbertitle', 'off', ...
    'name',              fig_name, ...
    'menubar',           'none', ...
    'nextplot',          'add', ...
    'position',          params.FigPos, ...
    'integerhandle',     'off', ...
    'PaperPositionMode', 'auto', ...
    'ResizeFcn',         @FigResize, ...
    'HandleVisibility', 'callback', ...
    'DeleteFcn',         @FigDelete,...
    'CloseRequestFcn',   @FigClose);

setappdata(hfig, 'IgnoreCloseAll', 1);

hax = zeros(1, numAxes);
hgrid = zeros(1, numAxes);

for count = 1:numAxes,
    hax(count) = axes('Parent',hfig, ...
        'Position', posAxes(count,:), ...
        'Box','on','FontSize',9);

    % Set up line for each channel:
    switch block_type
        case 1,
            wsVars = block_data.cparams.ws;

            if wsVars.fading == 1,
                comm.tracesPerLine = ceil(wsVars.numTraces / wsVars.numLinesMax);
                comm.numLines = ceil(wsVars.numTraces / comm.tracesPerLine);
            else
                comm.tracesPerLine = wsVars.numTraces;
                comm.numLines = 1;
            end
            comm.tracesPerLastLine = wsVars.numTraces - (comm.numLines - 1) ...
                * comm.tracesPerLine;

            numLines = comm.numLines;

            % update block data
            set_param(block_name,'userdata',block_data);
        case 3,
            wsVars = block_data.cparams.ws;

            if wsVars.fading == 1,
                comm.tracesPerLine = ceil(wsVars.numTraces / wsVars.numLinesMax);
                comm.numLines = ceil(wsVars.numTraces / comm.tracesPerLine);
            else
                comm.tracesPerLine = wsVars.numTraces;
                comm.numLines = 1;
            end
            comm.tracesPerLastLine = wsVars.numTraces - (comm.numLines - 1) ...
                * comm.tracesPerLine;

            numLines = comm.numLines;

            % update block data
            set_param(block_name,'userdata',block_data);
        otherwise,
            numLines = nchans;
    end

    % create grid before creating signal lines to avoid G607268
    hstem = line('parent',hax(count), ...
        'xdata',NaN, 'ydata',NaN);
    hgrid(count) = line('parent',hax(count), ...
        'xdata',NaN, 'ydata',NaN, ...
        'color',[.8 .8 .8]);

    % create signal lines after creating grid to avoid G607268
    for i = 1:numLines,
        hline(i,count) = line('parent',hax(count), ...
                              'xdata',NaN, 'ydata',NaN,'LineStyle','None'); %#ok<AGROW>
    end

    % Create non-displaying line to use for color translations
    hcspec = line('parent',hax(count), ...
        'xdata',nan,'ydata',nan, ...
        'vis','off');


    % Create a context menu:
    mContext = uicontextmenu('parent',hfig);

    % Set the non-compact display axis to pixels,
    % so resizing does not affect it
    switch block_type,
        case 3,
        otherwise,
            set(hax(count),'units','pixels');
    end

    % Store settings for axis zoom:
    % Cell-array contains {params, values},
    % where params itself is a cell-array of Units and Position
    % and values is a cell-array of corresponding values.
    p = {'Units','Position'};
    fig_data.main.axiszoom.off{count} = {p, get(hax(count), p)};
    fig_data.main.axiszoom.on{count}  = {p, {'Normalized',[0 0 1 1]}};

end

% Create Frame Number text
hframenum(1) = text(0,0,'','parent',hax(count));
hframenum(2) = text(0,0,'','parent',hax(count));

% In Graphics Version 1, setting the EraseMode to xor can speed up updates
if matlab.graphics.internal.isGraphicsVersion1
    set(hframenum(1),'string',[block_data.strFrame ': '],'erase','xor','HorizontalAlignment','left');
    set(hframenum(2),'string','-','erase','xor','userdata',0,'HorizontalAlignment','left');
else
    set(hframenum(1),'string',[block_data.strFrame ': '],'HorizontalAlignment','left');
    set(hframenum(2),'string','-','userdata',0,'HorizontalAlignment','left');
end

% Establish settings for all structure fields:
fig_data.block  = block_name;
fig_data.hfig   = hfig;
fig_data.hcspec = hcspec;

% Store major settings:
fig_data.main.haxis   = hax;
fig_data.main.hline   = hline;
fig_data.main.hstem   = hstem;
fig_data.main.hgrid   = hgrid;
fig_data.main.hframenum = hframenum;
fig_data.menu.context = mContext;


% ---------------------------------------------------------
% Figure menus:
% ---------------------------------------------------------
%
% Define FILE menu:
%
if ispc
    labels = {'&File', ...
        '&Close', ...
        '&Export...', ...
        'Pa&ge Setup...', ...
        'Print Set&up...', ...
        'Print Pre&view...', ...
        '&Print...'};
else
    labels = {'File', ...
        'Close', ...
        'Export...', ...
        'Page Setup...', ...
        'Print Setup...', ...
        'Print Preview...', ...
        'Print...'};
end
%
mFile = uimenu(hfig,'Label',labels{1});
%
% submenu items:
uimenu(mFile, 'label',labels{2}, ...
    'accel','W', ...
    'callback',{@CloseFigureAndClearUpdateMtd, block_name});
%uimenu(mFile, 'label',labels{3}, ...
%    'separator','on', ...
%   'callback','filemenufcn(gcbf,''FileExport'')');
uimenu(mFile, 'label',labels{4}, ...
    'separator','on', ...
    'callback','printpreview(gcbf)');
uimenu(mFile, 'label',labels{5}, ...
    'callback','printdlg(gcbf)');
uimenu(mFile, 'label',labels{6}, ...
    'callback','printpreview(gcbf)');
uimenu(mFile, 'label',labels{7}, ...
    'accel','P', ...
    'callback','printdlg(gcbf)');

%
% Define VIEW menu & add ZOOM buttons on the menu bar  - only for Vector or 
% Spectrum scopes. NOT for Comms Scopes
%

switch block_type
    
  case {1,3}
    % Comms Scopes - do not add any menu items. Just define mView to be 
    % empty so that it can be added to the fig userData
    mView = [];
    
  otherwise,
    % Vector or Spectrum scopes
    
    if ispc
        labels = {'&View'};
    else
        labels = {'View'};
    end
    
    mView = uimenu(hfig,'Label',labels{1});
    % render menu items, related to zoom, under VIEW menu
    mZoomMenu = render_zoommenus(hfig,[2 1]);
    
    % add zoom buttons on the menu bar
    render_zoombtns(hfig);
    hObj = zoom(hfig);
    
    % Set up pre and post action callbacks for zoom operations
    set(hObj,'ActionPreCallback', @ZoomPreCB);
    set(hObj,'ActionPostCallback', @ZoomPostCB);

    % Initialize and set some parameters related to Zoom feature
    fig_data.zoomInUse             = false;
    fig_data.originalXDisplay      = 0;
    fig_data.originalScalingFactor = 1;
    fig_data.zoomedScalingFactor   = 1;
    fig_data.XAxisParamsChanged    = false;
    fig_data.zoomActivated         = false;
    fig_data.zoomedXLimits         = [0 1];
    fig_data.zoomedYLimits         = [-10 10];
    fig_data.originalXLimits       = [0 1];
    fig_data.originalYLimits       = [-10 10];
    
end

%
% Define AXES menu labels:
%
if ispc
    labels = {'&Axes', 'Per&sistence', '&Refresh', ...
              '&Autoscale', 'Show &Grid', 'Compact &Display', ...
              ['&' block_data.strFrame ' #'], 'Channel &Legend', ...
              'Save A&xes Settings', 'Save Scope &Position'};
else
    labels = {'Axes', 'Persistence', 'Refresh', ...
              'Autoscale', 'Show Grid', 'Compact Display', ...
              [block_data.strFrame ' #'], 'Channel Legend', ...
              'Save Axes Settings', 'Save Scope Position'};
end
%
% Create figure AXIS menu
%
mAxes = uimenu(hfig, 'Label', labels{1});  % top-level Axes menu in figure
%
% submenu items:
switch block_type,
    case {1,3},
        % - Create Autoscale item
        fig_data.menu.autoscale = uimenu(mAxes, 'label',labels{4}, ...
            'callback', @Autoscale);
        % - Create Axis Grid item
        fig_data.menu.axisgrid = uimenu(mAxes, 'Label', labels{5}, ...
            'Callback', @AxisGrid);
        % - Create Axis Zoom item
        fig_data.menu.axiszoom = uimenu(mAxes, ...
            'Label', labels{6}, ...
            'Callback', @AxisZoom, 'Visible','off');
        % - Create Axis Frame Number item
        fig_data.menu.framenumber = uimenu(mAxes, 'Label', labels{7}, ...
            'Callback', @FrameNumber);
        % - Create Record Position item
        fig_data.menu.recpos = uimenu(mAxes, 'label',labels{10}, ...
                                      'callback', @SaveFigPos, ...
                                      'separator','on');
    otherwise,
        % - Create Memory item
        fig_data.menu.memory = uimenu(mAxes, 'label',labels{2}, ...
            'callback',@Memory);
        % - Create Refresh item
        fig_data.menu.refresh = uimenu(mAxes, 'label',labels{3}, ...
            'callback',@FigRefresh);
        % - Create Autoscale item
        fig_data.menu.autoscale = uimenu(mAxes, 'label',labels{4}, ...
            'separator','on', 'callback', @Autoscale);
        % - Create Axis Grid item
        fig_data.menu.axisgrid = uimenu(mAxes, 'Label', labels{5}, ...
            'Callback', @AxisGrid);
        % - Create Axis Zoom item
        fig_data.menu.axiszoom = uimenu(mAxes, ...
            'Label', labels{6}, ...
            'Callback', @AxisZoom);
        % - Create Axis Frame Number item
        fig_data.menu.framenumber = uimenu(mAxes, 'Label', labels{7}, ...
            'Callback', @FrameNumber);
        % - Create Axis Legend item
        fig_data.menu.axislegend = uimenu(mAxes, 'Label', labels{8}, ...
            'Callback', @AxisLegend);
        % - Create 'Save axes settings' item
        fig_data.menu.saveAxes = uimenu(mAxes,'label',labels{9}, ...
                                        'Callback',@SaveAxesSettings,'separator','on');
        % - Create Record Position item
        fig_data.menu.recpos = uimenu(mAxes, 'label',labels{10}, ...
            'callback', @SaveFigPos);

end

% Define OPTIONS menu labels:
%
switch block_type,
    case {1,3},
        if ispc
            % Use "&" for accelerator characters on the PC:
            labels = {'&Channels', '&Style', '&Marker', '&Color'};
        else
            labels = {'Channels', 'Style', 'Marker', 'Color'};
        end

        %
        % Create menus as if there were only ONE line in display:
        if nchans >= 1,  % original code
            mLines = uimenu(hfig, 'label',labels{1});  % top-level Lines menu in figure

            switch block_type,
                case 3,
                    % Line styles submenu:
                    lsmenu = uimenu(mLines, 'label',labels{2});
                    fig_data.menu.linestyle  = lsmenu;

                    uimenu(lsmenu,'label',' -', 'userdata','-', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' --', 'userdata','--', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' :', 'userdata',':', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' -.', 'userdata','-.', ...
                        'callback',@LineStyle);
                    visWhite = 'off';

                case 1,
                    % Line styles submenu:
                    lsmenu = uimenu(mLines, 'label',labels{2});
                    fig_data.menu.linestyle  = lsmenu;

                    uimenu(lsmenu,'label',' None', 'userdata','None', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' -', 'userdata','-', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' --', 'userdata','--', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' :', 'userdata',':', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' -.', 'userdata','-.', ...
                        'callback',@LineStyle);

                    % Line markers submenu:
                    lmmenu = uimenu(mLines, 'label',labels{3});
                    fig_data.menu.linemarker = lmmenu;

                    uimenu(lmmenu,'label','None','userdata','None', ...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','+','userdata','+',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','o','userdata','o',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','*','userdata','*',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','.','userdata','.',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','x','userdata','x',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','Square','userdata','Square',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','Diamond','userdata','diamond',...
                        'callback',@LineMarker);
                    visWhite = 'off';
                otherwise,  % Vector scope
                    % Line styles submenu:
                    lsmenu = uimenu(mLines, 'label',labels{2});
                    fig_data.menu.linestyle  = lsmenu;

                    uimenu(lsmenu,'label',' None', 'userdata','None', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' -', 'userdata','-', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' --', 'userdata','--', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' :', 'userdata',':', ...
                        'callback',@LineStyle);
                    uimenu(lsmenu,'label',' -.', 'userdata','-.', ...
                        'callback',@LineStyle);

                    % Line markers submenu:
                    lmmenu = uimenu(mLines, 'label',labels{3});
                    fig_data.menu.linemarker = lmmenu;

                    uimenu(lmmenu,'label','None','userdata','None', ...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','+','userdata','+',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','o','userdata','o',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','*','userdata','*',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','.','userdata','.',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','x','userdata','x',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','Square','userdata','Square',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','Diamond','userdata','diamond',...
                        'callback',@LineMarker);
                    uimenu(lmmenu,'label','Stem','userdata','stem',...
                        'callback',@LineMarker);
                    visWhite = 'on';
            end

            % Line colors submenu:
            lcmenu = uimenu(mLines, 'label',labels{4});
            fig_data.menu.linecolor  = lcmenu;

            % UserData holds valid RGB triples for each entry
            uimenu(lcmenu,'label','Cyan','userdata',[0 1 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Magenta','userdata',[1 0 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Yellow','userdata',[1 1 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Black','userdata',[0 0 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Red','userdata',[1 0 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Green','userdata',[0 1 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Blue','userdata',[0 0 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','White','userdata',[1 1 1 ],...
                'callback',@LineColor,'visible',visWhite);
        end
    otherwise,
        if ispc
            % Use "&" for accelerator characters on the PC:
            labels = {'&Channels', '&Style', '&Marker', '&Color'};
        else
            labels = {'Channels', 'Style', 'Marker', 'Color'};
        end
        %
        % Create menus as if there were only ONE line in display:
        if nchans >= 1,
            mLines = uimenu(hfig, 'label',labels{1});  % top-level Lines menu in figure

            lsmenu = uimenu(mLines, 'label',labels{2});
            lmmenu = uimenu(mLines, 'label',labels{3});
            lcmenu = uimenu(mLines, 'label',labels{4});

            fig_data.menu.linestyle  = lsmenu;
            fig_data.menu.linemarker = lmmenu;
            fig_data.menu.linecolor  = lcmenu;

            % Line styles submenu:
            uimenu(lsmenu,'label',' None', 'userdata','None', ...
                'callback',@LineStyle);
            uimenu(lsmenu,'label',' -', 'userdata','-', ...
                'callback',@LineStyle);
            uimenu(lsmenu,'label',' --', 'userdata','--', ...
                'callback',@LineStyle);
            uimenu(lsmenu,'label',' :', 'userdata',':', ...
                'callback',@LineStyle);
            uimenu(lsmenu,'label',' -.', 'userdata','-.', ...
                'callback',@LineStyle);

            % Line markers submenu:
            uimenu(lmmenu,'label','None','userdata','None', ...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','+','userdata','+',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','o','userdata','o',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','*','userdata','*',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','.','userdata','.',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','x','userdata','x',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','Square','userdata','Square',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','Diamond','userdata','diamond',...
                'callback',@LineMarker);
            uimenu(lmmenu,'label','Stem','userdata','stem',...
                'callback',@LineMarker);

            % Line colors submenu:
            % UserData holds valid RGB triples for each entry
            uimenu(lcmenu,'label','Cyan','userdata',[0 1 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Magenta','userdata',[1 0 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Yellow','userdata',[1 1 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Black','userdata',[0 0 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Red','userdata',[1 0 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Green','userdata',[0 1 0],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','Blue','userdata',[0 0 1],...
                'callback',@LineColor);
            uimenu(lcmenu,'label','White','userdata',[1 1 1 ],...
                'callback',@LineColor);
        end
end

%
% Define WINDOW menu
%
if ispc
    labels = {'&Window'};
else
    labels = {'Window'};
end
mWindow = matlab.ui.internal.createWinMenu(hfig);

% Help menu:
mHelp = uimenu(hfig,'Label','&Help');

% Help->Help Topics:
uimenu('parent',mHelp, ...
    'label','&Help Topics', ...
    'tag','helptopicstag',...
    'callback', {@HelpTopicsCB, block_name});

% Help->What's This? submenu:
%uimenu('parent',mHelp, ...
%   'label','&What''s This?', ...
%   'callback', @HelpWhatsThisCB);

% Store all top-level menu items in one vector
fig_data.menu.top = [mFile mView mAxes mLines mWindow mHelp];


% Recreate the figure and context menus if there are 2 or more lines
%
% One line menu item for each channel.
% Need to position the menu items according to i

% process index for comms scopes
count = modifyLineIdx(nchans, 1, block_name);

if count==1,
    % Single line display:

    % Just to allow things to be easy, define a "visible" menu item,
    % but make them invisible (doesn't seem to make a lot of sense
    % for one channel):
    fig_data.menu.linedisable(1,1) = uimenu(mLines,'label','Visible',...
        'callback',@LineDisable,'position',1, ...
        'visible','off');
    fig_data.menu.linedisable(2,1) = uimenu(mContext,'label','Visible',...
        'callback',@LineDisable, ...
        'visible','off');

    % Populate the context menu with Style/Color/Marker menus:
    switch block_type,
        case 1,
            fig_data.menu.linemarker(2,1) = copyobj(lmmenu, mContext);
            fig_data.menu.linestyle(2,1)  = copyobj(lsmenu, mContext);
        case 3,
            fig_data.menu.linestyle(2,1)  = copyobj(lsmenu, mContext);
        otherwise,
            fig_data.menu.linemarker(2,1) = copyobj(lmmenu, mContext);
            fig_data.menu.linestyle(2,1)  = copyobj(lsmenu, mContext);
    end
    fig_data.menu.linecolor(2,1)  = copyobj(lcmenu, mContext);

else
    % Multiple line display:
    fig_data.menu.linestyle  = [];
    fig_data.menu.linemarker = [];
    fig_data.menu.linecolor  = [];

    lineo = zeros(1, nchans);
    linec = zeros(1, nchans);
    for i = 1:nchans,
        % Create new "Ch #" submenus in Options and Context menus:
        s = ['Ch ' num2str(i)];
        lineo(i) = uimenu(mLines, 'Label', s, 'Position', i, 'UserData', i);
        linec(i) = uimenu(mContext, 'Label', s, 'Position', i, 'UserData', i);

        % Add "disable" option to each channel menu
        fig_data.menu.linedisable(1,i) = uimenu(lineo(i),'label','Visible',...
            'callback',@LineDisable);
        fig_data.menu.linedisable(2,i) = uimenu(linec(i),'label','Visible',...
            'callback',@LineDisable);

        % Copy each line options submenu under the new "Line #"
        % submenus in both the Options and Context menus:
        % - styles
        fig_data.menu.linestyle(:,i) = ...
            [copyobj(lsmenu, lineo(i)); copyobj(lsmenu, linec(i))];
        set(fig_data.menu.linestyle(:,i),'separator','on');
        % - markers
        fig_data.menu.linemarker(:,i) = ...
            [copyobj(lmmenu, lineo(i)); copyobj(lmmenu, linec(i))];
        % - colors
        fig_data.menu.linecolor(:,i) = ...
            [copyobj(lcmenu, lineo(i)); copyobj(lcmenu, linec(i))];
    end
    % Get rid of original "one display line" submenus from Options menu:
    delete([lsmenu lmmenu lcmenu]);  % Options submenus
end

% Copy menu items in common to both single- and multi-line context menus:
%
% Copy autoscale menu to context menu:
%
cAutoscale = copyobj(fig_data.menu.autoscale, mContext);
%
% Copy AxisGrid menu, storing both menu handles:
cAxisGrid = copyobj(fig_data.menu.axisgrid, mContext);
fig_data.menu.axisgrid = [fig_data.menu.axisgrid cAxisGrid];
% Copy Frame #, storing both menu handles:
cFrameNumber = copyobj(fig_data.menu.framenumber, mContext);
fig_data.menu.framenumber = [fig_data.menu.framenumber cFrameNumber];
% Copy AxisZoom menu, storing both menu handles:
cAxisZoom = copyobj(fig_data.menu.axiszoom, mContext);
fig_data.menu.axiszoom = [fig_data.menu.axiszoom cAxisZoom];

switch block_type,
    case {1,3},
        set(cAutoscale,'separator','on');  % Turn on separator just above item
    otherwise
        % Copy Legend menu, storing both menu handles:
        cAxisLegend = copyobj(fig_data.menu.axislegend, mContext);
        fig_data.menu.axislegend = [fig_data.menu.axislegend cAxisLegend];
end
%

switch block_type,
  case {1,3},
    % Comms Scopes - do not add any context menu items.
  otherwise,
    % Vector or Spectrum scopes
    
    % Add zoom related menu items to context menu
    
    cZoom = copyobj(mZoomMenu(length(mZoomMenu):-1:1), mContext);
    set(cZoom(4),'separator','on');
    copyobj(fig_data.menu.saveAxes, mContext);
end

% Copy save position menu:
copyobj(fig_data.menu.recpos, mContext);

% ---------------------------------------------------------
% End of figure menus
% ---------------------------------------------------------

% Record figure data:
set(hfig, 'UserData', fig_data);

% Assign context menu to the axis, lines, and grid:
set(fig_data.main.hline, 'UIContextMenu', mContext);
set([fig_data.main.haxis fig_data.main.hgrid fig_data.main.hstem], ...
    'UIContextMenu', mContext);

% ---------------------------------------------------------------
function ZoomPreCB(hfig, eventStruct)
% ActionPreCallback function for zoom feature. When any of the four zoom 
% buttons/menu-items is clicked, this function is called BEFORE that action is performed.
%
% hfig       - handle to the figure that has been clicked on
% evenStruct - handle to event object (actually structure)

fig_data   = get(hfig, 'UserData');

if ~fig_data.zoomActivated
    % if zoom is not yet activated, it is being activated now. Store current axes limits as
    % original axes limits for later use.
    fig_data.originalXLimits = get(eventStruct.Axes, 'xlim');
    fig_data.originalYLimits = get(eventStruct.Axes, 'ylim');

    % Store XDisplay, if applicable, as original XDisplay for later use
    block_name = fig_data.block;
    block_data = get_param(block_name,'UserData');
    if isfield(block_data.params, 'XDisplay')
        fig_data.originalXDisplay = block_data.params.XDisplay;
    end
end

% set the flag to indicate that Zoom has been activated.
fig_data.zoomActivated = true;

set(hfig, 'UserData', fig_data);

% ---------------------------------------------------------------
function ZoomPostCB(hfig, eventStruct)
% ActionPostCallback function for zoom feature. When any of the four zoom 
% buttons/menu-items is clicked, this function is called AFTER that action is completed.
%
% hfig       - handle to the figure that has been clicked on
% evenStruct - handle to event object (actually structure)

fig_data   = get(hfig,'UserData');
block_name = fig_data.block;

block_data = get_param(block_name,'UserData');

% figure out if zooming out (through 'Default view' button) or using one of the zoom-in mode
if defaultViewClicked(fig_data, eventStruct.Axes)
    % default view clicked

    % set the flag to indicate that current view is not zoomed-in 
    fig_data.zoomInUse = false;

    if block_data.params.Domain ~= 3
        % Not User-defined domain

        if fig_data.zoomedScalingFactor ~= fig_data.originalScalingFactor
            % this is the case when zooming out to default view causes the axis scaling to
            % change
            % re-scale and/or shift data ONLY if original and current scaling 
            % factors are different

            maxNewXData = -Inf;
            
            if isfield(block_data.params, 'XDisplay') && (block_data.params.XDisplay ~= 0) && ...
                    (fig_data.originalXDisplay ~= block_data.params.XDisplay)
                % Spectrum Scope w/ 'Frequency display offset' ~= 0
                % this xData needs to be shifted, only if current XDisplay is not equal to 
                % original XDisplay, to get back to original range
                xDisplay = block_data.params.XDisplay;
            else
                % Vector Scope (i.e. no XDisplay field) or Spectrum Scope w/ 
                % 'Frequency display offset' == 0
                % undo current scaling & re-do original scaling - no shifting required
                xDisplay = 0;
            end

            for idx = 1:length(fig_data.main.hline)

                xData = get(fig_data.main.hline(idx), 'xdata');
                
                newXData = ( (xData ./ fig_data.zoomedScalingFactor) - ...
                             xDisplay ) .* fig_data.originalScalingFactor;
                
                set(fig_data.main.hline(idx), 'xdata', newXData);

                % store maximum value in shifted/rescaled xdata to pass it to engunits later
                maxNewXData = max(maxNewXData, max(newXData));
                
            end
            
            % maxNewXData is not scaled at this point; scale it for use with engunits
            maxNewXData = maxNewXData ./ fig_data.originalScalingFactor;
            
            % Adjust X-Axis label
            if block_data.params.Domain == 1
                % Time-domain
                
                if block_data.Ts<0,
                    % Triggered:
                    xLabel = 'Trigger events (samples)';
                else
                    xLabel = 'Time (s)';
                end

                % engunits will use us/ms, and s/mins/hrs where applicable
                [~, xunits_exp, xunits_prefix] = engunits(maxNewXData, 'latex', 'time');
                % When engunits function is modified to return 'secs' instead of 's'
                % delete the following line.
                if strcmp(xunits_prefix,'secs'), xunits_prefix = 's'; end

                % Time - remove everything between parens  'Horiz (s)' => 'Horiz (days)'
                idx = find(xLabel=='('); j = find(xLabel==')');
                s = [xLabel(1:idx) xunits_prefix xLabel(j:end)];
                xLabel = s;

            elseif block_data.params.Domain == 2
                % Frequency-domain
                
                if block_data.params.XUnits == 1,
                    xLabel  = 'Frequency (Hz)';
                else
                    xLabel  = 'Frequency (rad/s)';
                end
                
                [~, xunits_exp, xunits_prefix] = engunits(maxNewXData, 'latex', 'freq');

                % Freq - insert units only  'Freq (Hz)' => 'Freq (kHz)'
                idx = find(xLabel=='(');
                s = [xLabel(1:idx) xunits_prefix xLabel(idx+1:end)];
                xLabel = s;

            end
            
            hxLabel = get(block_data.haxis(1), 'XLabel');
            set(hxLabel, 'String', xLabel);
            
            % update zoomedScalingFactor as per the newly computed value
            fig_data.zoomedScalingFactor = xunits_exp;
            fig_data.zoomedPrefix = xunits_prefix;
            
        end % if fig_data.zoomedScalingFactor ~= fig_data.originalScalingFactor ...

    end % if block_data.params.Domain ~= 3 ...

else
    % using one of the zoom-in modes
    
    if ~fig_data.zoomInUse
        % not in zoom mode - entering it now

        fig_data.zoomInUse = true;
        fig_data.zoomedXLimits = get(eventStruct.Axes,'xlim');
        fig_data.zoomedYLimits = get(eventStruct.Axes,'ylim');
    end
    
end % if defaultViewClicked(fig_data, eventStruct.Axes) ...
        
fig_data.zoomedXLimits = get(eventStruct.Axes,'xlim');
fig_data.zoomedYLimits = get(eventStruct.Axes,'ylim');

UpdateGrid(block_name);  % Do this prior to repositioning frame # text
UpdateFrameNumPos(block_name);

set(hfig,'UserData',fig_data);

% --------------------------------------------------------------
function flag = defaultViewClicked(fig_data, ax)
% function to check if default view button/menu was clicked

% if xlim & ylim stored in fig_data are same as that of the axes, default 
% view button/menu was clicked. This is the case when default view button/
% menu is clicked without zooming in

axesXLim = get(ax,'xlim');
axesYLim = get(ax,'ylim');

if ~fig_data.zoomActivated
    % If zoom is not yet activated, Default View is clicked

    flag = true;
    
else
    % Zoom already activated
    
    flag = isequal(axesXLim, fig_data.zoomedXLimits) && ...
           isequal(axesYLim, fig_data.zoomedYLimits);

    % if going from zoomed-in state to default view, compare current axes
    % xlim & ylim to original values
    if ~flag
        flag = isequal(axesXLim, fig_data.originalXLimits) && ...
               isequal(axesYLim, fig_data.originalYLimits);
    end
end

% --------------------------------------------------------------
function HelpTopicsCB(hcoNotUsed, eventStructNotUsed, block_name) %#ok
% HelpTopicsCB Get reference-page help
%
block_type = getfromancestor(block_name,'block_type_');
commMAP = fullfile(docroot,'toolbox','comm','comm.map');
dspMAP = fullfile(docroot,'toolbox','dsp','dsp.map');
switch block_type,
    case 'eye',
       path = commMAP;
       topicID =  'commdiscretetimeeyediagramscope';
    case 'xy',
       path = commMAP;
       topicID =  'commdiscretetimesignaltrajectoryscope';
    otherwise
        path = dspMAP;
        bref = get_param(block_name, 'referenceblock');
        i=find(bref == '/',1,'last');
        dref = bref(i+1:end);
        dref=strrep(dref,sprintf('\n'),' ');
        if strcmp(dref,'Spectrum Scope')
            topicID = 'dspspectrumscope';
        elseif strcmp(dref,'Vector Scope')
            topicID = 'dspvectorscope';
        end      
end

helpview(path,topicID);
return


% ---------------------------------------------------------------
function fig_data = restart_scope(block_name)
% RESTART_SCOPE Restart with existing scope window

% We want to confirm to a reasonable probability that
% the existing scope window is valid and can be restarted.

% The caller already verified that hfig is non-empty
block_data = get_param(block_name,'UserData');
hfig = block_data.hfig;

% We don't know if the handle points to a valid window:
if isempty(hfig) || ~ishghandle(hfig)
    block_data.hfig = [];  % reset it back
    set_param(block_name,'UserData',block_data);
    fig_data = [];
    return;
end

% Something could fail during restart if the figure data was
% altered between runs ... for example, by command-line interaction.
% If errors occur, abandon the restart attempt:
try
    fig_data = get(hfig,'UserData');
    hax = fig_data.main.haxis;

    % In case memory (persistence) was on:
    FigRefresh([],[],hfig);

    % Replace existing lines:
    delete(fig_data.main.hline);

    % Data lines:
    switch getfromancestor(block_name,'block_type_',2);
        case 1,
            numAxes = size(hax,2);
            if block_data.cparams.ws.fading,
                tracesPerLine = ceil(block_data.cparams.ws.numTraces / block_data.cparams.ws.numLinesMax);
                numLines = ceil(block_data.cparams.ws.numTraces / tracesPerLine);
            else
                numLines = 1;
            end
        case 3,
            numAxes = 1;
            if block_data.cparams.ws.fading,
                tracesPerLine = ceil(block_data.cparams.ws.numTraces / block_data.cparams.ws.numLinesMax);
                numLines = ceil(block_data.cparams.ws.numTraces / tracesPerLine);
            else
                numLines = 1;
            end
        otherwise,
            numAxes = 1;
            numLines = block_data.NChans;
    end

    hline = zeros(numLines, numAxes);
    for count = 1:numAxes,
        for idx = 1:numLines,
            hline(idx,count) = line('parent',hax(count), ...
                'xdata', NaN, ...
                'ydata', NaN, ...
                'linestyle', '-', ...
                'marker',    'none', ...
                'markerfacecolor', 'k', ...
                'color',     'k', ...
                'LineStyle','None');
        end
    end
    % NOTE: No need to delete stem lines

    % Reset frame number:
    set(fig_data.main.hframenum(2),'userdata',0,'string','0');

    % Update data structures:
    fig_data.main.hline = hline;

    %block_data.hgrid    = hgrid;
    block_data.hline    = hline;

    % Reassign context menu to the lines and grid:
    set(hline, 'UIContextMenu', fig_data.menu.context);
    % set([hline hgrid], 'UIContextMenu', mContext);

    figure(hfig); % bring window forward

catch %#ok
    % Something failed - reset hfig to indicate error during restart:
    fig_data.hfig=[];
    block_data.hfig=[];
end

% Update data structures:
set(hfig, 'UserData',fig_data);
set_param(block_name, 'UserData',block_data);

% ---------------------------------------------------------------
function NameChange %#ok - This function is called from block (mdl file) directly
% In response to the name change, we must do the following:
%
% (1) find the old figure window, only if the block had a GUI
%     associated with it.
%     NOTE: Current block is parent of the S-function block
block_name = gcb;
block_data = get_param(block_name, 'UserData');

% System might never have been run since loading.
% Therefore, block_data might be empty:
if ~isempty(block_data) && isfield(block_data,'hfig')
    %isstruct(block_data),
    % (2) change name of figure window (cosmetic)
    block_type = getfromancestor(block_name,'block_type_');
    switch block_type,
        case {'eye','xy'},
            parent   = get_param(block_name,'parent');
            fig_name = parent;
            iotype   = get_param(parent,'iotype');
            if strcmp(iotype,'viewer')
                fig_name = viewertitle(parent,false);
            end
        otherwise,
            fig_name = block_name;
            iotype   = get_param(block_name,'iotype');
            if strcmp(iotype,'viewer')
                fig_name = viewertitle(block_name,false);
            end
    end
    hfig = block_data.hfig;
    set(hfig,'name',fig_name);

    % (3) update figure's userdata so that the new blockname
    %     can be used if the figure gets deleted
    fig_data = get(hfig,'UserData');
    fig_data.block = block_name;
    set(hfig,'UserData',fig_data);
end



% ---------------------------------------------------------------
function CloseFigure(hcoNotUsed, eventStructNotUsed, blk) %#ok
% Manual (programmatic) closing of the figure window

block_data = get_param(blk,'UserData');
if ~isfield(block_data,'hfig'),
    return;
end
hfig       = block_data.hfig;

% Reset the block's figure handle:
block_data.hfig = [];
set_param(blk, 'UserData',block_data);

% Delete the window:
set(hfig,'DeleteFcn','');  % prevent recursion
delete(hfig);

% ---------------------------------------------------------------
function CloseFigureAndClearUpdateMtd(hcoNotUsed, eventStructNotUsed, blk) %#ok
% Manual (programmatic) closing of the figure window

% close figure window
CloseFigure([],[],blk);

% clear update method, if required 
clearUpdateMethodConditionally(blk);

% ---------------------------------------------------------------
function ScopeUpdate(blk, action) %#ok - This function is called from block (mdl file) directly

% Programmatic control of the scopes.

% Use:
% % define the block name or just use gcb while the block is selected
% block_name = gcb; % use gcb while the block is selected
% or
% block_name = 'Eye_Diagram_D/Discrete-Time Eye Diagram Scope' % define the block name
%
% % Command to open (OpenFig) the figure
% sdspfscope2([],[],[],'ScopeUpdate',block_name ,'OpenFig');
%
% % Command to close (CloseFig) the figure
% sdspfscope2([],[],[],'ScopeUpdate',block_name ,'CloseFig');
%
% % NOTE: OpenFig does nothing if the simulation is stopped or paused.
% %            CloseFig always closes the figure if there is one to close.
% %
% %  The vector scope and spectrum scope now have this ability too.


% We need to create the correct block string to call
% resetToFirstCall and Dialog Apply

% Handle SpectrumAnalyzer case (block replacement for SpectrumScope) and
% ConstellationDiagram (block replacement for Discrete-Time Scatter Plot
% scope block)
if ~isempty(regexp(get_param(blk,'BlockType'), ...
        '(SpectrumAnalyzer|ConstellationDiagram)', 'once'));
    switch action,
        case 'OpenFig',
            open_system(blk,'parameter');
        case 'CloseFig',
            close_system(blk);
        otherwise
            error(message('dsp:sdspfscope2:unhandledCase3')); 
    end
    return;
end

block_type = getfromancestor(blk,'block_type_');
switch block_type,
    case 'eye',
        blk = [blk '/Eye Rendering'];
    case 'xy',
        blk = [blk '/X-Y Rendering'];
    otherwise,
        % Do nothing!
end
switch action,
    case 'OpenFig',
        % Get sim status
        status    =  get_param(bdroot(blk),'simulationstatus');
        % Open figure when not stopped
        if ~strcmp(status,'stopped')
            openScopeWhileRunning(blk);
            block_data = get_param(blk,'UserData');
            if ~strcmp(status, 'external')
                % For normal & accelerator modes, the update method was set
                % to empty ([]) as the scope was not open. set it up
                % correctly now that scope is being opened
                setUpdateMethod(block_data.comm.block);
            end
            if isfield(block_data, 'hfig') && isempty(block_data.hfig),
                if strcmp(status,'running') || strcmp(status, 'external') ||  strcmp(status,'paused')
                    if strcmpi(get_param(blk,'BlockType'),'M-S-Function') % vector scope
                        sfcn = blk;
                    else  %%  'SubSystem' %% spectrum scope
                        sfcn = [blk '/' 'Frame Scope'];
                    end
                    block = get_param(sfcn,'runtimeobject');
                    % need to read the block_data again; as block_data.firstcall
                    % might get reset
                    if block_data.firstcall,
                        params = block_data.params;
                        Create_or_Restart_Scope(blk, block, params); %% blk, sfcn<-- change to blkh
                        % mdlUpdate will update the lines with valid data (update_lines)
                    end
                end
            end
        end
  case 'CloseFig',
    
        CloseFigureAndClearUpdateMtd([],[],blk);
  
  otherwise,
        error(message('dsp:sdspfscope2:unhandledCase3'));
end

% ---------------------------------------------------------------
function FigDelete(hcbNotUsed, eventStructNotUsed) %#ok
% Callback from figure window
% Called when the figure is closed or deleted

hfig = gcbf;
fig_data = get(hfig,'UserData');
if isempty(fig_data) || (hfig ~= fig_data.hfig)
    % The case where 'hfig' is a copy of the figure window created for
    % printing operations. In this case, just delete the temporary
    % invisible figure 'hfig' and return.
    delete(hfig);
    return;
end

% Close the figure window & clear update method, if required
CloseFigureAndClearUpdateMtd([],[],fig_data.block);

% ---------------------------------------------------------------

function FigClose(hcbNotUsed, eventStructNotUsed) %#ok

hfig = gcbf;
fig_data = get(hfig,'UserData');
blk = fig_data.block;
status    =  get_param(bdroot(blk),'simulationstatus');
% If we are initializing, do not close the figure because that would leave
% us in a bad state
if ~strcmp(status,'initializing')
    closereq;
end

% ---------------------------------------------------------------
function clearUpdateMethodConditionally(blk)
% Function to clear update method of MATLAB SFunction block i.e. set update method to [].
% This is done conditionally. Setting update method to [] will effectively make scope a 
% NO-OP for SL as SL will not call it at run-time resulting into better speed performance.
% A few cases when this function needs to be called:
%   - When the scope figure is deleted/closed
%   - When the scope figure is closed by double clicking on 'Close Figure/Plot' blocks 
%     that are used in some Comms blks demos

% if running or paused, set 'Update' method to []. Reason: if figure does not exist, 
% no need to call 'Update' method
% if not running, no need to change 'Update' method
status    =  get_param(bdroot(blk),'simulationstatus');
isRunning = strcmp(status,'running') || strcmp(status,'initializing') ...
    || strcmp(status,'updating');
isPaused = strcmp(status,'paused');
if isRunning || isPaused
    block_data = get_param(blk, 'UserData');
    if isa(block_data.comm.block, 'Simulink.RunTimeBlock')
        block_data.comm.block.RegBlockMethod('Update', []);
    end
end

% ---------------------------------------------------------------
function StopBlock(hcbNotUsed, eventStructNotUsed) %#ok - This function is called by the 
% block (mdl file) directly

% reset the scope to open when the mask dialog indicates
blk = gcb;
% We need to create the correct block string to call
% resetToFirstCall and Dialog Apply
block_type = getfromancestor(blk,'block_type_');
switch block_type,
    case 'eye',
        renderBlock = [blk '/Eye Rendering'];
    case 'xy',
        renderBlock = [blk '/X-Y Rendering'];
end
resetToFirstCall(renderBlock);


% ---------------------------------------------------------------
function BlockDelete %#ok - This function is called from block (mdl file) directly
% Block is being deleted from the model

% clear out figure's close function
% delete figure manually
blk = gcbh;
block_data = get_param(blk,'UserData');
if isstruct(block_data),
    if (isfield(block_data,'hfig') && ~isempty(block_data.hfig))
        set(block_data.hfig, 'DeleteFcn','');
        delete(block_data.hfig);
        block_data.hfig = [];
        set_param(blk,'UserData',block_data);
    end
end


% ---------------------------------------------------------------
function BlockCopy %#ok - This function is called from block (mdl file) directly
% Block is being copied from the model

% clear out stored figure handle
blk = gcbh;
block_data = get_param(blk,'UserData');
if isstruct(block_data),
    if (isfield(block_data,'hfig') && ~isempty(block_data.hfig))
        block_data.hfig = [];
        set_param(blk,'UserData',block_data);
    end
end


% ---------------------------------------------------------------
function SaveFigPos(hcbNotUsed, eventStructNotUsed) %#ok
% Record the current position of the figure into the block's mask

% Get the block's name:
hfig = gcbf;
fig_data = get(hfig,'UserData');
if hfig ~= fig_data.hfig,
    error(message('dsp:sdspfscope2:invalidHandle2'));
end

% Record the figure position, as a string, into the appropriate mask dialog:
blk = fig_data.block;
FigPos = get(hfig,'Position');             % Get the fig position in pixels
switch getfromancestor(blk,'block_type_',2)
    case {1,3},
        block_data = get_param(blk,'userdata');
        FigPosStr = mat2str(round(FigPos));
        parent = get_param(blk,'parent');
        set_param(parent, 'FigPos', FigPosStr); % Record new position
        block_data.cparams.ws.FigPos = FigPos;
        set_param(blk, 'userdata',block_data);
    otherwise,
        FigPosStr = mat2str(round(FigPos));
        set_param(blk, 'FigPos', FigPosStr); % Record new position
end

% ---------------------------------------------------------------
function SaveAxesSettings(hcbNotUsed, eventStructNotUsed) %#ok
% Callback function for 'Save Axes Settings' option of VIEW menu.

% hcb         - handle to the object whose callback is called
% eventStruct - handle to event object (actually structure)

% Get the figure
hfig = gcbf;
fig_data = get(hfig,'UserData');
if hfig ~= fig_data.hfig,
    error(message('dsp:sdspfscope2:invalidHandle3'));
end

% Get block
blk = fig_data.block;

switch getfromancestor(blk,'block_type_',2)
  case {1,3},
    % Comms scopes - do not do anything
  otherwise,
    % Vector or Spectrum Scope. Save axes settings
    setBlockAxesParams(blk);
end

% ---------------------------------------------------------------
function setBlockAxesParams(blk)
% Function to set XMin/XMax and YMin/YMax parameters of block to the values represented by
% current axes ranges.

block_data = get_param(blk, 'UserData');

% Get axes range from figure
xLim = get(block_data.haxis, 'xlim');
yLim = get(block_data.haxis, 'ylim');

% Save axes settings into block mask parameter
% scale the X-axis values as per the zoomedScalingFactor
fig_data = get(block_data.hfig, 'UserData');
set_param(blk, 'XLimit', 'User-defined', 'XMin', num2str(xLim(1) ./ fig_data.zoomedScalingFactor), ...
               'XMax', num2str(xLim(2) ./ fig_data.zoomedScalingFactor), ...
               'YMin', num2str(yLim(1)), 'YMax', num2str(yLim(2)));

% ---------------------------------------------------------------
function LineColor(hcbNotUsed ,eventStructNotUsed) %#ok
% Change line color for one line due to a menu-item selection

hco=gcbo; hfig=gcbf;
fig_data = get(hfig, 'UserData');

if (~isempty(hfig) && ~isempty(fig_data))
    % process index for comms scopes
    blk      = fig_data.block;
    hmenus   = fig_data.menu.linecolor;  % [options;context] x [line1 line2 ...]

    % Given color-menu handle into Options or Context menu,
    %  find "other" menu handle, and return both in a vector.

    % process index for comms scopes
    count = modifyLineIdx(size(hmenus,2), 1, blk);

    %for lineNum=1:size(hmenus,2),  % loop over columns = Line1,Line2,...
    for lineNum=1:count,  % loop over columns = Line1,Line2,...
        % rows are [options;context] menus
        h=get(hmenus(:,lineNum),'child');
        h=cat(2,h{:});
        [i,jNotUsed]=find(h==hco);  %#ok  % i=row#=which color
        if ~isempty(i),
            hi=h(i,:);  % get menu for option and context menus
            break;
        end
    end
    set(h,'check','off');
    set(hi,'check','on');
else
    blk      = gcb;
end

% Update block dialog setting, so param is recorded in model
% This will indirectly update the param structure, via the
% mask dialog callbacks.
block_type = getfromancestor(blk,'block_type_',2);
switch block_type
    
  case 0
    
    str = mat2str(get(hco,'userdata'));  % convert RGB triple to string
    pipestr = set_pipestr( get_param(blk,'LineColors'), lineNum, str);
    SetAndApply(blk,'LineColors',pipestr);
    
  otherwise
    
    switch block_type
      case 1
        renderBlock = [gcb '/Eye Rendering'];
      case 3
        renderBlock = [gcb '/X-Y Rendering'];
    end
    
    % process index for comms scopes
    if ~isempty(hco),
        % this is a call from the rendering block
        str = mat2str(get(hco,'userdata'));
        pipestr = set_pipestr( get_param(blk,'LineColors'), lineNum, str);
        parent = get_param(blk,'Parent');
        SetAndApply(blk,'LineColors',pipestr,parent);
    else
        % this is a call from the parent block
        pipestr = get_param(gcb,'LineColors');
        SetAndApply(renderBlock,'LineColors',pipestr);
    end
    
end

% ---------------------------------------------------------------
function SetAndApply(blk,varargin)
% Manually apply change if block dialog is open:

% check if the last argument is 'eval'
if strcmp(varargin{end},'eval'),
    evalmode=1;
    varargin=varargin(1:end-1);
else
    evalmode=0;
end

% check if 2nd to last argument is maskBlk
if mod(nargin, 2) == evalmode,
    maskBlk = varargin{end};
    varargin=varargin(1:end-1);
else
    maskBlk = blk;
end


% Set value into mask param:
set_param(maskBlk, varargin{:});

% Determine if dialog is open:
dialog_open = 1; % xxx determine if block dialog is open

if dialog_open,
    % Manually apply changes, since dynamic dialog behavior
    % does not allow the change to apply when dialog is open:
    block_data = get_param(blk,'UserData');
    if ~isfield(block_data, 'params')
        block_data.params = [];
    end
    params = block_data.params;
    for i=1:length(varargin)/2,
        v = varargin(2*i-1 : 2*i);
        if evalmode,
            % evaluation value in p/v pair:
            v{2} = str2double(v{2});
        end
        params = setfield(params,v{:});
    end
    DialogApply(params, blk);
end


% ---------------------------------------------------------------
function LineStyle(hcbNotUsed, eventStructNotUsed) %#ok
% Change line style for one line due to a menu-item selection

hco=gcbo; hfig=gcbf;
fig_data = get(hfig, 'UserData');

if (~isempty(hfig) && ~isempty(fig_data))
    % process index for comms scopes
    blk      = fig_data.block;
    hmenus   = fig_data.menu.linestyle;  % [options context] x [line1 line2 ...]

    % process index for comms scopes
    count = modifyLineIdx(size(hmenus,2), 1, blk);

    %for lineNum=1:size(hmenus,2),  % loop over columns = Line1,Line2,...
    for lineNum=1:count,  % loop over columns = Line1,Line2,...
        % rows are [options;context] menus
        h=get(hmenus(:,lineNum),'child');
        h=cat(2,h{:});
        [i,jNotUsed]=find(h==hco);  %#ok  % i=row#=which style
        if ~isempty(i),
            hi=h(i,:);  % get menu for option and context menus
            break;
        end
    end
    set(h,'check','off');
    set(hi,'check','on');
else
    blk      = gcb;
end

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
block_type = getfromancestor(blk,'block_type_',2);
switch block_type,
    case 0,
        str = get(hco,'userdata');  
        pipestr = set_pipestr( get_param(blk,'LineStyles'), lineNum, str);
        SetAndApply(blk,'LineStyles',pipestr);
    otherwise,
        switch block_type,
            case 1,
                renderBlock = [gcb '/Eye Rendering'];
            case 3,
                renderBlock = [gcb '/X-Y Rendering'];
        end
        % process index for comms scopes
        if ~isempty(hco),
            % this is a call from the rendering block
            str = get(hco,'userdata');
            pipestr = set_pipestr( get_param(blk,'LineStyles'), lineNum, str);
            parent = get_param(blk,'Parent');
            SetAndApply(blk,'LineStyles',pipestr,parent);
        else
            % this is a call from the parent block
            pipestr = get_param(gcb,'LineStyles');
            SetAndApply(renderBlock,'LineStyles',pipestr);
        end
end

% ---------------------------------------------------------------
function LineMarker(hcbNotUsed, eventStructNotUsed) %#ok
% Change line marker for one line due to a menu-item selection

hco=gcbo; hfig=gcbf;

fig_data = get(hfig, 'UserData');

if (~isempty(hfig) && ~isempty(fig_data))
    % process index for comms scopes
    blk      = fig_data.block;
    hmenus   = fig_data.menu.linemarker;  % [options context] x [line1 line2 ...]

    % process index for comms scopes
    count = modifyLineIdx(size(hmenus,2), 1, blk);

    %for lineNum=1:size(hmenus,2),  % loop over columns = Line1,Line2,...
    for lineNum=1:count,  % loop over columns = Line1,Line2,...
        % rows are [options;context] menus
        h=get(hmenus(:,lineNum),'child');
        h=cat(2,h{:});
        [i,jNotUsed]=find(h==hco);  %#ok  % i=row#=which marker
        if ~isempty(i),
            hi=h(i,:);  % get menu for option and context menus
            break;
        end
    end
    set(h,'check','off');
    set(hi,'check','on');
else
    blk      = gcb;
end

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
block_type = getfromancestor(blk,'block_type_',2);
switch block_type,
    case 0,
        str = get(hco,'userdata'); 
        pipestr = set_pipestr( get_param(blk,'LineMarkers'), lineNum, str);
        SetAndApply(blk,'LineMarkers',pipestr);
    otherwise,
        switch block_type,
            case 1,
                renderBlock = [gcb '/Eye Rendering'];
            case 3,
                renderBlock = [gcb '/X-Y Rendering'];
        end
        % process index for comms scopes
        if ~isempty(hco),
            % this is a call from the rendering block
            str = get(hco,'userdata');
            pipestr = set_pipestr( get_param(blk,'LineMarkers'), lineNum, str);
            parent = get_param(blk,'Parent');
            SetAndApply(blk,'LineMarkers',pipestr,parent);
        else
            % this is a call from the parent block
            pipestr = get_param(gcb,'LineMarkers');
            SetAndApply(renderBlock,'LineMarkers',pipestr);
        end
end



% ---------------------------------------------------------------
function LineDisable(hcbNotUsed, eventStructNotUsed) %#ok
% Change disable state for selected line due to a menu-item selection

hco=gcbo; hfig=gcbf;

fig_data = get(hfig, 'UserData');
blk      = fig_data.block;
hmenus   = fig_data.menu.linedisable;  % [options context] x [line1 line2 ...]

% process index for comms scopes
count = modifyLineIdx(size(hmenus,2), 1, blk);

%for lineNum=1:size(hmenus,2),  % loop over columns = Line1,Line2,...
for lineNum=1:count,  % loop over columns = Line1,Line2,...
    % rows are [options;context] menus
    h=hmenus(:,lineNum);

    if any(h==hco)
        hi=h;  % get menu for option and context menus
        break;
    end
end

if isOn(get(hi(1),'checked')),
    opt='off';
else
    opt='on';
end
set(hi,'check',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
% process index for comms scopes
lineNum = modifyLineIdx(lineNum, 1, blk);
pipestr = set_pipestr( get_param(blk,'LineDisables'), lineNum, opt);
SetAndApply(blk, 'LineDisables', pipestr);


% ---------------------------------------------------------------
function AxisZoom(hcbNotUsed, eventStructNotUsed, hfig, opt) %#ok
% Toggle display of compact display (zoomed-in axes)
%
% opt is a string option and may be one of the following:
%     'toggle', 'on', 'off'
% If not passed, default is 'toggle'.
%
% hfig is the figure handle
% if missing, it is set to gcbf

if nargin<4, opt='toggle'; end
if nargin<3, hfig=gcbf; end

fig_data = get(hfig, 'UserData');
blk      = fig_data.block;
haxzoom  = fig_data.menu.axiszoom;

if strcmp(opt,'toggle'),
    % toggle current setting:
    if isOn(get(haxzoom,'Checked')),
        opt='off';
    else
        opt='on';
    end
end

% Update menu check:
set(haxzoom,'Checked',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
SetAndApply(blk, 'AxisZoom', opt);


% ---------------------------------------------------------------
function AxisGrid(hcbNotUsed, eventStructNotUsed, hfig, opt) %#ok
% Toggle setting of axis grid
%
% opt is a string option and may be one of the following:
%     'toggle', 'on', 'off'
% If not passed, default is 'toggle'.
%
% hfig is the figure handle
% if missing, it is set to gcbf

if nargin<4, opt='toggle'; end
if nargin<3, hfig=gcbf; end

fig_data  = get(hfig, 'UserData');
blk       = fig_data.block;
hopt      = fig_data.menu.axisgrid;

if strcmp(opt,'toggle'),
    % toggle current setting:
    if strcmp(get(hopt,'Checked'),'on'),
        opt='off';
    else
        opt='on';
    end
end

% Update menu check:
set(hopt,'Checked',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        % update parent block
        parent = get_param(blk, 'parent');
        SetAndApply(blk, 'AxisGrid', opt, parent);
    otherwise,
        % update block
        SetAndApply(blk, 'AxisGrid', opt);
end


% ---------------------------------------------------------------
function FrameNumber(hcbNotUsed, eventStructNotUsed, hfig, opt) %#ok
% Toggle setting of frame number display
%
% opt is a string option and may be one of the following:
%     'toggle', 'on', 'off'
% If not passed, default is 'toggle'.
%
% hfig is the figure handle
% if missing, it is set to gcbf

if nargin<4, opt='toggle'; end
if nargin<3, hfig=gcbf; end

fig_data  = get(hfig, 'UserData');
blk       = fig_data.block;
hfnum     = fig_data.menu.framenumber;

if strcmp(opt,'toggle'),
    % toggle current setting:
    if strcmp(get(hfnum,'Checked'),'on'),
        opt='off';
    else
        opt='on';
    end
end

% Update menu check:
set(hfnum,'Checked',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
switch getfromancestor(blk,'block_type_',2),
    case {1,3},
    % update parent block
    block_data = get_param(blk, 'userdata');
    block_data.cparams.ws.FrameNumber = opt;
    set_param(blk, 'userdata', block_data);
    parent = get_param(blk, 'parent');
    SetAndApply(blk, 'FrameNumber', opt, parent);
    otherwise,
        % Update block
        SetAndApply(blk, 'FrameNumber', opt);
end


% ---------------------------------------------------------------
function AxisLegend(hcbNotUsed, eventStructNotUsed, hfig, opt) %#ok
% Toggle setting of axis legend
%
% opt is a string option and may be one of the following:
%     'toggle', 'on', 'off'
% If not passed, default is 'toggle'.
%
% hfig is the figure handle
% if missing, it is set to gcbf
if nargin<4, opt='toggle'; end
if nargin<3, hfig=gcbf; end

fig_data  = get(hfig, 'UserData');
blk       = fig_data.block;
haxlegend = fig_data.menu.axislegend;

if strcmp(opt,'toggle'),
    % toggle current setting:
    if strcmp(get(haxlegend,'Checked'),'on'),
        opt='off';
    else
        opt='on';
    end
end

% Update menu check:
set(haxlegend,'Checked',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
SetAndApply(blk, 'AxisLegend', opt);

% ---------------------------------------------------------------
function Memory(hcbNotUsed, eventStructNotUsed, hfig, opt) %#ok
% Toggle persistence
%
% opt is a string option and may be one of the following:
%     'toggle', 'on', 'off'
% If not passed, default is 'toggle'.
%
% hfig is the figure handle
% if missing, it is set to gcbf

if nargin<4, opt='toggle'; end
if nargin<3, hfig=gcbf; end

fig_data = get(hfig, 'UserData');
blk      = fig_data.block;
h        = fig_data.menu.memory;

if strcmp(opt,'toggle'),
    % toggle current setting:
    if strcmp(get(h,'Checked'),'on'),
        opt='off';
    else
        opt='on';
    end
end

% Update menu check:
set(h,'Checked',opt);

% Update block dialog setting, so param is recorded in model:
% This will indirectly update the param structure, via the
% mask dialog callbacks.
SetAndApply(blk, 'Memory', opt);

% Update line erase mode when using Graphics Version 1
if matlab.graphics.internal.isGraphicsVersion1
    startLineEraseMode(blk);
end



% ---------------------------------------------------------------
function Autoscale(hcbNotUsed, eventStructNotUsed, block_data, u) %#ok
% AUTOSCALE Compute min/max y-limits for several input frames

if nargin<4,
    % Begin autoscale iterations
    if nargin==3,
        hfig = block_data;  % 1st arg is hfig
    else
        hfig = gcbf;
    end
    
    fig_data = get(hfig,'UserData');
    blk = fig_data.block;
    block_data = get_param(blk,'UserData');
    block_type = getfromancestor(blk,'block_type_',2);
    
    % If an autoscale operation is currently in progress,
    % cancel it and stop:
    if ~isempty(block_data.autoscaling),
        CancelAutoscale(blk);
        return;
    end
    
    % If simulation stopped, do a one-shot autoscale and leave:
    v = get_sysparam(blk,'simulationstatus');
    if ~strcmp(v,'running'),
        % Simulation is stopped or paused - perform simple one-shot autoscaling:
        oneshot_autoscale(hfig);
        return;
    end
    
    % Begin countdown
    % This is the number of sequential frames which will be examined
    % in order to determine the min/max y-limits
    %
    count=10;
    
    % Preset min and max
    ymin=+inf;
    ymax=-inf;
    
    % Put up an autoscale indicator:
    str = ['Autoscale: ' mat2str(count)];
    htext = text('units','norm','pos',[0.5 0.5], ...
        'horiz','center', 'string',str);
    
    switch block_type,
        case 3,
            xmin=+inf;
            xmax=-inf;
            block_data.autoscaling = [count ymin ymax double(htext) xmin xmax];
        otherwise
            block_data.autoscaling = [count ymin ymax double(htext)];
    end
    
    set_param(blk, 'UserData', block_data);
    
else
    % 2 input arguments
    
    % Continue processing next frame of inputs
    % to determine autoscale limits
    
    count = block_data.autoscaling(1);
    ymin  = block_data.autoscaling(2);
    ymax  = block_data.autoscaling(3);
    
    fig_data = get(block_data.hfig, 'UserData');
    blk = fig_data.block;
    block_type = getfromancestor(blk,'block_type_',2);
    
    switch block_type,
        case 3,
            xmin  = block_data.autoscaling(5);
            xmax  = block_data.autoscaling(6);
        otherwise
    end
    htext = handle(block_data.autoscaling(4));
    
    if count>0,
        % Continue tracking min and max:
                
        count=count-1;
        
        switch block_type
            
            case 3
                
                rowsU = size(u,2);
                ymin=min(min(ymin,min(u(:, rowsU/2+1:rowsU))));
                ymax=max(max(ymax,max(u(:, rowsU/2+1:rowsU))));
                
                xmin=min(min(xmin,min(u(:, 1:rowsU/2))));
                xmax=max(max(xmax,max(u(:, 1:rowsU/2))));
                block_data.autoscaling = [count double(ymin) double(ymax) double(htext) double(xmin) double(xmax)];                

            case 1

              ymin=min(ymin,min(u(:)));
              ymax=max(ymax,max(u(:)));
              block_data.autoscaling = [count double(ymin) double(ymax) double(htext)];

            otherwise
                % Vector/Spectrum Scopes
                
                nrows = block_data.samples_per_frame;
                if fig_data.zoomInUse
                    % zoom in use i.e. current view is in zoomed-in state - perform autoscale on the data currently visible
                    
                    % Unrotate data if display range is [-Fn, Fn] in 'Frequency' domain
                    if (block_data.params.Domain == 2)

                        if isfield(block_data.params,'SpectrumScope')
                            
                            if (block_data.params.XRange==1 && nrows > 2)
                                % Spectrum type = One-sided
                                % Compute full-power one-sided spectrum
                                % No need to check input complexity here as autoscale operation 
                                % changes neither the input complexity nor the 'Spectrum type' 
                                % parameter.
                                u = computeOneSidedSpectrum(u, nrows);
                                
                            elseif (block_data.params.XRange==2 && nrows > 2)
                                % Spectrum type = Two-sided
                                u = computeTwoSidedSpectrum(u, nrows);
                            end
                            
                        else % Vector Scope -> Frequency domain
                            
                            if (block_data.params.XRange == 2) && ...
                                    (nrows > 1)
                                % unrotate each channel of data:
                                p = nrows/2;  % all FFTs are a power of 2 here
                                u = u([p+1:nrows 1:p],:);
                            end
                        end
                        
                    end
                    
                    x = get(fig_data.main.hline(1),'xdata');
                    xMinIdx = find(x >= fig_data.zoomedXLimits(1), 1);
                    xMaxIdx = find(x <= fig_data.zoomedXLimits(2), 1, 'last');
                    % u could be multi-column (more than one input signal)
                    uTmp = u(xMinIdx:xMaxIdx,:);
                    u = uTmp;
                    
                else
                    % zoom not in use - perform autoscale on full data
                    
                    % For Spectrum Scope, when 'Spectrum type' = 'One-sided', the displayed data
                    % has different amplitude than the block input data (u) due to spectrum folding.
                    % Need to emulate that before computing min and max values in input data.
                    if isfield(block_data.params,'SpectrumScope') && ...
                            (block_data.params.XRange==1 && nrows > 2)
                        % Spectrum type = One-sided
                        % Compute full-power one-sided spectrum
                        % No need to check input complexity here as autoscale operation 
                        % changes neither the input complexity nor the 'Spectrum type' 
                        % parameter.
                        u = computeOneSidedSpectrum(u, nrows);
                        
                    end                    
                    
                end % fig_data.zoomInUse

                if (block_data.params.Domain == 2) 
                    % Frequency domain - Convert to correct dB, if needed
                    
                    if isfield(block_data.params,'SpectrumScope')
                        
                        if (any(block_data.params.YUnits==(3:6)))
                            u = lin2dB(u);
                            if (any(block_data.params.YUnits==[5 6]))
                                % convert dBW to dBm
                                u = u + 30;
                            end        
                        end   
                        
                    else % Vector Scope -> Frequency domain
                        
                        if (block_data.params.YUnits==2)
                            u = lin2dB(u); 
                        end
                    end % if Spectrum Scope
                    
                end % If Frequency domain

                ymin=min(ymin,min(u(:)));
                ymax=max(ymax,max(u(:)));
                block_data.autoscaling = [count double(ymin) double(ymax) double(htext)];
                
        end % switch block_type
        
        % Update user feedback:
        set(htext,'string',['Autoscale: ' mat2str(count)]);
        
        set_param(blk, 'UserData', block_data);
        
    else
        % Finished computing autoscale limits
        
        % Remove autoscale indicator:
        delete(htext);
        htext=[];   %#ok  % reset so that terminate call deletes an empty handle
        
        % Turn off autoscale flag
        block_data = get_param(blk,'UserData');
        block_data.autoscaling = [];
        set_param(blk, 'UserData', block_data);
        
        % If ymin or ymax are Inf/-Inf or NaN, then don't attempt to autoscale because
        % there is no data or all-NaNs data or data has Inf/-Inf
        if ~(any(isnan([ymin ymax])) || any(isinf([ymin ymax])) )
            
            % Adjust ymin and ymax to give a bit of margin:
            ymin=ymin-(ymax - ymin)*0.05;
            ymax=ymax+(ymax - ymin)*0.05;
            
            % Protect against horizontal lines:
            if (ymax==ymin),
                ymin=floor(ymin-.5);
                ymax=ceil(ymax+.5);
            end

            % Indirectly set these via the DialogApply callback:
            parent = get_param(blk,'Parent');
            
            switch block_type
                
              case 3,
                
                % If xmin or xmax are Inf/-Inf or NaN, then don't attempt to autoscale because 
                % there is no data or all-NaNs data or data has Inf/-Inf
                if ~(any(isnan([xmin xmax])) || any(isinf([xmin xmax])) )
                    % Adjust xmin and xmax to give a bit of margin:
                    xmin=xmin-(xmax - xmin)*0.05;
                    xmax=xmax+(xmax - xmin)*0.05;
                    
                    % Protect against horizontal lines:
                    if (xmax==xmin),
                        xmin=floor(xmin-.5);
                        xmax=ceil(xmax+.5);
                    end
                    
                    % for now, yes, the aspect ratio of the limits must be the same
                    range = max([ymax-ymin xmax-xmin]);
                    midPoints = [ymax+ymin xmax+xmin];
                    ymax = (midPoints(1) + range)/2;
                    ymin = (midPoints(1) - range)/2;
                    xmax = (midPoints(2) + range)/2;
                    xmin = (midPoints(2) - range)/2;
                    
                    % protect again NaNs in the axis limits. This can happen if all NaNs are received
                    % in the data. In that case, do not autoscale
                    SetAndApply(blk, 'XMin',mat2str(xmin), ...
                                'XMax',mat2str(xmax), ...
                                'YMin',mat2str(ymin), ...
                                'YMax',mat2str(ymax), ...
                                parent, 'eval');
                end
                
                
              case 1
                
                % protect again NaNs in the axis limits. This can happen if all NaNs are received
                % in the data. In that case, do not autoscale
                SetAndApply(blk, 'YMin',mat2str(ymin), ...
                            'YMax',mat2str(ymax), parent, 'eval');
                
              otherwise
                % Vector/Spectrum Scopes
                
                % Do not write new Y-axis limits to block (starting with R2009A).
                % Just update Y-axis limits in the figure.
                set(fig_data.main.haxis(1), 'YLim', [ymin ymax]);
                
                UpdateGrid(blk);  % Do this prior to repositioning frame # text
                UpdateFrameNumPos(blk);
                
                % if Zoom in use, save the newly computed ymin and ymax values for later use
                if fig_data.zoomInUse
                    fig_data.zoomedYLimits = [ymin ymax];
                    set(block_data.hfig, 'UserData', fig_data);
                end
                    
            end % switch block_type
        end
    end % if count>0
end
% ---------------------------------------------------------------
function CancelAutoscale(blk)

% Cancel any pending autoscale operation

block_data = get_param(blk,'UserData');

% No autoscale operation in progress:
if ~isfield(block_data,'autoscaling') || isempty(block_data.autoscaling)
    return;
end

htext = handle(block_data.autoscaling(4));
delete(htext);
block_data.autoscaling=[];
set_param(blk,'UserData', block_data);


% ---------------------------------------------------------------
function oneshot_autoscale(hfig)
% ONESHOT_AUTOSCALE Used when simulation is stopped
%   Cannot use multi-frame autoscale, since the simulation is no longer
%   running.  Instead, we compute a one-time ymin/ymax computation, and
%   apply it to the static scope result.

fig_data = get(hfig, 'UserData');
blk = fig_data.block;

block_data = get_param(blk,'userdata');
block_type = getfromancestor(blk,'block_type_',2);

switch block_type
    
  case 1
    
    switch block_data.cparams.str.dispDiagram,
      case 'In-phase Only',
        numAxes = 1;
      case 'In-phase and Quadrature',
        numAxes = 2;
      otherwise,
    end
    asXAxis = 0;
    udBlock = get_param(blk,'Parent');
    
  case 3
    
    asXAxis = 1;
    numAxes = 1;
    udBlock = get_param(blk,'Parent');
    
  otherwise
    
    asXAxis = 0;
    numAxes = 1;
    udBlock = blk;
    
end

% Get data for each line, and find min/max:
hline = fig_data.main.hline;

ymin=inf; ymax=-inf;

% check for field 'zoomInUse' before accessing it as not all Scopes have Zoom feature
if (isfield(fig_data,'zoomInUse') && fig_data.zoomInUse)
    % zoom in use - perform autoscale on the data currently visible
    
    for count = 1:numAxes,
        for i = 1:length(hline(:,count)),
            x = get(hline(i,count),'xdata');
            y = get(hline(i,count),'ydata');
            xMinIdx = find(x >= fig_data.zoomedXLimits(1), 1);
            xMaxIdx = find(x <= fig_data.zoomedXLimits(2), 1, 'last');
            y1 = y(xMinIdx:xMaxIdx);
            ymin = min(ymin, min(y1));
            ymax = max(ymax, max(y1));
        end
    end
    
else
    % zoom not in use - perform autoscale on full data
    
    for count = 1:numAxes,
        for i = 1:length(hline(:,count)),
            y = get(hline(i,count),'ydata');
            ymin = min(ymin, min(y));
            ymax = max(ymax, max(y));
        end
    end
    
end

% Protect against horizontal lines:
if (ymax==ymin),
    ymin=floor(ymin-.5);
    ymax=ceil(ymax+.5);
end

excessRange = 1.05;

if asXAxis,
    % do Xaxis autoscale as well
    % This is never the case for Vector/Spectrum Scopes
    
    xmin=inf; xmax=-inf;
    for count = 1:numAxes,
        for i=1:length(hline(:,count)),
            x = get(hline(i,count),'xdata');
            %            [min(x) max(x) xmin xmax]
            xmin = min(xmin, min(x));
            xmax = max(xmax, max(x));
        end
    end


    % for now, yes, the aspect ratio of the limits must be the same
    % If ymin or ymax are Inf/-Inf or NaN, then don't attempt to autoscale because
    % there is no data or all-NaNs data or data has Inf/-Inf
    if ~(any(isnan([ymin ymax xmin xmax])) || any(isinf([ymin ymax xmin xmax])) )
        range = max([ymax-ymin xmax-xmin])*excessRange;
        midPoints = [ymax+ymin xmax+xmin];
        ymax = (midPoints(1) + range)/2;
        ymin = (midPoints(1) - range)/2;
        xmax = (midPoints(2) + range)/2;
        xmin = (midPoints(2) - range)/2;
        
        % Protect against vertical lines:
        if (xmax==xmin),
            xmin=floor(xmin-.5);
            xmax=ceil(xmax+.5);
        end
        
        SetAndApply(blk, 'XMin',mat2str(xmin), ...
                    'XMax',mat2str(xmax), ...
                    'YMin',mat2str(ymin), ...
                    'YMax',mat2str(ymax), ...
                    udBlock, 'eval');
    end
    
else
    
    % If ymin or ymax are Inf/-Inf or NaN, then don't attempt to autoscale because
    % there is no data or all-NaNs data or data has Inf/-Inf
    if ~(any(isnan([ymin ymax])) || any(isinf([ymin ymax])) )

        range = (ymax-ymin)*excessRange;
        
        % We could divide the midpoint and the range by 2 immediately here: the
        % motivation for postponing the divide is that it's more accurate
        midpoint = (ymax+ymin);
        ymin = (midpoint - range)/2;
        ymax = (midpoint + range)/2;
        
        switch block_type
          case {1,3}
            % Comms Scopes
            
            SetAndApply(blk, 'YMin',mat2str(ymin), ...
                        'YMax',mat2str(ymax), udBlock, 'eval');
            
          otherwise
            % Vector/Spectrum Scope blocks
            
            % Do not write new Y-axis limits to block, starting with R2009A. 
            % Just update Y-axis limits in the figure.
            for idx=1:numAxes
                set(fig_data.main.haxis(idx), 'YLim', [ymin ymax]);
            end
            UpdateGrid(blk);  % Do this prior to repositioning frame # text
            UpdateFrameNumPos(blk);

            % if Zoom in use, save the newly computed ymin and ymax values for later use
            % check for field 'zoomInUse' before accessing it as not all Scopes have Zoom feature
            if (isfield(fig_data,'zoomInUse') && fig_data.zoomInUse)
                fig_data.zoomedYLimits = [ymin ymax];
                set(hfig, 'UserData', fig_data);
            end

        end
        
    end
    
end

% ---------------------------------------------------------------
function mdlTerminate(block) %% function sys = mdlTerminate
% TERMINATE Clean up any remaining items

%sfcn = gcb;
sfcnh = block.BlockHandle;
if isVectorScope(block) %% vector scope
    blk    = [get_param(sfcnh,'parent') '/' get_param(sfcnh,'Name')];
else %% spectrum scope
    blk    = get_param(sfcnh,'parent');
end

% Cancel any pending autoscale operation:
CancelAutoscale(blk);

% When using Graphics Version 1, redraw all lines in "normal" mode; when
% lines redraw over themselves in "xor" mode, dots are left at peaks
% without lines connecting to them. This can be visually misleading.
if matlab.graphics.internal.isGraphicsVersion1
    terminateLineEraseMode(blk);
end

% ---------------------------------------------------------------
function FigRefresh(hcbNotUsed, eventStructNotUsed, hfig) %#ok
% Refresh display while memory turned on

if nargin<3, hfig=gcbf; end
if ~isempty(hfig),
    refresh(hfig);
end

% ------------------------------------------------------------
function UpdateGrid(blk,numAxes)

if nargin < 2,
    numAxes = 1;
end
% UpdateGrid Draw scope grid for frame scope.

block_data = get_param(blk,'UserData');
if isempty(block_data.hfig) || ~ishghandle(block_data.hfig)
    return;
end
figPos = get(block_data.hfig,'position');
if figPos(4) < 5,
    return;
end
hax        = block_data.haxis;
hgrid      = block_data.hgrid;
hgridtext  = block_data.hgridtext;

% Determine if compact display (axis zoom) mode is on:
fig_data = get(block_data.hfig, 'UserData');
haxzoom  = fig_data.menu.axiszoom;
isZoom   = strcmp(get(haxzoom,'Checked'),'on');

ltgray  = ones(1,3)*.8;  % light gray for axis lines
ltgrayt = ones(1,3)*.6;  % slightly darker for grid labels

xtick = get(hax(numAxes),'xtick'); xn=length(xtick);
ytick = get(hax(numAxes),'ytick'); yn=length(ytick);
xlim  = get(hax(numAxes),'xlim');
ylim  = get(hax(numAxes),'ylim');

% Render the tick label values only in compact display mode:
use_xlabels = isZoom;
use_ylabels = isZoom;
% Select grid options:
isFreq = (block_data.params.Domain==2);
% Don't use centerline ticks in the Frequency domain plots:
centerline_ticks = ~isFreq;

% Major axis lines
% ----------------

% - vert lines
y=[ylim NaN]; y=repmat(y,1,xn);
xnan = NaN; xnan=xnan(ones(xn,1));
x=[xtick' xtick' xnan]'; x=x(:)';
x1=x; y1=y;

% - horiz lines
x=[xlim NaN]; x=repmat(x,1,yn);
ynan=NaN; ynan=ynan(ones(yn,1));
y=[ytick' ytick' ynan]'; y=y(:)';
x2=x; y2=y;

if centerline_ticks,
    % Create centerline tick marks:

    xmajor = min(diff(xtick)); xminor=xmajor/5;
    ymajor = min(diff(ytick)); yminor=ymajor/5;

    % Compute axis tick lengths
    % - Normalize tick lengths according to the data aspect ratio
    %   and the ratio of window length to height
    % - Must get out of normalized mode, since we need "absolute"
    %   units to compare in x- and y-dimensions.
    oldUnits=get(hax(numAxes),'units');
    set(hax(numAxes),'unit','pix');
    p = get(hax(numAxes),'pos');
    set(hax(numAxes),'unit',oldUnits);

    dar = get(hax(numAxes),'dataaspectratio');
    ar = dar(2)/dar(1) * p(3)/p(4);
    tylen = yminor/2;
    txlen = tylen/ar;

    % - x-axis ticks
    if rem(yn,2)==1,
        % odd # of y-ticks
        ymiddle=ytick((yn+1)/2);
    else
        % even # of y-ticks
        ymiddle=ytick((yn)/2);
    end

    % NOTE: xlim has nothing to do with where the actual grid    
    %     lines fall ... we need to find first minor grid position
    di = floor(abs(xlim(1) - xtick(1)) / xminor);
    xstart = xtick(1) - di * xminor;
    xend = xlim(2);  % fine to do this for xend
    x = xstart : xminor : xend;

    % remove grid line positions from x - they won't show up
    x = setdiff(round(x*1e5), round(xtick*1e5)) * 1e-5;
    nx=length(x);
    y=[ymiddle-tylen ymiddle+tylen NaN]; y=repmat(y,1,nx);
    x=[x' x' NaN*ones(nx,1)]'; x=x(:)';
    xc1=x; yc1=y;

    if rem(xn,2)==1,
        % odd # of x-ticks
        xmiddle=xtick((xn+1)/2);
    else
        % even # of x-ticks
        xmiddle=xtick(xn/2+1);
    end

    % NOTE: xlim has nothing to do with where the actual grid
    %     lines fall ... we need to find first minor grid position
    di = floor(abs(ylim(1) - ytick(1)) / yminor);
    ystart = ytick(1) - di * yminor;
    yend = ylim(2);  % fine to do this for xend
    y = ystart : yminor : yend;

    % remove grid line positions from y - they won't show up
    y = setdiff(round(y*1e5), round(ytick*1e5)) * 1e-5;
    ny=length(y);
    x=[xmiddle-txlen xmiddle+txlen NaN]; x=repmat(x,1,ny);
    y=[y' y' NaN*ones(ny,1)]'; y=y(:)';
    yc2=y; xc2=x;

else
    % No centerline ticks:
    xc1=[]; yc1=[];
    xc2=[]; yc2=[];

end

% Always get rid of any existing grid text labels first:
if ishghandle(hgridtext),
    delete(hgridtext);
end
hgridtext = [];

% Plot grid:
% ----------
x = [xc1 xc2 x1 x2];
y = [yc1 yc2 y1 y2];
if isempty(hgrid(numAxes)),
    hgrid(numAxes) = line('parent',hax(numAxes), 'xdata',x, 'ydata',y, 'color',ltgray);
else
    set(hgrid(numAxes),'xdata',x, 'ydata',y);
end

% Update labels:
% --------------
if any(use_xlabels) || any(use_ylabels)

    xt=get(hax(numAxes),'xtick');
    yt=get(hax(numAxes),'ytick');
    if length(xt)==1,
        dx=xt;
    else
        dx=xt(2)-xt(1);
    end
    if length(yt)==1,
        dy=yt;
    else
        dy=yt(2)-yt(1);
    end
    xlim=get(hax(numAxes),'xlim'); xmin=xlim(1); xmax=xlim(2);
    ylim=get(hax(numAxes),'ylim'); ymin=ylim(1); ymax=ylim(2);

    if use_ylabels,
        % Add new y-axis labels INSIDE grid

        % Remove first and last ticks if they are at start/end of ylimits
        ytt=yt;
        if isApproxEqual(ymin, ytt(1)),
            ytt(1)=[];
        end
        if isApproxEqual(ymax, ytt(end)),
            ytt(end)=[];
        end

        % Determine vertical text label placements
        ytxt = ytt;  % add a little bit so we can see it over the tick line?
        % start 10 percent of the way between the first x-ticks
        xtxt = xmin + dx*0.05;
        xtxt = xtxt(ones(size(ytxt)));

        % Determine vertical text strings:
        str=cell(1,length(ytt));
        for i=1:length(ytt),
            str{i}=sprintf('%+g',ytt(i));
        end
        hytext = text(xtxt,ytxt,str, ...
            'vert','base', ...
            'color',ltgrayt, 'parent',hax(numAxes));
    else
        hytext=[];
    end

    if use_xlabels,
        % Add new x-axis labels INSIDE grid

        % Remove first and last ticks if they are at start/end of ylimits
        xtt=xt;
        if isApproxEqual(xmin,xtt(1)),
            xtt(1)=[];
        end
        if isApproxEqual(xmax,xtt(end)),
            xtt(end)=[];
        end

        xtxt = xtt;
        ytxt = ymin + dy*0.05;
        ytxt = ytxt(ones(size(xtxt)));
        str=cell(1,length(xtt));
        for i=1:length(xtt),
            str{i}=sprintf('%g',xtt(i));  % don't use + sign
        end
        hxtext = text(xtxt,ytxt,str, ...
            'color',ltgrayt,'horiz','center','vert','bottom',...
            'parent',hax(numAxes));
    else
        hxtext = [];
    end

    % Store all text handles:
    hgridtext = [hxtext;hytext];
end

% Check AxisGrid setting, and make invisible if necessary:
%
switch getfromancestor(blk,'block_type_',2),
    case {1,3},
        % update parent block
        parent = get_param(blk,'parent');
        set([hgrid(numAxes);hgridtext],'vis', get_param(parent,'AxisGrid'));
    otherwise,
        % update block
        set([hgrid(numAxes);hgridtext],'vis', get_param(blk,'AxisGrid'));
end

% Reassign context menu to the grid:
fig_data = get(block_data.hfig,'UserData');
set([hgrid(numAxes);hgridtext], 'UIContextMenu', fig_data.menu.context);

% Always store the grid text handle vector (even if empty):
block_data.hgrid     = hgrid;
block_data.hgridtext = hgridtext;
set_param(blk,'UserData',block_data);

% Set parent figure color to ltgray:
hfig=get(hax(numAxes),'parent');
set(hfig,'color',ltgray);


% ------------------------------------------------------------
function names = getInputSignalNames(blk)
% getInputSignalNames
% Return cell-array of strings, one string per input.

% Scope only accepts on input port.
% A single channel is an input vector (1-D or 2-D)
% Multiple channels is a matrix input (2-D)
%
% If single channel,
%   - get name of the input signal
%
% If multiple channels,
%   If input is named,
%       - get name of input signal as base name
%         if non-empty, concatenate with "CH #"
%   If input is not named,
%     If driven by a Mux or a Matrix Concat block,
%         - get name of each signal driving mux
%
% Assign a default name "CH #" to each channel with a blank name.

block_data = get_param(blk,'UserData');
nchans = block_data.NChans;

if nchans==1,
    % Only one input port - 1-D or 2-D vector input
    %
    % Only one name will appear, if specified:
    names = get_param(blk,'InputSignalNames');

else
    % Multiple channels - matrix input

    % Populate return array with empty strings:
    str = {''};
    names = str(ones(1,nchans));

    % Get name of input matrix:
    baseName = get_param(blk,'InputSignalNames');

    % If it's empty, that's that - we live with default names
    if ~isempty(baseName{1}),
        % Input is named - concatenate channel # to base name
        if ~isempty(baseName),
            for i=1:length(names),
                names{i} = [baseName{1} ' - CH ' num2str(i)];
            end
        end
    else
        % Input matrix is not named
        %
        % If input is a mux or a matrix concatenation block,
        % get the names of its inputs:
        pc    = get_param(blk,'portconnectivity');
        ret  = strfind(get_param(pc.SrcBlock,'blocktype'), 'Concatenate');
        isMC = ~isempty(ret);
        isMux = strcmp(get_param(pc.SrcBlock,'blocktype'),'Mux');
        if isMC || isMux
            % Driven by a matrix concat block or a mux - get names of input ports:
            driver_blk = pc.SrcBlock;
            names = get_param(driver_blk,'InputSignalNames');

            % Verify that we have nchans number of signal names:
            num=length(names);
            if num < nchans,
                % Could have been a mux of muxes, etc.
                % Don't follow this path any longer.
                str={''};
                names = str(ones(1,nchans));
            elseif num > nchans,
                % Too many inputs to mux/cat block - just truncate names array:
                names = names(1:nchans);
            end
        end
    end
end

% Assign a default name to any unnamed channel:
% Default is 'CH #'
%
for i=1:length(names),
    if isempty(names{i}),
        names{i}=['CH ' num2str(i)];
    end
end

% ------------------------------------------------------------
function z = isApproxEqual(x,y)

% different if difference in the two numbers
% is more than 1 percent of the maximum of
% the two:
tol = max(abs(x),abs(y)) * 1e-2;
z = (abs(x-y) < tol);

% ---------------------------------------------------------------
function y = isOn(x)
y = strcmp(x,'on');


% ---------------------------------------------------------------
function y = lin2dB(x)
% Fast way to do "y = 10*log10(x)"
% We would like an input x>0 always, but we can't guarantee that.
% So we protect ourselves with the following:
%  - taking the absolute value of the input
%  - adding an eps-offset to combat zero-valued inputs
y = 10./log(10) .* log(abs(x)+eps(x));


% ---------------------------------------------------------------
function y = dB2lin(x)
y = 10.^(x./10) - eps(x);

% ------------------------------------------------------------
function u = computeOneSidedSpectrum(u, fftLength)
% Compute full-power one-sided spectrum for Spectrum Scope

if mod(fftLength,2)
    % odd FFT length
    p = (fftLength+1)/2;
    u(2:p,:) = 2*u(2:p,:);
    u = u(1:p,:);
else
    % even FFT length                      
    p = fftLength/2; 
    u(2:p,:) = 2*u(2:p,:);
    u = u(1:p+1,:);
end

% ------------------------------------------------------------
function u = computeTwoSidedSpectrum(u, fftLength)
% Compute two-sided spectrum for Spectrum Scope

% Rotate data for two-sided spectrum (i.e. (-Fn, Fn])
% rotate each channel of data:        
if mod(fftLength,2)
    % odd FFT length
    p = (fftLength+1)/2;  
    u = u([p+1:fftLength 1:p],:);
else
    % even FFT length
    p = fftLength/2;
    u = u([p+2:fftLength 1:p+1],:);
end

% ------------------------------------------------------------
% [EOF] sdspfscope2.m
