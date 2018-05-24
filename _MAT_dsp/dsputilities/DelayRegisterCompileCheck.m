function DelayRegisterCompileCheck(block, muObj)
%DELAYREGISTERCOMPILECHECK This function is used to update the
%InputProcessing parameter on the SPC Delay block 
%
%  Input arguments:
%    block    - handle to the block being updated muObj    - model updater
%    object

%   Copyright 2011-2012 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectInProcData, @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function blkInfo = CollectInProcData(block, ~)

% Is input port a bus?

portHandles = get_param(block, 'Porthandles');
busType = get_param(portHandles.Inport(1), 'CompiledBusType');
if strcmp(busType, 'NOT_BUS')
    blkInfo.isBus = 0;
else
    blkInfo.isBus = 1;
end
    
% Get frameness of input signal

tp = get_param(block,'CompiledPortFrameData');

if blkInfo.isBus
    % First two entries of tp.Inport(1) will be -2 for bus and num elements
    % in the bus. Skip these.
    % all individual elements are frame-based if tp.Inport(3:end) are all
    % ones
    blkInfo.isFrame  = all(tp.Inport(3:end));
    blkInfo.isSample = ~any(tp.Inport(3:end));
else
    blkInfo.isFrame = tp.Inport(1) == 1;
end

%-------------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, blkInfo)
% Post compile action:


if blkInfo.isBus && ~blkInfo.isFrame && ~blkInfo.isSample
    % For mixed bus case, since no slupdate will be done, don't ask to do
    % it.
    return;
end

if askToReplace(muObj, block)
    if blkInfo.isBus
        if blkInfo.isFrame
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Columns as channels (frame based)');
            reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
            appendTransaction(muObj, block, reasonStr, {funcSet});

        elseif blkInfo.isSample 
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Elements as channels (sample based)');
            reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
            appendTransaction(muObj, block, reasonStr, {funcSet});
        end

    else
        if blkInfo.isFrame
            % If frame bit is on then set it to Columns as channels
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Columns as channels (frame based)');
        else
            % If frame bit is off then set it to Elements as channels
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Elements as channels (sample based)');
        end
        reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
        appendTransaction(muObj, block, reasonStr, {funcSet});
    end

end

% [EOF]
