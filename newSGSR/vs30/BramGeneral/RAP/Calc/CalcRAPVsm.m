function [RAPStat, PlotStruct, ErrTxt] = CalcRAPVsm(RAPStat)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 11-04-2005

%------------------------------implementation details-------------------------------
%   Following steps need to be taken for the implementation of a curve:
%
%   1)Checking of a dataset is already specified in the RAP session and if the 
%     particular curve can be calculated from the dataset ...
%   2)Applying calculation parameters ...
%   3)Calculating additional information if necessary ...
%   4)Assembling of a structure that contains all the data to generate an RAP plot, see
%     CreateRAPPlot.m for the layout of this structure. It can be passed entirely to this
%     function. The mandatoty text on a plot is the number of subsequences included
%     in the analysis in the upper left corner, the appliable calculation parameters in
%     the lower left corner (use AssembleRAPCalcParam.m) and if present calculated 
%     data extracted from the curve in the upper right corner ... 
%   5)Every calculation routine of the RAP project can change the RAP status variable,
%     this is neccessary because data retrieved from the calculations needs to be 
%     accessible afterwards, e.g. to replace substitution variables.
%
%   Attention! If the number of subsequences included in the analysis is more than one
%   and the curve can only be calculated for a single subsequence, an array of 
%   PlotStruct's needs to be returned ...
%-----------------------------------------------------------------------------------

ErrTxt = '';
PlotStruct = [];

%Checking of a dataset is specified and if Vector Strength Magnitude versus Independent 
%Variable curve can be calculated for the current dataset ... 
if isRAPStatDef(RAPStat, 'GenParam.DS')
    ErrTxt = 'No dataset specified';
    return
elseif isTHRdata(RAPStat.GenParam.DS) || isCALIBdata(RAPStat.GenParam.DS)
    ErrTxt = 'VSM curve cannot be plotted for current dataset stimulus type';
    return
end

%Applying the calculation parameters ...
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
if isempty(iSubSeqs)
    ErrTxt = 'No recorded subsequences for this dataset'; 
    return; 
end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin);
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
BinFreq    = GetRAPCalcParam(RAPStat, 'nr', 'BinFreq'); 
IntNCycles = GetRAPCalcParam(RAPStat, 'nr', 'IntNCycles'); 
RayCrit    = GetRAPCalcParam(RAPStat, 'nr', 'RayCrit'); 
CompDelay  = GetRAPCalcParam(RAPStat, 'nr', 'CompDelay'); 
PhaseConv  = GetRAPCalcParam(RAPStat, 'nr', 'PhaseConv'); 
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
if (RunAv > length(iSubSeqs)), ErrTxt = 'Number of points for running average is too large'; return; end
SyncThr    = GetRAPCalcParam(RAPStat, 'nr', 'SyncThr'); 
CalcData = CalcVSPH(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, 'minisi', MinISI, ...
    'timesubtr', ConSubTr, 'binfreq', BinFreq, 'intncycles', IntNCycles, 'raycrit', RayCrit, ...
    'runav', RunAv, 'compdelay', CompDelay, 'phaseconv', PhaseConv, 'phaselinreg', 'normal', 'cutoffthr', SyncThr);

if strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF') & (RAPStat.GenParam.DS.indepnr == 2),
    [IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs);
    
    if isnan(ConstIndepNr),
        fprintf('WARNING: No one-dimensional restriction on dataset with more than one independent variable.\n');
        UnitStr = '#'; XLabelStr = [ 'SubSequence (' UnitStr ')'];
        SubSeqTxt = AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's');
    elseif (ConstIndepNr == 1), %First independent variable is held constant ...
        UnitStr = ds.yunit; XLabelStr = [ ds.yname '(' UnitStr ')'];
        SubSeqTxt = [AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's'), {sprintf('IndepVal(X): %s', IndepVal2Str(ConstVal, ds.xunit))}];
    else, 
        UnitStr = ds.xunit; XLabelStr = [ ds.xname '(' UnitStr ')']; 
        SubSeqTxt = [AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's'), {sprintf('IndepVal(Y): %s', IndepVal2Str(ConstVal, ds.yunit))}];
    end
else,
    UnitStr = ds.xunit; XLabelStr = [ ds.xname '(' UnitStr ')'];
    SubSeqTxt = AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's');
end

%Assembling the PlotStruct structure ...
PlotStruct.Layout     = 'uni';
PlotStruct.Plot.Type  = 'line';
PlotStruct.Plot.XData = CalcData.curve.indepval; 
PlotStruct.Plot.YData = CalcData.curve.r;
PlotStruct.Plot.FaceColor = RAPStat.PlotParam.Vs.LineColor;
PlotStruct.Plot.EdgeColor = [];
PlotStruct.Plot.LineStyle = RAPStat.PlotParam.Vs.LineStyle;
PlotStruct.Plot.LineWidth = RAPStat.PlotParam.Vs.LineWidth;
PlotStruct.Plot.Marker    = RAPStat.PlotParam.Vs.Marker;

PlotStruct.Axis.Color     = RAPStat.PlotParam.Axis.Color;
PlotStruct.Axis.Box       = RAPStat.PlotParam.Axis.Box;
PlotStruct.Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
PlotStruct.Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
PlotStruct.Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
PlotStruct.Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;

PlotStruct.Axis.X = RAPStat.PlotParam.Axis.X;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct.Axis.X.Label.String = XLabelStr; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct.Axis.X.Scale = 'linear'; end

PlotStruct.Axis.Y = RAPStat.PlotParam.Axis.Y;
PlotStruct.Axis.Y.Limits = RAPStat.PlotParam.Vs.Axis.Y.Limits;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct.Axis.Y.Label.String = 'R'; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct.Axis.Y.Scale = 'linear'; end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct.Title.Label = 'Vector Strength Magnitude'; end

%Every plot must contain information on the subsequences numbers it represents ...
PlotStruct.Text = struct([]);
if strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
    PlotStruct.Text(end).Label      = SubSeqTxt;
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on calculation parameters ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', ...
            'MinISI', 'ConSubst', 'BinFreq', 'IntNCycles', 'RayCrit', 'PhaseConv', 'CompDelay', 'CurveRunAv', 'SyncThr'}, 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on data ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcData;
    PlotStruct.Text(end).Label      = {sprintf('\\itMaxR:\\rm %.2f', CalcData.curve.maxr), ...
            sprintf('\\itBestIndepVal:\\rm %.0f (%s)', CalcData.curve.valatmax, UnitStr), ...
            sprintf('\\itCutOffR:\\rm %.2f', CalcData.curve.cutoffr), ...
            sprintf('\\itCutOffVal:\\rm %.0f (%s)', CalcData.curve.cutoffval, UnitStr)};
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Adding additional plot elements, significant dots are plotted not transparant ...
NDots = length(CalcData.curve.isign);
for n = 1:NDots,
    PlotElem(n).Type      = 'dot';
    PlotElem(n).X         = CalcData.curve.indepval(CalcData.curve.isign(n));
    PlotElem(n).Y         = CalcData.curve.r(CalcData.curve.isign(n));
    PlotElem(n).FaceColor = RAPStat.PlotParam.Vs.LineColor;
    PlotElem(n).EdgeColor = [];
    PlotElem(n).LineStyle = [];
    PlotElem(n).LineWidth = [];
    PlotElem(n).Marker    = RAPStat.PlotParam.Vs.Marker;
end
%Plot line at cutoff threshold ...    
PlotElem(NDots+1).Type      = 'line';
PlotElem(NDots+1).X         = [-Inf, +Inf];
PlotElem(NDots+1).Y         = CalcData.curve.cutoffr([1 1]);
PlotElem(NDots+1).FaceColor = 'k';
PlotElem(NDots+1).EdgeColor = [];
PlotElem(NDots+1).LineStyle = ':';
PlotElem(NDots+1).LineWidth = RAPStat.PlotParam.Vs.LineWidth;
PlotElem(NDots+1).Marker    = 'none';
%And at cutoff value of independent variable ...
PlotElem(NDots+2).Type      = 'line';
PlotElem(NDots+2).X         = CalcData.curve.cutoffval([1 1]);
PlotElem(NDots+2).Y         = [-Inf, CalcData.curve.cutoffr];
PlotElem(NDots+2).FaceColor = 'k';
PlotElem(NDots+2).EdgeColor = [];
PlotElem(NDots+2).LineStyle = ':';
PlotElem(NDots+2).LineWidth = RAPStat.PlotParam.Vs.LineWidth;
PlotElem(NDots+2).Marker    = 'none';
%if (NDots ~= 0), PlotStruct.Add = PlotElem; end
PlotStruct.Add = PlotElem;

%Setting calculated data information in the RAP status variable... For a vector
%strength magnitude curve this is MaxR, BestVal, CutOffR and CutOffVal ...
RAPStat.CalcData.XData         = PlotStruct.Plot.XData;
RAPStat.CalcData.YData         = PlotStruct.Plot.YData;
RAPStat.CalcData.VSM.MaxR      = CalcData.curve.maxr;
RAPStat.CalcData.VSM.BestVal   = CalcData.curve.valatmax;
RAPStat.CalcData.VSM.CutOffR   = CalcData.curve.cutoffr;
RAPStat.CalcData.VSM.CutOffVal = CalcData.curve.cutoffval;
RAPStat.CalcData.VSM.RaySign   = CalcData.curve.raysign;

%---------------------------------------local functions-----------------------------------
function Str = IndepVal2Str(Val, Unit)

if mod(Val, 1), Str = sprintf('%.2f (%s)', Val, Unit);
else, Str = sprintf('%.0f (%s)', Val, Unit); end