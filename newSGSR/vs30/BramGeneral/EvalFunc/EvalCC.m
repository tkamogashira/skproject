function ArgOut = EvalCC(varargin)
%EVALCC
%   T = EVALCC(ds)
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   All calculations are cached. To clear the current cache use 'clrcache' 
%   as only input argument.

%B. Van de Sande 31-08-2004

%-----------------------------------template---------------------------------
Template.ds1.filename         = '';        %Datafile name for dataset
Template.ds1.icell            = NaN;       %Cell number of dataset
Template.ds1.iseq             = NaN;       %Sequence number of dataset
Template.ds1.seqid            = '';        %Identifier of dataset
Template.tag                  = 0;         %General purpose tag field
Template.createdby            = mfilename; %Name of MATLAB function that generated the data
Template.stim.burstdur        = NaN;       %Stimulus duration in ms
Template.stim.repdur          = NaN;       %Repetition duration in ms
Template.stim.spl             = NaN;       %Sound pressure level in dB
Template.rate.max             = NaN;       %Maximum rate (spk/sec)
Template.rate.bf              = NaN;       %Frequency of tone at this maximum (Hz)
Template.cc.max               = NaN;       %Maximum of autocorrelogram (DriesNorm)
Template.cc.peakratio         = NaN;       %Ratio of secundary versus primary peak in autocorrelogram
Template.diff.max             = NaN;       %Maximum of diffcorrelogram (DriesNorm)
Template.diff.peakratio       = NaN;       %Ratio of secundary versus primary peak in diffcorrelogram
Template.diff.hhw             = NaN;       %Half height with on diffcorrelogram (ms)
Template.diff.fft.df          = NaN;       %Dominant frequecny in diffcorrelogram (Hz)
Template.diff.fft.bw          = NaN;       %Bandwidth (Hz)
Template.thr.cf               = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr               = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr              = NaN;       %Threshold at characteristic frequency
Template.thr.q10              = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw               = NaN;       %Width 10dB above threshold (Hz)

%-------------------------------default parameters---------------------------
%Calculation parameters ...
DefParam.verbose       = 'yes';      %'yes' or 'no' ...
DefParam.cache         = 'yes';      %'yes' or 'no' ...
DefParam.subseqinput   = 'indepval'; %'indepval' or 'subseq' ...
DefParam.isubseq       = 'all';      %'all' or numeric vector ...
DefParam.anwin         = [0 +Inf];   %in ms (Infinite designates stimulus duration) ...
DefParam.corbinwidth   = 0.05;       %in ms ...
DefParam.cormaxlagunit = '#';        %'#' or 'ms' ...
DefParam.cormaxlag     = 0.5;        %in ms or number of periods of increment period ...   
DefParam.envrunavunit  = '#';        %'#' or 'ms' ...
DefParam.envrunav      = 1;          %in ms or number of periods ...
DefParam.fftrunav      = 100;        %in Hz ...
DefParam.sinperiods    = 2;          %in number of periods ...
DefParam.prdhnbin      = 64;         %in number of bins ...
%Plot parameters ...
DefParam.plot          = 'yes';      %'yes' or 'no' ...
DefParam.corxrange     = [-5 +5];    %in ms ...
DefParam.corxstep      = 1;          %in ms ...
DefParam.fftxrange     = [0 500];    %in Hz ...
DefParam.fftxstep      = 50;         %in Hz ...
DefParam.fftyunit      = 'dB';       %'dB' or 'P' ...
DefParam.fftyrange     = [-20 0]; 

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'clrcache'),
    emptycachefile(mfilename);
    return;
else, [Spt, Info, StimParam, Param] = ParseArgs(DefParam, varargin{:}); end

%Calculate data ...
CalcData = CalcCC(Spt, Info, Param, StimParam);

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(Info.ds1.filename, Info.ds1.icell); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(Info.ds1.filename, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        s = sprintf('THR: %s <%s>', dsTHR.FileName, dsTHR.seqID);
        s = strvcat(s, sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), Param2Str(Thr, 'dB', 0)));
        s = strvcat(s, sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)));
        s = strvcat(s, sprintf('BW = %s', Param2Str(BW, 'Hz', 1)));
        s = strvcat(s, sprintf('Q10 = %s', Param2Str(Q10, '', 1)));
        Str = s;
        CalcData.thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    else, CalcData.thr = struct([]); end    
catch, 
    warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); 
    CalcData.thr = struct([]);
end

%Display data ...
if strcmpi(Param.plot, 'yes'), PlotCC(Info, StimParam, Param, CalcData); end

%Return output if requested ...
if (nargout > 0), ArgOut = structtemplate(structcat(CalcData, struct('stim', StimParam, 'ds1', Info.ds1)), Template); end

%---------------------------------local functions----------------------------
function [Spt, Info, StimParam, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
if (length(varargin) < 1), error('Wrong number of input arguments.'); end
ds = varargin{1}; if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end
if ~strncmpi(ds.stimtype, 'fs', 2), warning(sprintf('Unknown dataset stimulus type ''%s''.', ds.stimtype)); end
    
%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{2:end});
CheckParam(Param);

%Unraveling and reorganizing input arguments ...
NRec = ds.nrec;
if strcmpi(Param.isubseq, 'all'),
    SubSeqs = 1:NRec;
    [IndepVal, idx] = sort(ds.xval(SubSeqs));
    SubSeqs = SubSeqs(idx);
    Spt = ds.spt(SubSeqs, :);
else,    
    if ~isequal(length(unique(Param.isubseq)), length(Param.isubseq)), error('Subsequence is included in analysis more than once.'); end
    if strcmpi(Param.subseqinput, 'indepval'), %Subsequences aren't sorted if user supplies values of independent variable explicitly ...
        if ~all(ismember(Param.isubseq, ds.xval(1:NRec)')), error('Invalid subsequences included for analysis.'); end
        IndepVal = Param.isubseq; 
        for n = 1:length(IndepVal), SubSeqs(n) = find(ds.xval == IndepVal(n)); end
        Spt = ds.spt(SubSeqs, :);
    else,
        if all(ismember(Param.isubseq, 1:NRec)), error('Invalid subsequences included for analysis.'); end
        SubSeqs = Param.isubseq;
        [IndepVal, idx] = sort(ds.xval(SubSeqs));
        SubSeqs = SubSeqs(idx);
        Spt = ds.spt(SubSeqs, :);
    end
end

%Assembling dataset information ...
Info.ds1.filename   = ds.filename;
Info.ds1.icell      = ds.icell;
Info.ds1.iseq       = ds.iseq;
Info.ds1.seqid      = ds.seqid;
Info.ds1.isubseq    = SubSeqs;
Info.ds1.indepval   = IndepVal;
Info.ds1.indepname  = ds.indepname;
Info.ds1.indepshort = ds.indepshortname;
Info.ds1.indepunit  = ds.indepunit;
[Scale, Inc] = GetIndepScale(ds.xval(1:NRec));
Info.ds1.indepscale = Scale; %Information about scale and increment of
Info.ds1.indepinc   = Inc;   %the independent variable isn't used anymore ...

%Collecting and reorganizing stimulus parameters ...
StimParam = GetStimParam(ds);

%Substitution of shortcuts in properties ...
if isinf(Param.anwin(2)), Param.anwin(2) = StimParam.burstdur; end

%Format parameter information ...
if strcmpi(Param.isubseq, 'all'), s = sprintf('SubSeqs = ALL');
else, s = sprintf('SubSeqs = %s', Param2Str(IndepVal, ds.indepunit, 0)); end
s = strvcat(s, sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0)));
s = strvcat(s, sprintf('BinWidth(SAC) = %s', Param2Str(Param.corbinwidth, 'ms', 2)));
if strcmpi(Param.cormaxlagunit, 'ms'), s = strvcat(s, sprintf('MaxLag(SAC) = %s', Param2Str(Param.cormaxlag, 'ms', 0)));
else, s = strvcat(s, sprintf('MaxLag(SAC) = %s', Param2Str(Param.cormaxlag, '#', 2))); end
s = strvcat(s, sprintf('RunAv(ENV) = %.2f%s', Param.envrunav, Param.envrunavunit));
s = strvcat(s, sprintf('RunAv(FFT on DIFCOR) = %s', Param2Str(Param.fftrunav, 'Hz', 0)));
s = strvcat(s, sprintf('NBin(PRDH) = %s', Param2Str(Param.prdhnbin, '#', 0)));
Param.str = s;

%----------------------------------------------------------------------------
function CheckParam(Param)

%Calculation parameters ...
if ~any(strcmpi(Param.verbose, {'yes', 'no'})), error('Property verbose must be ''yes'' or ''no''.'); end
if ~any(strcmpi(Param.cache, {'yes', 'no'})), error('Property cache must be ''yes'' or ''no''.'); end
if ~any(strcmpi(Param.subseqinput, {'indepval', 'subseq'})), error('Property subseqinput must be ''indepval'' or ''subseq''.'); end
if (~ischar(Param.isubseq) | ~strcmpi(Param.isubseq, 'all')) & (~isnumeric(Param.isubseq) | ~any(size(Param.isubseq) == 1)), error('Invalid value for property isubseq.'); end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]) | ~isinrange(Param.anwin, [0, +Inf]), error('Invalid value for property anwin.'); end
if ~isnumeric(Param.corbinwidth) | (length(Param.corbinwidth) ~= 1) | (Param.corbinwidth <= 0), error('Invalid value for property corbinwidth.'); end
if ~any(strcmpi(Param.cormaxlagunit, {'#', 'ms'})), error('Property cormaxlagunit must be ''#'' or ''ms''.'); end
if ~isnumeric(Param.cormaxlag) | (length(Param.cormaxlag) ~= 1) | (Param.cormaxlag <= 0), error('Invalid value for property cormaxlag.'); end
if ~any(strcmpi(Param.envrunavunit, {'#', 'ms'})), error('Property envrunavunit must be ''#'' or ''ms''.'); end
if ~isnumeric(Param.envrunav) | (length(Param.envrunav) ~= 1) | (Param.envrunav < 0), error('Invalid value for property envrunav.'); end
if ~isnumeric(Param.fftrunav) | (length(Param.fftrunav) ~= 1) | (Param.fftrunav < 0), error('Invalid value for property fftrunav.'); end
if ~isnumeric(Param.prdhnbin) | (length(Param.prdhnbin) ~= 1) | (Param.prdhnbin <= 0), error('Invalid value for property prdhnbin.'); end
if ~isnumeric(Param.sinperiods) | (length(Param.sinperiods) ~= 1) | (Param.sinperiods <= 0), error('Invalid value for property sinperiods.'); end

%Plot parameters ...
if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property plot must be ''yes'' or ''no''.'); end
if ~isinrange(Param.corxrange, [-Inf +Inf]), error('Invalid value for property corxrange.'); end
if ~isnumeric(Param.corxstep) | (length(Param.corxstep) ~= 1) | (Param.corxstep <= 0), error('Invalid value for property corxstep.'); end
if ~isinrange(Param.fftxrange, [0 +Inf]), error('Invalid value for property fftxrange.'); end
if ~isnumeric(Param.fftxstep) | (length(Param.fftxstep) ~= 1) | (Param.fftxstep <= 0), error('Invalid value for property fftxstep.'); end
if ~any(strcmpi(Param.fftyunit, {'dB', 'P'})), error('Property fftyunit must be ''dB'' or ''P''.'); end
if ~isinrange(Param.fftyrange, [-Inf +Inf]), error('Invalid value for property fftyrange.'); end

%----------------------------------------------------------------------------
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

%----------------------------------------------------------------------------
function StimParam = GetStimParam(ds)

%If stimulus and repetition duration is not the same for different channels then the minimum
%value is used. NaN's are automatically removed by min function ...
StimParam.burstdur = round(min(ds.burstdur));
StimParam.repdur   = round(min(ds.repdur));

%Sound pressure level (dB) is always returned as a scalar. If the SPL is different for
%the two channels the two SPLs are combined using the average of the power ...
SPL = GetSPL(ds); NRec = ds.nrec;
SPL = unique(SPL(1:NRec, :), 'rows');
StimParam.spl = CombineSPLs(SPL(1), SPL(end));

%Format stimulus parameters ...
s = sprintf('BurstDur = %s', Param2Str(StimParam.burstdur, 'ms', 0));
s = strvcat(s, sprintf('RepDur = %s', Param2Str(StimParam.repdur, 'ms', 0)));
s = strvcat(s, sprintf('SPL = %s', Param2Str(StimParam.spl, 'dB', 0)));
StimParam.str = s;

%----------------------------------------------------------------------------
function [Inc, Step] = GetIndepScale(Val, Tol)

Val = sort(Val); %If values are in random order ...
if (nargin == 2), Val = round(Val/Tol)*Tol; end

DVal = unique(diff(Val));
if (length(Val) == 1),
    Inc = 'lin';
    Step = Val;
elseif (length(DVal) == 1),  %Linear ...
    Inc  = 'lin';
    Step = DVal;
else, %Logaritmic ...
    Inc  = 'log'; 
    Step = log2(Val(2)/Val(1));
end

%----------------------------------------------------------------------------
function CalcData = CalcCC(Spt, Info, Param, StimParam)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
NRep   = size(Spt, 2); %Number of repetitions ...

%Maxlag of correlation can be given in fraction of the period of the stepsize, 
%because in the sum of all the correlograms there is resulting periodicity 
%depending on the period of the stepsize ...
%Attention! The value of the property cormaxlag is changed so the dimension
%is always in ms whatever the property cormaxlagunit might be ...
if strcmpi(Param.cormaxlagunit, '#'),
    %Always take the difference between the first and second minimum value of the
    %independent variable (only those values which were requested) as the stepsize,
    %whatever the scale might be ...
    NIndepVal = length(Info.ds1.indepval);
    if (NIndepVal == 1), Inc = Info.ds1.indepval;
    else,    
        SFreq = sort(Info.ds1.indepval);
        Inc = abs(diff(SFreq(1:2)));
    end    
    StepPeriod = 1000/Inc;
    Param.cormaxlag = Param.cormaxlag*StepPeriod;
end

%Calculation of the actual correlograms and period histograms ...
if strcmpi(Param.verbose, 'yes'), fprintf('Calculating correlogram for: '); end
Freqs = Info.ds1.indepval; NTones = size(Spt, 1);
[Ypp, Ynn, Ynp, Ypn, Yprdh] = deal([]);
[NCpp, NCnn, NCpn, NCnp] = deal(zeros(1, NTones));
for n = 1:NTones,
    Freq = Freqs(n); if strcmpi(Param.verbose, 'yes'), fprintf([ int2str(Freq) Info.ds1.indepunit ',']); end
    
    %Caching is done on the subsequence level and for autocorrelograms and periodhistograms ...
    SearchParam = structcat( ...
        struct('filename', Info.ds1.filename, 'iseq', Info.ds1.iseq, 'isubseq', Info.ds1.isubseq(n)), ... %Combinatorics ... dataset and subsequence used in correlation ...
        getfields(Param, {'anwin', 'corbinwidth', 'cormaxlag', 'prdhnbin'})); %Calculation parameters ...
    CacheData = FromCacheFile(mfilename, SearchParam);
    if strcmpi(Param.cache, 'yes') & ~isempty(CacheData),
        if strcmpi(Param.verbose, 'yes'), fprintf([ char(8) '(C),' ]); end
        CacheData = struct2cell(CacheData);
        [Ypp(n, :), Ynn(n, :), Ypn(n, :), Ynp(n, :), NCpp(n), NCnn(n), NCpn(n), NCnp(n), Yprdh(n, :), Sprdh(n)] = deal(CacheData{:});
    else, 
        [Ypp(n, :), Ynn(n, :), Ypn(n, :), Ynp(n, :), NCpp(n), NCnn(n), NCpn(n), NCnp(n), Yprdh(n, :), Sprdh(n)] = CalcSACXAC(Spt(n, :), Freq, StimParam, Param);
        if strcmpi(Param.cache, 'yes'), 
            CacheData = struct('Ypp', Ypp(n, :), 'Ynn', Ynn(n, :), 'Ypn', Ypn(n, :), 'Ynp', Ynp(n, :), ...
                'NCpp', NCpp(n), 'NCnn', NCnn(n), 'NCpn', NCpn(n), 'NCnp', NCnp(n), 'Yprdh', Yprdh(n, :), 'Sprdh', Sprdh(n));
            ToCacheFile(mfilename, +10000, SearchParam, CacheData);
        end
    end
end
if strcmpi(Param.verbose, 'yes'), fprintf([ char(8) '\n']); end

%Restricting SACs to requested number of periods ...
[dummy, T] = SPTCORR([], [], Param.cormaxlag, Param.corbinwidth);
Ysacs = repmat(NaN, NTones, length(T)); Periods = 1000./Freqs; PerFrac = Param.sinperiods/2;
for n = 1:NTones, 
    idx = find((T >= -(Periods(n)*PerFrac)) & (T <= (Periods(n)*PerFrac)));
    Ysacs(n, idx) = 1000*mean([Ypp(n, idx); Ynn(n, idx)], 1)/WinDur/NRep/(NRep-1); %In rate ...
end

%Calculation of the DIFCOR by taking the average of the two SACs and the two XACs and subtracting the second
%from the first, also calculating the SUMCOR by averaging the two ...
Ypp = sum(Ypp, 1)/sum(NCpp); 
Ynn = sum(Ynn, 1)/sum(NCnn); 
Ypn = sum(Ypn, 1)/sum(NCpn);
Ynp = sum(Ynp, 1)/sum(NCnp); 
%Ysac = mean([Ypp; Ynn]);
Ysac = Ypp; %Changed on 02-04-2004 ...
%Yxac = mean([Ypn; Ynp]);
Yxac = Ypn; %Changed on 02-04-2004 ...
Ydifcor = Ysac - Yxac;

%Performing spectrum analysis on the DIFCOR. Because a difcor has no DC component in comparison with
%other correlograms, this almost always results in a representative dominant frequency ...
FFTdif = spectana(T, Ydifcor, 'RunAvUnit', 'Hz', 'RunAvRange', Param.fftrunav);
DomFreq = FFTdif.DF; if (FFTdif.DF ~= 0), DomPer = 1000/FFTdif.DF; else, DomPer = NaN; end %Dominant period in ms ...

%Calculating the ratio of the secundary over the primary peak for the SAC ...
[SacPeakRatio, SacXPeaks, SacYPeaks] = getpeakratio(T, Ysac, DomFreq);

%Calculating envelope and Half Height Width of DIFCOR ...
if strcmpi(Param.envrunavunit, 'ms'), EnvRunAvN = round(Param.envrunav/Param.corbinwidth);
else, EnvRunAvN = round((Param.envrunav*DomPer)/Param.corbinwidth); end 
Yenv = runav(abs(hilbert(Ydifcor)), EnvRunAvN); 
HalfMaxEnv = max(Yenv)/2;
DifHHWx = cintersect(T, Yenv, HalfMaxEnv); DifHHW = abs(diff(DifHHWx));

%Calculating the ratio of the secundary over the primary peak for the DIFCOR ...
[DifPeakRatio, DifXPeaks, DifYPeaks] = getpeakratio(T, Ydifcor, DomFreq);

%Calculating rate curve ... Independent variable is given in the variable Freqs ...
Rate = 1000*sum(cellfun('length', anwin(Spt, Param.anwin)), 2)/WinDur/NRep;
[Freqs, idx] = sort(Freqs); Rate = Rate(idx);

%Period Histograms ...
BinCenters = 1/(2*Param.prdhnbin):1/Param.prdhnbin:(1-1/(2*Param.prdhnbin));
R = cat(1, Sprdh.R);
Ph = cat(1, Sprdh.Ph);
pRaySig = cat(1, Sprdh.pRaySig);

%Reorganizing calculated data ...
CalcData.rate.freq       = Freqs;
CalcData.rate.rate       = Rate;
CalcData.rate.max        = max(Rate);
CalcData.rate.bf         = GetMaxLoc(Freqs, Rate);
CalcData.si.delay        = T;
CalcData.si.normco       = Ysacs;
CalcData.prdh.bc         = BinCenters;
CalcData.prdh.normco     = Yprdh;
CalcData.prdh.r          = R;
CalcData.prdh.ph         = Ph;
CalcData.prdh.raysig     = pRaySig;
CalcData.cc.delay        = T;
CalcData.cc.normco       = [Ysac; Yxac];
CalcData.cc.max          = max(Ysac);
CalcData.cc.peakratio    = SacPeakRatio;
CalcData.cc.peakratiox   = SacXPeaks;
CalcData.cc.peakratioy   = SacYPeaks;
CalcData.diff.delay      = T;
CalcData.diff.normco     = [Ydifcor; Yenv; -Yenv];
CalcData.diff.max        = max(Ydifcor);
CalcData.diff.peakratio  = DifPeakRatio;
CalcData.diff.peakratiox = DifXPeaks;
CalcData.diff.peakratioy = DifYPeaks;
CalcData.diff.hhw        = DifHHW;
CalcData.diff.hhwx       = DifHHWx;
CalcData.diff.halfmax    = HalfMaxEnv;
CalcData.diff.fft.freq   = FFTdif.Freq;
CalcData.diff.fft.p      = FFTdif.Magn.P;   
CalcData.diff.fft.db     = FFTdif.Magn.dB;
CalcData.diff.fft.df     = FFTdif.DF;
CalcData.diff.fft.bw     = FFTdif.BW;

%----------------------------------------------------------------------------
function [Ypp, Ynn, Ypn, Ynp, NCpp, NCnn, NCpn, NCnp, Yprdh, Sprdh] = CalcSACXAC(Spt, Freq, StimParam, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
NRep   = size(Spt, 2); %Number of repetitions ...

%Responses to tone with same frequency but with phase shift of half a period is not
%recorded but generated automatically ...
SptFP = Spt; SptFN = PhaseShift(SptFP, StimParam.burstdur, Freq, 0.5);
[SptP, SptN] = SplitSpkTrain(SptFP); SptN = PhaseShift(SptN, StimParam.burstdur, Freq, 0.5);

%Calculating SAC, XAC ...
[Ypp, X, NC] = SPTCORR(anwin(SptFP, Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
NCpp = NC.DriesNorm;
[Ynn, dummy, NC] = SPTCORR(anwin(SptFN, Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur);
NCnn = NC.DriesNorm;
[Ypn, dummy, NC] = SPTCORR(anwin(SptP, Param.anwin), anwin(SptN, Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
NCpn = NC.DriesNorm;
[Ynp, dummy, NC] = SPTCORR(anwin(SptN, Param.anwin), anwin(SptP, Param.anwin), Param.cormaxlag, Param.corbinwidth, WinDur);
NCnp = NC.DriesNorm;

%Calculating Period Histogram on SAC ...
try,
    Prdh = CycleHist(X, mean([1000*Ypp/WinDur/NRep/(NRep-1); 1000*Ynn/WinDur/NRep/(NRep-1)], 1), WinDur, NRep, Freq, Param.prdhnbin);
    Yprdh = Prdh.Y;
    Sprdh = getfields(Prdh, {'R', 'Ph', 'pRaySig'});
catch,
    %Period Histogram could not be calculated because binning period is smaller than maxlag ...
    Yprdh = zeros(1, Param.prdhnbin);
    Sprdh = struct('R', NaN, 'Ph', NaN, 'pRaySig', NaN);
end    

%----------------------------------------------------------------------------
function [SptOut1, SptOut2] = SplitSpkTrain(SptIn)

NRep = length(SptIn);
[SptOut1, SptOut2] = deal(cell(0));

SptOut1 = SptIn(1:2:NRep);
SptOut2 = SptIn(2:2:NRep);

%----------------------------------------------------------------------------
function SptOut = PhaseShift(SptIn, StimDur, CarFreq, Shift)

NRep = length(SptIn);
SptOut = cell(1, NRep);

Period = 1000/CarFreq;
TimeShift = Period * Shift;

for RepNr = 1:NRep
   SpkTrain = SptIn{RepNr};
   SpkTrainStim   = SpkTrain(find(SpkTrain <= StimDur));
   SpkTrainNoStim = SpkTrain(find(SpkTrain > StimDur));
   SptOut{RepNr} = sort([rem(SpkTrainStim + TimeShift, StimDur), SpkTrainNoStim]);
end

%----------------------------------------------------------------------------
function PlotCC(Info, StimParam, Param, CalcData)

%General figure layout ...
UpperMargin    = 0.05;
LowerMargin    = 0.05;
LeftMargin     = 0.05;
RightMargin    = 0.05;
DivisionMargin = 0.05;
LabelFontSize  = 7;
TextFontSize   = 7;
TitleFontSize  = 9;
%In the upper part of the figure a fixed grid of 2 axes along the abcissa
%and 3 axes along
UpperDivision     = 3/4;
UpperVerAxSpacing = 0.05;
UpperHorAxSpacing = 0.05;
%In lower part of figure the period histograms are plotted with a variable
%spacing between axes. The organisation of the axes is also variable ..
LowerDivision     = 1/4;
LowerVerAxSpacing = 0.005;
LowerHorAxSpacing = 0.005;

%Creating frequently used character strings ...
IDStr = sprintf('%s <%s>', Info.ds1.filename, Info.ds1.seqid);
NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)'); %Normalisation Coincidence count ...

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), IDStr), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Upper Division of figure ...
NX = 2; NY = 3;
AxWidth  = (1 -(NX-1)*UpperHorAxSpacing -LeftMargin -RightMargin)/NX;
AxHeight = (UpperDivision -(NY-1)*UpperVerAxSpacing -DivisionMargin/2 -UpperMargin)/NY;
AxBgnHght = LowerDivision + DivisionMargin/2;

%Rate curve ...
nX = 1; nY = 3; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
AxRATE = axes('Position', [X, Y, AxWidth, AxHeight], 'TickDir', 'out', 'Box', 'off', 'FontSize', LabelFontSize);
LnHdl = line(CalcData.rate.freq, CalcData.rate.rate, 'LineStyle', '-', 'Color', 'b', 'Marker', '.'); 
LnHdl = line(CalcData.rate.bf, CalcData.rate.max, 'LineStyle', 'none', 'Color', 'r', 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 4);
XLim = xlim; YLim = ylim; YLim(1) = 0; set(AxRATE, 'YLim', YLim);
LnHdl = line(CalcData.rate.bf([1 1]), YLim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
TxtHdl = text(CalcData.rate.bf, YLim(1)+diff(YLim)*0.025, 'BF', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'demi', 'FontSize', TextFontSize);
TxtHdl = text(0, 1, {sprintf('BestFreq: %.0f%s', CalcData.rate.bf, Info.ds1.indepunit), ...
        sprintf('Max: %.0fspk/sec', CalcData.rate.max)}, 'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', TextFontSize);
if ~isempty(CalcData.thr), 
    LnHdl = line(XLim, CalcData.thr.sr([1 1]), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none'); 
    TxtHdl = text(XLim(1)+diff(XLim)*0.025, CalcData.thr.sr, 'SA', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'demi', 'FontSize', TextFontSize);
    LnHdl = line(CalcData.thr.cf([1 1]), YLim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none'); 
    if ((abs(CalcData.thr.cf-CalcData.rate.bf)/diff(XLim)) < 0.05), 
        YLoc = YLim(2)-diff(YLim)*0.025;
        VerAlign = 'top';
    else, 
        YLoc = YLim(1)+diff(YLim)*0.025; 
        VerAlign = 'bottom';
    end    
    TxtHdl = text(CalcData.thr.cf, YLoc, 'CF', 'VerticalAlignment', VerAlign, 'HorizontalAlignment', 'center', ...
        'FontWeight', 'demi', 'FontSize', TextFontSize);
end
title('RATE', 'FontSize', TitleFontSize, 'FontWeight', 'demi');
xlabel(sprintf('%s (%s)', Info.ds1.indepname, Info.ds1.indepunit), 'FontSize', LabelFontSize); 
ylabel('Rate (spk/sec)', 'FontSize', LabelFontSize);

%Superimpose curve of SACs ...
nX = 1; nY = 2; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
[MinX, MaxX, XTicks] = GetAxisLim('X', CalcData.si.delay, Param.corxrange, Param.corxstep);
AxSI = axes('Position', [X, Y, AxWidth, AxHeight], 'TickDir', 'out', 'Box', 'off', 'FontSize', LabelFontSize);
Hdl = line(CalcData.si.delay, CalcData.si.normco, 'LineStyle', '-', 'Marker', 'none');
Hdl = line([0, 0], ylim, 'LineStyle', ':', 'Marker', 'none', 'Color', 'k');
set(AxSI, 'XLim', [MinX MaxX], 'XTick', XTicks); 
title('SuperImpose Curve', 'FontSize', 9, 'FontWeight', 'demi');
xlabel('Delay(ms)', 'FontSize', LabelFontSize); 
ylabel('Rate (spk/sec)', 'FontSize', LabelFontSize);

%Header and information on calculation parameters ...
nX = 1; nY = 1; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
Str = { IDStr, sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))};
AxHDR = axes('Position', [X, Y, AxWidth, AxHeight], 'Visible', 'off');
text(0.5, 2/3+1/6, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', TitleFontSize);
text(0, 2/6, Param.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
    'FontWeight', 'normal', 'FontSize', TextFontSize);
if ~isempty(CalcData.thr),
    text(1/2, 2/6, char(CalcData.thr.str, '', StimParam.str), 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'normal', 'FontSize', TextFontSize);
else,
    text(1/2, 2/6, char(sprintf('THR data not present'), '', StimParam.str), 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'normal', 'FontSize', TextFontSize);
end

%Composite Curve ...
nX = 2; nY = 3; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
[MinX, MaxX, XTicks] = GetAxisLim('X', CalcData.cc.delay, Param.corxrange, Param.corxstep);
AxCC = axes('Position', [X, Y, AxWidth, AxHeight], 'TickDir', 'out', 'Box', 'off', 'FontSize', LabelFontSize);
LnHdl = line(CalcData.cc.delay, CalcData.cc.normco, 'LineStyle', '-', 'Marker', 'none'); 
set(LnHdl(1), 'LineWidth', 2, 'Color', 'b'); set(LnHdl(2), 'LineWidth', 0.5, 'Color', 'g');
title('SAC and XAC', 'FontSize', TitleFontSize, 'FontWeight', 'demi');
xlabel('Delay (ms)', 'FontSize', LabelFontSize); 
ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0], 'FontSize', LabelFontSize);
set(AxCC, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(AxCC, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
PlotPeakRatio(CalcData.cc.peakratiox, CalcData.cc.peakratioy, 'b'); 
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, {sprintf('Max: %.2f', CalcData.cc.max), sprintf('PeakRatio: %.2f', CalcData.cc.peakratio)}, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', TextFontSize);
legend({'SAC', 'XAC'}, 1);

%DIFCOR ...
nX = 2; nY = 2; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
AxDIF = axes('Position', [X, Y, AxWidth, AxHeight], 'TickDir', 'out', 'Box', 'off', 'FontSize', LabelFontSize);
LnHdl = line(CalcData.diff.delay, CalcData.diff.normco); 
set(LnHdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
set(LnHdl(2), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
set(LnHdl(3), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
title('DIFCOR', 'FontSize', TitleFontSize, 'FontWeight', 'demi');
xlabel('Delay(ms)', 'FontSize', LabelFontSize); 
ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0], 'FontSize', LabelFontSize);
set(AxDIF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
YRange = get(AxDIF, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
PlotPeakRatio(CalcData.diff.peakratiox, CalcData.diff.peakratioy, 'r');
LnHdl = PlotCInterSect(CalcData.diff.hhwx, CalcData.diff.halfmax([1 1]), MinY);
set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
text(MinX, MaxY, {sprintf('Max: %.2f', CalcData.diff.max), sprintf('PeakRatio: %.2f', CalcData.diff.peakratio), ...
        sprintf('HHW: %.2fms', CalcData.diff.hhw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', TextFontSize);

%Plotting discrete fourier transform of DIFCOR ...
nX = 2; nY = 1; X = LeftMargin + (nX-1)*(AxWidth+UpperHorAxSpacing); Y = AxBgnHght + (nY-1)*(AxHeight+UpperVerAxSpacing);
Xdata = CalcData.diff.fft.freq; 
if strcmpi(Param.fftyunit, 'dB'), 
    Ydata = CalcData.diff.fft.db; 
    YLblStr = 'Amplitude (dB)';
else, 
    Ydata = CalcData.diff.fft.p; 
    YLblStr = 'Power'; 
end
if ~isnan(CalcData.diff.fft.df),
    Ord = floor(log10(CalcData.diff.fft.df*2))-1;
    MinX = 0; MaxX = round(CalcData.diff.fft.df*2*10^-Ord)*10^Ord;
    XTicks = 'auto';
else, [MinX, MaxX, XTicks] = GetAxisLim('X', Xdata, Param.fftxrange, Param.fftxstep); end    
[MinY, MaxY] = GetAxisLim('Y', Ydata, Param.fftyrange);
AxDFT = axes('Position', [X, Y, AxWidth, AxHeight], 'TickDir', 'out', 'Box', 'off', 'FontSize', LabelFontSize);
LnHdl = line(Xdata, Ydata);
set(LnHdl(2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 0.5);
set(LnHdl(1), 'LineStyle', ':', 'Color', 'k', 'LineWidth', 0.5);
title('DFT on DIFCOR', 'FontSize', TitleFontSize, 'FontWeight', 'demi');
xlabel('Freq(Hz)', 'FontSize', LabelFontSize); ylabel(YLblStr, 'FontSize', LabelFontSize);
if ~ischar(XTicks), set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
else, set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY]); end    
YRange = get(AxDFT, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
line(CalcData.diff.fft.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Vertical line at dominant frequency ...
text(MinX, MaxY, {sprintf('DomFreq: %.2fHz', CalcData.diff.fft.df), sprintf('BandWidth: %.2fHz', CalcData.diff.fft.bw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', TextFontSize);
legend({'Orig', 'RunAv'}, 1);

%Period histograms on SACs ...
NHist = size(CalcData.prdh.normco, 1);
[NX, NY] = FactorsForSubPlot(NHist, 1/LowerDivision);
AxWidth = (1 -LeftMargin -RightMargin -(NX-1)*LowerHorAxSpacing)/NX;
AxHeight = (LowerDivision -LowerMargin -DivisionMargin/2 -(NY-1)*LowerVerAxSpacing)/NY;

MaxY = 0;
for n = 1:NHist,
    nX = mod((n-1),NX)+1;
    nY = NY - floor((n-1)/NX);
    X  = LeftMargin + (LowerHorAxSpacing + AxWidth)*(nX-1);
    Y  = LowerMargin + (LowerVerAxSpacing + AxHeight)*(nY-1); 

    AxPRDH(n) = axes('Position', [X, Y, AxWidth, AxHeight], 'FontSize', LabelFontSize);
    HistHdl(n) = bar(CalcData.prdh.bc, CalcData.prdh.normco(n, :), 1);
    set(HistHdl(n), 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', [0.7 0.7 0.7]);
    if (nY == 1), set(AxPRDH(n), 'XTick', [0 0.5 1]);
    else, set(AxPRDH(n), 'XTick', [], 'XTickLabel', []); end    
    if (nX ~= 1), set(AxPRDH(n), 'YTick', [], 'YTickLabel', []); end    
    TxtHdl = text(0, 1, {sprintf('%s: %.0f', Info.ds1.indepshort, Info.ds1.indepval(n)), sprintf('R: %.2f', CalcData.prdh.r(n)), sprintf('\\phi: %.2f', CalcData.prdh.ph(n)), ...
            sprintf('pRaySig: %.3f', CalcData.prdh.raysig(n))}, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', TextFontSize);
    MaxY = max([ylim, MaxY]);
end
set(AxPRDH, 'YLim', [0, MaxY]);

AxTITLE = axes('Position', [0.5, LowerDivision, eps, eps], 'Visible', 'off');
text(0.5, 0.5, 'PERIOD Histograms', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'demi', 'FontSize', TitleFontSize);

AxXLBL = axes('Position', [0.5, UpperMargin/2, eps, eps], 'Visible', 'off');
text(0.5, 0.5, 'Delay (cycles)', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'normal', 'FontSize', LabelFontSize);

AxYLBL = axes('Position', [LeftMargin/2, LowerDivision/2, eps, eps], 'Visible', 'off');
text(0.5, 0.5, 'Rate (spk/sec)', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'normal', 'FontSize', LabelFontSize, 'Rotation', 90);

%----------------------------------------------------------------------------
function [MinVal, MaxVal, Ticks] = GetAxisLim(AxisType, Values, Range, Step)

if strcmpi(AxisType, 'x'), %Abcissa ...
    Margin = 0.00;
    
    if isinf(Range(1)), MinVal = min(Values(:))*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
    Ticks = MinVal:Step:MaxVal;
else, %Ordinate ...    
    Margin = 0.05;
    
    if isinf(Range(1)), MinVal = min([0; Values(:)])*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
end

%----------------------------------------------------------------------------
function PlotPeakRatio(XPeaks, YPeaks, Color, MinY)

line(XPeaks, YPeaks, 'Color', Color, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 12); 

%----------------------------------------------------------------------------
function PlotVerZero(MinY, MaxY)

line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------
function PlotHorZero(MinX, MaxX)

line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------