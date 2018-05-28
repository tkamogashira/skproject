function [RAPStat, LineNr, ErrTxt] = RAPCmdED(RAPStat, LineNr, MacroFileName)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   ED @@..@@		          Edit specified macro (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Parsing of macro filename ...
[FullFileName, MacroFileName, ErrTxt] = ParseMCOFileName(RAPStat, MacroFileName);
if ~isempty(ErrTxt), return;
else, edit(FullFileName); end

LineNr = LineNr + 1;