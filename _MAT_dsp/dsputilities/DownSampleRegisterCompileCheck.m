function DownSampleRegisterCompileCheck(block, muObj, varargin)
% DOWNSAMPLEREGISTERCOMPILECHECK Compile check registration function for
% Downsample blocks with an 'Input processing' popup that must be reset
% from an inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object
%    varargin - allows the function to be called by Comms blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectInProcData, ...
    @UpdateInProcNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectInProcData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%----------------------------------------------------------------------------
function UpdateInProcNewFrames(block, muObj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Input processing'
% parameter to 'Columns as channels (Frame-based)' or 'Elements as channels
% (Sample-based)'.

if askToReplace(muObj, block)
        
    if isFrame
        inputProcessingValue = 'Columns as channels (frame based)';
        fmode = get_param(block,'fmode');
        if strcmpi(fmode, 'Maintain input frame size')
            rateOptionsValue = 'Allow multirate processing';
        else
            rateOptionsValue = 'Enforce single-rate processing';
        end
       
    else
        inputProcessingValue = 'Elements as channels (sample based)';
        smode = get_param(block, 'smode');
        if strcmpi(smode, 'Allow multirate')
            rateOptionsValue = 'Allow multirate processing';
        else
            rateOptionsValue = 'Enforce single-rate processing';
        end
        
    end
    funcSet = uSafeSetParam(muObj, block, ...
                            'InputProcessing', inputProcessingValue, ...
                            'RateOptions', rateOptionsValue);
        
    reasonStr = 'Reset ''Input processing'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, {funcSet});
    
end

% [EOF]

% LocalWords:  frameness fmode smode
