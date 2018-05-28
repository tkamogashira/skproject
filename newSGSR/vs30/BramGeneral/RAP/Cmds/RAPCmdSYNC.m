function [RAPStat, LineNr, ErrTxt] = RAPCmdSYNC(RAPStat, LineNr, OptArg)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   SYNC [AUTO/MAN]           Synchronize calculation parameters for current dataset
%                             with userdata interface (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if ~exist('OptArg', 'var'), [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat);
else,
    RAPStat.GenParam.SyncUDI = OptArg;
    if strcmpi(OptArg, 'auto') & ~isRAPStatDef(RAPStat, 'GenParam.DS'), 
        [RAPStat, ErrTxt] = SyncRAPDataset(RAPStat);    
    end
end

LineNr = LineNr + 1;