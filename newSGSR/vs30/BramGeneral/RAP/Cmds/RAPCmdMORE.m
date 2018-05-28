function [RAPStat, LineNr, ErrTxt] = RAPCmdMORE(RAPStat, LineNr, ToggleToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   MORE ON/OFF               Paging of the output in the command window (~)
%-----------------------------------------------------------------------------------

ErrTxt = '';

RAPStat.ComLineParam.More = lower(ToggleToken);
more(ToggleToken);

LineNr = LineNr + 1;