function [StatTb, Nsub, NsubRec, Err] = readEDFStatTb(fid, DsLoc, StatTbParam, IndepVarParam)

%B. Van de Sande 03-10-2003

Err = 0; NsubRec = []; StatTb = struct([]);
switch StatTbParam.Type
case 2
    %Status Tables of type II are generated while recording and thus the order in the pointers reflect the order 
    %in which the stimuli were presented. When presenting stimuli with more than one independent variable, then 
    %the last independent variable is varied first, followed by the others in opposite order. So the Y-variable
    %always varies faster than the X-variable, and the Z variable if present varies faster than the Y variable.
    %An entry for spontanious activity is always stored, even if there is only one independent variable, when the
    %first independent variable changes (X variable).
    %A negative pointer designates that that entry wasn't recorded.
    %Attention! Sch012 and sch016, the only schemes that are used in the datasets that Philip recorded, use only
    %a maximum of two independent variables. This implementation works only for two variables. Moreover this 
    %implementation can't handle multiple pointers.
    
    NVar   = length(IndepVarParam);
    Ranges = cellfun('length', {IndepVarParam.Values});
    
    if StatTbParam.NPtr > 1
        Err = 2;
        return
    end
    if NVar > 2
        Err = 3;
        return
    end
    
    NEntries = (StatTbParam.NPtr * prod(Ranges)) + Ranges(1);
    fseek(fid, StatTbParam.Loc, 'bof');
    StatTb = freadVAXG(fid, NEntries, 'int32');
    
    if NVar > 1
        NElemBtwSpon = StatTbParam.NPtr * prod(Ranges(2:end));
    else NElemBtwSpon = 1;
    end    
    idx = sum([1:Ranges(1); 0, cumsum(repmat(NElemBtwSpon, 1, Ranges(1)-1))]);
    StatTb(idx) = [];
    
    StatTb(StatTb <= 0) = NaN;
    StatTb = 4*(StatTb-1) + 512*(DsLoc - 1);
    
    Nsub    = size(StatTb, 1);
    NsubRec = sum(~isnan(StatTb), 1);
otherwise
        Err = 1;
end 