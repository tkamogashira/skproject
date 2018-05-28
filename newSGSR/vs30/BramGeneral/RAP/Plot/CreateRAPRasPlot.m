function [RAPStat, ErrTxt] = CreateRAPRasPlot(RAPStat)
%CreateRAPRasPlot    calculate and create RAP raster plot
%   [RAPStat, ErrTxt] = CreateRAPRasPlot(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-05-2004

ErrTxt = '';

%Checking whether a dataset is specified and if raster curve can be calculated
%for the current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return 
elseif isTHRdata(RAPStat.GenParam.DS) || isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'Raster plot cannot be plotted for current dataset stimulus type'; 
    return
end

%Not alot of calculation needs to be done, only applying the calculation parameters 
%Reps, MinISI and ConstSubst ... 
ds = RAPStat.GenParam.DS;
Spt = ds.spt;
iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
NSubSeqs = length(iSubSeqs);
if (NSubSeqs == 0)
    ErrTxt = 'No recorded subsequences for this dataset';
    return
end
iReps = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
NRep = length(iReps);
MinISI = GetRAPCalcParam(RAPStat, 'nr', 'MinISI');
Spt = ApplyMinISI(Spt, MinISI);
ConSubTr = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr');
Spt = ApplyTimeSubtr(Spt, ConSubTr);

%Check all possible errors before RAP Status is significantly altered, i.d. 
%do not create a new figure or plot before all possible errors are checked ...

%Only plot something if there is something to be plotted ...
if isempty(ds.spt)
    ErrTxt = 'Nothing to be plotted';
    return;
end

%Calculating the upper and lower limits for the abcissa ...
if isinf(RAPStat.PlotParam.Axis.X.Limits(1))
    XLimits(1) = 0;
else
    XLimits(1) = RAPStat.PlotParam.Axis.X.Limits(1);
end
if isinf(RAPStat.PlotParam.Axis.X.Limits(2))
    XLimits(2) = max(ds.repdur);
else
    XLimits(2) = RAPStat.PlotParam.Axis.X.Limits(2);
end
if (diff(XLimits) <= 0)
    ErrTxt = 'Limits on abcissa are invalid';
    return;
end

%Ylimits cannot be set by the user, they are determined by the analysis range ...
YLimits = [0.5 NSubSeqs+0.5];

%Determine and sort oridinate labels ...
[IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs);
if strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF') && (RAPStat.GenParam.DS.indepnr == 2)
    if isnan(ConstIndepNr)
        %Sorting according to first and second independent variable ...
        [YIndepVal, idx] = sort(ds.yval(iSubSeqs)); 
        iSubSeqs = iSubSeqs(idx);
        [XIndepVal, idx] = sort(ds.xval(iSubSeqs)); 
        YIndepVal = YIndepVal(idx); iSubSeqs = iSubSeqs(idx);

        YTickLabels = cellstr([num2str(XIndepVal), repmat('/', length(iSubSeqs), 1), num2str(YIndepVal)])';
        YLabelStr = [ ds.xname '(' ds.xunit ')/' ds.yname '(' ds.yunit ')']; 
        IndepValStr = '';
    elseif (ConstIndepNr == 1) %First independent variable is held constant ...
        [YTickLabels, idx] = sort(IndepVal'); iSubSeqs = iSubSeqs(idx);
        YLabelStr = [ ds.yname '(' ds.yunit ')']; 
        IndepValStr = sprintf('IndepVal(X): %s', IndepVal2Str(ConstVal, ds.xunit));
    else %Second independent variable is held constant ...
        [YTickLabels, idx] = sort(IndepVal'); iSubSeqs = iSubSeqs(idx);
        YLabelStr = [ ds.xname '(' ds.xunit ')']; 
        IndepValStr = sprintf('IndepVal(Y): %s', IndepVal2Str(ConstVal, ds.yunit));
    end
else
    [YTickLabels, idx] = sort(IndepVal'); iSubSeqs = iSubSeqs(idx);
    YLabelStr = [ ds.indepname '(' ds.indepunit ')']; 
    IndepValStr = '';
end

%Get current figure handle or create new one ...
if ~ishandle(RAPStat.PlotParam.Figure.Hdl)
    RAPStat = NewRAPFigure(RAPStat);
    [FigHdl, RAPStat] = CreateRAPFigure(RAPStat);
else
    FigHdl = RAPStat.PlotParam.Figure.Hdl;
end

%Create axis object ... 
[RAPStat, AxHdl] = CreateRAPAxis(RAPStat, 'uni');

%Drawing the analysis window ...
AnWinElems = CreateRAPPlotElem(RAPStat, 'anwin');
NElems = length(AnWinElems);
for n = 1:NElems
    PlotRAPAxisElement(AnWinElems(n), XLimits, YLimits);
end

%Plot spikes ...
Colors = RAPStat.PlotParam.Raster.Colors;
NColors = size(Colors, 1);
LineWidth = RAPStat.PlotParam.Raster.LineWidth;
ColIdx = 0; %Color index ...
for nSubSeq = 1:NSubSeqs
    X = [];
    Y = [];
    ColIdx = mod(ColIdx, NColors) + 1;
    yy = linspace(nSubSeq-0.4, nSubSeq+0.4, NRep+1);
    for n = 1:NRep
        Spks = Spt{iSubSeqs(nSubSeq), iReps(n)}; 
        NSpk = length(Spks);
        if (NSpk > 0)
            X = [X VectorZip(Spks, Spks , Spks+NaN)];
            y1 = yy(n)+0*Spks;   %same size as x
            y2 = yy(n+1)+0*Spks; %same size as x
            Y = [Y, VectorZip(y1, y2, y2)];
        end
    end
    Hdl = line(X, Y, 'LineStyle', '-', 'LineWidth', LineWidth, 'Color', Colors(ColIdx, :), 'Marker', 'none');
end

%Setting limits for the axis object ...
set(AxHdl, 'XLim', XLimits, 'XLimMode', 'manual', 'YLim', YLimits, 'YLimMode', 'manual');

%Setting the properties of the axis object after plotting the data ... 
A = RAPStat.PlotParam.Axis;
set(AxHdl, 'Box', A.Box, 'LineWidth', A.LineWidth, 'Color', A.Color, 'FontUnits', 'centimeters', ...
    'FontName', A.Tic.FontName, 'FontSize', CalcRAPFontSize(RAPStat, AxHdl, A.Tic.FontSize), 'TickDir', A.TickDir);

%Set properties for the abcissa ...
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale')
    XScale = 'linear'; 
else
    XScale = RAPStat.PlotParam.Axis.X.Scale;
end
X = RAPStat.PlotParam.Axis.X;
[TickVec, TickMode] = GetRAPAxisTicks(XLimits, X.TickInc);
set(AxHdl, 'XTick', TickVec, 'XTickMode', TickMode, 'XLim', XLimits, 'XLimMode','manual', ...
    'XScale', XScale, 'XAxisLocation', X.Location, 'XColor', X.Color)

if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String')
    XLabelStr = 'Time (ms)';
else
    XLabelStr = RAPStat.PlotParam.Axis.X.Label.String;
end
XL = RAPStat.PlotParam.Axis.X.Label;
xlabel(XLabelStr, 'FontUnits', 'centimeters', 'FontName', XL.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl, XL.FontSize), 'Color', XL.Color);

%Set properties for the ordinate ...
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale')
    YScale = 'linear'; 
else
    YScale = RAPStat.PlotParam.Axis.Y.Scale;
end

TickVec = 1:NSubSeqs;
Y = RAPStat.PlotParam.Axis.Y;
set(AxHdl, 'YTick', TickVec, 'YTickMode', 'manual', 'YTickLabel', YTickLabels, 'YLim', YLimits, 'YLimMode', 'manual', ...
    'YScale', YScale, 'YAxisLocation', Y.Location, 'YColor', Y.Color);

if ~isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String')
    YLabelStr = RAPStat.PlotParam.Axis.Y.Label.String;
end
YL = RAPStat.PlotParam.Axis.Y.Label;
ylabel(YLabelStr, 'FontUnits', 'centimeters', 'FontName', YL.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl, YL.FontSize), 'Color', YL.Color);

%Set the title ...
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label')
    TLabel = 'Raster Plot'; 
else
    TLabel = RAPStat.PlotParam.Axis.Title.Label;
end

T = RAPStat.PlotParam.Axis.Title;
title(TLabel, 'FontUnits', 'centimeters', 'FontName', T.FontName, ...
    'FontSize', CalcRAPFontSize(RAPStat, AxHdl, T.FontSize), 'Color', T.Color);

%Extra information on calculation parameters ...
Text = struct([]);
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on')
    Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
    Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'Reps', 'MinISI', 'ConSubst'}, 's');
    Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    Text(end).FontWeight = 'normal';
    Text(end).FontAngle  = 'normal';
    Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on indepent variables if necessary ...
if ~isempty(IndepValStr) && strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on')
    Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
    Text(end).Label      = IndepValStr;
    Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    Text(end).FontWeight = 'normal';
    Text(end).FontAngle  = 'normal';
    Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

for n = 1:length(Text)
    PlotRAPTextElement(RAPStat, AxHdl, Text(n));
end

%Set RAP status structure ready for a new plot and make current handle accessible
%so information can be retrieved by substitution variables ...
RAPStat.PlotParam.Axis.Hdl = AxHdl;
RAPStat = NextRAPPlot(RAPStat, 'uni');

%---------------------------------------local functions-----------------------------------
function Str = IndepVal2Str(Val, Unit)

if mod(Val, 1)
    Str = sprintf('%.2f (%s)', Val, Unit);
else
    Str = sprintf('%.0f (%s)', Val, Unit);
end
