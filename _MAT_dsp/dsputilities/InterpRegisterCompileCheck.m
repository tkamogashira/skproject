function InterpRegisterCompileCheck(block, muObj)
% INTERPREGISTERCOMPILECHECK Compile check registration function for the
% Interpolation block.
% The solution is ...
%
%  Input arguments:
%    block - handle to the block being updated
%    muObj - model updater object

% Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectInterpBlockData, ...
    @UpdateInterpBlockNewFrames);

end

%--------------------------------------------------------------------------
function blkInfo = CollectInterpBlockData(block, ~)

% Get frameness, dimensions of input signal
blkInfo.Frame          = get_param(block, 'CompiledPortFrameData');
blkInfo.Dim            = get_param(block, 'CompiledPortDimensions');

% Get Interpolation points info
blkInfo.InterpSource   = get_param(block, 'InterpSource');
blkInfo.InterpPointsParam = get_param(block, 'InterpPoints');
blkInfo.InterpPointsValue   = [];

if strcmp(blkInfo.InterpSource, 'Specify via dialog')
    % Get Interpolation points info from dialog
    maskwsvars = get_param(block, 'MaskWSVariables');
    for i=1:length(maskwsvars)
        if strcmp(maskwsvars(i).Name, 'InterpPoints')
            blkInfo.InterpPointsValue = maskwsvars(i).Value;
        end
    end    
end

end

%--------------------------------------------------------------------------
function UpdateInterpBlockNewFrames(block, muObj, blkInfo)

need2TransposeDialogPts = false;
need2TransposePortPts   = false;
need2TransposeData      = false;
hasPointsPort = length(blkInfo.Frame.Inport)==2;
isDataFrame = blkInfo.Frame.Inport(1)==1;
isDataRowVector = isInPortRowVector(blkInfo, 1);
isDataColVector = isInPortColVector(blkInfo, 1);
    
    if strcmp(blkInfo.InterpSource, 'Specify via dialog')
        
        isIndexRowVector = isDialogPtsRowVector(blkInfo.InterpPointsValue);               
        
        if isIndexRowVector && ~isDataFrame     
            need2TransposeDialogPts = true;                                                
        end
        
        if isIndexRowVector && isDataFrame  && isDataColVector
            need2TransposeDialogPts = true;
        end
        
    elseif hasPointsPort
            % Interpolation points are from second port
        
        isPtsRowVector = isInPortRowVector(blkInfo, 2);
        isPtsFrame = blkInfo.Frame.Inport(2)==1;
        
        if isPtsRowVector && ~isPtsFrame
            need2TransposePortPts = true;
        end                                  
        
    end
    
    if ~isDataFrame && isDataRowVector
        need2TransposeData = true;
    end
            
    if need2TransposeDialogPts || need2TransposePortPts || need2TransposeData
        
        if askToReplace(muObj, block)
            
            funcSet = {};
            
            reasonStr = '';
            
            if need2TransposeDialogPts
                
                if (doUpdate(muObj))                
                    uSafeSetParam(muObj, block, 'InterpPoints', ...
                    ['(', blkInfo.InterpPointsParam, ')''']);
                end            

                funcSet{end+1} = ...
                    {'uSafeSetParam', muObj, block, 'InterpPoints', ...
                    ['(', blkInfo.InterpPointsParam, ')''']};
                
                reasonStr = 'The interpolation points row vector is treated as a column. ';
            
            end
            
            if need2TransposePortPts || need2TransposeData            
                blkLHandles = get_param(block, 'LineHandles');
            end
            
            if need2TransposePortPts
                
                % Insert the flip block at points port
               
                blkLHInterpInport = get(blkLHandles.Inport(2));

                if (doUpdate(muObj))
                    InsertOneTpsBlockNewFrames(block, ...
                        blkLHInterpInport, 'Pre', 40, -20);
                end

                funcSet{end+1} = ...
                    {'InsertOneTpsBlockNewFrames', muObj, block, ...
                    blkLHInterpInport, 'Pre', 40, -20};
                
                reasonStr = 'The interpolation points row vector is treated as a column. ';
            end
            
            if need2TransposeData
                
                % Insert flip blocks at data in port and out port
                
                blkLHDataInport = get(blkLHandles.Inport(1));
                blkLHDataOutport = get(blkLHandles.Outport(1));
                
                if hasPointsPort
                    hOffset = 30;
                    vOffset = 20;
                else
                    hOffset = 30;
                    vOffset = 0;
                end
                
                
                if (doUpdate(muObj))
                    
                    InsertOneTpsBlockNewFrames(block, ...
                        blkLHDataInport, 'Pre', hOffset, vOffset);
                    InsertOneTpsBlockNewFrames(block, ...
                        blkLHDataOutport, 'Post', 40, 0);
                end
                    
                funcSet{end+1} = ...
                    {'InsertOneTpsBlockNewFrames', muObj, block, ...
                    blkLHDataInport, 'Pre', hOffset, vOffset};
                funcSet{end+1} = ...
                    {'InsertOneTpsBlockNewFrames', muObj, block, ...
                    blkLHDataOutport, 'Post', 40, 0};
                
                reasonStr = [reasonStr, 'The data row vector is treated as a column.'];
                
            end           
    
            appendTransaction(muObj, block, reasonStr, {funcSet});
            
        end % Ask to replace
        
    end % Should replace       

end

%--------------------------------------------------------------------------
function result = isDialogPtsRowVector(dialogPts)
% Returns true if the dialog points is a row vector

    sz = size(dialogPts);
    
    if length(sz) > 2
        result = false;
    elseif (sz(1) == 1) && (sz(2) > 1)
        result = true;
    else
        result = false;
    end
            
end

%--------------------------------------------------------------------------
function result = isInPortRowVector(blkInfo, port)
% Returns true if the port input is a row vector
        
    if port==2
        % Offset to skip to points port
        offset = blkInfo.Dim.Inport(1)+1;
    else
        offset = 0;
    end

    result = ((blkInfo.Dim.Inport(offset+1) == 2) && ...
        (blkInfo.Dim.Inport(offset+2) == 1) && ...
        (blkInfo.Dim.Inport(offset+3) > 1));       

end

%--------------------------------------------------------------------------
function result = isInPortColVector(blkInfo, port)
% Returns true if the port input is a column vector
        
    if port==2
        % Offset to skip to points port
        offset = blkInfo.Dim.Inport(1)+1;
    else
        offset = 0;
    end

    result = ((blkInfo.Dim.Inport(offset+1) == 2) && ...
        (blkInfo.Dim.Inport(offset+2) > 1) && ...
        (blkInfo.Dim.Inport(offset+3) == 1));

end

%EOF

% LocalWords:  frameness WS Tps
