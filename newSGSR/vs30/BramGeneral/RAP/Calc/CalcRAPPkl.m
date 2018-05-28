function [RAPStat, PlotStruct, ErrTxt] = CalcRAPPkl(RAPStat)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-04-2004

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

ErrTxt = ''; PlotStruct = [];

%Checking if a dataset is specified and if peak latency curve can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'Peak latency curve cannot be plotted for current dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConstSubst ...
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
if isempty(iSubSeqs), ErrTxt = 'No recorded subsequences for this dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
PkWin      = GetRAPCalcParam(RAPStat, 'nr', 'PklPkWin');
SrWin      = GetRAPCalcParam(RAPStat, 'nr', 'PklSrWin');
RateInc    = GetRAPCalcParam(RAPStat, 'nr', 'PklRateInc');
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'PklRunAv');
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
BinWidth   = GetRAPCalcParam(RAPStat, 'nr', 'BinWidth'); 
if isnan(BinWidth), 
    CalcParamIncList = {'Reps', 'PklPkWin', 'PklSrWin', 'PklRateInc', 'PklRunAv', 'NBin', 'MinISI', 'ConSubTr'};
    NBin     = GetRAPCalcParam(RAPStat, 'nr', 'NBin'); 
    BinWidth = diff(PkWin)/NBin;
else, CalcParamIncList = {'Reps', 'PklPkWin', 'PklSrWin', 'PklRateInc', 'PklRunAv', 'BinWidth', 'MinISI', 'ConSubTr'}; end
CalcData = CalcPKL(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'pkwin', PkWin, 'srwin', SrWin, ...
    'binwidth', BinWidth, 'rateinc', RateInc, 'runav', RunAv, 'minisi', MinISI, 'timesubtr', ConSubTr);

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
PlotStruct.Layout         = 'uni';
PlotStruct.Plot.Type      = 'line';
PlotStruct.Plot.XData     = CalcData.curve.indepval; 
PlotStruct.Plot.YData     = CalcData.curve.pklat;
PlotStruct.Plot.FaceColor = RAPStat.PlotParam.Rate.LineColor;
PlotStruct.Plot.EdgeColor = [];
PlotStruct.Plot.LineStyle = RAPStat.PlotParam.Rate.LineStyle;
PlotStruct.Plot.LineWidth = RAPStat.PlotParam.Rate.LineWidth;
PlotStruct.Plot.Marker    = RAPStat.PlotParam.Rate.Marker;

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
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct.Axis.Y.Label.String = 'Latency (ms)'; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct.Axis.Y.Scale = 'linear'; end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct.Title.Label = 'Peak Latency'; end

%Information on the subsequences numbers included...
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
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, CalcParamIncList, 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Setting calculated data information in the RAP status variable...
RAPStat.CalcData.XData       = PlotStruct.Plot.XData;
RAPStat.CalcData.YData       = PlotStruct.Plot.YData;

%---------------------------------------local functions-----------------------------------
function Str = IndepVal2Str(Val, Unit)

if mod(Val, 1), Str = sprintf('%.2f (%s)', Val, Unit);
else, Str = sprintf('%.0f (%s)', Val, Unit); end