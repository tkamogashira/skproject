function [RAPStat, LineNr, ErrTxt] = RAPCmdTemplate(RAPStat, LineNr)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   SWP                       Swap foreground and background dataset
%-----------------------------------------------------------------------------------

ErrTxt = '';

if isRAPStatDef(RAPStat, 'GenParam.DataFile'), ErrTxt = 'Datafile not yet specified'; return; end

%Swapping actual datasets and accompanying calculation parameters ...
RAPStat = SwapRAPDataSets(RAPStat);
    
%Reset plot parameters ...
RAPStat.PlotParam = ManageRAPStatus('PlotParam');
%Start a new figure ...
RAPStat = NewRAPFigure(RAPStat);

%Synchronize calculation parameters with UDI if requested ...
if strcmpi(RAPStat.GenParam.SyncUDI, 'auto') & ~isRAPStatDef(RAPStat, 'GenParam.DS'), 
    [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat); 
    if ~isempty(ErrTxt) return; end
end

%Displaying information ...
if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
    if isRAPStatDef(RAPStat, 'GenParam.DS'), fprintf('No foreground dataset loaded.\n');
    else, 
        [dummy, dummy, dsID] = unraveldsID(RAPStat.GenParam.DS.SeqID);
        fprintf('Foreground dataset is %s (%d).\n', dsID, RAPStat.GenParam.SeqNr); 
    end
    if isRAPStatDef(RAPStat, 'GenParam.DS2'), fprintf('No background dataset loaded.\n');
    else, 
        [dummy, dummy, dsID] = unraveldsID(RAPStat.GenParam.DS2.SeqID);
        fprintf('Background dataset is %s (%d).\n', dsID, RAPStat.GenParam.SeqNr2); 
    end
end

LineNr = LineNr + 1;