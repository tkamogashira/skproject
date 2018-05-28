function FigHdl = EvalMove_PlotCurve(CalcData, DSParam, StimParam, Param, Thr)

%% Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(strtok(mfilename, '_')), DSParam.idstr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

%% Display title
axes('Position', [0.05, 0.90, 0.90, 0.05], 'Visible', 'off');
text(0.5, 0.5, DSParam.titlestr, 'Units', 'normalized', 'VerticalAlignment', 'middle', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'normal', 'FontSize', 10);

%% Assembling legend ...
switch StimParam.type
    case 1 %MOV1-datasets ...
        if strcmpi(Param.pbratecor, 'yes')
            ITDrate = StimParam.effitdrate; %in microsec/sec ...
            StimDur = 1e3*abs(StimParam.effitdend-StimParam.itdbgn) ...
                ./StimParam.effitdrate; %in ms ...
        else
            ITDrate = StimParam.itdrate; %in microsec/sec ...
            StimDur = 1e3*abs(StimParam.itdend-StimParam.itdbgn) ...
                ./StimParam.itdrate; %in ms ...
        end
        LegendStr = cellstr([num2str(ITDrate, '%.0f\\mus/s, '), ...
            num2str(StimDur, '%.0fms')]);
    case 2 %MOV2-datasets ...
        if strcmpi(Param.pbratecor, 'yes')
            LegendStr = cellstr(num2str(StimParam.effitdend, '%+.0f\\mus'));
        else
            LegendStr = cellstr(num2str(StimParam.itdend, '%+.0f\\mus'));
        end
    case 3
        %MOV3-datasets ...
        LegendStr = cellstr(num2str(StimParam.delayslave, '%+.0f\\mus'));
    case 4
        %MOV4-datasets ...
        LegendStr = cellstr(num2str(StimParam.itdbgn, '%+.0f\\mus'));
end
if ~isvoid(Param.nitdds)
    LegendStr = [LegendStr; {'ND-fnc'}];
end %NITD-dataset ...

%% Setting up axes
AxMAIN = axes('units', 'normalized', 'position', [0.10 0.475 0.85 0.425], ...
    'fontunits', 'points', 'fontsize', 9);
if strcmpi(Param.dbg, 'yes')
    set(AxMAIN, 'box', 'on', 'xgrid', 'on', 'ygrid', 'on', 'tickdir', 'in');
else
    set(AxMAIN, 'box', 'off', 'xgrid', 'off', 'ygrid', 'off', 'tickdir', 'out');
end

XLim = InterpretXLimits(Param, CalcData);
YLim = InterpretYLimits(Param, CalcData);

%% Displaying DSSI segments ...
if ~isempty(CalcData.mov3) && strcmpi(Param.plottype, 'color')
    N = length(CalcData.mov3.segments);
    for n = 1:N
        patch(CalcData.mov3.segments(n).X, CalcData.mov3.segments(n).Y(1, :), ...
            [0.7 0.7 0.7], 'EdgeColor', 'none');
        patch(CalcData.mov3.segments(n).X, CalcData.mov3.segments(n).Y(2, :), ...
            [0.5 0.5 0.5], 'EdgeColor', 'none');
    end
end

%% Plotting movement direction ...
if isequal(StimParam.movedir, +1)
    text(0, 0.95*YLim(2), '\rightarrow', 'verticalalignment', 'middle', ...
        'horizontalalignment', 'center', 'interpreter', 'tex', ...
        'fontweight', 'bold', 'fontsize', 20);
elseif isequal(StimParam.movedir, -1)
    text(0, 0.95*YLim(2), '\leftarrow', 'verticalalignment', 'middle', ...
        'horizontalalignment', 'center', 'interpreter', 'tex', ...
        'fontweight', 'bold', 'fontsize', 20);
end

%% Plotting ITD curves ...
NPlots = length(CalcData.hist);
if strcmpi(Param.plottype, 'color')
    if isequal(StimParam.type, 1)
        Colors = num2cell(flipud(copper(NPlots)), 2)';
    else
        Colors = {'b', 'g', 'r', 'c', 'm', 'y'};
    end
    Markers = {'o', '^', 'v', '<', '>', 's', 'd', 'p', 'h'};
    LineStyles = {'-'};
else
    Colors = {'k'};
    Markers = {'none'};
    LineStyles = cell(NPlots, 1);
    LineStyles(1:2:end) = {'-'};
    LineStyles(2:2:end) = {':'};
end
ColIdx = 0;
NCol = length(Colors);
MrkIdx = 0;
NMrk = length(Markers);
LstIdx = 0;
NLst = length(LineStyles);
LnHdl = zeros(1, NPlots);
DotHdl = zeros(2, NPlots);
for n = 1:NPlots
    ColIdx = mod(ColIdx, NCol) + 1;
    MrkIdx = mod(MrkIdx, NMrk) + 1;
    LstIdx = mod(LstIdx, NLst) + 1;
    LnHdl(n) = line(CalcData.hist(n).bc, CalcData.hist(n).rate, 'LineStyle', LineStyles{LstIdx}, ...
        'Marker', Markers{MrkIdx}, 'Color', Colors{ColIdx});
    DotHdl(n, 1) = line(CalcData.hist(n).bcatmax, CalcData.hist(n).maxrate, 'LineStyle', 'none', ...
        'Marker', Markers{MrkIdx}, 'Color', Colors{ColIdx}, 'MarkerFaceColor', Colors{ColIdx});
    DotHdl(n, 2) = line(CalcData.hist(n).bcatmin, CalcData.hist(n).minrate, 'LineStyle', 'none', ...
        'Marker', Markers{MrkIdx}, 'Color', Colors{ColIdx}, 'MarkerFaceColor', Colors{ColIdx});
end

%% Plot noise delay function ...
if ~isvoid(Param.nitdds)
    if strcmpi(Param.plottype, 'color')
        Color = 'k'; LineStyle = '--'; LineWidth = 0.5;
    else
        Color = 'k'; LineStyle = '-'; LineWidth = 2;
    end
    %Reduce curve for plotting ...
    idx = find((CalcData.ndfnc.itd >= Param.calcitdrng(1)) & (CalcData.ndfnc.itd <= Param.calcitdrng(2)));
    ItdHdl = line(CalcData.ndfnc.itd(idx), CalcData.ndfnc.rate(idx), 'LineStyle', LineStyle, ...
        'LineWidth', LineWidth, 'Color', Color, 'Marker', 'o', 'MarkerFaceColor', 'k');

    line(CalcData.ndfnc.itdatmax([1 1]), YLim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
else
    ItdHdl = [];
end
line([0 0], YLim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
if strcmpi(Param.dbg, 'yes')
    text(0, 1, StimParam.dbgstr, 'VerticalAlign', 'top', ...
        'horizontalalign', 'left', 'units', 'normalized', 'fontname', 'courier');
end

axis([XLim, YLim]);
xlabel('ITD (\mus)', 'fontunits', 'points', 'fontsize', 9);
ylabel('Rate (spk/sec)', 'fontunits', 'points', 'fontsize', 9);
legend([LnHdl, ItdHdl], LegendStr, 1);

% secondary top X axes for post stimulus time if only one speed
if isequal(1, size(StimParam.itdbgn, 1))
    ITDBegin = StimParam.itdbgn;
    if strcmpi(Param.pbratecor, 'yes')
        ITDEnd = StimParam.effitdend;
        StimDur = StimParam.effstimdurslave;
    else
        ITDEnd = StimParam.itdend;
        StimDur = StimParam.stimdurslave;
    end

    ITDDur = abs( ITDEnd - ITDBegin );

    ITDLim = get(AxMAIN, 'xlim'); %calculate xlim for time axes
    XLimRatio(1) = (ITDLim(1) - ITDBegin) / ITDDur;
    XLimRatio(2) = (ITDLim(2) - ITDBegin) / ITDDur;
    TimeLim = StimDur * XLimRatio;

    axes('Position',get(AxMAIN,'Position'),...
        'XAxisLocation','top',...
        'YTick', [],...
        'YTickLabel', '', ...
        'Color','none',...
        'XColor','k','YColor','k', ...
        'xlim', TimeLim);
end

%% Display specific plots ...
if isequal(StimParam.type, 1) && ~isvoid(Param.nitdds)
    axes('Position', [0.10, 0.27, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    ColIdx = 0; NCol = length(Colors);
    MrkIdx = 0; NMrk = length(Markers);
    LstIdx = 0; NLst = length(LineStyles);
    for n = 1:NPlots
        ColIdx = mod(ColIdx, NCol) + 1;
        MrkIdx = mod(MrkIdx, NMrk) + 1;
        LstIdx = mod(LstIdx, NLst) + 1;
        line(CalcData.mov1.lags, CalcData.mov1.corr(n, :), 'LineStyle', LineStyles{LstIdx}, 'Marker', 'none', 'Color', Colors{ColIdx});
        line(CalcData.mov1.corrlagatmax(n), CalcData.mov1.corrmax(n), 'LineStyle', 'none', 'Marker', Markers{MrkIdx}, 'Color', Colors{ColIdx});
    end
    xlabel('Delay Mov. re. Stat. (\mus)', 'fontsize', 8);
    ylabel([Param.corrnorm ' Correlation'], 'fontsize', 8)
    xlim(Param.corrrng);

    axes('Position', [0.35 , 0.27, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    line(CalcData.mov1.itdrate, CalcData.mov1.stimcorrlagatmax, 'LineStyle', '-', ...
        'Marker', '.', 'Color', 'k');
    
    [Y, idx] = deNaN(CalcData.mov1.stimcorrlagatmax);
    X = CalcData.mov1.itdrate(idx);
    PFit = polyfit(X, Y, 1);
    PVal = polyval(PFit, CalcData.mov1.itdrate);
    line(CalcData.mov1.itdrate, PVal, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    xlabel('ITDrate (\mus/s)', 'fontsize', 8); 
    ylabel('Delay / ITDrate (ms)', 'fontsize', 8);
    currXLim = xlim;
    xlim([0, currXLim(2)]);
    axes('Position', [0.10 , 0.075, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    [XData, Idx] = sort(CalcData.mov1.itdrate);
    YDataTemp = cat(1, CalcData.hist.maxrate);
    YData = YDataTemp(Idx);
    line([0;XData], [CalcData.ndfnc.maxrate;YData], 'LineStyle', '-', ...
        'Marker', '.', 'Color', 'k');
    xlabel('ITDrate (\mus/s)', 'fontsize', 8); 
    ylabel('Maximum Rate (spk/sec)', 'fontsize', 8);
    currXLim = xlim;
    xlim([0, currXLim(2)]);
    currYLim = ylim;
    ylim([0, currYLim(2)]);
    axes('Position', [0.35 , 0.075, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    line(CalcData.mov1.itdrate, CalcData.mov1.corrlagatmax, 'LineStyle', '-', ...
        'Marker', '.', 'Color', 'k');
    [Y, idx] = deNaN(CalcData.mov1.corrlagatmax);
    X = CalcData.mov1.itdrate(idx);
    PFit = polyfit(X, Y, 1);
    PVal = polyval(PFit, CalcData.mov1.itdrate);
    line(CalcData.mov1.itdrate, PVal, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
    xlabel('ITDrate (\mus/s)', 'fontsize', 8); 
    ylabel('Delay Mov re Stat (\mus)', 'fontsize', 8);
    currXLim = xlim;
    xlim([0, currXLim(2)]);
elseif isequal(StimParam.type, 3)
    axes('Position', [0.10, 0.27, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    barplus(CalcData.mov3.bc, CalcData.mov3.dynrate, 'barcolor', [0.7, 0.7, 0.7], ...
        'linecolor', [0, 0, 0]);
    title('Dynamic PSTH'); xlabel('Time (ms)', 'fontsize', 8); ylabel('Rate (spk/sec)', 'fontsize', 8);
    axes('Position', [0.35 , 0.27, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    barplus(CalcData.mov3.bc, CalcData.mov3.statrate, 'barcolor', [0.7, 0.7, 0.7], ...
        'linecolor', [0, 0, 0]);
    title('Static PSTH'); xlabel('Time (ms)', 'fontsize', 8); ylabel('Rate (spk/sec)', 'fontsize', 8);
    axes('Position', [0.10 , 0.075, 0.20, 0.125], 'tickdir', 'out', 'fontsize', 8);
    line(CalcData.mov3.dynrate, CalcData.mov3.statrate, 'LineStyle', '-', ...
        'Marker', '.', 'Color', 'k');
    xlabel('Dynamic Rate (spk/sec)', 'fontsize', 8); ylabel('Static Rate (spk/sec)', 'fontsize', 8);
end

%% Displaying general and specific information ...
axes('Position', [0.50, 0.05, 0.45, 0.425], 'Visible', 'off');
[FirstColStr, SecColStr] = deal(StimParam.str, Param.str);
if ~isempty(Thr)
    FirstColStr = [FirstColStr; {''}; Thr.str];
end
text(0.25, 0.5, FirstColStr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);
text(0.75, 0.5, SecColStr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);
axes('Position', [0.30 , 0.05, 0.20, 0.1875], 'Visible', 'off');
text(0.5, 0.85, CalcData.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', 8);

%% InterpretXLimits
function XLim = InterpretXLimits(Param, CalcData)

Data1 = cat(2, CalcData.hist.bc)';
if ~isvoid(Param.nitdds) % if ntd function is supplied
    Data2 = CalcData.ndfnc.itd( CalcData.ndfnc.itd >= Param.calcitdrng(1) & ...
        CalcData.ndfnc.itd <= Param.calcitdrng(2) );
else
    sizeD1 = size(Data1);
    Data2 = zeros(sizeD1(1),1);
end

if isinf(Param.xlim(1))
    XLim(1) = floor(min([Data1; Data2])/1000)*1000;
else
    XLim(1) = Param.xlim(1);
end
if isinf(Param.xlim(2))
    XLim(2) = ceil(max([Data1; Data2])/100)*100;
else
    XLim(2) = Param.xlim(2);
end

%% InterpretYLimits
function YLim = InterpretYLimits(Param, CalcData)

Data = cat(2, CalcData.hist.rate)';
if isinf(Param.ylim(1))
    YLim(1) = min([0, floor(min(Data)/50)*50]);
else
    YLim(1) = Param.ylim(1);
end
if isinf(Param.ylim(2))
    YLim(2) = ceil(max(Data)/50)*50;
else
    YLim(2) = Param.ylim(2);
end
