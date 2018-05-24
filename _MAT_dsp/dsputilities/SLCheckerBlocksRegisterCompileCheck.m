function SLCheckerBlocksRegisterCompileCheck(block, muObj)
%SLCHECKERBLOCKREGISTERCOMPILECHECK This function is used to update the
%SamplingMode parameter on Inport, Outport and Signal Spec blocks for the
%'Frame based' setting. The ones with 'Sample based' setting will remain
%the same
%
%  Input arguments:
%    block    - handle to the block being updated muObj    - model updater
%    object

%   Copyright 2011 The MathWorks, Inc.   

appendCompileCheck(muObj, block, @CollectInProcData, @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectInProcData(block, ~)

% Get SamplingMode setting
isFrame = strcmpi(get_param(block,'SamplingMode'), 'Frame based');

%-------------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, isFrame)
% Post compile action:
% Update the InputProcessing parameter when the input is frame-based
if isFrame
    if askToReplace(muObj, block)
        SamplingModeValue = 'auto';
        funcSet = uSafeSetParam(muObj, block, ...
            'SamplingMode', SamplingModeValue);
        reasonStr = 'Reset ''Sampling mode'' parameter for new frame processing';
        appendTransaction(muObj, block, reasonStr, {funcSet});
    end
end

% [EOF]
