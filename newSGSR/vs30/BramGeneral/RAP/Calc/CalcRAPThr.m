function [RAPStat, PlotStruct, ErrTxt] = CalcRAPThr(RAPStat)
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

%Checking of a dataset is specified and if threeshold curve can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
    ErrTxt = 'No dataset specified'; 
    return; 
elseif ~isTHRdata(RAPStat.GenParam.DS), 
    ErrTxt = 'Threshold curve cannot be plotted for current dataset stimulus type'; 
    return;
end

%Only the calculation parameter iSubSeqs is taken into account ...
ds         = RAPStat.GenParam.DS;
iSubSeqs   = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
if isempty(iSubSeqs), ErrTxt = 'No recorded subsequences for this dataset'; return; end
ThrQ       = GetRAPCalcParam(RAPStat, 'nr', 'ThrQ');
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
if (RunAv > length(iSubSeqs)), ErrTxt = 'Number of points for running average is too large'; return; end
CalcData = CalcTHR(ds, 'thr', ThrQ, 'runav', RunAv, 'isubseqs', iSubSeqs);

%Assembling the PlotStruct structure ...
PlotStruct.Layout         = 'uni';
PlotStruct.Plot.Type      = 'line';
PlotStruct.Plot.XData     = CalcData.curve.freq; 
PlotStruct.Plot.YData     = CalcData.curve.thr;
PlotStruct.Plot.FaceColor = RAPStat.PlotParam.Thr.LineColor;
PlotStruct.Plot.EdgeColor = [];
PlotStruct.Plot.LineStyle = RAPStat.PlotParam.Thr.LineStyle;
PlotStruct.Plot.LineWidth = RAPStat.PlotParam.Thr.LineWidth;
PlotStruct.Plot.Marker    = RAPStat.PlotParam.Thr.Marker;

PlotStruct.Axis.Color     = RAPStat.PlotParam.Axis.Color;
PlotStruct.Axis.Box       = RAPStat.PlotParam.Axis.Box;
PlotStruct.Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
PlotStruct.Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
PlotStruct.Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
PlotStruct.Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;

PlotStruct.Axis.X = RAPStat.PlotParam.Axis.X;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct.Axis.X.Label.String = ['Frequency (' ds.xunit ')' ]; end
%Determine most appropriate abcissa scale ...
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'),
    if (max(CalcData.curve.freq)/min(CalcData.curve.freq)) > 4, PlotStruct.Axis.X.Scale = 'log';
    else, PlotStruct.Axis.X.Scale = 'lin'; end
else, PlotStruct.Axis.X.Scale = RAPStat.PlotParam.Axis.X.Scale; end

PlotStruct.Axis.Y = RAPStat.PlotParam.Axis.Y;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct.Axis.Y.Label.String = 'Threshold (dB SPL)'; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct.Axis.Y.Scale = 'linear'; end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct.Title.Label = 'Threshold Curve'; end

%Information on the subsequences numbers included...
PlotStruct.Text = struct([]);
if strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, 'SubSeqs', 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on calculation parameters ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on'),
    PlotStruct.Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
    PlotStruct.Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'ThrQ', 'CurveRunAv'}, 's');
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Extra information on data ...
if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on'),
    PlotStruct.Text(end+1).Location   = RAPStat.PlotParam.Axis.Text.Location.CalcData;
    PlotStruct.Text(end).Label      = {sprintf('\\itCF:\\rm %.0f (Hz)', CalcData.curve.cf), ...
            sprintf('\\itminThr:\\rm %.0f (dB SPL)', CalcData.curve.minthr), ...
            sprintf('\\itSA:\\rm %.2f (spk/sec)', CalcData.curve.sr), ...
            sprintf('\\itQ%.0f:\\rm %.2f', ThrQ, CalcData.curve.q), ...
            sprintf('\\itBW:\\rm %.0f (Hz)', CalcData.curve.bw)};
    PlotStruct.Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
    PlotStruct.Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
    PlotStruct.Text(end).FontWeight = 'normal';
    PlotStruct.Text(end).FontAngle  = 'normal';
    PlotStruct.Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
end

%Setting calculated data information in the RAP status variable... For a threshold
%curve this data is the center frequency, minimum threshold, the Q10, the bandwidth at
%10dB and the spontaneous activity ...
RAPStat.CalcData.XData       = PlotStruct.Plot.XData;
RAPStat.CalcData.YData       = PlotStruct.Plot.YData;
RAPStat.CalcData.Thr.CF      = CalcData.curve.cf;
RAPStat.CalcData.Thr.minThr  = CalcData.curve.minthr;
RAPStat.CalcData.Thr.Q       = CalcData.curve.q;
RAPStat.CalcData.Thr.BW      = CalcData.curve.bw;
RAPStat.CalcData.Thr.BWx     = CalcData.curve.bwf;
RAPStat.CalcData.Thr.SponAct = CalcData.curve.sr;

%Adding additional plot elements, such as Q10 line and marker at CF ...
PlotStruct.Add = CreateRAPPlotElem(RAPStat, 'thr');