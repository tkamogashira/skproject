function DFDRegisterCompileCheck(block, muobj)
% DFDRegisterCompileCheck Compile check registration function for blocks
% with an 'Input processing' popup that must be reset from an inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

% Copyright 2011 The MathWorks, Inc.

% Collect block information under compile stage
appendCompileCheck(muobj, block, @CollectFrameData, ...
    @UpdateDFDesignBlock);
end

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectFrameData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);
end


function UpdateDFDesignBlock(block, muobj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Input processing'
% parameter to 'Columns as channels (Frame-based)' or 'Elements as channels
% (Sample-based)'.

inpProcInhStr = ...
    'Inherited (this choice will be removed - see release notes)';
hUD = get_param(block, 'userdata');

% consider sidebar was added after r13
if ~isfield(hUD, 'sidebar')
    hUD = r12p1_to_r13(hUD);
end

switch hUD.sidebar.currentpanel
    case 'design'
        if ~isfield(hUD.sidebar.design, 'InputProcessing')||...
                strcmp(hUD.sidebar.design.InputProcessing, inpProcInhStr)
            if askToReplace(muobj, block)
                funcSet = {'ModelUpdater.safeSetParam', block, isFrame};
                if isFrame
                    hUD.sidebar.design.InputProcessing = 'Columns as channels (frame based)';
                else
                    hUD.sidebar.design.InputProcessing = 'Elements as channels (sample based)';
                end
                hBlk      = get_param(block, 'handle');
                set(hBlk, 'UserData', saveobj(hUD));
                reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
                appendTransaction(muobj, block, reasonStr, {funcSet});
            end
        end
    case 'xform'
        if ~isfield(hUD.sidebar.xform, 'InputProcessing')||...
                strcmp(hUD.sidebar.xform.InputProcessing, inpProcInhStr)
            if askToReplace(muobj, block)
                funcSet = {'ModelUpdater.safeSetParam', block, isFrame};
                if isFrame
                    hUD.sidebar.xform.InputProcessing = 'Columns as channels (frame based)';
                else
                    hUD.sidebar.xform.InputProcessing = 'Elements as channels (sample based)';
                end
                hBlk      = get_param(block, 'handle');
                set(hBlk, 'UserData', saveobj(hUD));
                reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
                appendTransaction(muobj, block, reasonStr, {funcSet});
            end
        end
    case 'pzeditor'
        % special treat for pzeditor because it does not have the field in
        % sidebar before        
        if ~isfield(hUD.sidebar, 'pzeditor')||...
           ~isfield(hUD.sidebar.pzeditor, 'InputProcessing')||...
                strcmp(hUD.sidebar.pzeditor.InputProcessing, inpProcInhStr)
            if askToReplace(muobj, block)
                funcSet = {'ModelUpdater.safeSetParam', block, isFrame};
                if isFrame
                    hUD.sidebar.pzeditor.InputProcessing = 'Columns as channels (frame based)';
                else
                    hUD.sidebar.pzeditor.InputProcessing = 'Elements as channels (sample based)';
                end
                hBlk      = get_param(block, 'handle');
                set(hBlk, 'UserData', saveobj(hUD));
                reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
                appendTransaction(muobj, block, reasonStr, {funcSet});
            end
        end
    case 'import'
        if ~isfield(hUD.sidebar.import, 'InputProcessing')||...
                strcmp(hUD.sidebar.import.InputProcessing, inpProcInhStr)
            if askToReplace(muobj, block)
                funcSet = {'ModelUpdater.safeSetParam', block, isFrame};
                if isFrame
                    hUD.sidebar.import.InputProcessing = 'Columns as channels (frame based)';
                else
                    hUD.sidebar.import.InputProcessing = 'Elements as channels (sample based)';
                end
                hBlk      = get_param(block, 'handle');
                set(hBlk, 'UserData', saveobj(hUD));
                reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
                appendTransaction(muobj, block, reasonStr, {funcSet});
            end
        end
end
end

function s = r12p1_to_r13(s)

s.sidebar.design = s.fdspecs;
s.sidebar.import = s.import_specs;
if isfield(s,'quantize_specs'),
    oldquantize = true;
    s.sidebar.quantize = s.quantize_specs;
    if isfield(s,'quantizationswitch'),
        s.sidebar.quantize.switch = s.quantizationswitch;
    end
else
    oldquantize = false;
end

switch s.mode.current
case 1,
    mode = 'design';
case 2,
    mode = 'import';
case 3,
    if oldquantize
        mode = 'design';
    else
        mode = 'quantize';
    end
end

% Don't go to the quantization panel if we have old data.
s.sidebar.currentpanel = mode;

s.export = s.export_specs;

if strcmpi(s.analysis_mode, 'filterresponsespecs'),
    s.analysis_mode = '';
    sr = 'on';
else
    sr = 'off';
end

s.sidebar.design.StaticResponse = sr;

s.fvtool.currentAnalysis = s.analysis_mode;
s.convert                = s.convert_specs;
s.version                = 1.10;
end
