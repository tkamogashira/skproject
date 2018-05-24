function TransferFcnLeadLagRegisterCompileCheck(block, h)
% Copyright 2012 The MathWorks, Inc.

appendCompileCheck(h, block, @CollectFrameData, @ReplaceTFLeadLagBlock);

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
function ReplaceTFLeadLagBlock(block, h, isFrame)
if isFrame
    if askToReplace(h, block)
        oldEntries = GetMaskEntries(block);
        num = [1 -1*str2double(oldEntries{2})];
        den = [1 -1*str2double(oldEntries{1})];
        funcSet = uReplaceBlock(h, block,'simulink/Discrete/Discrete Filter',...
                    'FilterStructure', 'Direct form I',...
                    'InputProcessing', 'Columns as channels (frame based)', ...
                    'Numerator',   ['[' num2str(num) ']'], ...
                    'Denominator', ['[' num2str(den) ']'], ...
                    'InitialStates', oldEntries{4}, ...
                    'InitialDenominatorStates',oldEntries{3});
        
        appendTransaction(h, block, h.ReplaceBlockReasonStr, {funcSet});
    end
end

end
