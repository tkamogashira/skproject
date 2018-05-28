function [RAPStat, PlotStruct, ErrTxt] = CalcRAPCr(RAPStat)
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

%Checking of a dataset is specified and if autocorrelogram can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'SAC cannot be plotted for current dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConSubTr ...
ds         = RAPStat.GenParam.DS; Spt = ds.spt;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); NSubSeqs = length(iSubSeqs); Spt = Spt(iSubSeqs, :);
if (NSubSeqs == 0), ErrTxt = 'No recorded subsequences for this dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps'); NRep = length(iReps); Spt = Spt(:, iReps);
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin); Spt = ApplyAnWin(Spt, AnWin);
AnWinDur   = GetRAPWinDur(RAPStat);
RunAvN     = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
Sign       = GetRAPCalcParam(RAPStat, 'nr', 'signlevel');
Boot       = GetRAPCalcParam(RAPStat, 'nr', 'bootstrap');
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); Spt = ApplyMinISI(Spt, MinISI);
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); Spt = ApplyTimeSubTr(Spt, ConSubTr);

BinWidth   = GetRAPCalcParam(RAPStat, 'nr', 'CorBinWidth');
MaxLag     = 0;

isign      = [];

%Generate multiple correlograms, for each subsequence in the analysis one ...
for n = 1:NSubSeqs,
    %Calculating the correlogram ...
    [CalcData(n).Corr, CalcData(n).BinCenters, NormConst] = sptcorr(Spt(n, :), 'nodiag', MaxLag, BinWidth, AnWinDur);
    if Boot > 0, 
       CalcData(n).Signlevel = SACPeakSign(Spt(n, :), BinWidth, Boot, AnWinDur); 
       if CalcData(n).Signlevel > Sign, isign(end+1) = n; end
    end
    CalcData(n).Rate  = runav((1000*CalcData(n).Corr) / (AnWinDur*(NRep*(NRep-1))), RunAvN);
    CalcData(n).Count = runav(CalcData(n).Corr/(NRep*(NRep-1)), RunAvN);
    CalcData(n).Norm  = runav(CalcData(n).Corr/NormConst.DriesNorm, RunAvN);
end

[IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs);
 
%Generate graph text
if strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF') & (RAPStat.GenParam.DS.indepnr == 2),
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
PlotStruct.Plot.XData = IndepVal;

if strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'norm'), 
   PlotStruct.Plot.YData = [CalcData.Norm]; 
   YUnitStr = 'Norm';
elseif strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'count'), 
   PlotStruct.Plot.YData = [CalcData.Count]; 
   YUnitStr = '# coincidences';
else, 
   PlotStruct.Plot.YData = [CalcData.Rate];
   YUnitStr = '# coincidences/sec';
end

PlotStruct.Plot.FaceColor = RAPStat.PlotParam.Cr.LineColor;
PlotStruct.Plot.EdgeColor = [];
PlotStruct.Plot.LineStyle = RAPStat.PlotParam.Cr.LineStyle;
PlotStruct.Plot.LineWidth = RAPStat.PlotParam.Cr.LineWidth;
PlotStruct.Plot.Marker    = RAPStat.PlotParam.Cr.Marker;

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
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'),
   if strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'norm'), 
      PlotStruct.Axis.Y.Label.String = 'Normalized # Coincidences' 
   elseif strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'count'), 
      PlotStruct.Axis.Y.Label.String = '# Coincidences';
   else, 
      PlotStruct.Axis.Y.Label.String = 'Coincidence Rate (# coincidences/sec)';
   end
end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct.Axis.Y.Scale = 'linear'; end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct.Title.Label = 'Coincidence Rate Curve'; end

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
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'CurveRunAv', 'MinISI', 'ConSubTr', 'SignLevel', 'BootStrap'}, 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Adding additional plot elements, significant dots are plotted not transparant ...
if Boot > 0,
   NDots = length(isign);
   for n = 1:NDots,
      PlotElem(n).Type      = 'dot';
      PlotElem(n).X         = IndepVal(isign(n));
      
      if strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'norm'), 
         PlotElem(n).Y     = CalcData(isign(n)).Norm;
      elseif strcmp(RAPStat.PlotParam.Cr.YAxisUnit, 'count'), 
         PlotElem(n).Y     = CalcData(isign(n)).Count;
      else, 
         PlotElem(n).Y     = CalcData(isign(n)).Rate;
      end
      
      PlotElem(n).FaceColor = RAPStat.PlotParam.Cr.LineColor;
      PlotElem(n).EdgeColor = [];
      PlotElem(n).LineStyle = [];
      PlotElem(n).LineWidth = [];
      PlotElem(n).Marker    = RAPStat.PlotParam.Cr.Marker;
   end
   if NDots > 0, PlotStruct.Add = PlotElem; end;
end

%Extract calculation parameters.
[MaxCR, MaxCRI] = max(PlotStruct.Plot.YData);
BestIndepVal = PlotStruct.Plot.XData(MaxCRI);

%Extra information on data ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcData;
    PlotStruct.Text(end).Label      = {sprintf('MaxCR: %.2f (%s)', MaxCR, YUnitStr), ...
            sprintf('BestIndepVal: %.0f (%s)', BestIndepVal, UnitStr)};
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Setting calculated data information in the RAP status variable...
RAPStat.CalcData.XData       = PlotStruct.Plot.XData;
RAPStat.CalcData.YData       = PlotStruct.Plot.YData;

%-----------------------------locals-------------------------------
function Asymptote = GetAsymptote(Y, Percent)

N = length(Y);
Nmargin = round(N*Percent);
Asymptote = mean(Y([1:Nmargin, end-Nmargin+1:end]));