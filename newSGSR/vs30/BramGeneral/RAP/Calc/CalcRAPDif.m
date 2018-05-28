function [RAPStat, PlotStruct, ErrTxt] = CalcRAPDif(RAPStat)
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

%Checking if two datasets are specified and if difcor can be calculated for the
%current datasets ...
if isRAPStatDef(RAPStat, 'GenParam.DS') | isRAPStatDef(RAPStat, 'GenParam.DS2'), 
    ErrTxt = 'No foreground or background dataset specified'; 
    return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
    ErrTxt = 'DIFCOR cannot be plotted for current foreground dataset stimulus type'; 
    return;
elseif isTHRdata(RAPStat.GenParam.DS2) | isCALIBdata(RAPStat.GenParam.DS2), 
    ErrTxt = 'DIFCOR cannot be plotted for current background dataset stimulus type'; 
    return;
end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConSubst ...
ds         = RAPStat.GenParam.DS; Spt1 = ds.spt; [dummy, dummy, dsID1] = unraveldsID(ds.SeqID);
iSubSeqs1  = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); Spt1 = Spt1(iSubSeqs1, :);
if isempty(iSubSeqs1), ErrTxt = 'No recorded subsequences for foreground dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps'); NRep1 = length(iReps); Spt1 = Spt1(:, iReps);
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin); Spt1 = ApplyAnWin(Spt1, AnWin);
AnWinDur1  = GetRAPWinDur(RAPStat);
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); Spt1 = ApplyMinISI(Spt1, MinISI);
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); Spt1 = ApplyTimeSubTr(Spt1, ConSubTr);
SubSeqTxt1    = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcParamTxt1 = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'MinISI', 'ConSubTr'}, 's');

RAPStat    = SwapRAPDataSets(RAPStat);
ds         = RAPStat.GenParam.DS; Spt2 = ds.spt; [dummy, dummy, dsID2] = unraveldsID(ds.SeqID);
iSubSeqs2  = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); Spt2 = Spt2(iSubSeqs2, :);
if isempty(iSubSeqs2), ErrTxt = 'No recorded subsequences for background dataset'; return; end
iReps      = GetRAPCalcParam(RAPStat, 'nr', 'Reps'); NRep2 = length(iReps); Spt2 = Spt2(:, iReps);
AnWin      = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
ReWin      = GetRAPCalcParam(RAPStat, 'nr', 'ReWin');
AnWin      = MergeRAPWin(AnWin, ReWin); Spt2 = ApplyAnWin(Spt2, AnWin);
AnWinDur2  = GetRAPWinDur(RAPStat);
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); Spt2 = ApplyMinISI(Spt2, MinISI);
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); Spt2 = ApplyTimeSubTr(Spt2, ConSubTr);
SubSeqTxt2    = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcParamTxt2 = AssembleRAPCalcParam(RAPStat, {'Reps', 'AnWin', 'ReWin', 'MinISI', 'ConSubTr'}, 's');
RAPStat    = SwapRAPDataSets(RAPStat); %Return to old status ...

BinWidth   = GetRAPCalcParam(RAPStat, 'nr', 'CorBinWidth');
MaxLag     = GetRAPCalcParam(RAPStat, 'nr', 'CorMaxLag');
RunAvN     = GetRAPCalcParam(RAPStat, 'nr', 'CurveRunAv');
EnvRunAvN  = GetRAPCalcParam(RAPStat, 'nr', 'EnvRunAv')/BinWidth;
if ~isequal(AnWinDur1, AnWinDur2), fprintf('WARNING: Duration of analysis window is different for both datasets. Average of both is used.\n'); end    
AnWinDur   = mean(AnWinDur1, AnWinDur2);
if ~isequal(length(iSubSeqs1), length(iSubSeqs2)), 
    fprintf('WARNING: Range restrictions don''t have same length. Using minimum of both.\n');
    NPlots = min(length(iSubSeqs1), length(iSubSeqs2));
else, NPlots = length(iSubSeqs1); end
CalcParamTxt  = AssembleRAPCalcParam(RAPStat, {'CorMaxLag', 'CorBinWidth', 'CurveRunAv', 'EnvRunAv'}, 's');
CalcParamTxt1 = {CalcParamTxt{:}, sprintf('\\bf1^{st}DS:\\rm'), CalcParamTxt1{:}};
CalcParamTxt2 = {sprintf('\\bf2^{nd}DS:\\rm'), CalcParamTxt2{:}};
for n = 1:NPlots, SubSeqTxt{n} = {sprintf('\\bf1^{st}DS: %s\\rm', dsID1), SubSeqTxt1{n}{:}, sprintf('\\bf2^{nd}DS: %s\\rm', dsID2), SubSeqTxt2{n}{:}}; end    

%Generate multiple correlograms, for each subsequence in the analysis one ...
for n = 1:NPlots,
    %Calculating the difcor ...
    [Ypp, T, NCpp] = sptcorr(Spt1(n, :), 'nodiag', MaxLag, BinWidth, AnWinDur1); %SAC ...
    [Ynn, T, NCnn] = sptcorr(Spt2(n, :), 'nodiag', MaxLag, BinWidth, AnWinDur2); %SAC ...
    [Ypn, T, NCpn] = sptcorr(Spt1(n, :), Spt2(n, :), MaxLag, BinWidth, AnWinDur); %XAC ...
    
    CalcData(n).BinCenters = T;
    CalcData(n).Corr = mean([Ypp; Ynn]) - Ypn;
    YppRate  = (1000*Ypp)/(AnWinDur1*(NRep1*(NRep1-1)));
    YnnRate  = (1000*Ynn)/(AnWinDur2*(NRep2*(NRep2-1)));
    YpnRate  = (1000*Ypn)/(AnWinDur*(NRep1*NRep2));
    CalcData(n).Rate = runav(mean([YppRate; YnnRate]) - YpnRate, RunAvN);
    CalcData(n).RateEnv = runav(abs(hilbert(CalcData(n).Rate)), EnvRunAvN);
    YppCount = Ypp/(NRep1*(NRep1-1));
    YnnCount = Ynn/(NRep2*(NRep2-1));
    YpnCount = Ypn/(NRep1*NRep2);
    CalcData(n).Count = runav(mean([YppCount; YnnCount]) - YpnCount, RunAvN);
    CalcData(n).CountEnv = runav(abs(hilbert(CalcData(n).Count)), EnvRunAvN);
    YppNorm  = Ypp./NCpp.DriesNorm;
    YnnNorm  = Ynn./NCnn.DriesNorm;
    YpnNorm  = Ypn./NCpn.DriesNorm;
    CalcData(n).Norm = runav(mean([YppNorm; YnnNorm]) - YpnNorm, RunAvN);
    CalcData(n).NormEnv = runav(abs(hilbert(CalcData(n).Norm)), EnvRunAvN);
    
    %Assembling the PlotStruct structure ...
    PlotStruct(n).Layout     = 'multi';
    PlotStruct(n).Plot.Type  = 'line';
    PlotStruct(n).Plot.XData = CalcData(n).BinCenters;
    if strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'rate'), 
        PlotStruct(n).Plot.YData = CalcData(n).Rate;
        YUnitStr = 'spk/sec';
        Env = CalcData(n).RateEnv;
    elseif strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'count'), 
        PlotStruct(n).Plot.YData = CalcData(n).Count;
        YUnitStr = '# spk';
        Env = CalcData(n).CountEnv;
    else, 
        PlotStruct(n).Plot.YData = CalcData(n).Norm;
        YUnitStr = 'Norm';
        Env = CalcData(n).NormEnv;
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
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct(n).Axis.X.Label.String = 'Delay (ms)'; end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct(n).Axis.X.Scale = 'linear'; end
    
    PlotStruct(n).Axis.Y = RAPStat.PlotParam.Axis.Y;
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct(n).Axis.Y.Label.String = sprintf('Rate (%s)', YUnitStr); end
    if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct(n).Axis.Y.Scale = 'linear'; end
    
    %Title is only displayed for the first plot in the range ...
    PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
    if (n == 1) & isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct(n).Title.Label = 'Difcor';
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

    %Extract calculation parameters. Running average changes the calculation ... (For FFT
    %this acts as a lowpass filter)
    FFTStruct = spectana(CalcData(n).BinCenters, CalcData(n).Corr);
    [DomFreq, BandWidth] = deal(FFTStruct.DF, FFTStruct.BW);
    PeakHeight = max(PlotStruct(n).Plot.YData); 
    HalfMax = max(Env)/2;
    HalfHeightx = cintersect(CalcData(n).BinCenters, Env, HalfMax); 
    HalfHeightWidth = abs(diff(HalfHeightx));

    if strcmpi(RAPStat.PlotParam.Axis.Text.CalcData, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcData;
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
    if (n == 1) & strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam;
        PlotStruct(n).Text(end).Label      = CalcParamTxt1;
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    if (n == 1) & strcmpi(RAPStat.PlotParam.Axis.Text.CalcParam2, 'on'),
        PlotStruct(n).Text(end+1).Location = RAPStat.PlotParam.Axis.Text.Location.CalcParam2;
        PlotStruct(n).Text(end).Label      = CalcParamTxt2;
        PlotStruct(n).Text(end).FontName   = RAPStat.PlotParam.Axis.Text.FontName;
        PlotStruct(n).Text(end).FontSize   = RAPStat.PlotParam.Axis.Text.FontSize;
        PlotStruct(n).Text(end).FontWeight = 'normal';
        PlotStruct(n).Text(end).FontAngle  = 'normal';
        PlotStruct(n).Text(end).Color      = RAPStat.PlotParam.Axis.Text.Color;
    end
    
    %Adding additional plot elements, such as envelope ...
    PlotStruct(n).Setup([1 2]) = CreateRAPPlotElem(RAPStat, 'zerolines');
    PlotStruct(n).Add(1).Type      = 'line';
    PlotStruct(n).Add(1).X         = CalcData(n).BinCenters;
    PlotStruct(n).Add(1).Y         = Env; 
    PlotStruct(n).Add(1).FaceColor = RAPStat.PlotParam.Corr.Env.LineColor;
    PlotStruct(n).Add(1).EdgeColor = [];
    PlotStruct(n).Add(1).LineStyle = RAPStat.PlotParam.Corr.Env.LineStyle;
    PlotStruct(n).Add(1).LineWidth = RAPStat.PlotParam.Corr.Env.LineWidth;
    PlotStruct(n).Add(1).Marker    = 'none';
    PlotStruct(n).Add(2).Type      = 'line';
    PlotStruct(n).Add(2).X         = PlotStruct(n).Plot.XData;
    PlotStruct(n).Add(2).Y         = -Env;
    PlotStruct(n).Add(2).FaceColor = RAPStat.PlotParam.Corr.Env.LineColor;
    PlotStruct(n).Add(2).EdgeColor = [];
    PlotStruct(n).Add(2).LineStyle = RAPStat.PlotParam.Corr.Env.LineStyle;
    PlotStruct(n).Add(2).LineWidth = RAPStat.PlotParam.Corr.Env.LineWidth;
    PlotStruct(n).Add(2).Marker    = 'none';
    PlotStruct(n).Add(3).Type      = 'line';
    PlotStruct(n).Add(3).X         = HalfHeightx;
    PlotStruct(n).Add(3).Y         = HalfMax([1 1]);
    PlotStruct(n).Add(3).FaceColor = RAPStat.PlotParam.Corr.HHWLine.LineColor;
    PlotStruct(n).Add(3).EdgeColor = [];
    PlotStruct(n).Add(3).LineStyle = RAPStat.PlotParam.Corr.HHWLine.LineStyle;
    PlotStruct(n).Add(3).LineWidth = RAPStat.PlotParam.Corr.HHWLine.LineWidth;
    PlotStruct(n).Add(3).Marker    = 'none';
end

%If upper limit of ordinate is set to default, then maximum of all plots is
%determined by the maximum value across all curves ...
if strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'rate'), 
    [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, cat(2, CalcData.Rate, CalcData.RateEnv));
elseif strcmp(RAPStat.PlotParam.Corr.YAxisUnit, 'norm'), 
    [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, cat(2, CalcData.Norm, CalcData.NormEnv));
else, [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, cat(2, CalcData.Count, CalcData.CountEnv)); end
if ~isempty(ErrTxt), return; end

%Setting calculated data information in the RAP status variable... 
RAPStat.CalcData.XData       = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData       = PlotStruct(end).Plot.YData;
RAPStat.CalcData.DIF.DF      = DomFreq;        %Dominant Frequency in Hz ...
RAPStat.CalcData.DIF.BW      = BandWidth;      %Bandwidth in Hz ...
RAPStat.CalcData.DIF.PH      = PeakHeight;     %Peak height in requested units ... 
RAPStat.CalcData.DIF.HHW     = HalfHeightWidth;%Half height width in ms ...