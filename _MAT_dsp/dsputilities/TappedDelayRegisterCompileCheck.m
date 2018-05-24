function TappedDelayRegisterCompileCheck(block, muObj)
%TAPPEDDELAYREGISTERCOMPILECHECK
% This function is used to replace the Simulink Tapped Delay
%  block with the Unit Delay block in the user's model. Only the Tapped
%  Delay blocks that are supporting frame-based inputs need to be updated.
%  The ones with sample-based input will remain as is. Input arguments:
%    block    - handle to the block being updated muObj    - model updater
%    object

%   Copyright 2010 The MathWorks, Inc.   

appendCompileCheck(muObj, block, @CollectTappedDelayData, @ReplaceTappedDelayNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectTappedDelayData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%-------------------------------------------------------------------------------
function ReplaceTappedDelayNewFrames(block, muObj, isFrame)
% Post compile action:
% Replace Tapped Delay with Unit Delay when the input is frame-based
if isFrame
    if askToReplace(muObj, block)
        % Replace Tapped Delay with Unit Delay block
        funcSet = uReplaceBlock(muObj, block,'built-in/UnitDelay',...
            'X0',get_param(block, 'vinit'), ...
            'InputProcessing','Columns as channels (frame based)', ...
            'SampleTime', get_param(block, 'samptime'));
        appendTransaction(muObj, block, muObj.ReplaceBlockReasonStr, {funcSet});
    end
end

% [EOF]
