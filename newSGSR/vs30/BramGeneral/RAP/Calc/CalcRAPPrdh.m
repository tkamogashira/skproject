function [RAPStat, PlotStruct, ErrTxt] = CalcRAPPrdh(RAPStat, format)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005

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

%Checking of a dataset is specified and if PRD histogram can be calculated for the
%current dataset ...
if isRAPStatDef(RAPStat, 'GenParam.DS'), 
   ErrTxt = 'No dataset specified'; 
   return; 
elseif isTHRdata(RAPStat.GenParam.DS) | isCALIBdata(RAPStat.GenParam.DS), 
   ErrTxt = 'PRD histogram cannot be plotted for current dataset stimulus type'; 
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
if (ViewPort(1) < 0) | (ViewPort(2) > 1),
   fprintf('WARNING: Abcissa limits aren''t valid for period histogram. Using default limits.\n');
   ViewPort = [0 1];
end
MinISI     = GetRAPCalcParam(RAPStat, 'nr', 'MinISI'); 
ConSubTr   = GetRAPCalcParam(RAPStat, 'nr', 'ConSubTr'); 
NBin       = GetRAPCalcParam(RAPStat, 'nr', 'NBin'); 
if isnan(NBin), 
   CalcParamIncList = {'Reps', 'AnWin', 'ReWin', 'BinWidth', 'BinFreq', 'IntNCycles', 'HistRunAv', 'MinISI', 'ConSubTr'};
   BinWidth = GetRAPCalcParam(RAPStat, 'nr', 'BinWidth'); 
   %To avoid inaccuracies introduced by the conversion of binwidth to number of
   %bins, the offset of the viewport is adjusted to make the interval an integral
   %number of bins ...
   Dur = abs(diff(ViewPort)); NBin = floor(Dur/BinWidth);
   ViewPort = [ViewPort(1), ViewPort(1)+(BinWidth*NBin)];
else, CalcParamIncList = {'Reps', 'AnWin', 'ReWin', 'NBin', 'BinFreq', 'IntNCycles', 'HistRunAv', 'MinISI', 'ConSubTr'}; end
[BinFreq, ErrTxt] = GetRAPCalcParam(RAPStat, 'nr', 'BinFreq');
if ~isempty(ErrTxt), return; else, BinFreq = abs(BinFreq); end
RunAv      = GetRAPCalcParam(RAPStat, 'nr', 'HistRunAv'); 
if (RunAv > NBin), ErrTxt = 'Number of points for running average cannot be larger than number of bins'; return; end
IntNCycles = GetRAPCalcParam(RAPStat, 'nr', 'IntNCycles'); 
CalcData   = CalcPRDH(ds, 'isubseqs', iSubSeqs, 'ireps', iReps, 'anwin', AnWin, ...
   'viewport', ViewPort, 'nbin', NBin, 'runav', RunAv, 'binfreq', BinFreq, 'minisi', MinISI, ...
   'timesubtr', ConSubTr, 'intncycles', IntNCycles);

R   = [CalcData.hist.r];
Ph  = [CalcData.hist.ph];

%Generate multiple period histograms, for each subsequence in the analysis one ...
SubSeqTxt    = AssembleRAPCalcParam(RAPStat, {'SubSeqs', 'IndepVal'}, 'm');
CalcParamTxt = AssembleRAPCalcParam(RAPStat, CalcParamIncList, 'm');

if strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'rate'), 
   MaxData = max([CalcData.hist.rate]);
elseif strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'count'), 
   MaxData = max([CalcData.hist.n]); 
else,
   MaxData = max([CalcData.hist.frac]); 
end

for n = 1:NPlots,
   %Assembling the PlotStruct structure ...
   PlotStruct(n).Layout     = 'multi';
   
   PlotStruct(n).Plot.XData = CalcData.hist(n).bincenters;
   if strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'rate'), 
      PlotStruct(n).Plot.YData = CalcData.hist(n).rate;
      YUnitStr = 'spk/sec';
   elseif strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'count'), 
      PlotStruct(n).Plot.YData = CalcData.hist(n).n; 
      YUnitStr = '# spk';
   else,
      PlotStruct(n).Plot.YData = CalcData.hist(n).frac; 
      YUnitStr = '% of total';
   end
   
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
   if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct(n).Axis.Y.Label.String = sprintf('Rate (%s)', YUnitStr); end
   if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct(n).Axis.Y.Scale = 'linear'; end
   
   PlotStruct(n).Plot.FaceColor = RAPStat.PlotParam.Hist.FaceColor;
   PlotStruct(n).Plot.EdgeColor = RAPStat.PlotParam.Hist.EdgeColor;
   
   if isequal('hist', RAPStat.PlotParam.Hist.Sort), % Sort has higher priority than Style
      PlotStruct(n).Plot.BarStyle = RAPStat.PlotParam.Hist.Style;
   else
      PlotStruct(n).Plot.BarStyle = 'line';
   end
   
   PlotStruct(n).Plot.LineStyle = RAPStat.PlotParam.Hist.LineStyle;
   PlotStruct(n).Plot.LineWidth = RAPStat.PlotParam.Hist.LineWidth;
   PlotStruct(n).Plot.Marker    = [];
   
   if isequal( format, 'hist'),    
      PlotStruct(n).Plot.Type  = 'bar';
   elseif isequal(format, 'pol'),
      PlotStruct(n).Plot.Type  = 'pol';
      
      XX = MaxData * R(n) * cos( Ph(n) * 2 * pi );
      YY = MaxData * R(n) * sin( Ph(n) * 2 * pi );
      
      PlotStruct(n).Add.Type        = 'patch';
      PlotStruct(n).Add.X           = [0 XX];
      PlotStruct(n).Add.Y           = [0 YY];
      PlotStruct(n).Add.FaceColor   = 'r';
      PlotStruct(n).Add.EdgeColor   = 'r';
      PlotStruct(n).Add.LineStyle   = '-';
      PlotStruct(n).Add.LineWidth   = 0.5;
      PlotStruct(n).Add.Marker      = 'none';
   else,
      ErrTxt = 'Wrong format in Cycle analysis';
      return;
   end
   
   %Title is only displayed for the first plot in the range ...
   PlotStruct(n).Title = RAPStat.PlotParam.Axis.Title;
   if (n == 1) & isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct(n).Title.Label = 'PRD histogram';
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
      PlotStruct(n).Text(end).Label      = {sprintf('\\itR\\rm: %.2f', CalcData.hist(n).r), ...
            sprintf('\\itPh\\rm: %.2f', CalcData.hist(n).ph), ...
            sprintf('\\itRaySign\\rm: %.3f', CalcData.hist(n).raysign), ...
            sprintf('\\itNSpk\\rm: %d', CalcData.hist(n).nspk)};
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
if strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'rate'), [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.hist, 'rate');
elseif strcmpi(RAPStat.PlotParam.Hist.YAxisUnit, 'count'), [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.hist, 'n'); 
else, [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData.hist, 'frac'); end
if ~isempty(ErrTxt), return; end

if isequal(format, 'pol'),
   for n = 1:NPlots, 
      PlotStruct(n).Axis.Y.Limits(2) = PlotStruct(n).Axis.Y.Limits(2) * 1.25;
      PlotStruct(n).Axis.Y.Limits(1) = - PlotStruct(n).Axis.Y.Limits(2);
      PlotStruct(n).Axis.X.Limits(1) = - PlotStruct(n).Axis.Y.Limits(2);
      PlotStruct(n).Axis.X.Limits(2) = PlotStruct(n).Axis.Y.Limits(2);
      PlotStruct(n).Axis.GridSize    = MaxData;
      PlotStruct(n).Plot.YData       = PlotStruct(n).Plot.YData;
   end
end

%Setting calculated data information in the RAP status variable... For a PRD
%histogram this data is the binwidth ...
RAPStat.CalcData.XData         = PlotStruct(end).Plot.XData;
RAPStat.CalcData.YData         = PlotStruct(end).Plot.YData;
RAPStat.CalcData.Hist.BinWidth = CalcData.hist(n).binwidth; %Binwidth in ms ...
RAPStat.CalcData.Cyc.NSpk      = CalcData.hist(n).nspk;     %Number of spikes ...
RAPStat.CalcData.Cyc.R         = CalcData.hist(n).r;        %Synchronicity ...
RAPStat.CalcData.Cyc.RaySig    = CalcData.hist(n).raysign;  %Rayleigh significance ...
RAPStat.CalcData.Cyc.MaxPh     = CalcData.hist(n).ph;       %Phase at maximum ...
RAPStat.CalcData.Cyc.MinPh     = NaN;                       %Phase at minimum ... NOT YET IMPLEMENTED