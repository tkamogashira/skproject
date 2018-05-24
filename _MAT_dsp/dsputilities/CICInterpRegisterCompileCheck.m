function CICInterpRegisterCompileCheck(block, muObj)
% CICINTERPREGISTERCOMPILECHECK Compile check registration function for the CIC
% Interpolation block, which has a 'Rate options' popup and an 'Input
% processing' popup
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectCICInterpData, ...
    @UpdateCICInterpNewFrames);

%--------------------------------------------------------------------------
% Collect block information under compile stage
function isFrame = CollectCICInterpData(block, ~)

% Get frameness of input signal
tp      = get_param(block,'CompiledPortFrameData');
isFrame = tp.Inport(1);

%----------------------------------------------------------------------------
function UpdateCICInterpNewFrames(block, muObj, isFrame)
% Post compile action: 
% Depending on the frameness of the input signal, set the 'Input processing'
% parameter to 'Columns as channels (Frame-based)' or 'Elements as channels
% (Sample-based)'.

if askToReplace(muObj, block)
    
    % The 'Input processing' parameter needs updating only if the CIC
    % Interpolation block is in single-rate mode.
    rateOption = get_param(block, 'framing');
    if ( strcmpi(rateOption, 'Enforce single-rate') || ...
            strcmpi(rateOption, 'Maintain input frame rate') )
        
        if isFrame
            % If frame bit is on then set it to Columns as channels
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Columns as channels (frame based)');
            
        else
            % If frame bit is off then set it to Elements as channels
            funcSet = uSafeSetParam(muObj, block, ...
                'InputProcessing', 'Elements as channels (sample based)');
        end
        
        reasonStr = ...
            'Reset ''Input processing'' parameter for new frame processing';
        appendTransaction(muObj, block, reasonStr, {funcSet});
        
    end
    
end

% [EOF]

% LocalWords:  frameness
