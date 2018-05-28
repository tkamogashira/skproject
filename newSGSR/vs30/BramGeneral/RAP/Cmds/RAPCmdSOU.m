function [RAPStat, LineNr, ErrTxt] = RAPCmdSOU(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   SOU #1 #2                 Set output plot to nr #1 along X-axis and nr #2 along Y-axis (*)
%   SOU DEF                   Set output plot to the upper left plot (*)
%   SOU NX                    Set output plot to the next plot, following row order (*)
%   SOU NEW FIG               Starts new figure, but keeps the current figure settings (*)
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   SOU command only works if a current figure exists and layout is fully defined
%   for this figure. This last requirement is fullfilled if the layout is set by
%   the user explicitly or if the current figure is not yet completed. 
%   Setting the location of an output plot to default, means setting the output of the plot
%   to the upper left corner of the figure. SOU never starts a new figure!
%   One exception to this rule is SOU NEW FIG.
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args   = varargin; NArgs = length(varargin);
Layout = GetRAPLayout(RAPStat); 

if ~ishandle(RAPStat.PlotParam.Figure.Hdl) | any(isnan(Layout)), 
    ErrTxt = 'SOU command only works if a current figure exists and layout is fully defined for this figure'; 
    return; 
end

if (NArgs == 1) & strcmp(Args{1}, 'def'),
    RAPStat.PlotParam.Figure.CurAx = [1 1]; %Setting output to the upper left corner of the figure ...
elseif (NArgs == 1) & strcmp(Args{1}, 'nx'),
    %NextRAPPlot.m is not used, because this function starts a new figure
    %when reaching the lower right corner of a figure. When this is the case for
    %SOU NX the upper left should be activated instead, because SOU never starts a new figure ...
    Vec = RAPStat.PlotParam.Figure.CurAx;
    Vec(1) = Vec(1) + 1;
    if Vec(1) > Layout(1), Vec(1) = 1; Vec(2) = Vec(2) + 1; end    
    if Vec(2) > Layout(2), Vec = [1 1]; end
    RAPStat.PlotParam.Figure.CurAx = Vec;
elseif (NArgs == 2) & strcmp(Args{1}, 'new') & strcmp(Args{2}, 'fig'),    
    ErrTxt = 'SOU NEW FIG not implemented yet'
    return;
else,
    [Nr1, Nr2, ErrTxt] = GetRAPInt(RAPStat, Args{:});
    if ~isempty(ErrTxt), return; else, Vec = [Nr1, Nr2]; end
    if any(Vec > Layout) | any(Vec <= 0), ErrTxt = 'Invalid range'; return;
    else RAPStat.PlotParam.Figure.CurAx = Vec; end
end    

LineNr = LineNr + 1;