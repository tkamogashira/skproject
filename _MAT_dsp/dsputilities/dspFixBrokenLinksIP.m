function dspFixBrokenLinksIP(unlnkBlk, newBlk)
%dspFixBrokenLinksIP(unlnkBlk, newBlk)
%
% Fix Input Processing for broken link block.
% Called by slupdate.

%   Copyright 2011 The MathWorks, Inc.
                              
    newBlkParams   = localGetDialogParams(newBlk);
    unlnkBlkParams = localGetDialogParams(unlnkBlk);
    
    unlnkBlkHasIP     = localHasParam(unlnkBlkParams, 'InputProcessing');
    newBlkHasFraming  = localHasParam(newBlkParams, 'framing');         
    unlnkBlkHasFmode  = localHasParam(unlnkBlkParams, 'fmode');        

    if ~unlnkBlkHasIP
        if unlnkBlkHasFmode
            set_param(newBlk, 'InputProcessing', ...
                'Inherited (this choice will be removed - see release notes)');                
        elseif ~newBlkHasFraming
            % Only InputProcessing
            set_param(newBlk, 'InputProcessing', ...
                'Inherited (this choice will be removed - see release notes)');                                                                                                                                                          
        end
    end
end

function dialogParams = localGetDialogParams(block)
    dialogParams = fields(get_param(block, 'DialogParameters'));    
end

function result = localHasParam(dialogParams, paramName)    
    result = ~isempty(find(cell2mat(strfind(dialogParams, ...
        paramName)), 1));
end

% END dspFixBrokenLinksIP
