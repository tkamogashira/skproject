function StwsCompileCheck(block, muObj)
% STWSCOMPILECHECK Compile check registration function for the
% Signal To Workspace block.
% The solution is ...
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

% Copyright 2010-2011 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectStwBlockData, ...
    @UpdateStwBlockNewFrames);

end

%--------------------------------------------------------------------------
function blkInfo = CollectStwBlockData(block, ~)

% Get frameness and value of Save2DSignal
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.SaveFormat     = get_param(block, 'SaveFormat');

end

%--------------------------------------------------------------------------
function UpdateStwBlockNewFrames(block, muObj, blkInfo)
          
    if askToReplace(muObj, block)

        isDataFrame = blkInfo.Frame.Inport(1)==1;


        if isDataFrame

            funcSet = uSafeSetParam(muObj, block, 'Save2DSignal', ...
                '2-D array (concatenate along first dimension)');

        else

            funcSet = uSafeSetParam(muObj, block, 'Save2DSignal', ...
             '3-D array (concatenate along third dimension)');

        end

        reasonStr = 'Reset ''Save 2-D signals as'' parameter for new frame processing'; 
        appendTransaction(muObj, block, reasonStr, {funcSet});

    end

end

%EOF

% LocalWords:  frameness DMode
