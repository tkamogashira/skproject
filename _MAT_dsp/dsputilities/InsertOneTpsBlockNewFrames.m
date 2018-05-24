function InsertOneTpsBlockNewFrames(blk, blkLHPort, preOrPost, ...
                                tpsBlkHOffset, tpsBlkVOffset)
% Insert a Transpose block given the inport/outport handle of the block
% instance being updated. The transpose block has the same height (width)
% as the instance block and width (height) 20 when the instance block
% is oriented horizontally (vertically).
%
% Parameters:
%           blk: The instance block.
%     blkLHPort: The (input/output) port of the instance block that
%                is to be connected to the newly inserted Transpose block.
%     preOrPost: A string to indicate the Transpose block is before or
%                after the instance block being updated.
% tpsBlkHOffset: A nonnegative value that is horizontal (vertical) distance
%                between the Transpose block and the instance block
%                that is oriented horizontally (vertically).
% tpsBlkVOffset: A value that is vertical (horizontal) distance between the
%                Transpose block and the instance block that is
%                oriented horizontally (vertically). There is no limitation
%                for this value, and the right/up direction is positive.
%
% Illustration for horizontally oriented instance block:
%
%                       |-------|
%                  |--->|  Blk  |---|                       ^
%                  |    |-------|   |                       |
%        'Pre'     |                |    |<- 20->|       VOffset
%      |-------|   |                |    |-------|          |
% ---->|  Tps  |---|                |--->|  Tps  |----->    v
%      |-------|                         |-------|
%          |<-- HOffset -->|              'Post'
%

%   Copyright 2010 The MathWorks, Inc.
%

% Get the parent block full name
blkParentName = get_param(blk, 'Parent');

% Get a random name for the Transpose block
[~ , tpsBlkName] = fileparts(tempname);
tpsBlkName = [blkParentName '/' tpsBlkName];

% Delete the line connecting from/to the port.
delete_line(blkLHPort.Handle);

% Orient the Transpose block w.r.t. the instance block being updated
blkPos    = get_param(blk, 'Position');
blkOrient = get_param(blk, 'Orientation');
blkCenter = mean([blkPos(1:2); blkPos(3:4)]);
blkWidth  = blkPos(3) - blkPos(1);
blkHeight = blkPos(4) - blkPos(2);

if strcmpi(blkOrient, 'left') || strcmpi(blkOrient, 'right')
    sign = (strcmpi(blkOrient, 'left')  && strcmpi(preOrPost, 'Pre')) ||...
           (strcmpi(blkOrient, 'right') && strcmpi(preOrPost, 'Post'));
    sign = sign * 2 - 1; % Map 0 to -1 and 1 to 1
    tpsBlkCenter = [blkCenter(1) + sign * (blkWidth/2 + tpsBlkHOffset),...
                    blkCenter(2) - tpsBlkVOffset];
    tpsBlkWidth  = 20;
    tpsBlkHeight = blkHeight;
elseif (strcmpi(blkOrient, 'up') || strcmpi(blkOrient, 'down'))
    sign = (strcmpi(blkOrient, 'up')   && strcmpi(preOrPost, 'Pre')) ||...
           (strcmpi(blkOrient, 'down') && strcmpi(preOrPost, 'Post'));
    sign = sign * 2 - 1; % Map 0 to -1 and 1 to 1
    tpsBlkCenter = [blkCenter(1) - tpsBlkVOffset,...
                    blkCenter(2) + sign * (blkHeight/2 + tpsBlkHOffset)];
    tpsBlkWidth  = blkWidth;
    tpsBlkHeight = 20;
end

tpsBlkPos = [tpsBlkCenter(1) - tpsBlkWidth  / 2, ...
             tpsBlkCenter(2) - tpsBlkHeight / 2, ...
             tpsBlkCenter(1) + tpsBlkWidth  / 2, ...
             tpsBlkCenter(2) + tpsBlkHeight / 2];

% Load dspmtrx3 library that contains the Transpose block.
load_system('dspmtrx3');

% Add the Transpose block and hide its name
tpsBlkHandle = add_block('dspmtrx3/Transpose', tpsBlkName, ...
                         'Position',           tpsBlkPos, ...
                         'Orientation',        blkOrient, ...
                         'ShowName',           'off');

tpsBlkPortH = get_param(tpsBlkHandle, 'PortHandles');

% Reconnect lines from the original source block to the Transpose block,
% and from the Transpose block to the original destination block.
fromBlkName    = get_param(blkLHPort.SrcBlockHandle, 'Name');
% If the block's name contains '/', replace it by '//'.
fromBlkName    = regexprep(fromBlkName, '/', '//');
fromBlkPortNum = get_param(blkLHPort.SrcPortHandle, 'PortNumber');
toBlkName      = get_param(tpsBlkHandle, 'Name');
toBlkPortNum   = get_param(tpsBlkPortH.Inport, 'PortNumber');
add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
                        [toBlkName   '/' int2str(toBlkPortNum)], ...
                        'autorouting', 'on');

fromBlkName    = get_param(tpsBlkHandle, 'Name');
fromBlkPortNum = get_param(tpsBlkPortH.Outport, 'PortNumber');
toBlkName      = get_param(blkLHPort.DstBlockHandle, 'Name');
% If the block's name contains '/', replace it by '//'.
toBlkName      = regexprep(toBlkName, '/', '//');
toBlkPortNum   = get_param(blkLHPort.DstPortHandle, 'PortNumber');
add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
                        [toBlkName   '/' int2str(toBlkPortNum)], ...
                        'autorouting', 'on');
end

% LocalWords:  LH tps HOffset VOffset dspmtrx autorouting
