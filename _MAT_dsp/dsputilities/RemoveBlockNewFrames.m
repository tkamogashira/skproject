function RemoveBlockNewFrames(blk, blkLHInport, blkLHOutport)

% To be used to remove a block that is a direct feedthrough

%   Copyright 2010 The MathWorks, Inc.

% Get the parent block full name
blkParentName = get_param(blk, 'Parent');

% Delete the line connecting to the block input and output ports
delete_line(blkLHInport.Handle);
delete_line(blkLHOutport.Handle);
delete_block(blk);

% Connect
fromBlkName    = get_param(blkLHInport.SrcBlockHandle,  'Name');
fromBlkPortNum = get_param(blkLHInport.SrcPortHandle, 'PortNumber');
toBlkName      = get_param(blkLHOutport.DstBlockHandle, 'Name');
toBlkPortNum   = get_param(blkLHOutport.DstPortHandle, 'PortNumber');

if ~iscell(toBlkName)
    add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
            [toBlkName   '/' int2str(toBlkPortNum)], ...
            'autorouting', 'on');
else
    % deal with fan-out
    for i=1:numel(toBlkName)
        add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
            [toBlkName{i}   '/' int2str(toBlkPortNum{i})], ...
            'autorouting', 'on');
    end
end
                    
% LocalWords:  autorouting
