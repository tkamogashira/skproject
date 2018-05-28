function ListRAPStatus(RAPStat)
%ListRAPStatus  lists RAPStatus structure
%   ListRAPStatus(RAPStat) lists the RAP status on the MATLAB command
%   window.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005

%Setting the last error to a meaningful string... This error message 
%appears when user interrupts the output on the command window by
%pressing 'q' on the '--more--' prompt ...
if strcmpi(RAPStat.ComLineParam.More, 'on'), lasterr('Screen output interrupted by user.'); end

%-------------------------------------------------------------------------
GenParam = RAPStat.GenParam;
fprintf('General parameters\n');
fprintf('------------------\n');
if isRAPStatDef(RAPStat, 'GenParam.DataFile'), fprintf('No datafile specified.\n');
else, fprintf('Current datafile : %s\n', upper(GenParam.DataFile)); end
SecDSDef = ~isRAPStatDef(RAPStat, 'GenParam.SeqNr2');
if ~SecDSDef, 
    if isRAPStatDef(RAPStat, 'GenParam.SeqNr'), fprintf('No dataset specified.\n');
    else, fprintf('Current dataset :\n'); disp(GenParam.DS); end
else, 
    if isRAPStatDef(RAPStat, 'GenParam.SeqNr'), fprintf('No foreground dataset specified.\n');
    else, fprintf('Foreground dataset :\n'); disp(GenParam.DS); end
    fprintf('Background dataset :\n'); disp(GenParam.DS2);
end
fprintf('Userdata interface sync.  : %s\n', lower(RAPStat.GenParam.SyncUDI));

%-------------------------------------------------------------------------
CalcParam = RAPStat.CalcParam;
fprintf('\n');
fprintf('Calculation parameters\n');
fprintf('----------------------\n');

if SecDSDef, fprintf('  *Foreground dataset*\n'); end
fprintf('Included subsequences     : %s\n', GetRAPCalcParam(RAPStat, 's', 'SubSeqs'));
fprintf('Included repetitions      : %s\n', GetRAPCalcParam(RAPStat, 's', 'Reps'));
fprintf('Analysis window           : %s\n', GetRAPCalcParam(RAPStat, 's', 'AnWin')); 
fprintf('Reject window             : %s\n', GetRAPCalcParam(RAPStat, 's', 'ReWin'));
fprintf('Number of bins            : %s\n', GetRAPCalcParam(RAPStat, 's', 'NBin'));
fprintf('Binwidth                  : %s\n', GetRAPCalcParam(RAPStat, 's', 'BinWidth'));
[Str, Err] = GetRAPCalcParam(RAPStat, 's', 'BinFreq'); if ~isempty(Err), Str = 'default'; end
fprintf('Binning frequency         : %s\n', Str);
fprintf('Mininum ISI               : %s\n', GetRAPCalcParam(RAPStat, 's', 'MinISI'));
fprintf('Constant time subtraction : %s\n', GetRAPCalcParam(RAPStat, 's', 'ConSubTr'));
fprintf('Correlation binwidth      : %s\n', GetRAPCalcParam(RAPStat, 's', 'CorBinWidth'));
fprintf('Correlation max. lag      : %s\n', GetRAPCalcParam(RAPStat, 's', 'CorMaxLag'));
fprintf('Phase convention          : %s\n', GetRAPCalcParam(RAPStat, 's', 'PhaseConv'));
fprintf('Compensating delay        : %s\n', GetRAPCalcParam(RAPStat, 's', 'CompDelay'));
fprintf('Phase unwrapping          : %s\n', GetRAPCalcParam(RAPStat, 's', 'UnWrapping'));
fprintf('Rayleigh criterion        : %s\n', GetRAPCalcParam(RAPStat, 's', 'RayCrit'));
fprintf('Integer Nr. of cycles     : %s\n', GetRAPCalcParam(RAPStat, 's', 'IntNCycles'));
fprintf('Averaging window (RGL)    : %s\n', GetRAPCalcParam(RAPStat, 's', 'AvgWin'));
fprintf('Min nr. of intervals (RGL): %s\n', GetRAPCalcParam(RAPStat, 's', 'MinNInt'));
fprintf('Running average (HI)      : %s\n', GetRAPCalcParam(RAPStat, 's', 'HistRunAv'));
fprintf('Running average           : %s\n', GetRAPCalcParam(RAPStat, 's', 'CurveRunAv'));
fprintf('Running average (PKL)     : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklRunAv'));
fprintf('Env.running average (DIF) : %s\n', GetRAPCalcParam(RAPStat, 's', 'EnvRunAv'));
fprintf('Rate increase (PKL)       : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklRateInc'));
fprintf('Peak window (PKL)         : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklPkWin'));
fprintf('Spon. rate window (PKL)   : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklSrWin'));
fprintf('Q-factor threshold (TH)   : %s\n', GetRAPCalcParam(RAPStat, 's', 'ThrQ'));
fprintf('Cutoff threshold (SYNC)   : %s\n', GetRAPCalcParam(RAPStat, 's', 'SyncThr'));
fprintf('Sign. Level (CR)          : %s\n', GetRAPCalcParam(RAPStat, 's', 'SignLevel'));
fprintf('Bootstrap (BOOT)          : %s\n', GetRAPCalcParam(RAPStat, 's', 'BootStrap'));

if SecDSDef,
fprintf('   *Background dataset*\n');
RAPStat = SwapRAPDataSets(RAPStat);
fprintf('Included subsequences     : %s\n', GetRAPCalcParam(RAPStat, 's', 'SubSeqs'));
fprintf('Included repetitions      : %s\n', GetRAPCalcParam(RAPStat, 's', 'Reps'));
fprintf('Analysis window           : %s\n', GetRAPCalcParam(RAPStat, 's', 'AnWin')); 
fprintf('Reject window             : %s\n', GetRAPCalcParam(RAPStat, 's', 'ReWin'));
fprintf('Mininum ISI               : %s\n', GetRAPCalcParam(RAPStat, 's', 'MinISI'));
fprintf('Constant time subtraction : %s\n', GetRAPCalcParam(RAPStat, 's', 'ConSubTr'));
RAPStat = SwapRAPDataSets(RAPStat); %Return to old status ...
end

%-------------------------------------------------------------------------
PlotParam = RAPStat.PlotParam;
fprintf('\n');
fprintf('Plot parameters\n');
fprintf('---------------\n');

fprintf('   *figure*\n');
Layout = GetRAPLayout(RAPStat); 
if all(isnan(Layout)), Str = 'default'; else Str = mat2str(Layout); end
fprintf('Figure layout             : %s\n', Str);
fprintf('Current plot position     : %s\n', mat2str(PlotParam.Figure.CurAx));

fprintf('   *header*\n');
fprintf('Font name                 : %s\n', PlotParam.Header.FontName);
fprintf('Font size                 : %.2f%%(header height)\n', PlotParam.Header.FontSize);
fprintf('Color                     : %s\n', ConvRAPStatColor(PlotParam.Header.Color));

fprintf('   *plot*\n');
fprintf('Title label               : %s\n', ConvRAPStatLabel(PlotParam.Axis.Title.Label));
fprintf('Title font name           : %s\n', PlotParam.Axis.Title.FontName);
fprintf('Title font size           : %.2f%%(plot height)\n', PlotParam.Axis.Title.FontSize);
fprintf('Title color               : %s\n', ConvRAPStatColor(PlotParam.Axis.Title.Color));

fprintf('Abcis limits              : %s\n', ConvRAPStatLimits(PlotParam.Axis.X.Limits));
fprintf('Abcis scale               : %s\n', PlotParam.Axis.X.Scale);
fprintf('Abcis tick increment      : %s\n', ConvRAPStatTickInc(PlotParam.Axis.X.TickInc));
fprintf('Abcis color               : %s\n', ConvRAPStatColor(PlotParam.Axis.X.Color));
fprintf('Abcis label               : %s\n', ConvRAPStatLabel(PlotParam.Axis.X.Label.String));
fprintf('Abcis label font name     : %s\n', PlotParam.Axis.X.Label.FontName);
fprintf('Abcis label font size     : %.2f%%(plot height)\n', PlotParam.Axis.X.Label.FontSize);
fprintf('Abcis label color         : %s\n', ConvRAPStatColor(PlotParam.Axis.X.Label.Color));
fprintf('Abcis linewidth           : %.1f(points)\n', PlotParam.Axis.LineWidth);
fprintf('Abcis flipping            : %s\n', PlotParam.Axis.X.Flip);

fprintf('Ordinate location         : %s\n', PlotParam.Axis.Y.Location);
fprintf('Ordinate limits           : %s\n', ConvRAPStatLimits(PlotParam.Axis.Y.Limits));
fprintf('Ordinate scale            : %s\n', PlotParam.Axis.Y.Scale);
fprintf('Ordinate tick increment   : %s\n', ConvRAPStatTickInc(PlotParam.Axis.Y.TickInc));
fprintf('Ordinate color            : %s\n', ConvRAPStatColor(PlotParam.Axis.Y.Color));
fprintf('Ordinate label            : %s\n', ConvRAPStatLabel(PlotParam.Axis.Y.Label.String));
fprintf('Ordinate label font name  : %s\n', PlotParam.Axis.Y.Label.FontName);
fprintf('Ordinate label font size  : %.2f%%(plot height)\n', PlotParam.Axis.Y.Label.FontSize);
fprintf('Ordinate label color      : %s\n', ConvRAPStatColor(PlotParam.Axis.Y.Label.Color));
fprintf('Ordinate linewidth        : %.1f(points)\n', PlotParam.Axis.LineWidth);
    
fprintf('Text font name            : %s\n', PlotParam.Axis.Text.FontName);
fprintf('Text font size            : %.2f%%(plot height)\n', PlotParam.Axis.Text.FontSize);
fprintf('Text color                : %s\n', ConvRAPStatColor(PlotParam.Axis.Text.Color));
fprintf('Text location subseq. info: %s\n', PlotParam.Axis.Text.Location.SubSeq);
fprintf('Text location calc. param : %s\n', PlotParam.Axis.Text.Location.CalcParam);
fprintf('Text location calc. param2: %s\n', PlotParam.Axis.Text.Location.CalcParam2);
fprintf('Text location extr. data  : %s\n', PlotParam.Axis.Text.Location.CalcData);
fprintf('Text display subseq. info : %s\n', PlotParam.Axis.Text.SubSeq);
fprintf('Text display calc. param  : %s\n', PlotParam.Axis.Text.CalcParam);
fprintf('Text display calc. param2 : %s\n', PlotParam.Axis.Text.CalcParam2);
fprintf('Text display extr. data   : %s\n', PlotParam.Axis.Text.CalcData);

fprintf('Ticks font name           : %s\n', PlotParam.Axis.Tic.FontName);
fprintf('Ticks font size           : %.2f%%(plot height)\n', PlotParam.Axis.Tic.FontSize);

fprintf('An. window linewidth      : %.1f\n', PlotParam.AnWin.LineWidth);
fprintf('An. window linestyle      : %s\n', PlotParam.AnWin.LineStyle);
fprintf('An. window patch color    : %s\n', ConvRAPStatColor(PlotParam.AnWin.FaceColor));

fprintf('Thr. curve linecolor      : %s\n', ConvRAPStatColor(PlotParam.Thr.LineColor));
fprintf('Thr. curve linestyle      : %s\n', PlotParam.Thr.LineStyle);
fprintf('Thr. curve linewidth      : %.1f(points)\n', PlotParam.Thr.LineWidth);
fprintf('Thr. curve marker         : %s\n', PlotParam.Thr.Marker);
    
fprintf('Rate curve linecolor      : %s\n', ConvRAPStatColor(PlotParam.Rate.LineColor));
fprintf('Rate curve linestyle      : %s\n', PlotParam.Rate.LineStyle);
fprintf('Rate curve linewidth      : %.1f(points)\n', PlotParam.Rate.LineWidth);
fprintf('Rate curve marker         : %s\n', PlotParam.Rate.Marker);
fprintf('Rate ordinate unit        : %s\n', PlotParam.Rate.YAxisUnit);
fprintf('Error bars on rate curve  : %s\n', PlotParam.Rate.ErrorBars.Plot);
fprintf('Error bars linecolor      : %s\n', ConvRAPStatColor(PlotParam.Rate.ErrorBars.LineColor));
fprintf('Error bars linestyle      : %s\n', PlotParam.Rate.ErrorBars.LineStyle);
fprintf('Error bars linewidth      : %.1f(points)\n', PlotParam.Rate.ErrorBars.LineWidth);
    
fprintf('Raster plot linewidth     : %.1f(points)\n', PlotParam.Raster.LineWidth);
    
fprintf('Histograms style          : %s\n', PlotParam.Hist.Style);
fprintf('Histograms facecolor      : %s\n', ConvRAPStatColor(PlotParam.Hist.EdgeColor));
fprintf('Histograms edgecolor      : %s\n', ConvRAPStatColor(PlotParam.Hist.EdgeColor));
fprintf('Histograms ordinate unit  : %s\n', PlotParam.Hist.YAxisUnit);

fprintf('Correlograms linecolor    : %s\n', ConvRAPStatColor(PlotParam.Corr.LineColor));
fprintf('Correlograms linestyle    : %s\n', PlotParam.Corr.LineStyle);
fprintf('Correlograms linewidth    : %.1f(points)\n', PlotParam.Corr.LineWidth);
fprintf('Correlograms marker       : %s\n', PlotParam.Corr.Marker);
fprintf('Correlograms ordinate unit: %s\n', PlotParam.Corr.YAxisUnit);
    
fprintf('VS curves linecolor       : %s\n', ConvRAPStatColor(PlotParam.Vs.LineColor));
fprintf('VS curves linestyle       : %s\n', PlotParam.Vs.LineStyle);
fprintf('VS curves linewidth       : %.1f(points)\n', PlotParam.Vs.LineWidth);
fprintf('VS curves marker          : %s\n', PlotParam.Vs.Marker);
fprintf('VS curves ordinate unit   : %s\n', PlotParam.Vs.YAxisUnit);

fprintf('Scatterplot linecolor     : %s\n', ConvRAPStatColor(PlotParam.Scp.LineColor));
fprintf('Scatterplot linestyle     : %s\n', PlotParam.Scp.LineStyle);
fprintf('Scatterplot linewidth     : %.1f(points)\n', PlotParam.Scp.LineWidth);
fprintf('Scatterplot marker        : %s\n', PlotParam.Scp.Marker);

fprintf('Coinc. rate ordinate unit : %s\n', PlotParam.Cr.YAxisUnit);