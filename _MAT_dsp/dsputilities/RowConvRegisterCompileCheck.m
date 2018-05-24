function RowConvRegisterCompileCheck(block, muObj)
% ROWCONVREGISTERCOMPILECHECK Compile check registration function for blocks
% that implicitly or explicitly support row convenience. The solution is to add
% Transpose block(s) before (and sometimes after) the block instance being
% updated when row convenience happens.
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

% Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectRowConvBlockData, ...
    @UpdateRowConvBlockNewFrames);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function blkInfo = CollectRowConvBlockData(block, ~)

% Get frameness, dimensions, and var-size status of input signal
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.Dim            = get_param(block, 'CompiledPortDimensions');
blkInfo.Width          = get_param(block, 'CompiledPortWidths');
blkPortH               = get_param(block, 'PortHandles');
if ~isempty(blkPortH.Inport)
    % It is possible that the Window Function block has no input port
    blkInfo.isInpVarSize = ...
        get_param(blkPortH.Inport(1),'CompiledPortDimensionsMode');
else
    blkInfo.isInpVarSize = false;
end

%-------------------------------------------------------------------------------
function UpdateRowConvBlockNewFrames(block, muObj, blkInfo)
% Post compile action: 
% Depending on the frameness, dims, and var-size status of the input signal,
% insert a Transpose block before (and maybe after) the block being updated.

% Row convenience does not happen by default
isRowConv = false;

% First input is sample-based or not
if ~isempty(blkInfo.Frame.Inport)
    % It is possible that the Window Function block has no input port
    is1stInputSB = (blkInfo.Frame.Inport(1) == 0);    
else % If there are no inports, the block can never be in row conv. mode.
    is1stInputSB = false;
end

% We do nothing if the input is variable-size or frame-based
if ~blkInfo.isInpVarSize && is1stInputSB
    % First input is a row vector or not
    is1stInputRow = (2 == blkInfo.Dim.Inport(1)) && ...
                    (1 == blkInfo.Dim.Inport(2)) && ...
                    (1 <  blkInfo.Dim.Inport(3));

    % Get block mask type
    blkMaskType = get_param(block, 'MaskType');

    % Is the block a Convolution or Correlation block.
    isConvOrXCorrBlk = any(strcmpi(blkMaskType, ...
        {'Correlation', 'Convolution'}));

    % Get the row index of this block in rowConvList
    [~, ~, ~, ~, rowConvList] = dspGetFrameUpgradeList;
    rowIdxRowConv = find(strcmp(blkMaskType, rowConvList(:, 1)));

    % Second input is sample-based or not
    is2ndInputRow = false;  % Only used for Convolution/Correlation block.
    % Is there a Transpose block needed after the block being updated.
    isTpsBlkAfter = rowConvList{rowIdxRowConv, 5};

    if isConvOrXCorrBlk
        % Handle Correlation or Convolution block separately. At this
        % point, it is not clear that row convenience happens to it or not.
        is2ndInputSB = (blkInfo.Frame.Inport(2) == 0);    
        isRowConv = false;
        
        if is1stInputSB && is2ndInputSB 
            is1stInputCol = (2 == blkInfo.Dim.Inport(1)) && ...
                            (1 <  blkInfo.Dim.Inport(2)) && ...
                            (1 == blkInfo.Dim.Inport(3));

            is1stInputScalar = (1 == blkInfo.Width.Inport(1));
                        
            is2ndInputRow = ...
                (2 == blkInfo.Dim.Inport(2 + blkInfo.Dim.Inport(1))) && ...
                (1 == blkInfo.Dim.Inport(3 + blkInfo.Dim.Inport(1))) && ...
                (1 <  blkInfo.Dim.Inport(4 + blkInfo.Dim.Inport(1)));

            is2ndInputCol = ...    
                (2 == blkInfo.Dim.Inport(2 + blkInfo.Dim.Inport(1))) && ...
                (1 <  blkInfo.Dim.Inport(3 + blkInfo.Dim.Inport(1))) && ...
                (1 == blkInfo.Dim.Inport(4 + blkInfo.Dim.Inport(1)));

            is2ndInputScalar = (1 == blkInfo.Width.Inport(2));
            
            isRowConv = ...
                (is1stInputRow && ~is2ndInputCol && ~is2ndInputScalar)||...
                (is2ndInputRow && ~is1stInputCol && ~is1stInputScalar);            
        end
    elseif is1stInputRow && ...
            isRowConvEnabled(block, rowConvList{rowIdxRowConv, [1, 3, 4]})
        % Row convenience happens to this block. Add a Transpose block
        % before (and/or after) the block instance being updated.
        isRowConv = true; % Row convenience happens
    end
end

if isRowConv % Insert Transpose block(s) if needed
    if askToReplace(muObj, block)
        funcSet = {'InsertBlockRowConvNewFrames', block, blkInfo.Dim, ...
            isConvOrXCorrBlk, is1stInputRow, is2ndInputRow, isTpsBlkAfter};

        if (doUpdate(muObj))
            InsertBlockRowConvNewFrames(block, blkInfo.Dim, ...
                isConvOrXCorrBlk, is1stInputRow, is2ndInputRow, ...
                isTpsBlkAfter);
        end

        reasonStr = 'The sample-based row input is treated as a column.';
        appendTransaction(muObj, block, reasonStr, {funcSet});
    end
end

%--------------------------------------------------------------------------          
function rowConvEnabled = isRowConvEnabled(blk, blkMaskType, ...
                          isExplicitRowConv, rowConvChkboxName)
% This function is to check if row convenience mode is enabled by the block

if isExplicitRowConv % Explicit row convenience 
    % Row convenience checkbox is visible or not
    switch blkMaskType
        case {'Minimum', 'Maximum'}
            isRowConvVis = ~strcmpi(get_param(blk, 'fcn'), 'Running') &&...
                strcmpi(get_param(blk, 'operateOver'), 'Each column');
        case {'Mean', 'Standard Deviation', 'Variance', 'RMS'}
            isRowConvVis = strcmpi(get_param(blk, 'run'), 'off') &&...
                strcmpi(get_param(blk, 'directionMode'), 'Each column');
        case 'Median'
            isRowConvVis = strcmpi(get_param(blk, 'directionMode'), 'Each column');
        case 'Normalization'
            isRowConvVis = strcmpi(get_param(blk, 'NormOver'), 'Each column');
        otherwise
            isRowConvVis = false; % For safety
    end
    
    % Row convenience is enabled when the checkbox is visible and checked.
    rowConvEnabled = isRowConvVis && ...
                     strcmpi(get_param(blk, rowConvChkboxName), 'on');
else % Implicit row convenience
    if ~isempty(rowConvChkboxName)
        % Row convenience is determined by a hidden parameter.
        rowConvEnabled = strcmpi(get_param(blk, rowConvChkboxName), 'on');
    else % Row convenience is always enabled.
        rowConvEnabled = true;
    end
end

% [EOF]
% LocalWords:  frameness RMS
