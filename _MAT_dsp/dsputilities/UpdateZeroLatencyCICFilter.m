function UpdateZeroLatencyCICFilter(block, h)
% method for converting zero-latency CIC filter to non-zero latency CIC filter
% 

%   Copyright 2009 The MathWorks, Inc.

if askToReplace(h, block)    
    
    blkParams = GetMaskEntries(block);
    if strcmp(blkParams{3},'Zero-latency decimator')
        reasonStr = 'Replace ''Zero-latency decimator'' by ''Decimator''';
        funcSet = uSafeSetParam(h, block,'ftype','Decimator');
        appendTransaction(h, block, reasonStr, {funcSet});
    end
    if strcmp(blkParams{3},'Zero-latency interpolator')
        reasonStr = 'Replace ''Zero-latency interpolator'' by ''Interpolator''';
        funcSet = uSafeSetParam(h, block,'ftype','Interpolator');
        appendTransaction(h, block, reasonStr, {funcSet});
    end
end
