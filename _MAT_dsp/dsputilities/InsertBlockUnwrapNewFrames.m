function InsertBlockUnwrapNewFrames(blk)
% Function to insert Transpose blocks when the row convenience mode is on
%
% Parameters:
%              blk: The row convenience block.
%
% Copyright 2010 The MathWorks, Inc.

set_param(blk, 'InputProcessing', 'Columns as channels (frame based)');
        
% Get block line handles
blkLHandles = get_param(blk, 'LineHandles');

blkLHInport1 = get(blkLHandles.Inport(1));
InsertOneTpsBlockNewFrames(blk, blkLHInport1, 'Pre', 40, 0);

blkLHOutport = get(blkLHandles.Outport(1));
InsertOneTpsBlockNewFrames(blk, blkLHOutport, 'Post', 40, 0);

end

% [EOF]
%
