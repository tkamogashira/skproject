function [RAPStat, PlotStruct, ErrTxt] = CalcRAPSac(RAPStat)
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

ErrTxt = ''; %#ok
PlotStruct = [];

%Checking of a dataset is specified and if autocorrelogram can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS')
    ErrTxt = 'No dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) || isCALIBdata(RAPStat.GenParam.DS)
    ErrTxt = 'SAC cannot be plotted for current dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConSubTr ...
ds = RAPStat.GenParam.DS;
Spt = ds.spt;
iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
NPlots = length(iSubSeqs);
Spt = Spt(iSubSeqs, :);
if (NPlots == 0)
    ErrTxt = 'No recorded subsequences for this dataset';
    return;
end
iReps = GetRAPCalcParam(RAPStat, 'nr', 'Reps');
NRep = length(iReps);
Spt = Spt(:, iReps);
AnWin = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin = MergeRAPWin(AnWin, ReWin);
Spt = ApplyAnWin(Spt, AnWin);
AnWinDur = GetRAPWinDur(RAPStat);
RunAvN = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
MinISI = GetRAPCalcParam(RAPStat, 'nr', 'MinISI');
Spt = ApplyMinISI(Spt, MinISI);
ConSubTr = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr');
Spt = ApplyTimeSubtr(Spt, ConSubTr);

BinWidth = GetRAPCalcParam(RAPStat, 'nr', 'CorBinWidth');
MaxLag = GetRAPCalcParam(RAPStat, 'nr', 'CorMaxLag');

%Generate multiple correlograms, for each subsequence in the analysis one ...
SubSeqTxt = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcData(1:NPlots) = deal(struct);
for n = 1:NPlots
    %Calculating the correlogram ...
    [CalcData(n).Corr, CalcData(n).BinCenters, NormConst] = ...
        SPTCORR(Spt(n, :), 'nodiag', MaxLag, BinWidth, AnWinDur);
    NormConst
    CalcData(n).Count = runav(CalcData(n).Corr/(NRep*(NRep-1)), RunAvN);
    CalcData(n).Rate  = runav((1000*CalcData(n).Corr) / (AnWinDur*(NRep*(NRep-1))), RunAvN);
    CalcData(n).Norm  = runav(CalcData(n).Corr/NormConst.DriesNorm, RunAvN);
    
    %Assembling the PlotStruct structure ...
    PlotStruct(n).Layout     = 'multi';
    PlotStruct(n).Plot.Type  = 'line';
    PlotStruct(n).Plot.XData = CalcData(n).BinCenters;
    if strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'rate')
        PlotStruct(n).Plot.YData = CalcData(n).Rate;
        YUnitStr = '# coincidences/sec';
        Asymptote = GetAsymptote(CalcData(n).Rate, 0.05);
    elseif strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'count')
        PlotStruct(n).Plot.YData = CalcData(n).Count; 
        YUnitStr = '# coincidences';
        Asymptote = GetAsymptote(CalcData(n).Count, 0.05);
    else 
        PlotStruct(n).Plot.YData = CalcData(n).Norm; 
        YUnitStr = 'Norm';
        Asymptote = 1;
    end
    PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Corr.LineColor;
    PlotStruct(n).Plot.EdgeColor = [];
    PlotStruct(n).Plot.LineStyle = RAPStat.PlotParam.Corr.LineStyle;
    PlotStruct(n).Plot.LineWidth = RAPStat.PlotParam.Corr.LineWidth;
    PlotStruct(n).Plot.Marker    = RAPStat.PlotParam.Corr.Marker;
    
    PlotStruct(n).Axis.Color     = RAPStat.PlotParam.Axis.Color;
    PlotStruct(n).Axis.Box       = RAPStat.PlotParam.Axis.Box;
    PlotStruct(n).Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
    PlotStruct(n).Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
    PlotStruct(n).Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
    PlotStruct(n).Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;
    
    PlotStruct(n).Axis.X = RAPStat.PlotParam.Axis.X;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String')
        PlotStruct(n).Axis.X.Label.String = 'Delay (ms)';
    end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale')
        PlotStruct(n).Axis.X.Scale = 'linear';
    end
    
    PlotStruct(n).Axis.Y = RAPStat.PlotParam.Axis.Y;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String')
        PlotStruct(n).Axis.Y.Label.String = sprintf('Rate (%s)', YUnitStr);
    end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale')
        PlotStruct(n).Axis.Y.Scale = 'linear';
    end
    
    %Title is only displayed for the first plot in the range ...
    PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
    if (n == 1) && isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label')
        PlotStruct(n).Title.Label = 'Auto Correlogram';
    elseif (n ~= 1)
        PlotStruct(n).Title.Label = '';
    end
    
    %Every plot must contain information on the subsequences numbers it represents ...
    PlotStruct(n).Text = struct([]);
    if strcmpi(RAPStat.PlotParam.Axis.Text.SubSeq, 'on')
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.SubSeq;
        PlotStruct(n).Text(end).Label      = SubSeqTxt{n};
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end

    %Extract calculation parameters. Running average changes the calculation ... (For FFT
    %this acts as a lowpass filter)
    MeanCorr = mean(CalcData(n).Corr);
    FFTStruct = spectana(CalcData(n).BinCenters, CalcData(n).Corr-MeanCorr);
    [DomFreq, BandWidth] = deal(FFTStruct.DF, FFTStruct.BW);
    PeakHeight = max(PlotStruct(n).Plot.YData); 
    HalfHeight = ((PeakHeight - Asymptote)/2) + Asymptote;
    HalfHeightx = cintersect(PlotStruct(n).Plot.XData, PlotStruct(n).Plot.YData, HalfHeight);
    HalfHeightWidth = abs(diff(HalfHeightx));
    
    if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on')
        PlotStruct(n).Text(end+1).Location   = RAPStat.PlotParam.Axis.Text.Location.CalcData;
        PlotStruct(n).Text(end).Label      = {sprintf('\\itDomFreq\\rm: %.0f Hz', DomFreq), ...
                sprintf('\\itBandWidth\\rm: %.0f Hz', BandWidth), ...
                sprintf('\\itPeakHeight\\rm: %.2f', PeakHeight), ...
                sprintf('\\itHHW\\rm: %.2f ms', HalfHeightWidth)};
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end

    %Extra information on calculation parameters is only displayed for the first plot in the range ...
    if (n == 1) && strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on')
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
        PlotStruct(n).Text(end).Label      = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'CorMaxLag', 'CorBinWidth', 'CurveRunAv', 'MinISI', 'ConSubTr'}, 's');
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Adding additional plot elements, such as analysis window ...
    PlotStruct(n).Add([1 2]) = CreateRAPPlotElem(RAPStat, 'zerolines');
    PlotStruct(n).Add(3).Type      = 'line';
    PlotStruct(n).Add(3).X         = HalfHeightx;
    PlotStruct(n).Add(3).Y         = HalfHeight([1 1]);
    PlotStruct(n).Add(3).FaceColor = RAPStat.PlotParam.Corr.HHWLine.LineColor;
    PlotStruct(n).Add(3).EdgeColor = [];
    PlotStruct(n).Add(3).LineStyle = RAPStat.PlotParam.Corr.HHWLine.LineStyle;
    PlotStruct(n).Add(3).LineWidth = RAPStat.PlotParam.Corr.HHWLine.LineWidth;
    PlotStruct(n).Add(3).Marker    = 'none';
end

%If upper limit of ordinate is set to default, then maximum of all plots is
%determined by the maximum value across all curves ...
if strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'rate')
    [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData, 'Rate');
elseif strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'norm')
    [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData, 'Norm');
else
    [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData, 'Count');
end
if ~isempty(ErrTxt)
    return;
end

%Setting calculated data information in the RAP status variable... 
RAPStat.CalcData.XData        = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData        = PlotStruct(end).Plot.YData;
RAPStat.CalcData.SAC.DF       = DomFreq;        %Dominant Frequency in Hz ...
RAPStat.CalcData.SAC.BW       = BandWidth;      %Bandwidth in Hz ...
RAPStat.CalcData.SAC.PH       = PeakHeight;     %Peak height in requested units ... 
RAPStat.CalcData.SAC.HHW      = HalfHeightWidth;%Half height width in ms ... 

%-----------------------------locals-------------------------------
function Asymptote = GetAsymptote(Y, Percent)

N = length(Y);
Nmargin = round(N*Percent);
Asymptote = mean(Y([1:Nmargin, end-Nmargin+1:end]));
