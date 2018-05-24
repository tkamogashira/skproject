function BiasRegisterCompileCheck(block, muObj)
%BIASREGISTERCOMPILECHECK This function is to update the built-in Bias
%  block when the input is a frame-based full matrix and the bias parameter
%  is a row vector.
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

%   Copyright 2010-2011 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectBiasData, @UpdateBiasNewFrames);

%--------------------------------------------------------------------------
function frameParams = CollectBiasData(block, ~)
% Collect block information under compile stage

tp = get_param(block,'CompiledPortFrameData');
frameParams.isFrame = tp.Inport(1);
td = get_param(block,'CompiledPortDimensions');
frameParams.inDims = td.Inport(2:end);

%--------------------------------------------------------------------------
function UpdateBiasNewFrames(block, muObj, frameParams)
% Post compile action.

inDims = frameParams.inDims;
bias   = evalin('base', get_param(block, 'Bias'));

if ((frameParams.isFrame) && (inDims(1)) > 1 && (inDims(2) > 1) && ~isscalar(bias))
    % Update block only when the input is a frame-based full matrix and the
    % bias parameter is a row vector
    if askToReplace(muObj, block)
        funcSet = {'BiasBlockUpdate', block, muObj, inDims};

        if (doUpdate(muObj))
            BiasBlockUpdate(block, muObj, inDims);
        end
        
        reasonStr = 'Support of frame-based signals is being removed from the Bias block';

        appendTransaction(muObj, block, reasonStr, {funcSet});
    end    
end

%--------------------------------------------------------------------------
function BiasBlockUpdate(block, muObj, inDims) 

blkLHandles  = get_param(block, 'LineHandles');
blkLHInport  = get(blkLHandles.Inport(1));
blkLHOutport = get(blkLHandles.Outport(1));

% Insert a Frame Conversion block before the Bias block
toSampleBlock = insertFrameConvBlock(block, blkLHInport, 'Pre', 30, 0);
uSafeSetParam(muObj, toSampleBlock, 'OutFrame', 'Sample-based');

% Expand the bias parameter to a full matrix
newBias = ['repmat(', get_param(block, 'Bias'), ', ', num2str(inDims(1)), ', 1)'];
uSafeSetParam(muObj, block, 'Bias', newBias);

% Insert a Frame Conversion block after the Bias block
toFrameBlock = insertFrameConvBlock(block, blkLHOutport, 'Post', 30, 0);
uSafeSetParam(muObj, toFrameBlock, 'OutFrame', 'Frame-based');

%--------------------------------------------------------------------------
function frmConvBlkHandle = insertFrameConvBlock(blk, blkLHPort, ...
                            preOrPost, frmConvBlkHOffset, frmConvBlkVOffset)
% Insert a Frame Conversion block given the inport/outport handle of the
% block instance being updated. The Frame Conversion block has the same
% height (width) as the instance block and width (height) 20 when the
% instance block is oriented horizontally (vertically).
%
% Parameters:
%               blk: The instance block.
%         blkLHPort: The (input/output) port of the instance block that is
%                    to be connected to the Frame Conversion block.
%         preOrPost: A string to indicate the Frame Conversion block is 
%                    before or after the instance block being updated.
% frmConvBlkHOffset: A nonnegative value that is horizontal (vertical) 
%                    distance between the Frame Conversion block and the 
%                    instance block that is oriented horizontally 
%                    (vertically).
% frmConvBlkVOffset: A value that is vertical (horizontal) distance between 
%                    the Frame Conversion block and the instance block that 
%                    is oriented horizontally (vertically). There is no 
%                    limitation for this value, and the right/up direction 
%                    is positive.
%
% Illustration for horizontally oriented instance block:
%
%                       |-------|
%                  |--->|  Blk  |---|                       ^
%                  |    |-------|   |                       |
%        'Pre'     |                |    |<- 20->|       VOffset
%      |-------|   |                |    |-------|          |
% ---->|  Frm  |---|                |--->|  Frm  |----->    v
%      |-------|                         |-------|
%          |<-- HOffset -->|              'Post'

% Get the parent block full name
blkParentName = get_param(blk, 'Parent');

% Get a random name for the Frame Conversion block
[~ , frmConvBlkName] = fileparts(tempname);
frmConvBlkName = [blkParentName '/' frmConvBlkName];

% Delete the line connecting from/to the port.
delete_line(blkLHPort.Handle);

% Orient the Frame Conversion block w.r.t. the instance block being updated
blkPos    = get_param(blk, 'Position');
blkOrient = get_param(blk, 'Orientation');
blkCenter = mean([blkPos(1:2); blkPos(3:4)]);
blkWidth  = blkPos(3) - blkPos(1);
blkHeight = blkPos(4) - blkPos(2);

if strcmpi(blkOrient, 'left') || strcmpi(blkOrient, 'right')
    sign = (strcmpi(blkOrient, 'left')  && strcmpi(preOrPost, 'Pre')) ||...
           (strcmpi(blkOrient, 'right') && strcmpi(preOrPost, 'Post'));
    sign = sign * 2 - 1; % Map 0 to -1 and 1 to 1
    frmConvBlkCenter = [blkCenter(1) + sign * (blkWidth/2 + frmConvBlkHOffset),...
                        blkCenter(2) - frmConvBlkVOffset];
    frmConvBlkWidth  = 20;
    frmConvBlkHeight = blkHeight;
elseif (strcmpi(blkOrient, 'up') || strcmpi(blkOrient, 'down'))
    sign = (strcmpi(blkOrient, 'up')   && strcmpi(preOrPost, 'Pre')) ||...
           (strcmpi(blkOrient, 'down') && strcmpi(preOrPost, 'Post'));
    sign = sign * 2 - 1; % Map 0 to -1 and 1 to 1
    frmConvBlkCenter = [blkCenter(1) - frmConvBlkVOffset,...
                        blkCenter(2) + sign * (blkHeight/2 + frmConvBlkHOffset)];
    frmConvBlkWidth  = blkWidth;
    frmConvBlkHeight = 20;
end

frmConvBlkPos = [frmConvBlkCenter(1) - frmConvBlkWidth  / 2, ...
                 frmConvBlkCenter(2) - frmConvBlkHeight / 2, ...
                 frmConvBlkCenter(1) + frmConvBlkWidth  / 2, ...
                 frmConvBlkCenter(2) + frmConvBlkHeight / 2];

% Load dspsigattribs library that contains the Frame Conversion block
load_system('dspsigattribs');

% Add the Frame Conversion block and hide its name
frmConvBlkHandle = add_block('dspsigattribs/Frame Conversion', frmConvBlkName, ...
                             'Position',    frmConvBlkPos, ...
                             'Orientation', blkOrient, ...
                             'ShowName',    'off');
   
frmConvBlkPortH = get_param(frmConvBlkHandle, 'PortHandles');

% Reconnect lines from the original source block to the Frame Conversion 
% block, and from the Frame Conversion block to the original destination 
% block.
fromBlkName    = get_param(blkLHPort.SrcBlockHandle, 'Name');
% If the block's name contains '/', replace it by '//'.
fromBlkName    = regexprep(fromBlkName, '/', '//');
fromBlkPortNum = get_param(blkLHPort.SrcPortHandle, 'PortNumber');
toBlkName      = get_param(frmConvBlkHandle, 'Name');
toBlkPortNum   = get_param(frmConvBlkPortH.Inport, 'PortNumber');
add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
                        [toBlkName   '/' int2str(toBlkPortNum)], ...
                        'autorouting', 'on');

fromBlkName    = get_param(frmConvBlkHandle, 'Name');
fromBlkPortNum = get_param(frmConvBlkPortH.Outport, 'PortNumber');
toBlkName      = get_param(blkLHPort.DstBlockHandle, 'Name');
% If the block's name contains '/', replace it by '//'.
toBlkName      = regexprep(toBlkName, '/', '//');
toBlkPortNum   = get_param(blkLHPort.DstPortHandle, 'PortNumber');
add_line(blkParentName, [fromBlkName '/' int2str(fromBlkPortNum)], ...
                        [toBlkName   '/' int2str(toBlkPortNum)], ...
                        'autorouting', 'on');

% [EOF]
