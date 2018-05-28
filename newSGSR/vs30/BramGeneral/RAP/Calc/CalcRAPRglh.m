function [RAPStat, PlotStruct, ErrTxt] = CalcRAPRglh(RAPStat)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

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

%Checking of a dataset is specified and if regularity analysis can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'Regularity analysis cannot be calculated for current dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, MinISI, ConSubTr, AvgWin and MinNInt.
%AnWin and ReWin are not applicable for regularity analysis in the RAP implementation. 
%This shouldn't reduce the flexibility, by changing the abcissa limits the same plot can
%be achieved ...
%The analysis window is set to the maximum repetition duration for both channels, so that
%all spikes are taken into account ... 
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); NPlots = length(iSubSeqs);
if (NPlots == 0), ErrTxt = 'No recorded subsequences for this dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
AnWin      = [0 max(ds.repdur)];
%Using the same standard viewport as for PST histograms ...
ViewPort   = GetRAPHistWindow(RAPStat, 'psth');
if any(ViewPort < 0) | (diff(ViewPort) <= 0), ErrTxt = 'Invalid limits for abcissa'; return; end
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
NBin       = GetRAPCalcParam(RAPStat, 'nr', 'NBin'); 
AvgWin     = GetRAPCalcParam(RAPStat, 'nr', 'AvgWin');
MinNInt    = GetRAPCalcParam(RAPStat, 'nr', 'MinNInt');
if isnan(NBin), 
    CalcParamIncList = {'Reps', 'BinWidth', 'MinISI', 'ConSubTr', 'AvgWin', 'HistRunAv', 'MinNInt'};
    BinWidth = GetRAPCalcParam(RAPStat, 'nr', 'BinWidth'); 
    %To avoid inaccuracies introduced by the conversion of binwidth to number of
    %bins, the offset of the viewport is adjusted to make the interval an integral
    %number of bins ...
    Dur = abs(diff(ViewPort)); NBin = floor(Dur/BinWidth);
    ViewPort = [ViewPort(1), ViewPort(1)+(BinWidth*NBin)];
else, CalcParamIncList = {'Reps', 'NBin', 'MinISI', 'ConSubTr', 'AvgWin', 'HistRunAv', 'MinNInt'}; end
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'HistRunAv'); 
if (RunAv > NBin), ErrTxt = 'Number of points for running average cannot be larger than number of bins'; return; end
CalcData   = CalcRGLH(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, ...
    'viewport', ViewPort, 'nbin', NBin, 'runav', RunAv, 'minisi', MinISI, 'timesubtr', ConSubTr, ...
    'avgwin', AvgWin, 'minnint', MinNInt);

%Generate multiple curve, for each subsequence in the analysis one ...
SubSeqTxt = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
for n = 1:NPlots,
    %Assembling the PlotStruct structure ...
    PlotStruct(n).Layout     = 'multi';
    %Curve with only the coefficient of variation ...
    if strcmpi(RAPStat.PlotParam.Rgl.YAxisUnit, 'cv'), 
        PlotStruct(n).Plot.Type      = 'line';
        PlotStruct(n).Plot.XData     = CalcData.hist(n).bincenters;
        PlotStruct(n).Plot.YData     = CalcData.hist(n).cv;
        PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Rgl.CV.LineColor;
        PlotStruct(n).Plot.EdgeColor = [];
        PlotStruct(n).Plot.LineStyle = RAPStat.PlotParam.Rgl.CV.LineStyle;
        PlotStruct(n).Plot.LineWidth = RAPStat.PlotParam.Rgl.CV.LineWidth;
        PlotStruct(n).Plot.Marker    = 'none';
        YLabelStr = 'Coeff. of Variation';
        CalcDataStr = sprintf('\\itCV\\rm: %.2f', CalcData.hist(n).avgcv);
    %Curve with mean and standard deviation ...
    elseif strcmpi(RAPStat.PlotParam.Rgl.YAxisUnit, 'mean'), 
        PlotStruct(n).Plot.Type      = 'line';
        PlotStruct(n).Plot.XData     = CalcData.hist(n).bincenters;
        PlotStruct(n).Plot.YData     = CalcData.hist(n).mean; 
        PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Rgl.Avg.LineColor;
        PlotStruct(n).Plot.EdgeColor = [];
        PlotStruct(n).Plot.LineStyle = RAPStat.PlotParam.Rgl.Avg.LineStyle;
        PlotStruct(n).Plot.LineWidth = RAPStat.PlotParam.Rgl.Avg.LineWidth;
        PlotStruct(n).Plot.Marker    = 'none';
        
        PlotStruct(n).Add(1).Type       = 'line';
        PlotStruct(n).Add(1).X          = CalcData.hist(n).bincenters;
        PlotStruct(n).Add(1).Y          = CalcData.hist(n).std;
        PlotStruct(n).Add(1).FaceColor  = RAPStat.PlotParam.Rgl.Std.LineColor;  
        PlotStruct(n).Add(1).EdgeColor  = [];
        PlotStruct(n).Add(1).LineStyle  = RAPStat.PlotParam.Rgl.Std.LineStyle;
        PlotStruct(n).Add(1).LineWidth  = RAPStat.PlotParam.Rgl.Std.LineWidth;
        PlotStruct(n).Add(1).Marker     = 'none';
        
        YLabelStr = 'Mean and Std. Dev. (ms)';
        CalcDataStr = {sprintf('\\itMean\\rm: %.1f', CalcData.hist(n).avgmean);
            sprintf('\\itStd\\rm: %.1f', CalcData.hist(n).avgstd)};
    end
    
    PlotStruct(n).Axis.Color     = RAPStat.PlotParam.Axis.Color;
    PlotStruct(n).Axis.Box       = RAPStat.PlotParam.Axis.Box;
    PlotStruct(n).Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
    PlotStruct(n).Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
    PlotStruct(n).Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
    PlotStruct(n).Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;
    
    PlotStruct(n).Axis.X = RAPStat.PlotParam.Axis.X;
    PlotStruct(n).Axis.X.Limits = ViewPort;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct(n).Axis.X.Label.String = 'Time (ms)'; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct(n).Axis.X.Scale = 'linear'; end
    
    PlotStruct(n).Axis.Y = RAPStat.PlotParam.Axis.Y;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct(n).Axis.Y.Label.String = YLabelStr; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct(n).Axis.Y.Scale = 'linear'; end
    
    %Title is only displayed for the first plot in the range ...
    PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
    if (n == 1) & isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct(n).Title.Label = 'Regularity Analysis';
    elseif (n ~= 1), PlotStruct(n).Title.Label = ''; end
        
    %Every plot must contain information on the subsequences numbers it represents ...
    PlotStruct(n).Text = struct([]);
    if strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
        PlotStruct(n).Text(end).Label      = SubSeqTxt{n};
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Extracted parameters ...
    if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcData;
        PlotStruct(n).Text(end).Label      = CalcDataStr;
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Extra information on calculation parameters is only displayed for the first plot in the range ...
    if (n == 1) & strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
        PlotStruct(n).Text(end).Label      = AssembleRAPCalcParam(RAPStat, CalcParamIncList, 's');
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Adding additional plot elements, such as analysis window ...
    PlotStruct(n).Setup = CreateRAPPlotElem(RAPStat, 'avgwin');
end

%If upper limit of ordinate is set to default, then maximum of all plots is
%determined by the maximum value across all curves ...
if strcmpi(RAPStat.PlotParam.Rgl.YAxisUnit, 'cv'), [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.hist, 'cv');
else, [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, cat(2, CalcData.hist.mean, CalcData.hist.std)); end
if ~isempty(ErrTxt), return; end

%Setting calculated data information in the RAP status variable... For regularity
%analysis this data is the coefficient of variation ...
RAPStat.CalcData.XData         = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData         = PlotStruct(end).Plot.YData;
RAPStat.CalcData.RGL.CV        = CalcData.hist(end).avgcv;