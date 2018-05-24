function RateOptionsRegisterCompileCheck(block, muObj, varargin)
% RATEOPTIONSREGISTERCOMPILECHECK  Function to update the RateOptions
% parameter in multiple blocks.  This parameter governs whether the block
% operates in its frame-based mode or its sample-based mode.
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object
%    varargin - allows the function to be called by Comms Blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectRateOptionsData, ...
    @UpdateRateOptionsNewFrames);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectRateOptionsData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%-------------------------------------------------------------------------------
function UpdateRateOptionsNewFrames(block, muObj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Rate options'
% parameter to 'Enforce single-rate' or 'Allow multi-rate'.

if askToReplace(muObj, block)
    
    if isFrame
        % If frame bit is on then set it to Enforce single-rate
        funcSet = uSafeSetParam(muObj, block, ...
            'RateOptions', 'Enforce single-rate processing');
        
    else
        % If frame bit is off then set it to Allow multi-rate
        funcSet = uSafeSetParam(muObj, block, ...
            'RateOptions', 'Allow multirate processing');
    end
    
    reasonStr = 'Reset ''Rate options'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, {funcSet});
    
end

% [EOF]
% LocalWords:  RATEOPTIONSONLYREGISTERCOMPILECHECK frameness
