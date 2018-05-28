function varargout = EvalTHR(varargin)
%EVALTHR  evalauate dataset containing threshold curve.
%   EVALTHR(ds) evaluates the threshold curve for dataset ds.
%   D = EVALTHR(DS) also returns a structure-array with all the extracted 
%   parameters.
%   [CF, SR, minThr, BW, Qfactor] = EVALTHR(DS) returns the characteristic
%   frequency(CF), spontanious rate(SR), threshold at CF(minThr), Bandwidth
%   (BW) and the Q factor(Qfactor). When a fit is performed on the threshold
%   curve the returned parameters where extracted from the fitted curve and
%   not from the original curve.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 14-07-2005

%----------------------------template-----------------------------
Template.ds.filename = '';        %Datafile name for datasets
Template.ds.icell    = NaN;       %Cell number of datasets
Template.ds.iseq     = NaN;       %Sequence number of first dataset
Template.ds.seqid    = '';        %Identifier of first dataset
Template.ds.dfreq    = NaN;       %Frequency spacing
Template.ds.stepunit = '';        %Frequency spacing units 
Template.tag         = 0;         %General purpose tag field
Template.createdby   = mfilename; %Name of MATLAB function that generated the data
Template.thr.freq    = NaN;       %Frequencies in Hz
Template.thr.thr     = NaN;       %Corresponding thresholds in dB for each frequency
Template.thr.cf      = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr      = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.minthr  = NaN;       %Threshold at characteristic frequency
Template.thr.q10     = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw      = NaN;       %Width 10dB above threshold (Hz)
Template.fit.freq    = NaN;       %Frequencies in Hz for fitted curve
Template.fit.thr     = NaN;       %Corresponding thresholds in dB for each frequency
Template.fit.cf      = NaN;       %Characteristic frequency retrieved from fitted curve
Template.fit.minthr  = NaN;       %Threshold at characteristic frequency
Template.fit.q10     = NaN;       %Q10 retrieved from fitted curve
Template.fit.bw      = NaN;       %Width 10dB above threshold (Hz)

%------------------------default parameters-----------------------
%Calculation parameters ...
DefParam.isubseqs   = 'all'; %The subsequences included in the analysis.
                             %By default all subsequences are included ('all').
DefParam.thr        = 10;    %Threshold in dB for the bandwidth and Q-factor.
DefParam.tailcutoff = 'no';  %Cutting off tails at both sides of the CF-peak. 
                             %Should be 'yes' or 'no'.
DefParam.fit        = 'none';%Fitting function requested on threshold curve.
                             %Can be 'none', 'runav'(running average), 'poly'
                             %(2nd degree polynomial) or 'spline'(cubic spline).
DefParam.smplfactor = 10;    %The number of extra samples for the fitted curve
                             %supplied as the ratio of the number of samples in
                             %the fitted curve over the number of samples in the
                             %original curve.
DefParam.runav      = 0;     %Number of datapoints used in smoothing the
                             %threshold curve. Only applicable when property
                             %'fit' is set to the value 'runav'.
%Plot parameters ...                           
DefParam.plot       = 'yes'; %Create figure with threshold curve 'yes' or 'no'.
DefParam.xscale     = 'auto';%The scale for the abcissa can be 'lin'(linear),
                             %'log'(logaritmic) or 'auto'(automatic).
DefParam.xunit      = 'auto';%Units for the abicissa can be 'hz', 'khz' or
                             %'auto'(automatic).

%-------------------------main program-----------------------------
%Checking input parameters ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their default values:'); 
    disp(DefParam);
    return;
else
    [ds, Param] = ParseArgs(DefParam, varargin{:});
end

%Calculate threshold curve ...
CalcData = CalcThrCurve(ds, Param);

%Display data if requested ...
if strncmpi(Param.plot, 'y', 1)
    PlotThrCurve(ds, CalcData, Param); 
end

%Return output if requested ...
if (nargout == 1),
    CalcData.ds = ds;
    varargout{1} = structtemplate(CalcData, Template, 'reduction', 'off');
elseif (nargout > 1), 
    if strcmpi(Param.fit, 'none'), Stmp = CalcData.thr; else Stmp = CalcData.fit; end
    [varargout{1:5}] = deal(Stmp.cf, Stmp.sr, Stmp.minthr, Stmp.bw, Stmp.q10);
end

%-------------------------local functions--------------------------
function [ds, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
NArgs = length(varargin);
if (NArgs < 1)
    error('Wrong number of input arguments.'); 
end
if ~any(strcmpi(class(varargin{1}), {'dataset', 'edfdataset'}))
    error('First argument should be dataset.'); 
end
if ~any(strcmpi(varargin{1}.stimtype, {'th', 'thr'}))
    error('First argument should be dataset containing threshold curve.'); 
end
ds = varargin{1};

%Retrieving properties and checking their values ...
Param = checkproplist(DefParam, varargin{2:end});
Param = CheckParam(ds, Param);

%------------------------------------------------------------------
function Param = CheckParam(ds , Param)

Param.isubseqs = ExpandiSubSeqs(zeros(length(ds.indepval), 0), Param.isubseqs);
if isempty(Param.isubseqs)
    error('Invalid value for property ''isubseqs''.');
end
if ~isnumeric(Param.thr) || (length(Param.thr) ~= 1) || (Param.thr <= 0)
    error('Value for property ''thr'' must be positive scalar.');
end
if ~any(strcmpi(Param.tailcutoff, {'yes', 'no'}))
    error('Value for property ''tailcutoff'' must be ''yes'' or ''no''.');
end
if ~any(strcmpi(Param.fit, {'none', 'runav', 'poly', 'spline'}))
    error('Value for property ''fit'' must be ''none'', ''runav'', ''poly'' or ''spline''.');
end
if ~isnumeric(Param.smplfactor) || (length(Param.smplfactor) ~= 1) || ...
        (Param.smplfactor <= 0) || (mod(Param.smplfactor, 1) ~= 0)
    error('Value for property ''smplfactor'' must be positive integer.');
end
if ~isnumeric(Param.runav) || (length(Param.runav) ~= 1) || (Param.runav < 0) || ...
        (mod(Param.runav, 1) ~= 0)
    error('Value for property ''runav'' must be positive integer.');
end
%Only checking first character in value of property 'plot' for backward compatibility ...
if ~any(strncmpi(Param.plot, {'y', 'n'}, 1))
    error('Value for property ''plot'' must be ''yes'' or ''no''.');
end
if ~any(strcmpi(Param.xscale, {'auto', 'lin', 'log'}))
    error('Value for property ''xscale'' must be ''auto'', ''lin'' or ''log''.');
end
if ~any(strcmpi(Param.xunit, {'auto', 'hz', 'khz'}))
    error('Value for property ''xunit'' must be ''auto'', ''hz'' or ''khz''.');
end

%------------------------------------------------------------------
function CalcData = CalcThrCurve(ds, Param)

%Running CalcTHR for calculation of the threshold curve and extraction of
%the spontaneous rate ...
S = CalcTHR(ds, 'isubseqs', Param.isubseqs, 'thr', Param.thr, 'runav', 0);
[CalcData.thr.freq, CalcData.thr.thr] = deal(S.curve.freq, S.curve.thr);
[CalcData.thr.cf, CalcData.thr.minthr, CalcData.thr.bwf, CalcData.thr.bw, ...
       CalcData.thr.q10] = ExtractUsefulParam(S.curve.freq, S.curve.thr, Param);
CalcData.thr.sr = S.curve.sr;

%Cut off tails if requested ...
if strcmpi(Param.tailcutoff, 'yes'),
    [CalcData.thr.freq, CalcData.thr.thr] = CutOffTails(CalcData.thr.freq, CalcData.thr.thr);
end    

%Fit a curve if requested ...
if ~strcmpi(Param.fit, 'none'),
    [Thr, idx] = deNaN(CalcData.thr.thr); Freq = CalcData.thr.freq(idx);
    switch lower(Param.fit)
    case 'runav', %Running average ...
        CalcData.fit.freq = CalcData.thr.freq;
        CalcData.fit.thr  = runav(CalcData.thr.thr, Param.runav);
    case 'poly', %2nd degree polynomial ...
        CalcData.fit.freq = GenerateFreqsForFit(CalcData.thr.freq(idx(1):idx(end)), Param);
        CalcData.fit.thr  = polyval(polyfit(Freq, Thr, 2), CalcData.fit.freq);
    case 'spline', %Cubic spline ...
        CalcData.fit.freq = GenerateFreqsForFit(CalcData.thr.freq(idx(1):idx(end)), Param);
        CalcData.fit.thr  = ppval(spline(Freq, Thr), CalcData.fit.freq);
    end
    [CalcData.fit.cf, CalcData.fit.minthr, CalcData.fit.bwf, CalcData.fit.bw, ...
            CalcData.fit.q10] = ExtractUsefulParam(CalcData.fit.freq, CalcData.fit.thr, Param);
end

%------------------------------------------------------------------
function [Freq, Thr] = CutOffTails(Freq, Thr)

%Find minimum threshold ...
[minThr, minIdx] = min(Thr);
%Search for first two consecutive constant threshold values in both
%direction starting from the minimum threshold ...
diffs = diff(Thr(1:minIdx-1));
if isempty(diffs)
    StartIdx = 1;
else
    constIdx = find(diffs == 0);
    if isempty(constIdx)
        StartIdx = 1;
    else
        StartIdx = max(constIdx) + 1;
    end
end
diffs = diff(Thr(minIdx+1:end));
if isempty(diffs)
    EndIdx = length(Thr);
else 
    constIdx = find(diffs == 0);
    if isempty(constIdx)
        EndIdx = length(Thr);
    else
        EndIdx = minIdx + min(constIdx);
    end
end
%Reduce curve ...
[Freq, Thr] = deal(Freq(StartIdx:EndIdx), Thr(StartIdx:EndIdx));

%------------------------------------------------------------------
function [CF, minThr, BWf, BW, Q] = ExtractUsefulParam(Freq, Thr, Param)

%Extracting CF and minimum threshold ...
[minThr, idx] = min(Thr); 
CF = Freq(idx);
%Calculating Q and BW ...
BWThr = minThr + Param.thr;
warning('off','MATLAB:interp1:NaNinY'); %reduce output spam
BWf   = cintersect(Freq, -Thr, -BWThr);
warning('on','MATLAB:interp1:NaNinY'); 
BW    = abs(diff(BWf));
Q     = CF/BW;

%------------------------------------------------------------------
function FitFreqs = GenerateFreqsForFit(Freqs, Param)

N = length(Freqs);
Tol = 0.01; NDiffSteps = length(unique(diff(round(Freqs/Tol)*Tol)));
if (NDiffSteps == 1), %Linear spacing ...
    FitFreqs = linspace(Freqs(1), Freqs(end), Param.smplfactor*N);
else %Logaritmic spacing ...
    FitFreqs = logspace(log10(Freqs(1)), log10(Freqs(end)), Param.smplfactor*N);
end

%------------------------------------------------------------------
function PlotThrCurve(ds, CalcData, Param)

%Reorganization of information ...
IDStr = sprintf('%s <%s> (#%d)', ds.FileName, ds.SeqID, ds.iSeq);
if strcmpi(Param.xunit, 'hz') || (strcmpi(Param.xunit, 'auto') && (CalcData.thr.cf <= 1000))
    [Xorig, Yorig] = deal(CalcData.thr.freq, CalcData.thr.thr);
    if ~strcmpi(Param.fit, 'none')
        [Xfit, Yfit] = deal(CalcData.fit.freq, CalcData.fit.thr);
    end
    [CForig, BWforig] = deal(CalcData.thr.cf, CalcData.thr.bwf);
    if ~strcmpi(Param.fit, 'none')
        [CFfit, BWffit] = deal(CalcData.fit.cf, CalcData.fit.bwf);
    end
    FreqUnit = 'Hz';
else
    [Xorig, Yorig] = deal(CalcData.thr.freq/1e3, CalcData.thr.thr);
    if ~strcmpi(Param.fit, 'none')
        [Xfit, Yfit] = deal(CalcData.fit.freq/1e3, CalcData.fit.thr);
    end
    [CForig, BWforig] = deal(CalcData.thr.cf/1e3, CalcData.thr.bwf/1e3);
    if ~strcmpi(Param.fit, 'none')
        [CFfit, BWffit] = deal(CalcData.fit.cf/1e3, CalcData.fit.bwf/1e3);
    end
    FreqUnit = 'kHz'; 
end
if strcmpi(Param.fit, 'none')
    DataStr = {sprintf('%.1fdB SPL @ %.0f%s SR = %.2fsp/s Q%d = %.2f', ...
    CalcData.thr.minthr, CForig, FreqUnit, CalcData.thr.sr, Param.thr, CalcData.thr.q10)};
else
    DataStr = { ...
        sprintf('%.1fdB SPL @ %.0f%s SR = %.2fsp/s Q%d = %.2f (ORIG)', ...
        CalcData.thr.minthr, CForig, FreqUnit, CalcData.thr.sr, Param.thr, CalcData.thr.q10); ...
        sprintf('%.1fdB SPL @ %.0f%s Q%d = %.2f (FIT)', ...
        CalcData.fit.minthr, CFfit, FreqUnit, Param.thr, CalcData.fit.q10)};
end

%Creating figure ...
figure('Name', sprintf('%s: %s', upper(mfilename), IDStr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Header ...
Str = { IDStr; sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now)) };
Str = [Str; DataStr];
axes('Position', [0.10 0.80 0.8 0.20], 'Visible', 'off');
text(0.5, 0.5, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 12);

%Actual threshold curve ...
if ~strcmpi(Param.fit, 'none'), 
    TmpX = deNaN([Xorig(:); Xfit(:)]); TmpY = deNaN([Yorig(:); Yfit(:)]);
else
    TmpX = deNaN(Xorig(:)); TmpY = deNaN(Yorig(:));
end
minFreq = min(TmpX); maxFreq = max(TmpX);
minSPL = min([10; TmpY]) - 10; maxSPL = max(TmpY) + 10;

AxHdl = axes('Position', [0.10 0.10 0.80 0.70], 'Box', 'off', 'TickDir', 'out');
line(Xorig, Yorig, 'LineStyle', '-', 'Marker', 'o', 'Color', 'b');
if ~strcmpi(Param.fit, 'none')
    line(Xfit, Yfit, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
end
if strcmpi(Param.xscale, 'log') || (strcmpi(Param.xscale, 'auto') && ...
        ((maxFreq/minFreq) > 5))
    set(AxHdl, 'xscale', 'log');
else
    set(AxHdl, 'xscale', 'lin');
end
line(CForig, CalcData.thr.minthr, 'LineStyle', 'none', 'Marker', 'o', 'Color', 'r');
if ~strcmpi(Param.fit, 'none')
    line(CFfit, CalcData.fit.minthr, 'LineStyle', 'none', 'Marker', '.', 'Color', 'k');
end
line(BWforig, CalcData.thr.minthr([1 1])+Param.thr, 'LineStyle', '-', ...
    'Marker', 'none', 'Color', 'r');
if ~strcmpi(Param.fit, 'none')
    line(BWffit, CalcData.fit.minthr([1 1])+Param.thr, ...
        'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
end
axis([minFreq maxFreq minSPL maxSPL]);
xlabel(['Frequency (' FreqUnit ')']); ylabel('Threshold (dB SPL)');

%------------------------------------------------------------------