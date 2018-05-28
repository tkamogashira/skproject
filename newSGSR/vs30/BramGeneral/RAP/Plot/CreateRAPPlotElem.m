function PlotElem = CreateRAPPlotElem(RAPStat, Type)
%CreateRAPPlotElem    creates an RAP plot element
%   PlotElem = CreateRAPPlotElem(RAPStat, Type)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

%------------------------------implementation details------------------------
%   A plot element is a structure with the following fields:
%       Type        : must be 'line' or patch' ...
%       X
%       Y 
%       FaceColor
%       EdgeColor 
%       LineStyle
%       LineWidth
%       Marker
%   An array of this structure designates multiple elements that are plotted
%   sequentially ...
%----------------------------------------------------------------------------

switch lower(Type)
case 'anwin',
    AnWin = GetRAPCalcParam(RAPStat, 'nr', 'anwin');
    ReWin = GetRAPCalcParam(RAPStat, 'nr', 'rewin');
    
    YLimits = [-Inf, +Inf]; %Designates limits of the axis being plotted ...
    AnWinParam = RAPStat.PlotParam.AnWin;

    XWin = MergeRAPWin(AnWin, ReWin); NElem = length(XWin);
    %When transparant facecolor requested then plot only the edges as lines ...
    if isequal(AnWinParam.FaceColor, [1 1 1]),
        for n = 1:2:NElem,
            PlotElem((n+1)/2).Type      = 'line';
            PlotElem((n+1)/2).X         = [XWin(n), XWin(n), XWin(n+1), XWin(n+1), XWin(n)];
            PlotElem((n+1)/2).Y         = [YLimits(1), YLimits(2), YLimits(2), YLimits(1), YLimits(1)];
            PlotElem((n+1)/2).FaceColor = AnWinParam.EdgeColor;
            PlotElem((n+1)/2).EdgeColor = '';
            PlotElem((n+1)/2).LineStyle = AnWinParam.LineStyle;
            PlotElem((n+1)/2).LineWidth = AnWinParam.LineWidth;
            PlotElem((n+1)/2).Marker    = 'none';
        end
    else
        for n = 1:2:NElem,
            PlotElem((n+1)/2).Type      = 'patch';
            PlotElem((n+1)/2).X         = [XWin(n), XWin(n), XWin(n+1), XWin(n+1)];
            PlotElem((n+1)/2).Y         = [YLimits(1), YLimits(2), YLimits(2), YLimits(1)];
            PlotElem((n+1)/2).FaceColor = AnWinParam.FaceColor;
            PlotElem((n+1)/2).EdgeColor = AnWinParam.EdgeColor;
            PlotElem((n+1)/2).LineStyle = AnWinParam.LineStyle;
            PlotElem((n+1)/2).LineWidth = AnWinParam.LineWidth;
            PlotElem((n+1)/2).Marker    = 'none';
        end
    end
case 'avgwin',
    AvgWin = GetRAPCalcParam(RAPStat, 'nr', 'avgwin');
    
    YLimits = [-Inf, +Inf]; %Designates limits of the axis being plotted ...
    AnWinParam = RAPStat.PlotParam.AnWin;

    %When transparant facecolor requested then plot only the edges as lines ...
    if isequal(AnWinParam.FaceColor, [1 1 1]),
        PlotElem.Type      = 'line';
        PlotElem.X         = [AvgWin(1), AvgWin(1), AvgWin(2), AvgWin(2), AvgWin(1)];
        PlotElem.Y         = [YLimits(1), YLimits(2), YLimits(2), YLimits(1), YLimits(1)];
        PlotElem.FaceColor = AnWinParam.EdgeColor;
        PlotElem.EdgeColor = '';
        PlotElem.LineStyle = AnWinParam.LineStyle;
        PlotElem.LineWidth = AnWinParam.LineWidth;
        PlotElem.Marker    = 'none';
    else
        PlotElem.Type      = 'patch';
        PlotElem.X         = [AvgWin(1), AvgWin(1), AvgWin(2), AvgWin(2)];
        PlotElem.Y         = [YLimits(1), YLimits(2), YLimits(2), YLimits(1)];
        PlotElem.FaceColor = AnWinParam.FaceColor;
        PlotElem.EdgeColor = AnWinParam.EdgeColor;
        PlotElem.LineStyle = AnWinParam.LineStyle;
        PlotElem.LineWidth = AnWinParam.LineWidth;
        PlotElem.Marker    = 'none';
    end
case 'thr',
    PlotParam = RAPStat.PlotParam.Thr;
    CalcData  = RAPStat.CalcData.Thr;
    
    %Marker at CF ...
    PlotElem(1).Type      = 'line';
    PlotElem(1).X         = CalcData.CF;
    PlotElem(1).Y         = CalcData.minThr;
    PlotElem(1).FaceColor = PlotParam.CF.Color;
    PlotElem(1).EdgeColor = [];
    PlotElem(1).LineStyle = 'none';
    PlotElem(1).LineWidth = PlotParam.Q10.LineWidth;
    PlotElem(1).Marker    = PlotParam.CF.Marker;
    
    %Line for Q10 ...
    PlotElem(2).Type      = 'line';
    PlotElem(2).X         = CalcData.BWx;
    PlotElem(2).Y         = CalcData.minThr([1 1]) + GetRAPCalcParam(RAPStat, 'nr', 'ThrQ');
    PlotElem(2).FaceColor = PlotParam.Q10.LineColor;
    PlotElem(2).EdgeColor = [];
    PlotElem(2).LineStyle = PlotParam.Q10.LineStyle;
    PlotElem(2).LineWidth = PlotParam.Q10.LineWidth;
    PlotElem(2).Marker    = 'none';
case 'zerolines',
    PlotParam = RAPStat.PlotParam.Corr.ZeroLine;
    
    %Vertical zero line ...
    PlotElem(1).Type      = 'line';
    PlotElem(1).X         = [0 0];
    PlotElem(1).Y         = [-Inf +Inf];
    PlotElem(1).FaceColor = PlotParam.LineColor;
    PlotElem(1).EdgeColor = [];
    PlotElem(1).LineStyle = PlotParam.LineStyle;
    PlotElem(1).LineWidth = PlotParam.LineWidth;
    PlotElem(1).Marker    = 'none';
    
    %Horizontal zero line ...
    PlotElem(2).Type      = 'line';
    PlotElem(2).X         = [-Inf +Inf];
    PlotElem(2).Y         = [0 0];
    PlotElem(2).FaceColor = PlotParam.LineColor;
    PlotElem(2).EdgeColor = [];
    PlotElem(2).LineStyle = PlotParam.LineStyle;
    PlotElem(2).LineWidth = PlotParam.LineWidth;
    PlotElem(2).Marker    = 'none';
end
end
