function TreatMby1RegisterCompileCheck(block, muObj)
% TREATMBY1REGISTERCOMPILECHECK Compile check registration function for blocks
% that have the 'Treat Mx1 and unoriented sample-based signals as:' popup.
% The solution is to add a transpose block before the block instance being
% updated.
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

% Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectTreatMby1BlockData, ...
    @UpdateTreatMby1BlockNewFrames);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function blkInfo = CollectTreatMby1BlockData(block, ~)

% Get frameness, dimensions of input signal
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.Dim            = get_param(block, 'CompiledPortDimensions');
% Is the input sample based?
blkInfo.isInputSB      = (blkInfo.Frame.Inport(1) == 0);

%-------------------------------------------------------------------------------
function UpdateTreatMby1BlockNewFrames(block, muObj, blkInfo)
% Post compile action:

if isTreatMby1MChannels(block)
    
    if askToReplace(muObj, block)
        
        funcSet = {};
        
        % Change TreatMby1Signal parameter to 'One channel' in all cases:
        funcSet{end+1} = uSafeSetParam(muObj, block, 'TreatMby1Signals', 'One channel');
                                              
        % If block input is sample-based unoriented or column vector, insert
        % a flip block at the input to the instance block.
        
        if (needFlipBlock(blkInfo))
            
            % Insert the flip block.
            blkLHandles = get_param(block, 'LineHandles');
            blkLHInport  = get(blkLHandles.Inport(1));

            funcSet{end+1} = ...
                {'InsertOneTpsBlockNewFrames', block, blkLHInport, 'Pre', 40, 0};

            if (doUpdate(muObj))
                InsertOneTpsBlockNewFrames(block, blkLHInport, 'Pre', 40, 0);
            end
            
            reasonStr = 'The sample-based unoriented or column input is treated as a row.';
            
        else
            reasonStr = 'Setting ''Treat Mx1 and unoriented sample-based signals'' to library default.';
        end
        
        appendTransaction(muObj, block, reasonStr, {funcSet});
                                                           
    end % askToReplace
end

%-------------------------------------------------------------------------------
function result = isTreatMby1MChannels(blk)
    result = strcmpi(get_param(blk, 'TreatMby1Signals'), ...
        'M channels (this choice will be removed - see release notes)');
    
%-------------------------------------------------------------------------------
function result = needFlipBlock(blkInfo)
    
    if blkInfo.isInputSB
        isInputUnorientedVector = ((blkInfo.Dim.Inport(1) == 1) && ...
                                   (blkInfo.Dim.Inport(2) > 1));
        if isInputUnorientedVector
            result = true;
        else
            isInputColumnVector = ((blkInfo.Dim.Inport(1) == 2) && ...
                                   (blkInfo.Dim.Inport(2) > 1) && ...
                                   (blkInfo.Dim.Inport(3)== 1));
                               
            if (isInputColumnVector)
                result = true;
            else
                result = false;
            end
        
        end                
    else
        result = false;
    end
%EOF    

% LocalWords:  frameness Tps
