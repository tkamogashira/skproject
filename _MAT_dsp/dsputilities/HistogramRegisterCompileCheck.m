function HistogramRegisterCompileCheck(block, muObj, varargin)
% HISTOGRAMREGISTERCOMPILECHECK Compile check registration function for 
% the Histogram block "Find the histogram over" popup that must be reset 
% from an inherited mode
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object
%    varargin - allows the function to be called by Comms Blocks

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectHistogramData, ...
    @UpdateHistogramNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectHistogramData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%----------------------------------------------------------------------------
function UpdateHistogramNewFrames(block, muObj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Find the 
% histogram over' parameter to 'Entire input (sample-based)' or 
% 'Each column (frame-based)'.

if askToReplace(muObj, block)
        
    if isFrame
        % If frame bit is on then set it to Each column
        funcSet = uSafeSetParam(muObj, block, ...
            'operateOver', 'Each column');                        
    else
        % If frame bit is off then set it to Entire input
        funcSet = uSafeSetParam(muObj, block, ...
            'operateOver', 'Entire input');    
    end
    
    reasonStr = 'Reset ''Find the histogram over'' parameter for new frame processing';
    appendTransaction(muObj, block, reasonStr, {funcSet});
    
end

% [EOF]

% LocalWords:  frameness
