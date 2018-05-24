function SampleBasedProcessingRegisterCompileCheck(block, muObj)
% SAMPLEBASEDPROCESSINGREGISTERCOMPILECHECK Compile check registration
% function for blocks that have the 'Sample-based processing:' popup. The
% solution is to remove the block (it is in pass-through mode) before the
% block instance being updated.
%
%  Input arguments:
%    block - handle to the block being updated muObj - model updater object

% Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectSBProcData, ...
    @UpdateSBProcBlockNewFrames);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function blkInfo = CollectSBProcData(block, ~)

% Get frameness, dimensions, and var-size status of input signal
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.Dim            = get_param(block, 'CompiledPortDimensions');
% Is the input sample based?
blkInfo.isInputSB      = (blkInfo.Frame.Inport(1) == 0);

%-------------------------------------------------------------------------------
function UpdateSBProcBlockNewFrames(block, muObj, blkInfo)
% Post compile action:   

if isPassthrough(block)
    
    if askToReplace(muObj, block)
        
        funcSet = {};
        % Change SampleBasedProcessing parameter to 'Same as frame based' in all cases:
        funcSet{end+1} = uSafeSetParam(muObj, block, ...
            'SampleBasedProcessing', 'Same as frame based');
        
        if blkInfo.isInputSB
            blkLHandles = get_param(block, 'LineHandles');
            blkLHInport  = get(blkLHandles.Inport(1));
            blkLHOutport = get(blkLHandles.Outport(1));
            funcSet{end+1}  = {'RemoveBlockNewFrames', blkLHInport, blkLHOutport};
            
            if (doUpdate(muObj))
                RemoveBlockNewFrames(block, blkLHInport, blkLHOutport);
            end
            
            reasonStr = 'The block is in pass-through mode.';
            appendTransaction(muObj, block, reasonStr, {funcSet});
        end
        
    end
end

%-------------------------------------------------------------------------------
function result = isPassthrough(blk)
    result = strcmpi(get_param(blk, 'SampleBasedProcessing'), ...
        'Pass through (this choice will be removed - see release notes)');

%EOF    



% LocalWords:  frameness Tps
