function SLDelayRegisterCompileCheck(block, muObj)
%SLDELAYREGISTERCOMPILECHECK This function is used to update the
%InputProcessing parameter on Unit Delay and Integer Delay blocks for
%frame-based inputs. The ones with sample-based input will remain the same
%
%  Input arguments:
%    block    - handle to the block being updated muObj    - model updater
%    object

%   Copyright 2010 The MathWorks, Inc.   

appendCompileCheck(muObj, block, @CollectInProcData, @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectInProcData(block, ~)

% Get frameness of input signal
tp = get_param(block,'CompiledPortFrameData');
if length(tp.Inport) == 1
    isFrame = tp.Inport(1) == 1;
else
    % bus input
    % all individual elements are frame-based if tp.Inport(3:end) are all
    % ones
    isFrame = all(tp.Inport(3:end));
end

%-------------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, isFrame)
% Post compile action:
% Update the InputProcessing parameter when the input is frame-based
if isFrame
    if askToReplace(muObj, block)
        inputProcessingValue = 'Columns as channels (frame based)';
        try
            y = find_system(block);
        catch
            y = [];
        end
        if ~isempty(y)
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', inputProcessingValue);
            reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
            appendTransaction(muObj, block, reasonStr, {funcSet});
        end
    end
end

% [EOF]
