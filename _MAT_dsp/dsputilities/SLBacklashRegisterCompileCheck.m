function SLBacklashRegisterCompileCheck(block, muObj)
%SLBACKLASHREGISTERCOMPILECHECK This function is used to update the
%InputProcessing parameter on Backlash and Relay blocks for
%frame-based inputs. The ones with sample-based input will remain the same
%
%  Input arguments:
%    block    - handle to the block being updated muObj    - model updater
%    object

%   Copyright 2011 The MathWorks, Inc.   

appendCompileCheck(muObj, block, @CollectInProcData, @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectInProcData(block, ~)

% Get frameness of input signal
tp = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%-------------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, isFrame)
% Post compile action:
% Update the InputProcessing parameter when the input is frame-based
if isFrame
    if askToReplace(muObj, block)
        inputProcessingValue = 'Columns as channels (frame based)';
        funcSet = uSafeSetParam(muObj, block, ...
            'InputProcessing', inputProcessingValue);
        reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
        appendTransaction(muObj, block, reasonStr, {funcSet});
    end
end

% [EOF]
