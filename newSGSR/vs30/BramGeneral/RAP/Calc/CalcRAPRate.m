function [RAPStat, PlotStruct, ErrTxt] = CalcRAPRate(RAPStat)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

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
%     in the analysis in the upper left corner, the applicable calculation parameters in
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

%Checking of a dataset is specified and if rate curve can be calculated for the
%current dataset ... Three dimensional rate curves for datasets with two independent
%variables is not yet implemented ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return
elseif isTHRdata(RAPStat.GenParam.DS) || isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'Rate curve cannot be plotted for current dataset stimulus type'; 
    return
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConstSubst ...
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
if isempty(iSubSeqs)
    ErrTxt = 'No recorded subsequences for this dataset';
    return
end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin);
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv'); 
if (RunAv > length(iSubSeqs)), ErrTxt = 'Number of points for running average is too large'; return; end
CalcData = CalcRATE(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, 'runav', RunAv, 'minisi', MinISI, 'timesubtr', ConSubTr);

if strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF') && (RAPStat.GenParam.DS.indepnr == 2)
    [IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs);
    
    if isnan(ConstIndepNr)
        fprintf('WARNING: No one-dimensional restriction on dataset with more than one independent variable.\n');
        UnitStr = '#';
        XLabelStr = [ 'SubSequence (' UnitStr ')'];
        SubSeqTxt = AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's');
    elseif (ConstIndepNr == 1) %First independent variable is held constant ...
        UnitStr = ds.yunit;
        XLabelStr = [ ds.yname '(' UnitStr ')'];
        SubSeqTxt = [AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's'), {sprintf('IndepVal(X): %s', IndepVal2Str(ConstVal, ds.xunit))}];
    else
        UnitStr = ds.xunit;
        XLabelStr = [ ds.xname '(' UnitStr ')']; 
        SubSeqTxt = [AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's'), {sprintf('IndepVal(Y): %s', IndepVal2Str(ConstVal, ds.yunit))}];
    end
else
    UnitStr = ds.xunit; XLabelStr = [ ds.xname '(' UnitStr ')'];
    SubSeqTxt = AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's');
end

%Assembling the PlotStruct structure ...
PlotStruct.Layout     = 'uni';
PlotStruct.Plot.Type  = 'line';
PlotStruct.Plot.XData = CalcData.curve.indepval;
if strcmp(RAPStat.PlotParam.Rate.YAxisUnit, 'rate')
    PlotStruct.Plot.YData = CalcData.curve.rate;
    YUnitStr = 'spk/sec';
else
    PlotStruct.Plot.YData = CalcData.curve.n;
    YUnitStr = '# spk';
end
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
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String')
    PlotStruct.Axis.X.Label.String = XLabelStr; 
end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale')
    PlotStruct.Axis.X.Scale = 'linear'; 
end

PlotStruct.Axis.Y = RAPStat.PlotParam.Axis.Y;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String')
    if strcmp(RAPStat.PlotParam.Rate.YAxisUnit, 'rate')
        PlotStruct.Axis.Y.Label.String = 'Rate (spk/sec)';
    else
        PlotStruct.Axis.Y.Label.String = 'Rate (# spk)'; 
    end
end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale')
    PlotStruct.Axis.Y.Scale = 'linear';
end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label')
    PlotStruct.Title.Label = 'Rate Curve'; 
end

%Extracting additional information ...
[MaxVal, MaxIdx] = max(PlotStruct.Plot.YData);
[MinVal, MinIdx] = min(PlotStruct.Plot.YData);
XatMax = PlotStruct.Plot.XData(MaxIdx);
XatMin = PlotStruct.Plot.XData(MinIdx);
NumX   = length(PlotStruct.Plot.XData);

%Every plot must contain information on the subsequences numbers it represents ...
PlotStruct.Text = struct([]);
if strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on')
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
    PlotStruct.Text(end).Label      = SubSeqTxt;
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on calculation parameters ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on')
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'CurveRunAv', 'MinISI', 'ConSubTr'}, 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on data ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on')
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcData;
    PlotStruct.Text(end).Label      = {sprintf('\\itMax:\\rm %.0f (%s)', MaxVal, YUnitStr), ...
            sprintf('\\itMin:\\rm %.0f (%s)', MinVal, YUnitStr), ...
            sprintf('\\itXatMax:\\rm %.0f (%s)', XatMax, UnitStr), ...
            sprintf('\\itXatMin:\\rm %.0f (%s)', XatMin, UnitStr)};
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Adding error bars to the plot ...
if strcmpi(RAPStat.PlotParam.Rate.ErrorBars.Plot, 'yes')
    NErrorBars = length(CalcData.curve.indepval);
    for n = 1:NErrorBars
        PlotStruct.Add(n).Type      = 'line';
        PlotStruct.Add(n).X         = CalcData.curve.indepval([n n]);
        if strcmp(RAPStat.PlotParam.Rate.YAxisUnit, 'rate')
            PlotStruct.Add(n).Y = CalcData.curve.rate(n)+[-1,+1].*CalcData.curve.semrate(n);
        else
            PlotStruct.Add(n).Y = CalcData.curve.n(n)+[-1,+1].*CalcData.curve.sem(n);
        end
        PlotStruct.Add(n).FaceColor = RAPStat.PlotParam.Rate.ErrorBars.LineColor;
        PlotStruct.Add(n).EdgeColor = [];
        PlotStruct.Add(n).LineStyle = RAPStat.PlotParam.Rate.ErrorBars.LineStyle;
        PlotStruct.Add(n).LineWidth = RAPStat.PlotParam.Rate.ErrorBars.LineWidth;
        PlotStruct.Add(n).Marker    = 'none';
    end
end

%Setting calculated data information in the RAP status variable... For a rate
%curve this data is the maximum and mininum value, the X at these values and the
%number of values of the indepenent variable included in the analysis ...
%Attention! The values for the second independent variable (Y) not yet implemented ...
RAPStat.CalcData.XData       = PlotStruct.Plot.XData;
RAPStat.CalcData.YData       = PlotStruct.Plot.YData;
RAPStat.CalcData.Rate.MaxVal = MaxVal;
RAPStat.CalcData.Rate.MinVal = MinVal;
RAPStat.CalcData.Rate.XatMax = XatMax;
RAPStat.CalcData.Rate.XatMin = XatMin;
RAPStat.CalcData.Rate.NumX   = NumX;

%---------------------------------------local functions-----------------------------------
function Str = IndepVal2Str(Val, Unit)

if mod(Val, 1)
    Str = sprintf('%.2f (%s)', Val, Unit);
else
    Str = sprintf('%.0f (%s)', Val, Unit);
end
