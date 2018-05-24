function TransferFcnFirstOrderRegisterCompileCheck(block, h)
% Copyright 2012 The MathWorks, Inc.

appendCompileCheck(h, block, @CollectFrameData, @ReplaceTFFirstOrderBlock);

end

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectFrameData(block, ~)
% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

end

%--------------------------------------------------------------------------
% Reshape column vector coefficient port input to row vector
function ReplaceTFFirstOrderBlock(block, h, isFrame)
if isFrame
    if askToReplace(h, block)
        oldEntries = GetMaskEntries(block);
        num = [1-str2double(oldEntries{1}) 0];
        den = [1 -1*str2double(oldEntries{1})];
        ic  = str2double(oldEntries{2}) / (1-str2double(oldEntries{1}));
        funcSet = uReplaceBlock(h, block,sprintf('simulink/Discrete/Discrete\nTransfer Fcn'),...
                    'InputProcessing', 'Columns as channels (frame based)', ...
                    'Numerator',   ['[' num2str(num) ']'], ...
                    'Denominator', ['[' num2str(den) ']'], ...
                    'InitialStates', num2str(ic));
        
        appendTransaction(h, block, h.ReplaceBlockReasonStr, {funcSet});
    end
end

end
