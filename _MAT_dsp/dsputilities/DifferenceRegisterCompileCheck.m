function DifferenceRegisterCompileCheck(block, muObj, varargin)
% DIFFERENCEREGISTERCOMPILECHECK Compile check registration function for 
% the Difference block "Running difference" popup that must be reset 
% from an inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object
%    varargin - allows the function to be called by Comms Blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectHistogramData, ...
    @UpdateDifferenceNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function blkInfo = CollectHistogramData(block, ~)

blkInfo.Frame = get_param(block, 'CompiledPortFrameData');
blkInfo.Width = get_param(block, 'CompiledPortWidths');

%----------------------------------------------------------------------------
function UpdateDifferenceNewFrames(block, muObj, blkInfo)
% Post compile action: 
% Depending on the input signal frameness and block parameter settings, 
% set the 'Running difference' parameter to 'Yes' or 'No'.

isInputFrame = blkInfo.Frame.Inport(1);

if askToReplace(muObj, block)
    if isInputFrame && (strcmpi(get_param(block,'dim'), 'Columns') || ...
       (strcmpi(get_param(block, 'dim'), 'Specified dimension') && ...
       (blkInfo.Width.Inport(1) == blkInfo.Width.Outport(1))))
        % If input is frame-based and difference operation is along columns
        % or 1st dimension, set the 'Running difference' parameter to
        % 'Yes'. Note that we avoid reading the 'Dimension' editbox
        % parameter (it could be a variable); Instead, we decide if the
        % block is in running mode from its input/output width.
        funcSet = uSafeSetParam(muObj, block, 'Run', 'Yes'); 
        if ~strcmpi(get_param(block,'dim'), 'Columns') % Defensive code
            funcSet = uSafeSetParam(muObj, block, 'dim', 'Columns'); 
        end
    else
        % In all the other cases, set the 'Running difference' parameter to
        % 'No'.
        funcSet = uSafeSetParam(muObj, block, 'Run', 'No');
    end
    
    reasonStr = 'Reset ''Running difference'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, {funcSet});    
end

% [EOF]

% LocalWords:  frameness