function UnwrapRegisterCompileCheck(block, muObj, varargin)
% UNWRAPREGISTERCOMPILECHECK Compile check registration function for Unwrap
% block with an 'Input processing' popup that must be reset from an
% inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated 
%    muObj    - model updater
%    object varargin - allows the function to be called by Comms Blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectInProcData, ...
    @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
% Encode data
% isFrame = 1
% isUnoriented = 1<<1 = 2
% isNonRow = 1<<2 = 4
% isRowVector  = 1<<3 = 8
% data = isFrame + isUnoriented + isNonRow + isRowVector
function data = CollectInProcData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);
tpDims  = get_param(block,'CompiledPortDimensions');
isUnoriented = (tpDims.Inport(1) == 1);
isRowVector = (tpDims.Inport(1) == 2) && (tpDims.Inport(2) == 1) && (tpDims.Inport(3) > 1);
isNonRow = (tpDims.Inport(1) == 2) && (~isRowVector);
% Encode data
data = isFrame + 2*isUnoriented + 4*isNonRow + 8*isRowVector;

%----------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, data)

if askToReplace(muObj, block)
    
    % Decode data
    isRowVector = (data >= 8);
    data = data - 8*isRowVector;
    isNonRow = (data >= 4);
    data = data - 4*isNonRow;
    isUnoriented = (data >= 2);
    isFrame      = mod(data,2);
    interFrameInterpOff = strcmpi(get_param(block,'running'),'on');
    
    if isFrame || isUnoriented || (isNonRow && interFrameInterpOff)
        % Frame-based processing cases are:
        % 1. frame-based inputs or
        % 2. Unoriented inputs or
        % 3. Sample-based non row input with InterFrameInterp OFF
        funcSet = uSafeSetParam(muObj, block, ...
            'InputProcessing', 'Columns as channels (frame based)');
        
    elseif isRowVector && interFrameInterpOff
        % row convenience case
        % input is sample-based row vector with InterFrameInterp OFF
        funcSet = {'InsertBlockUnwrapNewFrames', block};
        
        if (doUpdate(muObj))
            InsertBlockUnwrapNewFrames(block);
        end
        
    else
        % sample-based processing
        funcSet = uSafeSetParam(muObj, block, ...
            'InputProcessing', 'Elements as channels (sample based)');
    end
    
    reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, funcSet);
    
end

% [EOF]

% LocalWords:  frameness
