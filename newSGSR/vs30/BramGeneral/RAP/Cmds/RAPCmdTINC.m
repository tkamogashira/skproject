function [RAPStat, LineNr, ErrTxt] = RAPCmdTINC(RAPStat, LineNr, AxToken, ValToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   TINC X #                  Tic increment along X-axis
%   TINC X DEF                Default Tic increment along X-axis
%   TINC Y #                  Tic increment along Y-axis
%   TINC Y DEF                Default Tic increment along Y-axis
%-----------------------------------------------------------------------------------

ErrTxt = '';

if strcmp(AxToken, 'x'),
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Current abcis tick increment is %s.\n', ConvRAPStatTickInc(RAPStat.PlotParam.Axis.X.TickInc)); 
        end
    elseif ischar(ValToken) & strcmp(ValToken, 'def'), 
        RAPStat.PlotParam.Axis.X.TickInc = ManageRAPStatus('PlotParam.Axis.X.TickInc');
    else,
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [Inc, ErrTxt] = GetRAPFloat(RAPStat, ValToken);
        if ~isempty(ErrTxt), return; end
        if Inc <= 0, ErrTxt = 'Tick increment cannot be negative or zero'; return;
        else, RAPStat.PlotParam.Axis.X.TickInc = Inc; end    
    end
elseif strcmp(AxToken, 'y'),
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Current ordinate tick increment is %s.\n', ConvRAPStatTickInc(RAPStat.PlotParam.Axis.Y.TickInc)); 
        end
    elseif ischar(ValToken) & strcmp(ValToken, 'def'), 
        RAPStat.PlotParam.Axis.Y.TickInc = ManageRAPStatus('PlotParam.Axis.Y.TickInc');
    else, 
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [Inc, ErrTxt] = GetRAPFloat(RAPStat, ValToken);
        if ~isempty(ErrTxt), return; end
        if Inc <= 0, ErrTxt = 'Tick increment cannot be negative or zero'; return;
        else, RAPStat.PlotParam.Axis.Y.TickInc = Inc; end
    end
end

LineNr = LineNr + 1;