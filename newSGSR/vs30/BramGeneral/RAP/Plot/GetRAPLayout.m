function LayVec = GetRAPLayout(RAPStat, LayType)
%GetRAPLayout    get current figure layout
%   Layout = GetRAPLayout(RAPStat, LayoutType)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-02-2004

%----------------------------implementation details----------------------------
%   The layout of a figure is determined in the following way:
%   1) If the layout of the figure is explicitly set by the user, via the PP
%      command, then these settings are always used first.
%   2) If no layout is given by the user but the current figure is already
%      filled with plots, then the current layout of the figure is used further.
%   3) The default layout for a new figure is determined by the kind of plot
%      that is requested. There are two kinds of plots: plots over multiple
%      subsequences (e.g. Rate curve) and plot that are restricted by their 
%      nature to only one subsequence (e.g. PST histograms).
%------------------------------------------------------------------------------

LayParam = RAPStat.PlotParam.Figure.Layout;

if (nargin == 2),
    if ~any(strcmpi(LayType, {'uni', 'multi'})), error('Wrong layout type.'); end
    
    for n = 1:2,
        if isnan(LayParam.Requested(n)), 
            if isnan(LayParam.Current(n)),
                if strcmpi(LayType, 'uni'), LayVec(n) = LayParam.UniDef(n);
                else, LayVec(n) = LayParam.MultiDef(n); end
            else, LayVec(n) = LayParam.Current(n); end
        else, LayVec(n) = LayParam.Requested(n); end
    end
else, 
%If the layout is fully defined, by the user or for the current figure, then
%this funtion returns this layout. Otherwise [NaN NaN] is returned...
    if all(~isnan(LayParam.Requested)), LayVec = LayParam.Requested;
    elseif all(~isnan(LayParam.Current)), LayVec = LayParam.Current;
    else, LayVec = [NaN NaN]; end    
end   