function TrigTowkCompileCheck(block, muObj)
% TRIGTOWKCOMPILECHECK Compile check registration function for the
% Triggered To Workspace block.
% The solution is ...
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

% Copyright 2011 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectTrigTowkBlockData, ...
    @UpdateTrigTowkNewFrames);

end

%--------------------------------------------------------------------------
function blkInfo = CollectTrigTowkBlockData(block, ~)

% Get frameness and value of Save2DMode
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.Save2DMode     = get_param(block, 'Save2DMode');

end

%--------------------------------------------------------------------------
function UpdateTrigTowkNewFrames(block, muObj, blkInfo)

      
    if askToReplace(muObj, block)
        
        isDataFrame = blkInfo.Frame.Inport(1)==1;
                                         
            
        if isDataFrame
            
            funcSet = uSafeSetParam(muObj, block, 'Save2DMode', ...
                '2-D array (concatenate along first dimension)');
           
        else
            
            funcSet = uSafeSetParam(muObj, block, 'Save2DMode', ...
             '3-D array (concatenate along third dimension)');
            
        end
                          
        reasonStr = 'Reset ''Save 2-D signals as'' parameter for new frame processing'; 
        appendTransaction(muObj, block, reasonStr, {funcSet});
        
    end
    
end

%EOF

% LocalWords:  frameness DMode
