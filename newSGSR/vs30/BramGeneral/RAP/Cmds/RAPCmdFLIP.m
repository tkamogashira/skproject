function [RAPStat, LineNr, ErrTxt] = RAPCmdFLIP(RAPStat, LineNr, XXToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-04-2004

%-------------------------------------RAP Syntax------------------------------------
%   FLIP XX                   Flip X-axis (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if isRAPStatDef(RAPStat, 'GenParam.DS')
    ErrTxt = 'No dataset specified';
    return
end

if strcmpi(RAPStat.PlotParam.Axis.X.Flip, 'yes')
    RAPStat.PlotParam.Axis.X.Flip = 'no';
else
    RAPStat.PlotParam.Axis.X.Flip = 'yes';
end

LineNr = LineNr + 1;
