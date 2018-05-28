function [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotStruct)
%CreateRAPPlot    creates RAP plot
%   [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotStruct) creates a plot based on
%   the data given by PlotStruct. This function not only takes care of 
%   the actual plotting, but also manages the creation of figures and their
%   headers, and the organisation of different plots on a figure.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005

%-----------------------------implementation details-----------------------
%   The organization of PlotStruct is kept similar to the organisations
%   of plot parameters in the RAP status structures... The fieldnames that
%   are different from RAPStat are indicated with an asterisk.
%
%   PlotStruct.Layout         : default figure layout to be used. Must be
%                               'multi' or 'uni' ...
%
%   PlotStruct.Plot.Type      : must be 'pol', 'bar' or 'line'. According to the 
%                               type, the parameters in the field Hist or 
%                               Rate are used... (*)
%   PlotStruct.Plot.XData     : data for abcissa or edges of a histogram (*)
%   PlotStruct.Plot.YData     : data for ordinate (*)
%   PlotStruct.Plot.FaceColor : for plots of type 'line' this is interpretated as
%                               as the color of the line ... (*)
%   PlotStruct.Plot.EdgeColor : not used for plots of type 'line' ... (*)
%   PlotStruct.Plot.LineStyle : not used for plots of type 'bar' ... (*)
%   PlotStruct.Plot.LineWidth : not used for plots of type 'bar' ... (*)
%   PlotStruct.Plot.Marker    : not used for plots of type 'bar' ... (*)
%   PlotStruct.Plot.BarStyle  : must be 'bars', 'line' or 'outline'. Not used for plots
%                               of type 'line' ... (*)
%
%   PlotStruct.Axis.Color
%   PlotStruct.Axis.Box
%   PlotStruct.Axis.LineWidth
%   PlotStruct.Axis.FontName  : the fontname and size of the tick labels is set via 
%   PlotStruct.Axis.FontSize  : axis properties ... (*)
%   PlotStruct.Axis.GridSize
%
%   PlotStruct.Axis.X.Limits
%   PlotStruct.Axis.X.Scale
%   PlotStruct.Axis.X.Location
%   PlotStruct.Axis.X.TickInc : 'auto' or a vector ...
%   PlotStruct.Axis.X.TickDir
%   PlotStruct.Axis.X.Color
%   PlotStruct.Axis.X.Flip
%   PlotStruct.Axis.X.Label.String
%   PlotStruct.Axis.X.Label.FontName
%   PlotStruct.Axis.X.Label.FontSize
%   PlotStruct.Axis.X.Label.Color
%
%   PlotStruct.Axis.Y.Limits
%   PlotStruct.Axis.Y.Scale
%   PlotStruct.Axis.Y.Location
%   PlotStruct.Axis.Y.TickInc
%   PlotStruct.Axis.Y.TickDir
%   PlotStruct.Axis.Y.Color
%   PlotStruct.Axis.Y.Label.String
%   PlotStruct.Axis.Y.Label.FontName
%   PlotStruct.Axis.Y.Label.FontSize
%   PlotStruct.Axis.Y.Label.Color
%
%   PlotStruct.Title.Label
%   PlotStruct.Title.FontName
%   PlotStruct.Title.FontSize
%   PlotStruct.Title.Color
%
%   PlotStruct.Text(n).Location   : must be 'ul', 'ur', 'll' or 'lr' ... (*)
%   PlotStruct.Text(n).Label      : can be cell-array of strings for multiple
%                                   lines ... (*)
%   PlotStruct.Text(n).FontName
%   PlotStruct.Text(n).FontSize  
%   PlotStruct.Text(n).FontWeight : must be 'light', 'demi', 'normal' or 'bold' ... (*)
%   PlotStruct.Text(n).FontAngle  : must be 'normal', 'italic' or 'oblique' ... (*)
%   PlotStruct.Text(n).Color
%
%   PlotStruct.Setup(n).Type      : must be 'line' or patch' ...
%   PlotStruct.Setup(n).X
%   PlotStruct.Setup(n).Y
%   PlotStruct.Setup(n).FaceColor      
%   PlotStruct.Setup(n).EdgeColor   
%   PlotStruct.Setup(n).LineStyle   
%   PlotStruct.Setup(n).LineWidth   
%   PlotStruct.Setup(n).Marker      
%
%   PlotStruct.Add(n).Type        : must be 'line', 'dot' or patch' ...
%   PlotStruct.Add(n).X
%   PlotStruct.Add(n).Y
%   PlotStruct.Add(n).FaceColor      
%   PlotStruct.Add(n).EdgeColor   
%   PlotStruct.Add(n).LineStyle   
%   PlotStruct.Add(n).LineWidth   
%   PlotStruct.Add(n).Marker      
%
%--------------------------------------------------------------------------

ErrTxt = '';

%Check all possible errors before RAP Status is significantly altered, i.e. 
%do not create a new figure or plot before all possible errors are checked ...
P = [PlotStruct.Plot];
X = [PlotStruct.Axis];
X = [X.X];
Y = [PlotStruct.Axis];
Y = [Y.Y];

if ~all(strcmpi({PlotStruct.Layout}, PlotStruct(1).Layout))
    disp('WARNING: Different layouts are not supported.');
    return
end

if ~(all(strcmpi({X.Scale}, X(1).Scale)) && all(strcmpi({Y.Scale}, Y(1).Scale)))
    disp('WARNING: Different scales are not supported.');
    return
end

%Only plot something if there is something to be plotted ...
if all(isnan([P.YData])) || any(cellfun(@isempty, {P.YData}))
    % TODO not sure about this one, should it be 'all' instead of 'any'?
    % Or should we be more careful instead of just discarding all plot data?
    if any(strcmpi({PlotStruct.Layout}, 'uni'))
        %Only display warning on command-line, but don't plot anything ...
        disp('WARNING: Nothing to be plotted.');
        return
    else
        %Get current figure handle or create new one ...
        if ~ishandle(RAPStat.PlotParam.Figure.Hdl)
            RAPStat = NewRAPFigure(RAPStat);
            [dummy, RAPStat] = CreateRAPFigure(RAPStat);
        end
        %Create empty plot ...
        [RAPStat, AxHdl] = CreateRAPEmptyPlot(RAPStat, 'multi');
        %Set RAP status structure ready for a new plot ...
        RAPStat.PlotParam.Axis.Hdl = AxHdl;
        RAPStat = NextRAPPlot(RAPStat, 'multi');
        return
    end
end

%Check validity of axis limits ...
if isfield(PlotStruct, 'Add')
    tmp = [PlotStruct.Add];
    tmp = [tmp.X];
    Data = PoolData([P.XData], tmp);
    clear tmp;
else
    Data = [P.XData];
end

% get all plots with axis on the left
idx = cellfun(@(loc) isequal(loc,'left'),{Y.Location});
if ~isempty(X(idx))
    XLimits = GetRAPAxisLimits('X', [min([X(idx).Limits]) max([X(idx).Limits])], ...
        Data, max([X.Margin]));
    if (diff(XLimits) <= 0)
        ErrTxt = 'Limits on abcissa are invalid';
        return
    end
else
    XLimits = GetRAPAxisLimits('X', [min([X.Limits]) max([X.Limits])], ...
        Data, max([X.Margin]));
    if (diff(XLimits) <= 0)
        ErrTxt = 'Limits on abcissa are invalid';
        return
    end
end

if isfield(PlotStruct, 'Add')
    tmp = [PlotStruct.Add];
    tmp = [tmp.Y];
    Data = PoolData([P.YData], tmp);
    clear tmp;
else
    Data = [P.YData];
end

if ~isempty(Y(idx))
    YLimits = GetRAPAxisLimits('Y', [min([Y(idx).Limits]) max([Y(idx).Limits])], Data, ...
        max([Y.Margin]));
    if (diff(YLimits) <= 0)
        ErrTxt = 'Limits on ordinate are invalid';
        return
    end
else
    YLimits = GetRAPAxisLimits('Y', [min([Y.Limits]) max([Y.Limits])], Data, ...
        max([Y.Margin]));
    if (diff(YLimits) <= 0)
        ErrTxt = 'Limits on ordinate are invalid';
        return
    end
end
    
%Get current figure handle or create new one ...
if ~ishandle(RAPStat.PlotParam.Figure.Hdl)
    RAPStat = NewRAPFigure(RAPStat);
    [dummy, RAPStat] = CreateRAPFigure(RAPStat);
end


%Create axis object ... 
[RAPStat, AxHdl(1)] = CreateRAPAxis(RAPStat, PlotStruct(1).Layout);

%Setting limits for the axis object ...
set(AxHdl(1), 'XLim', XLimits, 'XScale', X(1).Scale, 'XLimMode', 'manual', ...
    'YLim', YLimits, 'YScale', Y(1).Scale, 'YLimMode','manual', 'NextPlot', 'add');

%Setting up the axis object ...
if isfield(PlotStruct, 'Setup')
    Setup = PlotStruct.Setup;
    NElem = length(Setup);
    for n = 1:NElem
        PlotRAPAxisElement(Setup(n), XLimits, YLimits);
    end
end

figure(RAPStat.PlotParam.Figure.Hdl);

% We take the first left y-axis and the first right y-axis we find
% Search first axis on the other side of y(1)
secAxisIdx = find( arrayfun(@(y) ~isequal(y.Location, Y(1).Location), Y) ,1);
if ~isequal(length(PlotStruct(secAxisIdx)), 0)
    [RAPStat, AxHdl(2)] = CreateRAPAxis(RAPStat, PlotStruct(secAxisIdx).Layout);
    set(AxHdl(2), 'XLim', XLimits, 'XScale', X(secAxisIdx).Scale, ...
        'XLimMode', 'manual', 'YLim', YLimits, 'YScale', Y(secAxisIdx).Scale, ...
        'YLimMode','manual', 'YAxisLocation', Y(secAxisIdx).Location, ...
        'NextPlot', 'add');
    axes(AxHdl(2));
else
    secAxisIdx = 0; % no second axis
end

% set this axis last to make it the current axis
axes(AxHdl(1));

%Plotting of requested data ...
for idx = 1:length(P)
    p = P(idx);
    x = X(idx);
    %color = colors(idx,:);
    
    if ~isequal(secAxisIdx, 0)
        if strcmpi('Vector Strength Magnitude', PlotStruct(idx).Title.Label)
            for n = 1:length(p.YData)
                p.YData(n) = p.YData(n) .* YLimits(2);
            end
            for n = 1:length(PlotStruct(idx).Add)
                PlotStruct(idx).Add(n).Y = PlotStruct(idx).Add(n).Y .* YLimits(2);
            end
        elseif strcmpi('Vector Strength Phase', PlotStruct(idx).Title.Label)
            maxY = ceil(max(p.YData));
            minY = floor(min(p.YData));
            widthY = maxY - minY;
            maxAxis = max(str2num(get(AxHdl(2), 'YTickLabel')));
            for n = 1:length(p.YData)
                p.YData(n) = (p.YData(n) - minY) .* maxAxis ./ widthY;
            end
            for n = 1:length(PlotStruct(idx).Add)
                PlotStruct(idx).Add(n).Y = (PlotStruct(idx).Add(n).Y - minY )...
                    .* maxAxis ./ widthY;
            end
            ticks = str2num(get(AxHdl(2), 'YTickLabel')) .* widthY ./ maxAxis + minY;
            ticks = arrayfun(@(x) sprintf('%.1f',x), ticks, 'UniformOutput', false);
            set(AxHdl(2), 'YTickLabel', ticks);
        end
    end
    
    switch p.Type
        case 'bar',
            barplus(p.XData, p.YData, 'barwidth', 1, 'barcolor', p.FaceColor, ...
                'linecolor', p.EdgeColor, 'style', p.BarStyle);
        case 'line',
            if strcmpi(p.LineStyle, 'none')
                line(p.XData, p.YData, 'LineStyle', p.LineStyle, 'Color', p.FaceColor, ...
                    'Marker', p.Marker', 'MarkerSize', p.LineWidth);
            else
                %Flip abcissa if requested ...
                if strcmpi(x.Flip, 'yes')
                    [p.XData, I] = sort(-p.XData);
                    p.YData = p.YData(I);
                end
                line(p.XData, p.YData, 'LineStyle', p.LineStyle, ...
                    'Color', p.FaceColor ,'Marker', p.Marker', 'LineWidth', p.LineWidth);
            end
        case 'pol';
            polarplus(p.XData*2*pi, p.YData, 'linestyle', p.LineStyle, ...
                'linewidth', p.LineWidth, ...
                'gridcolor', [0.6 0.6 0.6], ...
                'linecolor', p.EdgeColor, ...
                'fillcolor', p.FaceColor, ...
                'gridsize', PlotStruct(idx).Axis.GridSize, ...
                'style', p.BarStyle);
    end

    %Plotting additional elements ...
    if isfield(PlotStruct(idx), 'Add')
        AddElem = PlotStruct(idx).Add;
        NElem = length(AddElem);
        for n = 1:NElem
            PlotRAPAxisElement(AddElem(n), XLimits, YLimits);
        end
    end
end

%Setting the properties of the axis object after plotting the data, because bar
%is a high level plotting function and resets alot of properties including 'Box'.
%Attention! The fontname and size of the tick labels is set via axis properties ...

% We need to choose one plotdata entry to take axis settings from
A = PlotStruct(1).Axis;
set(AxHdl(1), 'Box', A.Box, 'LineWidth', A.LineWidth, 'Color', A.Color, ...
    'FontUnits', 'centimeters', 'FontName', A.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl(1), A.FontSize), ...
    'TickDir', A.TickDir);

% We need to choose one plotdata entry to take x axis settings from
x = X(1);

%Set properties for the abcissa ...
[TickVec, TickMode] = GetRAPAxisTicks(XLimits, x.TickInc);
set(AxHdl, 'XTick', TickVec, 'XTickMode', TickMode, 'XLim', XLimits, ...
    'XLimMode','manual', 'XScale', x.Scale, 'XAxisLocation', x.Location, ...
    'XColor', x.Color)

XL = x.Label;
xlabel(XL.String, 'FontUnits', 'centimeters', 'FontName', XL.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl(1), XL.FontSize), 'Color', XL.Color);

y(1) = Y(1);
% second y axis on the other side
if ~isequal(secAxisIdx, 0)
    y(2) = Y(secAxisIdx);
end

for n = 1:length(y)
    %Set properties for the ordinate ...
    [TickVec, TickMode] = GetRAPAxisTicks(YLimits, y(n).TickInc);
    set(AxHdl(n), 'YTick', TickVec, 'YTickMode', TickMode, 'YLim', YLimits, ...
        'YLimMode', 'manual', 'YScale', y(n).Scale, 'YAxisLocation', y(n).Location, ...
        'YColor', y(n).Color);

    YL = y(n).Label;
    ylabel(AxHdl(n), YL.String, 'FontUnits', 'centimeters', 'FontName', YL.FontName, ...
        'FontSize', CalcRAPFontSize(RAPStat, AxHdl(n), YL.FontSize), 'Color', YL.Color);
end

if isequal(length(AxHdl), 2)
    set(AxHdl(2), 'XTick', []);
end

%Remove axes when polar plot
if all(isequal([P.Type], 'pol'))
   set(AxHdl(1), 'Box', 'on', 'xtick', [], 'ytick', []); 
   xlabel('');
   ylabel('');
end

%Set the title ...
T = [PlotStruct.Title];
title( implode(unique({T.Label}), ' & '), 'FontUnits', 'centimeters', ...
    'FontName', T(1).FontName, 'FontSize', ...
    CalcRAPFontSize(RAPStat, AxHdl(1), T(1).FontSize), 'Color', T(1).Color);

if isequal(length(PlotStruct), 1)
    %Plot texts in different corners ...
    Txt = PlotStruct.Text;
    NCorners = length(Txt);
    for n = 1:NCorners
        PlotRAPTextElement(RAPStat, AxHdl, Txt(n));
    end
end

%Set RAP status structure ready for a new plot and make current handle accessible
%so information can be retrieved by substitution variables ...
RAPStat.PlotParam.Axis.Hdl = AxHdl;
RAPStat = NextRAPPlot(RAPStat, PlotStruct(1).Layout);

%------------------------------------local functions------------------------------
function Data = PoolData(varargin)

Data = [];
for n = 1:nargin
    Data = [Data, varargin{n}(:)'];
end
