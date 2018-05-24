function InsertBlockRowConvNewFrames(blk, blkDim, isConvOrXCorrBlk, ...
    is1stInputRow, is2ndInputRow, isTpsBlkAfter)
% Function to insert Transpose blocks when the row convenience mode is on,
% depending on which block is being updated.
% 
% Parameters: 
%              blk: The row convenience block.
%           blkDim: The compiled block input/output dimension information.
% isConvOrXCorrBlk: Is the block a Convolution or Correlation block?
%    is1stInputRow: Is the first input is a row vector?
%    is2ndInputRow: Is the second input is a row vector? It is always false
%                   if isConvOrXCorrBlk is false.
%    isTpsBlkAfter: Is there a Transpose block needed after the block?
% 
% Copyright 2009-2010 The MathWorks, Inc.

% Get block line handles
blkLHandles = get_param(blk, 'LineHandles');

if isConvOrXCorrBlk
    % For Correlation/Convolution block that has 2 inports and 1 outport, 
    % add a Transpose block for each sample-based row input and output.
    if is1stInputRow % 1st inport is a 2-D row, add a Transpose block to it
        blkLHInport1 = get(blkLHandles.Inport(1));
        InsertOneTpsBlockNewFrames(blk, blkLHInport1, 'Pre', 40, 10);
    end
    
    if is2ndInputRow % 2nd inport is a 2-D row, add a Transpose block to it
        blkLHInport2 = get(blkLHandles.Inport(2));
        InsertOneTpsBlockNewFrames(blk, blkLHInport2, 'Pre', 40, -10);
    end
    
    % Output is a row vector or not
    isOutputRow = (2 == blkDim.Outport(1)) && ...
                  (1 == blkDim.Outport(2)) && ...
                  (1 <  blkDim.Outport(3));
    
    if isOutputRow % Add a Transpose block to the outport
        blkLHOutport = get(blkLHandles.Outport(1));
        InsertOneTpsBlockNewFrames(blk, blkLHOutport, 'Post', 40, 0);
    end
else  % For other blocks, always add a Transpose block to the first inport
    blkLHInport1  = get(blkLHandles.Inport(1));
    InsertOneTpsBlockNewFrames(blk, blkLHInport1, 'Pre', 40, 0);
    
    if isTpsBlkAfter % Add a Transpose block to the first outport
        blkLHOutport1 = get(blkLHandles.Outport(1));
        InsertOneTpsBlockNewFrames(blk, blkLHOutport1, 'Post', 40, 0);
        
        % When the block is Sort and it has both value and index outports,
        % add another Transpose block to the second outport.
        if (strcmpi(get_param(blk, 'MaskType'), 'Sort') && ...
            strcmpi(get_param(blk, 'otype'), 'Value and Index'))
            blkLHOutport2 = get(blkLHandles.Outport(2));
            InsertOneTpsBlockNewFrames(blk, blkLHOutport2, 'Post', 40, -20);
        end
    end
end

end

% [EOF]
% LocalWords:  XCorr nd Tps
