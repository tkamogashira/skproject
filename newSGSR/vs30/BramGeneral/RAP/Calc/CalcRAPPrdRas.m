function [RAPStat, PlotStruct, ErrTxt] = CalcRAPPrdRas(RAPStat)
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

%Checking of a dataset is specified and if PRD dot raster can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) || isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'PRD dot raster cannot be plotted for current dataset stimulus type'; 
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
ViewPort   = GetRAPHistWindow(RAPStat, 'prdh');
if (diff(ViewPort) <= 0), ErrTxt = 'Invalid limits for abcissa'; return; end
if (ViewPort(1) < 0) || (ViewPort(2) > 1),
    fprintf('WARNING: Abcissa limits aren''t valid for period histogram. Using default limits.\n');
    ViewPort = [0 1];
end
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
[BinFreq, ErrTxt] = GetRAPCalcParam(RAPStat, 'nr', 'BinFreq');
if ~isempty(ErrTxt), return; else BinFreq = abs(BinFreq); end
IntNCycles = GetRAPCalcParam(RAPStat, 'nr', 'IntNCycles'); 
CalcData   = CalcPRDRAS(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, ...
    'binfreq', BinFreq, 'minisi', MinISI, 'timesubtr', ConSubTr, ...
    'intncycles', IntNCycles);

%Generate multiple period histograms, for each subsequence in the analysis one ...
SubSeqTxt    = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcParamTxt = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'BinFreq', 'IntNCycles', 'MinISI', 'ConSubTr'}, 'm');
for n = 1:NPlots,
    %Assembling the PlotStruct structure ...
    PlotStruct(n).Layout     = 'multi';
    PlotStruct(n).Plot.Type  = 'line';
    PlotStruct(n).Plot.XData = CalcData.ras(n).phase;
    PlotStruct(n).Plot.YData = CalcData.ras(n).cycnr; 
    PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Raster.Colors(1, :);
    PlotStruct(n).Plot.EdgeColor = [];
    PlotStruct(n).Plot.LineStyle = 'none';
    PlotStruct(n).Plot.LineWidth = 1;
    PlotStruct(n).Plot.Marker    = '.';
    
    PlotStruct(n).Axis.Color     = RAPStat.PlotParam.Axis.Color;
    PlotStruct(n).Axis.Box       = RAPStat.PlotParam.Axis.Box;
    PlotStruct(n).Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
    PlotStruct(n).Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
    PlotStruct(n).Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
    PlotStruct(n).Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;
    
    PlotStruct(n).Axis.X = RAPStat.PlotParam.Axis.X;
    PlotStruct(n).Axis.X.Limits = ViewPort;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct(n).Axis.X.Label.String = 'Phase (cyc)'; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct(n).Axis.X.Scale = 'linear'; end
    
    PlotStruct(n).Axis.Y = RAPStat.PlotParam.Axis.Y;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct(n).Axis.Y.Label.String = 'Cycle Nr.'; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct(n).Axis.Y.Scale = 'linear'; end
    
    %Title is only displayed for the first plot in the range ...
    PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
    if (n == 1) && isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct(n).Title.Label = 'PRD Dot Raster';
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
%determined by the maximum value for each individual curve ...
if isinf(RAPStat.PlotParam.Axis.Y.Limits(2)),
    for n = 1:NPlots, PlotStruct(n).Axis.Y.Limits(2) = CalcData.ras(n).ncyc; end
end

%Setting calculated data information in the RAP status variable...
RAPStat.CalcData.XData         = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData         = PlotStruct(end).Plot.YData;