function InProcRegisterCompileCheck(block, muObj, varargin)
% INPROCREGISTERCOMPILECHECK Compile check registration function for blocks
% with an 'Input processing' popup that must be reset from an inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object
%    varargin - allows the function to be called by Comms Blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectInProcData, ...
    @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectInProcData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%----------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Input processing'
% parameter to 'Columns as channels (Frame-based)' or 'Elements as channels
% (Sample-based)'.

if askToReplace(muObj, block)
        
    if isFrame
        % If frame bit is on then set it to Columns as channels
        funcSet = uSafeSetParam(muObj, block, ...
            'InputProcessing', 'Columns as channels (frame based)');
        
    else
        % If frame bit is off then set it to Elements as channels
        funcSet = uSafeSetParam(muObj, block, ...
            'InputProcessing', 'Elements as channels (sample based)');
    end
    
    reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, {funcSet});
    
end

% [EOF]

% LocalWords:  frameness
