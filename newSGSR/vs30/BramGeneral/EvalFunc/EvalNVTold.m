function ArgOut = EvalNVT(varargin)
%EVALNVT    compares NRHO dataset with FS dataset for a nerve fiber
%   D = EVALNVT(dsNoise, dsTone) compares NRHO dataset, containing responses to a noise
%   token with different polarity, with FS dataset, containing responses to monospectral
%   tones, for a nerve fiber. This ccomparison includes plotting normalized composite curve
%   of shuffled autocorrelograms to tones and normalized autocorrelogram for noise. 
%   Optional output argument is a structure S with all the calulated data.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'list' as only property.

%B. Van de Sande 13-02-2004, New version of NOISEVTONE.M that doesn't need a table with cell 
%information, but takes the datasets itself as input arguments ...

%---------------------------------------------------------------------------------------------
%Template for scatterplots ... 

Template.ds1.filename         = '';  
Template.ds1.icell            = NaN;
Template.ds1.iseq             = NaN;       %Sequence number of noise dataset
Template.ds1.seqid            = '';        %Identifier of noise dataset
Template.ds2.iseq             = NaN;       %Sequence number of tone dataset
Template.ds2.seqid            = '';        %Identifier of tone dataset
Template.tag                  = 0;         %General purpose tag field
Template.createdby            = mfilename; %Name of MATLAB function that generated the data
Template.noise.ds.posmeanrate = NaN;       %Mean rate of A+ condition in noise dataset (spk/sec)
Template.noise.ds.negmeanrate = NaN;       %Mean rate of A- condition in noise dataset (spk/sec)
Template.noise.ds.spl         = NaN;       %SPL at which noise stimulus was presented (dB)
Template.noise.ac.max         = NaN;       %Maximum of autocorrelogram (DriesNorm)
Template.noise.ac.peakratio   = NaN;       %Ratio of secundary versus primary peak in autocorrelogram
Template.noise.ac.xsecpeak    = NaN;       %Delay at secundary peak (ms)
Template.noise.diff.max       = NaN;       %Maximum of diffcorrelogram (DriesNorm)
Template.noise.diff.peakratio = NaN;       %Ratio of secundary versus primary peak in diffcorrelogram
Template.noise.diff.xsecpeak  = NaN;       %Delay at secundary peak (ms)
Template.noise.diff.hhw       = NaN;       %Half height with on diffcorrelogram (ms)
Template.noise.fft.df         = NaN;       %Dominant frequecny in diffcorrelogram (or autocorrelogram) (Hz)
Template.noise.fft.bw         = NaN;       %Bandwidth (Hz)
Template.tone.ds.maxmeanrate  = NaN;       %Maximum rate of all tone responses (spk/sec)
Template.tone.ds.freq4maxrate = NaN;       %Frequency of tone at this maximum (Hz)
Template.tone.ds.spl          = NaN;       %SPL at which the tones were recorded (dB)
Template.tone.ac.max          = NaN;       %Maximum of autocorrelogram (DriesNorm)
Template.tone.ac.peakratio    = NaN;       %Ratio of secundary versus primary peak in autocorrelogram
Template.tone.ac.xsecpeak     = NaN;       %Delay at secundary peak (ms)
Template.tone.diff.max        = NaN;       %Maximum of diffcorrelogram (DriesNorm)
Template.tone.diff.peakratio  = NaN;       %Ratio of secundary versus primary peak in diffcorrelogram
Template.tone.diff.xsecpeak   = NaN;       %Delay at secundary peak (ms)
Template.tone.diff.hhw        = NaN;       %Half height with on diffcorrelogram (ms)
Template.tone.fft.df          = NaN;       %Dominant frequecny in diffcorrelogram (or autocorrelogram) (Hz)
Template.tone.fft.bw          = NaN;       %Bandwidth (Hz)
Template.thr.cf               = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr               = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr              = NaN;       %Threshold at characteristic frequency
Template.thr.q10              = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw               = NaN;       %Width 10dB above threshold (Hz)

%---------------------------------------------------------------------------------------------
%List of default parameters ...
%Calculation parameters ...
DefParam.verbose       = 'yes';   %'yes' or 'no' ...
DefParam.rho           = 0;       %+1, -1 or 0 ...
DefParam.anwin         = [0 -1];  %-1 designates stimulus duration... in ms...
DefParam.corbinwidth   = 0.05;    %in ms ...
DefParam.cormaxlagunit = '#';     %'#' or 'ms' ...
DefParam.cormaxlag     = 0.5;     %in ms or number of periods ...   
DefParam.envrunavunit  = 'ms';    %must be '#' or 'ms' ...
DefParam.envrunav      = 0.1;
%Plot parameters ...
DefParam.plot          = 'yes';   %'yes' or 'no' ...
DefParam.corxrange     = [-5 +5]; %in ms ...
DefParam.corxstep      = 1;       %in ms ...
DefParam.fftxrange     = [0 2500];%in Hz ...
DefParam.fftxstep      = 250;     %in Hz ...
DefParam.fftyunit      = 'dB';    %'dB' or 'P' ...
DefParam.fftyrange     = [-20 0]; 

%---------------------------------------------------------------------------------------------
%Evaluate input parameters ...
[dsN, dsT, CellInfo, Param] = EvalParam(varargin, DefParam);

%Calculate data ... Caching system ...
SearchParam = structcat(getfields(CellInfo, {'datafile', 'nseqnr', 'tseqnr'}), ...
    getfields(Param, {'rho', 'anwin', 'corbinwidth', 'cormaxlag', 'envrunav'}));
CalcData = FromCacheFile(mfilename, SearchParam);
if isempty(CalcData), 
    CalcData = CalcCurve(dsN, dsT, Param);
    ToCacheFile(mfilename, +100, SearchParam, CalcData);
elseif strcmpi(Param.verbose, 'yes'), fprintf('Data retrieved from cache ...\n'); end    

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(dsN); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(CellInfo.datafile, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        CalcData.thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10));
        CellInfo.thrstr = sprintf('CF = %s / SR = %s', Param2Str(CF, 'Hz', 0), Param2Str(SR, 'spk/sec', 1));
    else, CalcData.thr = struct([]); CellInfo.thrstr = sprintf('THR data not present'); end    
catch, 
    warning('Could not make connection to SGSR server. Additional information is not included.'); 
    CalcData.thr = struct([]); CellInfo.thrstr = sprintf('THR data not present');
end

%Display data ...
if strcmpi(Param.plot, 'yes'), PlotCurve(CalcData, CellInfo, Param); end

%Return output parameters ...
if nargout > 0, ArgOut = structtemplate(CalcData, Template); end    

%---------------------------------------------------------------------------------------------
function [dsN, dsT, CellInfo, Param] = EvalParam(ParamList, DefParam)

%Check input parameters ...
if (isempty(ParamList)) | (length(ParamList) < 2), error('Wrong number of input parameters.'); end
[dsN, dsT] = deal(ParamList{1:2});
if ~isa(dsN, 'dataset') | ~strcmpi(dsN.StimType, 'NRHO'), error('First argument should be NRHO-dataset.'); end
if ~isa(dsT, 'dataset') | ~strcmpi(dsT.StimType, 'FS'), error('Second argument should be FS-dataset.'); end
if ~isequal(dsN.iCell, dsT.iCell), error('Datasets must be collected from same cell.'); end

%Check stimulus parameters ...
StimParam = CheckStimParam(dsN, dsT); if isempty(StimParam), error('Stimulus parameters should be the same.'); end

%Checking optional list of properties and their corresponding values ...
ParamList(1:2) = [];
Param = CheckPropList(DefParam, ParamList{:});
    
if ~any(strcmpi(Param.verbose, {'yes', 'no'})), error('Property verbose must be ''yes'' or ''no''.'); end
if ~any(Param.rho == [0, -1, +1]), error('Property rho must be 0, -1 or +1.'); end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]), error('Invalid value for property anwin.'); end
if ~isnumeric(Param.corbinwidth) | (length(Param.corbinwidth) ~= 1) | (Param.corbinwidth <= 0), error('Invalid value for property corbinwidth.'); end
if ~any(strcmpi(Param.cormaxlagunit, {'#', 'ms'})), error('Property cormaxlagunit must be ''#'' or ''ms''.'); end
if ~isnumeric(Param.cormaxlag) | (length(Param.cormaxlag) ~= 1) | (Param.cormaxlag <= 0), error('Invalid value for property cormaxlag.'); end
if ~any(strcmpi(Param.envrunavunit, {'#', 'ms'})), error('Property envrunavunit must be ''#'' or ''ms''.'); end
if ~isnumeric(Param.envrunav) | (length(Param.envrunav) ~= 1) | (Param.envrunav < 0), error('Invalid value for property envrunav.'); end

if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property plot must be ''yes'' or ''no''.'); end
if ~isinrange(Param.corxrange, [-Inf +Inf]), error('Invalid value for property corxrange.'); end
if ~isnumeric(Param.corxstep) | (length(Param.corxstep) ~= 1) | (Param.corxstep <= 0), error('Invalid value for property corxstep.'); end
if ~isinrange(Param.fftxrange, [0 +Inf]), error('Invalid value for property fftxrange.'); end
if ~isnumeric(Param.fftxstep) | (length(Param.fftxstep) ~= 1) | (Param.fftxstep <= 0), error('Invalid value for property fftxstep.'); end
if ~any(strcmpi(Param.fftyunit, {'dB', 'P'})), error('Property fftyunit must be ''dB'' or ''P''.'); end
if ~isinrange(Param.fftyrange, [-Inf +Inf]), error('Invalid value for property fftyrange.'); end

%Shortcuts on properties ...
if (Param.anwin(2) == -1), Param.anwin(2) = max(StimParam.burstdur); end
if (Param.rho == 0) & ~all(find(ismember([+1, -1], dsN.indepval))), error('Noise dataset doesn''t have reponses to both + and - correlation.');
elseif (Param.rho ~= 0) & isempty(find(dsN.indepval == Param.rho)), error('No noise responses for requested correlation in dataset.'); end
if strcmpi(Param.cormaxlagunit, '#'),
    StepSize  = dsT.indepval(2)-dsT.indepval(1); %in Hz ...
    StepPer   = 1000/StepSize;
    MaxLagN   = Param.cormaxlag;
    MaxLagT   = MaxLagN*StepPer;
    MaxLagStr = sprintf('%.1f# (%.0fms)', MaxLagN, MaxLagT);
    Param.cormaxlag = MaxLagT;
else, MaxLagStr = sprintf('%.0fms', Param.cormaxlag); end
if strcmpi(Param.envrunavunit, 'ms'), 
    RunAvTsup = Param.envrunav;
    RunAvNsup = round(Param.envrunav/Param.corbinwidth);
    RunAvNeff = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff = RunAvNeff*Param.corbinwidth;
    Param.envrunav = RunAvNsup;
    RunAvStr = sprintf('%.2fms (%.0f#, %.2fms)', RunAvTsup, RunAvNeff, RunAvTeff);
else,
    RunAvNsup = Param.envrunav;
    RunAvNeff = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff = RunAvNeff*Param.corbinwidth;
    Param.envrunav = RunAvNsup;
    RunAvStr = sprintf('%.0f# (%.0f#, %.2fms)', RunAvNsup, RunAvNeff, RunAvTeff);
end 

%Assembling cell information ...
CellInfo.datafile = upper(dsN.FileName);
CellInfo.cellnr   = dsN.iCell;
CellInfo.nseqnr   = dsN.iSeq;
[CellNr, TestNr, StimType, dsID] = UnRavelID(dsN.SeqID);
CellInfo.ndsid    = dsID;
CellInfo.tseqnr   = dsT.iSeq;
[CellNr, TestNr, StimType, dsID] = UnRavelID(dsT.SeqID);
CellInfo.tdsid    = dsID;
CellInfo.cellstr  = sprintf('%s %s/%s', CellInfo.datafile, CellInfo.ndsid, CellInfo.tdsid);

%Constructing information string on parameters ...
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('BinWidth = %s', Param2Str(Param.corbinwidth, 'ms', 2)));
s = strvcat(s, sprintf('MaxLag = %s', MaxLagStr));
s = strvcat(s, sprintf('RunAv = %s', RunAvStr));
CellInfo.paramstr = s;

%Constructing information string on stimulus parameters ...
s = sprintf('BurstDur = %s', Param2Str(StimParam.burstdur, 'ms', 0));
if (Param.rho == 0), s = strvcat(s, sprintf('Noise Correlation = +1/-1'));
else, s = strvcat(s, sprintf('Noise Correlation = %+0.0f', Param.rho)); end    
CellInfo.stimstr = s;

%Reorganize parameters ...
Param = structcat(Param, StimParam);

%---------------------------------------------------------------------------------------------
function StimParam = CheckStimParam(varargin)

if ~isequal(varargin{1}.burstdur, varargin{2}.burstdur), StimParam = struct([]);
else, StimParam.burstdur = varargin{1}.burstdur; end

%---------------------------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) | all(isequal(C{:})), Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2), Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1), 
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else, 
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%---------------------------------------------------------------------------------------------
function [CellNr, TestNr, StimType, dsID] = UnRavelID(dsID)

idx = findstr(dsID, '-'); if (length(idx) == 1), idx = [idx length(dsID)+1]; end

CellNr   = str2num(dsID(1:idx(1)-1));
TestNr   = str2num(dsID(idx(1)+1:idx(2)-1));
if (length(idx) == 2), StimType = dsID(idx(2)+1:end); else, StimType = dsID(idx(2)+1:idx(3)-1); end

dsID = sprintf('<%d-%d-%s>', CellNr, TestNr, StimType);

%---------------------------------------------------------------------------------------------
function CalcData = CalcCurve(dsN, dsT, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...

if strcmpi(Param.verbose, 'yes'), fprintf('Calculating AC for Noise ...\n'); end
switch Param.rho
case {-1, +1},
    SubSeq = find(dsN.indepval == Param.rho);        
    
    [YAutoCor, X, NC] = sptcorr(anwin(dsN.spt(SubSeq, :), Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
    
    YAutoCor = ApplyNorm('dries', YAutoCor, NC);              %Normalisation to correct for drift between stimulus presentation ...
    FFT = spectana(X, (YAutoCor-1));                          %Extracting the dominant frequency from the normalised SAC but subtracting the DC first ...
    [PeakRatio, XPeaks, YPeaks] = getpeakratio(X, YAutoCor);  %Calculating the ratio of the secundary over the primary peak ...
    if (Param.rho == -1), PosRate = NaN; NegRate = getrate(dsN, SubSeq, Param.anwin(1), Param.anwin(2));
    else, PosRate = getrate(dsN, SubSeq, Param.anwin(1), Param.anwin(2)); NegRate = NaN; end    
   
    Noise.X               = X;
    Noise.Y               = YAutoCor;
    Noise.YComNorm        = ApplyNorm('comp', YAutoCor);
    Noise.DS.PosMeanRate  = PosRate;
    Noise.DS.NegMeanRate  = NegRate;
    Noise.DS.SPL          = dsN.SPL(1);
    Noise.AC.Max          = max(YAutoCor);
    Noise.AC.PeakRatio    = PeakRatio;
    Noise.AC.XPeaks       = XPeaks;
    Noise.AC.YPeaks       = YPeaks;
    Noise.AC.XSecPeak     = GetSecPeak(XPeaks);
    Noise.DIFF.Max        = NaN;
    Noise.DIFF.PeakRatio  = NaN;
    Noise.DIFF.XPeaks     = NaN;
    Noise.DIFF.YPeaks     = NaN;
    Noise.DIFF.XSecPeak   = NaN;
    Noise.DIFF.HHW        = NaN;
    Noise.DIFF.XInterSect = [NaN NaN];
    Noise.DIFF.YHalfEnv   = NaN;
    Noise.FFT.Freq        = FFT.Freq;
    Noise.FFT.A           = FFT.Magn.A;
    Noise.FFT.dB          = FFT.Magn.dB;
    Noise.FFT.P           = FFT.Magn.P;
    Noise.FFT.DF          = FFT.DF;
    Noise.FFT.BW          = FFT.BW;
    
    s = sprintf('PeakRatio: %.2f @ %.2fms', Noise.AC.PeakRatio, Noise.AC.XSecPeak);
    s = strvcat(s, sprintf('Max: %.2f', Noise.AC.Max));
    s = strvcat(s, sprintf('SPL: %.0fdB', Noise.DS.SPL));
    if (Param.rho == +1), s = strvcat(s, sprintf('A+ Rate: %.0fspk/s', Noise.DS.PosMeanRate));
    else, s = strvcat(s, sprintf('A- Rate: %.0fspk/s', Noise.DS.NegMeanRate)); end    
    Noise.AC.PlotStr = s;
    Noise.DIFF.PlotStr = '';
    s = sprintf('DF: %.2fHz', Noise.FFT.DF);
    s = strvcat(s, sprintf('BW: %.2fHz', Noise.FFT.BW));
    Noise.FFT.PlotStr = s;
    Noise.NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');
case 0, 
    PosSubSeq = find(dsN.indepval == +1); NegSubSeq = find(dsN.indepval == -1);
    
    [Ypp, X, NC] = sptcorr(anwin(dsN.spt(PosSubSeq, :), Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
    Ypp = ApplyNorm('dries', Ypp, NC); %Normalisation to correct for drift between stimulus presentation ...
    [Ynn, X, NC] = sptcorr(anwin(dsN.spt(NegSubSeq, :), Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
    Ynn = ApplyNorm('dries', Ynn, NC); %Normalisation to correct for drift between stimulus presentation ...
    [Ypn, X, NC] = sptcorr(anwin(dsN.spt(PosSubSeq, :), Param.anwin), anwin(dsN.spt(NegSubSeq, :), Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
    Ypn = ApplyNorm('dries', Ypn, NC); %Normalisation to correct for drift between stimulus presentation ...
    [Ynp, X, NC] = sptcorr(anwin(dsN.spt(NegSubSeq, :), Param.anwin), anwin(dsN.spt(PosSubSeq, :), Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
    Ynp = ApplyNorm('dries', Ynp, NC); %Normalisation to correct for drift between stimulus presentation ...

    YAutoCor = mean([Ypp; Ynn]);
    YAntiCor = mean([Ypn; Ynp]);
    YDiffCor = YAutoCor - YAntiCor;
    
    YDiffCorEnv = runav(abs(hilbert(YDiffCor)), Param.envrunav);
    YHalfEnv = max(YDiffCorEnv)/2;
    XRange = cintersect(X, YDiffCorEnv, YHalfEnv); HHW = XRange(2) - XRange(1);
    FFT = spectana(X, YDiffCor); %Extracting the dominant frequency from the DIFFCOR ...
    [AC.PeakRatio, AC.XPeaks, AC.YPeaks] = getpeakratio(X, YAutoCor, FFT.DF); %Calculating the ratio of the secundary over the primary peak ...
    [DIFF.PeakRatio, DIFF.XPeaks, DIFF.YPeaks] = getpeakratio(X, YDiffCor, FFT.DF); %Calculating the ratio of the secundary over the primary peak ...
    NegRate = getrate(dsN, NegSubSeq, Param.anwin(1), Param.anwin(2));
    PosRate = getrate(dsN, PosSubSeq, Param.anwin(1), Param.anwin(2));
    
    Noise.X               = X;
    Noise.Y               = [YAutoCor; YAntiCor; YDiffCor; YDiffCorEnv; -YDiffCorEnv];
    Noise.YComNorm        = ApplyNorm('comp', YAutoCor);
    Noise.DS.PosMeanRate  = PosRate;
    Noise.DS.NegMeanRate  = NegRate;
    Noise.DS.SPL          = dsN.SPL(1);
    Noise.AC.Max          = max(YAutoCor);
    Noise.AC.PeakRatio    = AC.PeakRatio;
    Noise.AC.XPeaks       = AC.XPeaks;
    Noise.AC.YPeaks       = AC.YPeaks;
    Noise.AC.XSecPeak     = GetSecPeak(AC.XPeaks);
    Noise.DIFF.Max        = max(YDiffCor);
    Noise.DIFF.PeakRatio  = DIFF.PeakRatio;
    Noise.DIFF.XPeaks     = DIFF.XPeaks;
    Noise.DIFF.YPeaks     = DIFF.YPeaks;
    Noise.DIFF.XSecPeak   = GetSecPeak(DIFF.XPeaks);
    Noise.DIFF.HHW        = HHW;
    Noise.DIFF.XInterSect = XRange;
    Noise.DIFF.YHalfEnv   = YHalfEnv;
    Noise.FFT.Freq        = FFT.Freq;
    Noise.FFT.A           = FFT.Magn.A;
    Noise.FFT.dB          = FFT.Magn.dB;
    Noise.FFT.P           = FFT.Magn.P;
    Noise.FFT.DF          = FFT.DF;
    Noise.FFT.BW          = FFT.BW;
    
    s = sprintf('PeakRatio: %.2f @ %.2fms', Noise.AC.PeakRatio, Noise.AC.XSecPeak);
    s = strvcat(s, sprintf('Max: %.2f', Noise.AC.Max));
    s = strvcat(s, sprintf('SPL: %.0fdB', Noise.DS.SPL));
    s = strvcat(s, sprintf('A+ Rate: %.0fspk/s', Noise.DS.PosMeanRate));
    s = strvcat(s, sprintf('A- Rate: %.0fspk/s', Noise.DS.NegMeanRate));
    Noise.AC.PlotStr = s;
    s = sprintf('PeakRatio: %.2f @ %.2fms', Noise.DIFF.PeakRatio, Noise.DIFF.XSecPeak);
    s = strvcat(s, sprintf('HHW: %.2fms', Noise.DIFF.HHW));
    s = strvcat(s, sprintf('Max: %.2f', Noise.DIFF.Max));
    Noise.DIFF.PlotStr = s;
    s = sprintf('DF: %.2fHz', Noise.FFT.DF);
    s = strvcat(s, sprintf('BW: %.2fHz', Noise.FFT.BW));
    Noise.FFT.PlotStr = s;
    Noise.NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');
end

if strcmpi(Param.verbose, 'yes'), fprintf('Calculating AC for: '); end
NTones = dsT.nrec; 
[Ypp, Ynn, Ynp, Ypn] = deal([]);
[NCpp, NCnn, NCpn, NCnp] = deal(zeros(1, NTones));
for n = 1:NTones
    ToneFreq = dsT.indepval(n);
    if strcmpi(Param.verbose, 'yes'), fprintf([ int2str(ToneFreq) 'Hz,']); end
    
    SptFP = dsT.spt(n, :); SptFN = PhaseShift(SptFP, dsT.burstdur, ToneFreq, 0.5);
    [SptP, SptN] = SplitSpkTrain(SptFP);
    SptN = PhaseShift(SptN, dsT.burstdur, ToneFreq, 0.5);
    
    [Ypp(n, :), X, NC] = sptcorr(anwin(SptFP, Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
    NCpp(n) = NC.DriesNorm;
    [Ynn(n, :), X, NC] = sptcorr(anwin(SptFN, Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
    NCnn(n) = NC.DriesNorm;
    [Ypn(n, :), X, NC] = sptcorr(anwin(SptP, Param.anwin), anwin(SptN, Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
    NCpn(n) = NC.DriesNorm;
    [Ynp(n, :), X, NC] = sptcorr(anwin(SptN, Param.anwin), anwin(SptP, Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
    NCnp(n) = NC.DriesNorm;
end
if strcmpi(Param.verbose, 'yes'), fprintf([ char(8) '\n']); end

Ypp = sum(Ypp, 1)/sum(NCpp); 
Ynn = sum(Ynn, 1)/sum(NCnn);
Ypn = sum(Ypn, 1)/sum(NCpn);
Ynp = sum(Ynp, 1)/sum(NCnp);

YAutoCor = mean([Ypp; Ynn]);
YAntiCor = mean([Ypn; Ynp]);
YDiffCor = YAutoCor - YAntiCor;

YDiffCorEnv = runav(abs(hilbert(YDiffCor)), Param.envrunav);
YHalfEnv = max(YDiffCorEnv)/2;
XRange = cintersect(X, YDiffCorEnv, YHalfEnv); HHW = XRange(2) - XRange(1);
FFT = spectana(X, YDiffCor); %Extracting the dominant frequency from the DIFFCOR ...
[AC.PeakRatio, AC.XPeaks, AC.YPeaks] = getpeakratio(X, YAutoCor, FFT.DF); %Calculating the ratio of the secundary over the primary peak ...
[DIFF.PeakRatio, DIFF.XPeaks, DIFF.YPeaks] = getpeakratio(X, YDiffCor, FFT.DF); %Calculating the ratio of the secundary over the primary peak ...
Rate = getrate(dsT, 1:dsT.nrec, Param.anwin(1), Param.anwin(2));
[MaxMeanRate, idx] = max(Rate); Freq4MaxRate = dsT.indepval(idx);

Tone.X               = X;
Tone.Y               = [YAutoCor; YAntiCor; YDiffCor; YDiffCorEnv; -YDiffCorEnv];
Tone.YComNorm        = ApplyNorm('comp', YAutoCor);
Tone.DS.MaxMeanRate  = MaxMeanRate;
Tone.DS.Freq4MaxRate = Freq4MaxRate;
Tone.DS.SPL          = dsT.SPL(1);
Tone.DS.IndepRange   = [min(dsT.indepval), max(dsT.indepval), (dsT.indepval(2)-dsT.indepval(1))];
Tone.AC.Max          = max(YAutoCor);
Tone.AC.PeakRatio    = AC.PeakRatio;
Tone.AC.XPeaks       = AC.XPeaks;
Tone.AC.YPeaks       = AC.YPeaks;
Tone.AC.XSecPeak     = GetSecPeak(AC.XPeaks);
Tone.DIFF.Max        = max(YDiffCor);
Tone.DIFF.PeakRatio  = DIFF.PeakRatio;
Tone.DIFF.XPeaks     = DIFF.XPeaks;
Tone.DIFF.YPeaks     = DIFF.YPeaks;
Tone.DIFF.XSecPeak   = GetSecPeak(DIFF.XPeaks);
Tone.DIFF.HHW        = HHW;
Tone.DIFF.XInterSect = XRange;
Tone.DIFF.YHalfEnv   = YHalfEnv;
Tone.FFT.Freq        = FFT.Freq;
Tone.FFT.A           = FFT.Magn.A;
Tone.FFT.dB          = FFT.Magn.dB;
Tone.FFT.P           = FFT.Magn.P;
Tone.FFT.DF          = FFT.DF;
Tone.FFT.BW          = FFT.BW;

s = sprintf('PeakRatio: %.2f @ %.2fms', Tone.AC.PeakRatio, Tone.AC.XSecPeak);
s = strvcat(s, sprintf('Max: %.2f', Tone.AC.Max));
s = strvcat(s, sprintf('SPL: %.0fdB', Tone.DS.SPL));
s = strvcat(s, sprintf('MaxRate: %.0fspk/s @ %dHz', Tone.DS.MaxMeanRate, Tone.DS.Freq4MaxRate));
s = strvcat(s, sprintf('FreqRange: %.0fHz..%.0fHz/%.0fHz', Tone.DS.IndepRange));
Tone.AC.PlotStr = s;
s = sprintf('PeakRatio: %.2f @ %.2fms', Tone.DIFF.PeakRatio, Tone.DIFF.XSecPeak);
s = strvcat(s, sprintf('HHW: %.2fms', Tone.DIFF.HHW));
s = strvcat(s, sprintf('Max: %.2f', Tone.DIFF.Max));
Tone.DIFF.PlotStr = s;
s = sprintf('DF: %.2fHz', Tone.FFT.DF);
s = strvcat(s, sprintf('BW: %.2fHz', Tone.FFT.BW));
Tone.FFT.PlotStr = s;
Tone.NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');

%Reorganize and assemble data ...
CalcData.DS1   = emptyDataSet(dsN);
CalcData.DS2   = emptyDataSet(dsT);
CalcData.Noise = Noise;
CalcData.Tone  = Tone;
%All fields to lower case ...
CalcData = RecLowerFields(CalcData);

%---------------------------------------------------------------------------------------------
function [SptOut1, SptOut2] = SplitSpkTrain(SptIn)

NRep = length(SptIn);
[SptOut1, SptOut2] = deal(cell(0));

SptOut1 = SptIn(1:2:NRep);
SptOut2 = SptIn(2:2:NRep);

%---------------------------------------------------------------------------------------------
function SptOut = PhaseShift(SptIn, StimDur, CarFreq, Shift)

NRep = length(SptIn);
SptOut = cell(1, NRep);

Period = 1000/CarFreq;
TimeShift = Period * Shift;

for RepNr = 1:NRep
   SpkTrain = SptIn{RepNr};
   SpkTrainStim   = SpkTrain(find(SpkTrain <= StimDur));
   SpkTrainNoStim = SpkTrain(find(SpkTrain > StimDur));
   SptOut{RepNr} = sort([rem(SpkTrainStim + TimeShift, StimDur)  SpkTrainNoStim ]);
end

%---------------------------------------------------------------------------------------------
function Y = ApplyNorm(Type, Y, NormConst)

switch lower(Type)
case 'dries', 
    if ~all(Y == 0), Y = Y/NormConst.DriesNorm;
    else, Y = ones(size(Y)); end
case 'comp',
    Y = detrend(Y, 'constant');
    Y = Y/max(Y);
end

%---------------------------------------------------------------------------------------------
function X = GetSecPeak(XPeaks)

[dummy, idx] = sort(abs(XPeaks));
X = XPeaks(idx(end));

%---------------------------------------------------------------------------------------------
function S = RecLowerFields(S)

FNames  = fieldnames(S);
NFields = length(FNames);
for n = 1:NFields,
    Val = getfield(S, FNames{n});
    S = rmfield(S, FNames{n});
    if isstruct(Val), S = setfield(S, lower(FNames{n}), RecLowerFields(Val));  %Recursive ...
    else, S = setfield(S, lower(FNames{n}), Val); end
end

%---------------------------------------------------------------------------------------------
function PlotCurve(CalcData, CellInfo, Param);

%Creating frequently used character strings ...
switch Param.rho
case +1, 
    CorTypeStr = 'Positive Correlation';
    [CorLgdStr, FFTOnStr] = deal('AutoCor');
case -1, 
    CorTypeStr = 'Negative Correlation';
    [CorLgdStr, FFTOnStr] = deal('AutoCor');
case 0,  
    CorTypeStr = 'Mean Correlation'; 
    CorLgdStr = {'AutoCor', 'CrossStim'};
    FFTOnStr = 'DiffCor';
end
TitleStr = sprintf('Composite Curve of SACs to Tones & SAC to Noise for %s @ %s', CellInfo.cellstr, CorTypeStr);

%Creating figure ...
Interface = figure('Name', sprintf('%s: %s', upper(mfilename), TitleStr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!)...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

%Range for abcissa and ordinate ...
AC.MinX  = Param.corxrange(1); AC.MaxX  = Param.corxrange(2); AC.XStep = Param.corxstep;
 
FFT.MinX = Param.fftxrange(1); FFT.MaxX = Param.fftxrange(2); FFT.XStep = Param.fftxstep;
FFT.MinY = Param.fftyrange(1); FFT.MaxY = Param.fftyrange(2); FFT.YUnit = Param.fftyunit;

%-= Plotting NOISE data =-
X = CalcData.noise.x; Y = CalcData.noise.y(unique([1, min(2, end)]), :); 
[MinX, MaxX, XTicks] = GetAxisLim('X', X, AC);
Ax_Noise_AC = axes('Position', [0.05 0.824 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
Hdl = line(X, Y); set(Hdl(1), 'LineWidth', 2); try set(Hdl(2), 'LineWidth', 0.5); end
title(sprintf('SAC on NOISE response of %s', CellInfo.ndsid), 'FontSize', 12);
xlabel('Delay(ms)'); ylabel(CalcData.noise.normstr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0]);
set(Ax_Noise_AC, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(Ax_Noise_AC, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
PlotPeakRatio(CalcData.noise.ac.xpeaks, CalcData.noise.ac.ypeaks, 'b'); 
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, CalcData.noise.ac.plotstr, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 7);
legend(CorLgdStr, 1);

if isequal(Param.rho, 0),
    X = CalcData.noise.x; Y = CalcData.noise.y(3:5, :); 
    Ax_Noise_DIFF = axes('Position', [0.05 0.597 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
    Hdl = line(X, Y); set(Hdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
    set(Hdl(2), 'LineStyle', '-', 'Color', [0 0 0]);
    set(Hdl(3), 'LineStyle', '-', 'Color', [0 0 0]);
    title(sprintf('DIFFCOR on NOISE response of %s', CellInfo.ndsid), 'FontSize', 12);
    xlabel('Delay(ms)'); ylabel(CalcData.noise.normstr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0]);
    set(Ax_Noise_DIFF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(Ax_Noise_DIFF, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    PlotPeakRatio(CalcData.noise.diff.xpeaks, CalcData.noise.diff.ypeaks, 'r');
    Hdl = PlotCInterSect(CalcData.noise.diff.xintersect, CalcData.noise.diff.yhalfenv([1 1]), MinY);
    set(Hdl(1), 'LineStyle', '-', 'Color', [0 0 0]);
    text(MinX, MaxY, CalcData.noise.diff.plotstr,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 7);
else, PlotEmptyAxis([0.05 0.597 0.40 0.127]); end

X = CalcData.noise.fft.freq; 
if strcmpi(FFT.YUnit, 'dB'), Y = CalcData.noise.fft.db; YLblStr = 'Amplitude (dB)';
else, Y = CalcData.noise.fft.p; YLblStr = 'Power'; end
[MinX, MaxX, XTicks] = GetAxisLim('X', X, FFT); [MinY, MaxY] = GetAxisLim('Y', Y, FFT);
Ax_Noise_FFT = axes('Position', [0.05 0.37 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
Hdl = line(X, Y);
title(sprintf('FFT on %s for NOISE', upper(FFTOnStr)), 'FontSize', 12);
xlabel('Freq(Hz)'); ylabel(YLblStr);
set(Ax_Noise_FFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
YRange = get(Ax_Noise_FFT, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
line(CalcData.noise.fft.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Verticale nullijn thv DF ...
text(FFT.MaxX, MinY, CalcData.noise.fft.plotstr,'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'FontSize', 7);
    
%-= Plotting TONE data =-
X = CalcData.tone.x; Y = CalcData.tone.y([1, 2], :); 
[MinX, MaxX, XTicks] = GetAxisLim('X', X, AC);
Ax_Tone_AC = axes('Position', [0.55 0.824 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
Hdl = line(X, Y); set(Hdl(1), 'LineWidth', 2); 
if ~isequal(Param.rho, 0), delete(Hdl(2)); else, set(Hdl(2), 'LineWidth', 0.5); end
title(sprintf('CC on TONE responses of %s', CellInfo.tdsid), 'FontSize', 12);
xlabel('Delay(ms)'); ylabel(CalcData.tone.normstr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0]);
set(Ax_Tone_AC, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(Ax_Tone_AC, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
PlotPeakRatio(CalcData.tone.ac.xpeaks, CalcData.tone.ac.ypeaks, 'b'); 
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, CalcData.tone.ac.plotstr, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 7);

if isequal(Param.rho, 0),
    X = CalcData.tone.x; Y = CalcData.tone.y(3:5, :); 
    Ax_Tone_DIFF = axes('Position', [0.55 0.597 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
    Hdl = line(X, Y); set(Hdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
    set(Hdl(2), 'LineStyle', '-', 'Color', [0 0 0]);
    set(Hdl(3), 'LineStyle', '-', 'Color', [0 0 0]);
    title(sprintf('DIFFCOR on TONE responses of %s', CellInfo.tdsid), 'FontSize', 12);
    xlabel('Delay(ms)'); ylabel(CalcData.tone.normstr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0]);
    set(Ax_Tone_DIFF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(Ax_Tone_DIFF, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
    PlotPeakRatio(CalcData.tone.diff.xpeaks, CalcData.tone.diff.ypeaks, 'r');
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    Hdl = PlotCInterSect(CalcData.tone.diff.xintersect, CalcData.tone.diff.yhalfenv([1 1]), MinY);
    set(Hdl(1), 'LineStyle', '-', 'Color', [0 0 0]);
    text(MinX, MaxY, CalcData.tone.diff.plotstr,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 7);
else, PlotEmptyAxis([0.55 0.597 0.40 0.127]); end

X = CalcData.tone.fft.freq; 
if strcmpi(FFT.YUnit, 'dB'), Y = CalcData.tone.fft.db; YLblStr = 'Amplitude (dB)';
else, Y = CalcData.tone.fft.p; YLblStr = 'Power'; end
[MinX, MaxX, XTicks] = GetAxisLim('X', X, FFT); [MinY, MaxY] = GetAxisLim('Y', Y, FFT);
Ax_Tone_FFT = axes('Position', [0.55 0.37 0.40 0.127], 'Box', 'off', 'TickDir', 'out');
Hdl = line(X, Y);
title(sprintf('FFT on %s for TONE', upper(FFTOnStr)), 'FontSize', 12);
xlabel('Freq(Hz)'); ylabel(YLblStr);
set(Ax_Tone_FFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
YRange = get(Ax_Tone_FFT, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
line(CalcData.tone.fft.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Verticale nullijn thv DF ...
text(FFT.MaxX, MinY, CalcData.tone.fft.plotstr,'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'FontSize', 7);
    
%-= SuperImpose Plot =-
[MinX, MaxX, XTicks] = GetAxisLim('X', X, AC);
MinX = max([1.5*MinX, -Param.cormaxlag]);
MaxX = min([1.5*MaxX, Param.cormaxlag]);
XTicks = MinX:Param.corxstep:MaxX;
Ax_Main = axes('Position', [0.05 0.05 0.65 0.23]); set(Ax_Main, 'Box', 'off', 'TickDir', 'out');
line(CalcData.tone.x, CalcData.tone.ycomnorm, 'Color', 'b', 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 2); 
line(CalcData.noise.x, CalcData.noise.ycomnorm, 'Color', 'r', 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 0.5);
title(TitleStr, 'FontSize', 12, 'Units', 'normalized', 'Position', [0.75, 1.0387, 0]);
xlabel('Delay(ms)'); ylabel(sprintf('Norm. Count (Detrend&Max)'));
set(Ax_Main, 'XLim', [MinX, MaxX], 'XTick', XTicks);
legend({['Composite Curve']; ['Noise']}, 2);
YRange = get(Ax_Main, 'YLim'); MinY = YRange(1); MaxY = YRange(2);

PrintInfo([0.75 0.05 0.20 0.23], char(CellInfo.cellstr, '', CellInfo.paramstr, '', CellInfo.stimstr, '', CellInfo.thrstr), Interface, 'fontsize', 9);

%---------------------------------------------------------------------------------------------
function PlotEmptyAxis(Pos)

AxHdl = axes('Position', Pos, 'Box', 'on', 'Color', [0.7 0.7 0.7], 'Units', 'normalized', ...
    'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);

TxtHdl = text(0.5, 0.5, sprintf('No plot to be\ngenerated'));
set(TxtHdl, 'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'center', ...
             'Color', [0 0 0], ...
             'FontAngle', 'normal', ...
             'FontWeight', 'demi');
         
%---------------------------------------------------------------------------------------------
function [MinVal, MaxVal, Ticks] = GetAxisLim(AxisType, V, AxisStruct)

switch lower(AxisType)
case 'x', %Abcissa ...
    Margin = 0.00;
    
    if isinf(AxisStruct.MinX), MinVal = min(V(:))*(1-Margin); else MinVal = AxisStruct.MinX; end
    if isinf(AxisStruct.MaxX), MaxVal = max(V(:))*(1+Margin); else MaxVal = AxisStruct.MaxX; end
    Ticks = MinVal:AxisStruct.XStep:MaxVal;
case 'y', %Ordinate ...    
    Margin = 0.05;
    
    if isinf(AxisStruct.MinY), MinVal = min([0; V(:)])*(1-Margin); else MinVal = AxisStruct.MinY; end
    if isinf(AxisStruct.MaxY), MaxVal = max(V(:))*(1+Margin); else MaxVal = AxisStruct.MaxY; end
end

%---------------------------------------------------------------------------------------------
function PlotPeakRatio(XPeaks, YPeaks, Color, MinY)
line(XPeaks, YPeaks, 'Color', Color, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 12); 

%---------------------------------------------------------------------------------------------
function PlotVerZero(MinY, MaxY)
line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');

%---------------------------------------------------------------------------------------------
function PlotHorZero(MinX, MaxX)
line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':');