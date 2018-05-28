function [RAPStat, LineNr, ErrTxt] = RAPCmdAUTO(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 07-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   AUTO XX                   Auto-scaling for X-axis
%   AUTO YX                   Auto-scaling for Y-axis
%   AUTO AX                   Auto-scaling for X-, Y-axis
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   This command also resets the ticks along the specified axis ...
%-----------------------------------------------------------------------------------

ErrTxt = '';

switch Token,
case 'xx',
    RAPStat.PlotParam.Axis.X.Limits  = ManageRAPStatus('PlotParam.Axis.X.Limits');
    RAPStat.PlotParam.Axis.X.TickInc = ManageRAPStatus('PlotParam.Axis.X.TickInc');
    RAPStat.PlotParam.Axis.X.Scale   = ManageRAPStatus('PlotParam.Axis.X.Scale');
case 'yx',
    RAPStat.PlotParam.Axis.Y.Limits  = ManageRAPStatus('PlotParam.Axis.Y.Limits');
    RAPStat.PlotParam.Axis.Y.TickInc = ManageRAPStatus('PlotParam.Axis.Y.TickInc');
    RAPStat.PlotParam.Axis.Y.Scale   = ManageRAPStatus('PlotParam.Axis.Y.Scale');
case 'ax',
    RAPStat.PlotParam.Axis.X.Limits  = ManageRAPStatus('PlotParam.Axis.X.Limits');
    RAPStat.PlotParam.Axis.X.TickInc = ManageRAPStatus('PlotParam.Axis.X.TickInc');
    RAPStat.PlotParam.Axis.X.Scale   = ManageRAPStatus('PlotParam.Axis.X.Scale');
    RAPStat.PlotParam.Axis.Y.Limits  = ManageRAPStatus('PlotParam.Axis.Y.Limits');
    RAPStat.PlotParam.Axis.Y.TickInc = ManageRAPStatus('PlotParam.Axis.Y.TickInc');
    RAPStat.PlotParam.Axis.Y.Scale   = ManageRAPStatus('PlotParam.Axis.Y.Scale');
end

LineNr = LineNr + 1;