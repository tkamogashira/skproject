function [RAPStat, PlotStruct, ErrTxt] = CalcRAPTrd(RAPStat)
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

ErrTxt = ''; 

%Checking of a dataset is specified and if TRD can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'TRD cannot be plotted for current dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI, ConSubTr etc ...
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); NPlots = length(iSubSeqs);
if (NPlots == 0), ErrTxt = 'No recorded subsequences for this dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin);
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
if (RunAv > length(iReps)), ErrTxt = 'Number of points for running average is too large'; return; end
CalcData   = CalcRRD(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, 'runav', RunAv, ...
    'minisi', MinISI, 'timesubtr', ConSubTr);

%Generate multiple period histograms, for each subsequence in the analysis one ...
SubSeqTxt    = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcParamTxt = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'CurveRunAv', 'MinISI', 'ConSubTr'}, 'm');
for n = 1:NPlots,
    %Assembling the PlotStruct structure ...
    PlotStruct(n).Layout     = 'multi';
    PlotStruct(n).Plot.Type  = 'line';
    PlotStruct(n).Plot.XData = CalcData.distr(n).repnr;
    if strcmpi(RAPStat.PlotParam.Trd.YAxisUnit, 'rate'), 
        PlotStruct(n).Plot.YData = CalcData.distr(n).rate;
        YUnitStr = 'spk/sec';
        Avg = CalcData.distr(n).avgrate; Std = CalcData.distr(n).stdrate;
    else, 
        PlotStruct(n).Plot.YData = CalcData.distr(n).n;
        YUnitStr = '# spk';
        Avg = CalcData.distr(n).avgn; Std = CalcData.distr(n).stdn;
    end
    PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Trd.LineColor;
    PlotStruct(n).Plot.EdgeColor = [];
    PlotStruct(n).Plot.LineStyle = RAPStat.PlotParam.Trd.LineStyle;
    PlotStruct(n).Plot.LineWidth = RAPStat.PlotParam.Trd.LineWidth;
    PlotStruct(n).Plot.Marker    = RAPStat.PlotParam.Trd.Marker;
    
    PlotStruct(n).Add(1).Type       = 'line';
    PlotStruct(n).Add(1).X          = [-Inf, +Inf];
    PlotStruct(n).Add(1).Y          = Avg+Std([1 1]);
    PlotStruct(n).Add(1).FaceColor  = RAPStat.PlotParam.Trd.StdLine.LineColor;  
    PlotStruct(n).Add(1).EdgeColor  = [];
    PlotStruct(n).Add(1).LineStyle  = RAPStat.PlotParam.Trd.StdLine.LineStyle;
    PlotStruct(n).Add(1).LineWidth  = RAPStat.PlotParam.Trd.StdLine.LineWidth;
    PlotStruct(n).Add(1).Marker     = 'none';
    PlotStruct(n).Add(2).Type       = 'line';
    PlotStruct(n).Add(2).X          = [-Inf, +Inf];
    PlotStruct(n).Add(2).Y          = Avg-Std([1 1]);
    PlotStruct(n).Add(2).FaceColor  = RAPStat.PlotParam.Trd.StdLine.LineColor;
    PlotStruct(n).Add(2).EdgeColor  = [];
    PlotStruct(n).Add(2).LineStyle  = RAPStat.PlotParam.Trd.StdLine.LineStyle;
    PlotStruct(n).Add(2).LineWidth  = RAPStat.PlotParam.Trd.StdLine.LineWidth;
    PlotStruct(n).Add(2).Marker     = 'none';
    PlotStruct(n).Add(3).Type       = 'line';
    PlotStruct(n).Add(3).X          = [-Inf, +Inf];
    PlotStruct(n).Add(3).Y          = Avg([1 1]);
    PlotStruct(n).Add(3).FaceColor  = RAPStat.PlotParam.Trd.AvgLine.LineColor;
    PlotStruct(n).Add(3).EdgeColor  = [];
    PlotStruct(n).Add(3).LineStyle  = RAPStat.PlotParam.Trd.AvgLine.LineStyle;
    PlotStruct(n).Add(3).LineWidth  = RAPStat.PlotParam.Trd.AvgLine.LineWidth;
    PlotStruct(n).Add(3).Marker     = 'none';
   
    PlotStruct(n).Axis.Color     = RAPStat.PlotParam.Axis.Color;
    PlotStruct(n).Axis.Box       = RAPStat.PlotParam.Axis.Box;
    PlotStruct(n).Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
    PlotStruct(n).Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
    PlotStruct(n).Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
    PlotStruct(n).Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;
    
    PlotStruct(n).Axis.X = RAPStat.PlotParam.Axis.X;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct(n).Axis.X.Label.String = 'Rep. Nr.'; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct(n).Axis.X.Scale = 'linear'; end
    
    PlotStruct(n).Axis.Y = RAPStat.PlotParam.Axis.Y;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct(n).Axis.Y.Label.String = sprintf('Rate (%s)', YUnitStr); end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct(n).Axis.Y.Scale = 'linear'; end
    
    %Title is only displayed for the first plot in the range ...
    PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
    if (n == 1) & isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct(n).Title.Label = 'Trial Rate Distribution';
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
        PlotStruct(n).Text(end).Label      = {sprintf('\\itAvg\\rm: %.2f', Avg), ...
                sprintf('\\itStd\\rm: %.2f', Std)};
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Extra information on calculation parameters is only on the first histogram of the range,
    %for the following histrograms only the binning frequency is displayed ...
    if strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
        PlotStruct(n).Text(end).Label      = CalcParamTxt{n};
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
end

%If upper limit of ordinate is set to default, then maximum of all plots is
%determined by the maximum value across all curves ...
if strcmpi(RAPStat.PlotParam.Trd.YAxisUnit, 'rate'), [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.distr, 'rate');
else, [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.distr, 'n'); end
if ~isempty(ErrTxt), return; end

%Setting calculated data information in the RAP status variable...
RAPStat.CalcData.XData   = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData   = PlotStruct(end).Plot.YData;
RAPStat.CalcData.TRD.Avg = Avg;   %Average rate in requested units ...
RAPStat.CalcData.TRD.Std = Std;   %Standard deviation on rate inrequested units ...