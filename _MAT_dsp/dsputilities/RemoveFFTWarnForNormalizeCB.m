function RemoveFFTWarnForNormalizeCB(block, h)
%ReplaceDSPConstant Replaces obsolete DSP Constant with Simulink's built-in
%Constant block. 
% 

%   Copyright 2008-2010 The MathWorks, Inc.

if askToReplace(h, block)    
    reason = 'Stop seeing the warning in FFT block, caused by moving the Scaling checkbox from fixed-pt tab to Main tab';
    blkParams = GetMaskEntries(block);
    if ~strcmp(blkParams{2},'NEW')
        funcSet = uSafeSetParam(h, block,'TableOpt','NEW');
        appendTransaction(h, block, reason, {funcSet});
    end
end
