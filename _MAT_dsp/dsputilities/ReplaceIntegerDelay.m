% Function: ReplaceIntegerDelay ==============================
% This function is used to replace the obsoleted Integer Delay block with
% the 'Delay' block in dspsigops.mdl in user's models. 

function ReplaceIntegerDelay(block, h)
%ReplaceDSPConstant Replaces obsolete DSP Constant with Simulink's built-in
%Constant block. 
% Only updates the blocks used in sample-based mode correctly so far. 
% 
if askToReplace(h, block)    
    oldEntries = GetMaskEntries(block);

    oldDelayValue           = oldEntries{1};
    oldICVal              = oldEntries{2};
    
    % Default settings for the 'Constant' block. 
    diffICChan   = 'off';
    diffICDly    = 'off';
    delayVal     = str2num(oldDelayValue);
    icValS        = oldICVal;
    oldIcValNumeric =  str2num(oldICVal);
    
    ableToUpdate = true;
    if (numel(delayVal) == 1) 
        % scalar delay. 
        if (numel(oldIcValNumeric)>1)
            diffICDly = 'on';
            if (ndims(oldIcValNumeric) == 3)
                diffICChan = 'on';
                % Convert numeric array into a cell array
                icValN = cell(size(oldIcValNumeric,1), size(oldIcValNumeric,2));
                icValS = '{';
                for row = 1:size(icValN,1)
                    for col = 1:size(icValN,2)
                        icValS =  strcat(icValS,' [');
                        icValN{row,col} = squeeze(oldIcValNumeric(row,col,:))';
                        icValS =  strcat(icValS,num2str(icValN{row,col}),'] ');
                    end
                    if (row < size(icValN,1))
                        icValS = strcat(icValS,';');
                    end
                end                
                icValS = strcat(icValS,'}');
            end
        end
    else
        if (numel(oldIcValNumeric)>1)
            if (ndims(oldIcValNumeric) == 3)
                diffICDly = 'on';
                diffICChan = 'on';
                
                icValN = cell(size(oldIcValNumeric,1), size(oldIcValNumeric,2));
                icValS = '{';                
                maxDly = size(oldIcValNumeric,3);
                for row = 1:size(icValN,1)
                    for col = 1:size(icValN,2)                        % Look at the corresponding delay value to
                        % determine the size of this cell. 
                        icValS =  strcat(icValS,' [');
                        thisDly = delayVal(row,col);
                        icValN{row,col} = squeeze(oldIcValNumeric(row,col,(maxDly-thisDly+1):maxDly))';
                        icValS =  strcat(icValS,num2str(icValN{row,col}),'] ');                        
                    end
                    if (row < size(icValN,1))
                        icValS = strcat(icValS,';');
                    end                    
                end  
                icValS = strcat(icValS,'}');                                
            else
                % New delay block doesn't support this mode, can't
                % slupdate. 
                ableToUpdate = false;
                disp('Unable to update this instance since the new Delay block does not have this functionality, try using a variable integer delay block instead');
            end
        end
    end
    if   (ableToUpdate)
        % now replace the block with the bult-in Constant block
         funcSet = uReplaceBlock(h, block,'dspsigops/Delay',...
                    'ic',icValS,...
                    'delay',oldEntries{1},...
                    'dif_ic_for_ch',diffICChan,...
                    'reset_popup',oldEntries{3},...
                    'dif_ic_for_dly',diffICDly);
        appendTransaction(h, block, h.ReplaceBlockReasonStr, {funcSet});
    end
end



