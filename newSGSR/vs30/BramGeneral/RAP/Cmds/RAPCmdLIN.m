function [RAPStat, LineNr, ErrTxt] = RAPCmdLIN(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   LIN XX/YX                 X-,Y-axis to be linear
%-----------------------------------------------------------------------------------

ErrTxt = '';

if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end

switch Token
case 'xx', RAPStat.PlotParam.Axis.X.Scale = 'linear';
case 'yx', RAPStat.PlotParam.Axis.Y.Scale = 'linear';  
end

LineNr = LineNr + 1;