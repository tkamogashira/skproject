function [RAPStat, LineNr, ErrTxt] = RAPCmdPP(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   PP #	                  Plots per page
%   PP # #                    Plots/page in X and Y-direction (*)
%   PP X #                    Plots/page in X-direction
%   PP Y #                    Plots/page in Y-direction
%   PP X/Y DEF                Plots/page in X- or Y-dir to default
%   PP DEF                    Plots/page to default along X- and Y-direction
%-----------------------------------------------------------------------------------

%-----------------------------------implementation details--------------------------
%   The command PP changes the requested layout setting and starts a new figure, so
%   the layout of the current figure is discarded.
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args = varargin; NArgs = length(Args); 
DefValue = ManageRAPStatus('PlotParam.Figure.Layout.Requested');

%Setting the requested layout ...
if (NArgs == 0),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        Layout = GetRAPLayout(RAPStat); 
        if all(isnan(Layout)), Str = 'default'; else Str = mat2str(Layout); end
        fprintf('Current figure layout is %s.\n', Str); 
    end
elseif (NArgs == 1) & ischar(Args{1}) & strcmp(Args{1}, 'def'), 
    RAPStat.PlotParam.Figure.Layout.Requested = DefValue;
elseif (NArgs == 1) & isRAPInt(Args{1}),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Args{1}, ErrTxt] = GetRAPInt(RAPStat, Args{1});
    if ~isempty(ErrTxt), return; end
    if Args{1} <= 0, ErrTxt = 'Invalid range'; return;
    else, RAPStat.PlotParam.Figure.Layout.Requested = repmat(round(sqrt(Args{1})), 1, 2); end
elseif (NArgs == 2) & ischar(Args{1}) & strcmp(Args{1}, 'x') & ischar(Args{2}) & strcmp(Args{2}, 'def'),
    RAPStat.PlotParam.Figure.Layout.Requested(1) = DefValue(1); 
elseif (NArgs == 2) & ischar(Args{1}) & strcmp(Args{1}, 'x') & isRAPInt(Args{2}),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Args{2}, ErrTxt] = GetRAPInt(RAPStat, Args{2});
    if ~isempty(ErrTxt), return; end
    if Args{2} <= 0, ErrTxt = 'Invalid range'; return;
    else, RAPStat.PlotParam.Figure.Layout.Requested(1) = Args{2}; end
elseif (NArgs == 2) & ischar(Args{1}) & strcmp(Args{1}, 'y') & ischar(Args{2}) & strcmp(Args{2}, 'def'), 
    RAPStat.PlotParam.Figure.Layout.Requested(2) = DefValue(2); 
elseif (NArgs == 2) & ischar(Args{1}) & strcmp(Args{1}, 'y') & isRAPInt(Args{2}),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Args{2}, ErrTxt] = GetRAPInt(RAPStat, Args{2});
    if ~isempty(ErrTxt), return; end
    if Args{2} <= 0, ErrTxt = 'Invalid range';
    else, RAPStat.PlotParam.Figure.Layout.Requested(2) = Args{2}; end
elseif (NArgs == 2) & isRAPInt(Args{1}) & isRAPInt(Args{2}),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [NX, NY, ErrTxt] = GetRAPInt(RAPStat, Args{1:2});
    if ~isempty(ErrTxt), return; end
    if any([NX, NY] <= 0), ErrTxt = 'Invalid range';
    else, RAPStat.PlotParam.Figure.Layout.Requested = [NX, NY]; end
end

%Start new figure ...
RAPStat = NewRAPFigure(RAPStat);

LineNr = LineNr + 1;