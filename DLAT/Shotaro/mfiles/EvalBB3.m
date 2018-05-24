function [ArgOut,ThrCF,DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF] = EvalBB3(varargin)
%EVALBB  evaluate binaural beat (BB) datasets
%   EVALBB(ds) evaluates the binaural beat responses in dataset ds.
%   D = EVALBB(ds) returns the results in structure D.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'list' as only property.

%B. Van de Sande 13-09-2004

%---------------------------------------------------------------------------------------------
%Template for scatterplots ... 
Template.ds1.filename   = '';  
Template.ds1.icell      = NaN;
Template.ds1.iseq       = NaN;  
Template.ds1.seqid      = '';  
Template.ds2.iseq       = NaN;
Template.ds2.seqid      = '';
Template.param.repdur   = NaN;       %Repetition duration in ms ...
Template.param.burstdur = NaN;       %Stimulus duration in ms ...
Template.param.nrep     = NaN;       %Repetition number ...
Template.param.spl      = NaN;       %Sound pressure level in dB ...
Template.param.inc      = '';        %Linear or logaritmic independent value incrementation ...
Template.param.step     = NaN;       %Size of independent value incrementation ...
Template.tag            = 0;         %General purpose tag field
Template.createdby      = mfilename; %Name of MATLAB function that generated the data
Template.rate.max       = NaN;       %Maximum firing rate (spk/sec)
Template.rate.bf        = NaN;       %Frequency at maximum rate (Hz)
Template.vs.maxr        = NaN;       %Maximum synchronicity
Template.vs.bf          = NaN;       %Frequency at maximum synchronicity (Hz)
Template.vs.cd          = NaN;       %Characteristic delay (ms)
Template.vs.cp          = NaN;       %Characteristic phase (cycles)
Template.vs.cpmod       = NaN;       %Characteristic phase restricted to interval [0, +1[(cycles)
Template.vs.plinreg     = NaN;       %Probability of linear regression
Template.itd.max        = NaN;       %Maximum 'interaural' firing rate (spk/sec)
Template.itd.bestitd    = NaN;       %Delay at this maximum rate (ms)
Template.itd.ratio      = NaN;       %Ratio of secundary versus primary peak in interaural delay curve
Template.diff.max       = NaN;       %Maximum 'interaural' firing rate (spk/sec)
Template.diff.bestitd   = NaN;       %Delay at this maximum rate (ms)
Template.diff.ratio     = NaN;       %Ratio of secundary versus primary peak in interaural delay curve
Template.diff.hhw       = NaN;       %Half height width (ms) ...
Template.fft.df         = NaN;       %Dominant frequency in interaural delay curve (Hz)
Template.fft.bw         = NaN;       %Bandwidth of interaural delay curve (Hz)
Template.thr.cf         = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr         = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr        = NaN;       %Threshold at characteristic frequency
Template.thr.q10        = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw         = NaN;       %Width 10dB above threshold (Hz)

%---------------------------------------------------------------------------------------------
%List of default parameters ...
%Calculation parameters ...
DefParam.indep2val     = 'max';       %'min', 'max' or specific value ...
DefParam.anwin         = [0 -1];      %in ms ... (-1 designates stimulus duration)
DefParam.histnbin      = 64;
DefParam.vsraysig      = 0.001;   
DefParam.calcdf        = NaN;           %in Hz, NaN (automatic), 'cf' or 'df' ...
DefParam.itdconfreq    = 'mean';      %'mean' or 'master' ...
DefParam.itdbinwidth   = 0.05;        %in ms ...
DefParam.itdmaxlagunit = '#';         %'#' or 'ms' ...
DefParam.itdmaxlag     = 0.5; 
DefParam.itdrunavunit  = 'ms';        %'ms' or '#' ...   
DefParam.itdrunav      = 0.20;
DefParam.envrunavunit  = '#';         %'ms' or '#' ...   
DefParam.envrunav      = 1;    
%Plot parameters ...
DefParam.plot         = 'yes';       %'yes' or 'no' ...
DefParam.plottype     = 'all';       %'all', 'cc' or 'vs' ... 
DefParam.freqxrange   = [-Inf +Inf]; %in Hz ...
DefParam.rasmaxytick  = 12;          
DefParam.itdxrange    = [-5 +5];     %in ms ...
DefParam.itdxstep     = 1;           %in ms ...
DefParam.fftxrange    = [0 2500];    %in Hz ...
DefParam.fftxstep     = 250;         %in Hz ...
DefParam.fftyunit     = 'dB';        %'dB' or 'P' ...
DefParam.fftyrange    = [-20 0]; 

%---------------------------------------------------------------------------------------------
%Evaluate input parameters ...
[dsBB, CellInfo, Param] = EvalParam(DefParam, varargin);

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(dsBB); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(CellInfo.datafile, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        %extract
        ThrCF=CF;
        assignin('base','ThrCF',ThrCF);
        
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10));
        CellInfo.thrstr = sprintf('CF = %s / SR = %s', Param2Str(CF, 'Hz', 0), Param2Str(SR, 'spk/sec', 1));
    else, Thr = struct([]); CellInfo.thrstr = sprintf('THR data not present');
        %extract
        ThrCF=0;
        assignin('base','ThrCF',ThrCF);
    end    
catch, 
    warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); 
    Thr = struct([]); CellInfo.thrstr = sprintf('THR data not present');
    %extract
    ThrCF=0;
    assignin('base','ThrCF',ThrCF);
end

%Calculate data ...
[CalcData, CellInfo] = CalcCurve(dsBB, CellInfo, Thr, Param);

%Display data ...
if strcmpi(Param.plot, 'yes'), 
    if strcmpi(Param.plottype, 'all'),
        [DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF]=PlotCurve('cc', CalcData, CellInfo, Param); 
        [DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF]=PlotCurve('vs', CalcData, CellInfo, Param); 
    elseif strcmpi(Param.plottype, 'cc'), [DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF]=PlotCurve('cc', CalcData, CellInfo, Param); 
    else, [DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF]=PlotCurve('vs', CalcData, CellInfo, Param); end
end

%Return output parameters ...
if nargout > 0, 
    CalcData.thr = Thr;
    ArgOut = structtemplate(CalcData, Template); 
end    

%---------------------------------------------------------------------------------------------
function [dsBB, CellInfo, Param] = EvalParam(DefParam, ParamList)

%Checking input parameters ...
if (length(ParamList) < 1), error('Wrong number of input parameters.'); end
if ~isa(ParamList{1}, 'dataset') | ~isequal(ParamList{1}.chan, 0), error('First argument should be binaural dataset.'); end
dsBB = ParamList{1};

%Checking dataset ...
FileFormat = dsBB.FileFormat; [CellNr, TestNr, StimType] = UnRavelID(dsBB.SeqID);
if ~(strcmpi(FileFormat, 'IDF/SPK') & any(strcmpi(StimType, {'BB', 'FS', 'BFS'}))) & ... %IDF/SPK datasets ...
   ~(strcmpi(FileFormat, 'EDF') & ~isempty(findstr(StimType, 'BB'))),                    %EDF datasets ...
    warning(sprintf('Unknown dataset type: ''%s''.', upper(StimType))); 
end
if strcmpi(FileFormat, 'EDF') & (dsBB.indepnr > 1), warning('Multiple independent variables, using one-dimensional restriction.'); end

%Evaluate optional list of property/values ...
ParamList(1) = [];
Param = checkproplist(DefParam, ParamList{:});
CheckParam(Param);

%Assembling stimulus parameters ...
StimParam = GetStimParam(dsBB, Param);

%Setting shortcuts in calculation parameters ...
if Param.anwin(2) == -1, Param.anwin(2) = max(StimParam.burstdur); end %Taking maximum burst duration as default offset for analysis window ...
if strcmpi(Param.itdrunavunit, 'ms'), 
    RunAvTsup = Param.itdrunav;
    RunAvNsup = round(Param.itdrunav/Param.itdbinwidth);
    RunAvNeff = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff = RunAvNeff*Param.itdbinwidth;
    Param.itdrunav = RunAvNsup;
    RunAvItdStr = sprintf('%.2fms (%.0f#, %.2fms)', RunAvTsup, RunAvNeff, RunAvTeff);
else,
    RunAvNsup = Param.itdrunav;
    RunAvNeff = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff = RunAvNeff*Param.itdbinwidth;
    Param.itdrunav = RunAvNsup;
    RunAvItdStr = sprintf('%.0f# (%.0f#, %.2fms)', RunAvNsup, RunAvNeff, RunAvTeff);
end 
if strcmpi(Param.itdmaxlagunit, '#')
    if strcmpi(StimParam.inc, 'lin')
        StepPer = 1000/abs(StimParam.step);
    else
        StepPer = 1000/((StimParam.indepval(1)*2^StimParam.step)-StimParam.indepval(1)); 
    end %Smallest StepSize used ...
    MaxLagN = Param.itdmaxlag;
    MaxLagT = MaxLagN*StepPer;
    Param.itdmaxlag = MaxLagT;
    MaxLagStr = sprintf('%.1f# (%.0fms)', MaxLagN, MaxLagT);
else
    MaxLagStr = Param2Str(Param.itdmaxlag, 'ms', 0); 
end
%Running average parameters on enveloppe cannot be unified yet, dominant frequency necessary ...

%Assembling cell information ...
CellInfo.datafile = upper(dsBB.FileName);
CellInfo.seqnr    = dsBB.iSeq;
CellInfo.dsid     = dsBB.SeqID;
CellInfo.cellstr  = sprintf('%s <%s> (#%d)', CellInfo.datafile, CellInfo.dsid, CellInfo.seqnr);

%Constructing information string on parameters ...
if isnan(Param.calcdf), CalcDFStr = 'auto';
elseif ischar(Param.calcdf), CalcDFStr = lower(Param.calcdf);
else, CalcDFStr = Param2Str(Param.calcdf, 'Hz', 0); end
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('NBin(CH) = %s', Param2Str(Param.histnbin, '#', 0)));
s = strvcat(s, sprintf('Calc. DF = %s', CalcDFStr));
s = strvcat(s, sprintf('BinWidth(ITD) = %s', Param2Str(Param.itdbinwidth, 'ms', 2)));
s = strvcat(s, sprintf('MaxLag(ITD) = %s', MaxLagStr));
s = strvcat(s, sprintf('RunAv(ITD) = %s', RunAvItdStr));
CellInfo.ccparamstr = s;
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('NBin(CH) = %s', Param2Str(Param.histnbin, '#', 0)));
s = strvcat(s, sprintf('RaySig(CH) = %s', Param2Str(Param.vsraysig, '', 3)));
CellInfo.vsparamstr = s;

%Constructing information string on stimulus parameters ...
s = sprintf('BurstDur/IntDur/#Reps = %s/%s x %s', Param2Str(StimParam.burstdur, '', 0), ...
    Param2Str(StimParam.repdur, 'ms', 0), Param2Str(StimParam.nrep, '', 0));
s = strvcat(s, sprintf('SPL = %s', Param2Str(StimParam.spl, 'dB', 0)));
if strcmpi(StimParam.inc, 'lin'), s = strvcat(s, sprintf('StepFreq = %s', Param2Str(StimParam.step, 'Hz', 0)));
else, s = strvcat(s, sprintf('StepFreq = %s', Param2Str(StimParam.step, 'Oct', 2))); end    
if ~isnan(StimParam.beatcarfreq),
    s = strvcat(s, sprintf('CarFreq = %s (%s)', Param2Str(StimParam.carfreq, 'Hz', 0), upper(StimParam.inc)));
    s = strvcat(s, sprintf('CarBeat = %s', Param2Str(StimParam.beatcarfreq, 'Hz', 0)));
else,
    s = strvcat(s, sprintf('CarFreq = %s', Param2Str(StimParam.carfreq, 'Hz', 0)));
    s = strvcat(s, sprintf('ModFreq = %s (%s)', Param2Str(StimParam.modfreq, 'Hz', 0), upper(StimParam.inc)));
    s = strvcat(s, sprintf('ModBeat = %s', Param2Str(StimParam.beatmodfreq, 'Hz', 0)));
end
CellInfo.stimstr = s;

%Reorganize parameters ...
Param = structcat(StimParam, Param);

%---------------------------------------------------------------------------------------------
function CheckParam(Param)

if ~(isnumeric(Param.indep2val) & (length(Param.indep2val) == 1)) & ~(any(strcmpi(Param.indep2val, {'min', 'max'}))), error('Invalid value for property indep2val.'); end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]), error('Invalid value for property anwin.'); end
if ~isnumeric(Param.vsraysig) | (length(Param.vsraysig) ~= 1) | (Param.vsraysig <= 0), error('Invalid value for property vsraysig.'); end
if ~isnumeric(Param.histnbin) | (length(Param.histnbin) ~= 1) | (Param.histnbin <= 0) | (mod(Param.histnbin, 1) ~= 0), error('Invalid value for property histnbin.'); end
if (mod(Param.histnbin, 2) ~= 0), error('Property histnbin must be assigned an even number.'); end
if ~(isnumeric(Param.calcdf) & ((Param.calcdf > 0) | isnan(Param.calcdf))) & ...
        ~(ischar(Param.calcdf) & any(strcmpi(Param.calcdf, {'cf', 'df'}))), 
    error('Property calcdf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if ~any(strcmpi(Param.itdconfreq, {'mean', 'master'})), error('Property itdconfreq should be ''mean'' or ''master''.'); end
if ~isnumeric(Param.itdbinwidth) | (length(Param.itdbinwidth) ~= 1) | (Param.itdbinwidth <= 0), error('Invalid value for property itdbinwidth.'); end
if ~any(strcmpi(Param.itdmaxlagunit, {'ms', '#'})), error('Property itdmaxlagunit should be ''ms'' or ''#''.'); end
if ~isnumeric(Param.itdmaxlag) | (length(Param.itdmaxlag) ~= 1) | (Param.itdmaxlag <= 0), error('Invalid value for property itdmaxlag.'); end
if ~isnumeric(Param.itdrunav) | (length(Param.itdrunav) ~= 1) | (Param.itdrunav < 0), error('Invalid value for property itdrunav.'); end
if ~any(strcmpi(Param.itdrunavunit, {'ms', '#'})), error('Property itdrunavunit should be ''ms'' or ''#''.'); end
if ~isnumeric(Param.envrunav) | (length(Param.envrunav) ~= 1) | (Param.envrunav < 0), error('Invalid value for property envrunav.'); end
if ~any(strcmpi(Param.envrunavunit, {'ms', '#'})), error('Property envrunavunit should be ''ms'' or ''#''.'); end

if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property plot must be ''yes'' or ''no''.'); end
if ~any(strcmpi(Param.plottype, {'all', 'cc', 'vs'})), error('Property plottype should be ''all'', ''cc'' or ''vs''.'); end
if ~isinrange(Param.freqxrange, [-Inf +Inf]), error('Invalid value for property freqxrange.'); end
if ~isnumeric(Param.rasmaxytick) | (length(Param.rasmaxytick) ~= 1) | (Param.rasmaxytick <= 0), error('Invalid value for property rasmaxytick.'); end
if ~isinrange(Param.itdxrange, [-Inf +Inf]), error('Invalid value for property itdxrange.'); end
if ~isnumeric(Param.itdxstep) | (length(Param.itdxstep) ~= 1) | (Param.itdxstep <= 0), error('Invalid value for property itdxstep.'); end
if ~isinrange(Param.fftxrange, [0 +Inf]), error('Invalid value for property fftxrange.'); end
if ~isnumeric(Param.fftxstep) | (length(Param.fftxstep) ~= 1) | (Param.fftxstep <= 0), error('Invalid value for property fftxstep.'); end
if ~any(strcmpi(Param.fftyunit, {'dB', 'P'})), error('Property fftyunit must be ''dB'' or ''P''.'); end
if ~isinrange(Param.fftyrange, [-Inf +Inf]), error('Invalid value for property fftyrange.'); end

%---------------------------------------------------------------------------------------------
function StimParam = GetStimParam(dsBB, Param)

StimParam = struct('repdur', [], 'burstdur', [], 'risedur', [], 'falldur', [], 'spl', [], 'carfreq', [], 'modfreq', [], ...
    'beatcarfreq', [], 'beatmodfreq', [], 'freq', [], 'beat', [], 'inc', [], 'step', [], 'indepval', [], 'isubseqs', []);
Nrec = dsBB.nrec; 
FileFormat = dsBB.fileformat; if strcmpi(FileFormat, 'EDF'), Nindep = dsBB.indepnr; else, Nindep = 1; end
if (Nindep > 1),
    FreqIndepNr = isempty(strfind(dsBB.EDFIndepVar(1).ShortName, 'frequency')) + 1;
    SecIndepNr  = mod(FreqIndepNr, 2) + 1;
    if isnumeric(Param.indep2val), SecVal = Param.indep2val;
    else, SecVal = feval(Param.indep2val, dsBB.EDFIndepVar(SecIndepNr).Values); end
    iSubSeqs = find(dsBB.EDFIndepVar(SecIndepNr).Values == SecVal);
else, iSubSeqs = 1:Nrec; end

StimParam.repdur   = dsBB.Special.RepDur(1); %Repetition duration is always equal for both channels ...
StimParam.burstdur = dsBB.Special.BurstDur([1, min(2, end)]); %Always two-element columnvector ...
StimParam.nrep     = dsBB.nrep; %Number of repetition is always equal for both channels ...
if strcmpi(FileFormat, 'IDF/SPK'),
    StimParam.risedur = [dsBB.StimParam.indiv.stim{1}.rise, dsBB.StimParam.indiv.stim{2}.rise]; %Always two-element columnvector ...
    StimParam.falldur = [dsBB.StimParam.indiv.stim{1}.fall, dsBB.StimParam.indiv.stim{2}.fall]; %Always two-element columnvector ...
elseif strcmpi(FileFormat, 'EDF') & (Nindep == 1),
    StimParam.risedur  = dsBB.StimParam.RiseDur([1, min(2, end)]); %Always two-element columnvector ...
    StimParam.falldur  = dsBB.StimParam.FallDur([1, min(2, end)]); %Always two-element columnvector ...
elseif strcmpi(FileFormat, 'EDF') & (Nindep == 2),
    StimParam.risedur  = dsBB.StimParam.RiseDur([1, min(2, end)]); %Always two-element columnvector ...
    StimParam.falldur  = dsBB.StimParam.FallDur([1, min(2, end)]); %Always two-element columnvector ...
end
SPL = GetSPL(dsBB); LeSPL = unique(SPL(iSubSeqs, 1)); ReSPL = unique(SPL(iSubSeqs, 2));
if (length(LeSPL) == 1) & (length(ReSPL) == 1), StimParam.spl = [LeSPL, ReSPL];
else, StimParam.spl = SPL(iSubSeqs, :); end    

%Special structure is invalid for incomplete FS-dataset collected before August 2002 ...
if strcmpi(dsBB.FileFormat, 'IDF/SPK') & any(strcmpi(dsBB.StimType, {'BFS', 'FS'})) & (dsBB.nrec ~= dsBB.nsub) & ...
   (datenum(dsBB.Time([3, 2, 1, 4, 5, 6])) < datenum(2002, 8, 1)),
    warning('Incomplete FS-dataset collected before August 2002.');
    Freqs = SPKuetvar(dsBB);
    StimParam.carfreq = Freqs(iSubSeqs, :);
    StimParam.modfreq = NaN;
    StimParam.beatcarfreq = abs(Freqs(iSubSeqs, 2)-Freqs(iSubSeqs, 1));
    StimParam.beatmodfreq = NaN;
else,
    S = GetFreq(dsBB);
    LeCarFreq = unique(S.CarFreq(iSubSeqs, 1)); ReCarFreq = unique(S.CarFreq(iSubSeqs, 2)); 
    if (length(LeCarFreq) == 1) & (length(ReCarFreq) == 1), StimParam.carfreq = [LeCarFreq, ReCarFreq];
    else, StimParam.carfreq = S.CarFreq(iSubSeqs, :); end
    ModFreq = S.ModFreq(iSubSeqs, :);
    if all(isnan(ModFreq(:))), StimParam.modfreq = NaN; else, StimParam.modfreq = ModFreq; end
    if all(isnan(S.BeatFreq(iSubSeqs))), StimParam.beatcarfreq = NaN; else, StimParam.beatcarfreq = abs(S.BeatFreq(iSubSeqs)); end
    if all(isnan(S.BeatModFreq(iSubSeqs))), StimParam.beatmodfreq = NaN; else, StimParam.beatmodfreq = abs(S.BeatModFreq(iSubSeqs)); end
    if isnan(StimParam.beatcarfreq) & isnan(StimParam.beatmodfreq), error('Wrong stimulus in dataset.'); end
end

%The constant frequency can be taken as the frequency of the DSS/channel that was varied or 
%it can be taken as the mean of the frequencies administered at both ears ...
if ~all(isnan(StimParam.beatcarfreq)), 
    if strcmpi(Param.itdconfreq, 'mean'), StimParam.freq = mean(StimParam.carfreq, 2)';
    else, StimParam.freq = StimParam.carfreq(:, 1)'; end
    StimParam.beat     = StimParam.beatcarfreq';
    StimParam.indepval = StimParam.carfreq(:, 1)';
elseif ~all(isnan(StimParam.beatmodfreq)), 
    if strcmpi(Param.itdconfreq, 'mean'), StimParam.freq = mean(StimParam.modfreq, 2)';
    else, StimParam.freq = StimParam.modfreq(:, 1)'; end
    StimParam.beat     = StimParam.beatmodfreq'; 
    StimParam.indepval = StimParam.modfreq(:, 1)';
end
[StimParam.inc, StimParam.step] = GetIndepScale(StimParam.indepval); %Logaritmic or linear scale ...
StimParam.isubseqs = iSubSeqs;

%---------------------------------------------------------------------------------------------
function [CellNr, TestNr, StimType] = UnRavelID(dsID)

idx = findstr(dsID, '-');

if (length(idx) == 1), idx = [idx length(dsID)+1]; end
CellNr   = str2num(dsID(1:idx(1)-1));
TestNr   = str2num(dsID(idx(1)+1:idx(2)-1));
if isempty(TestNr), TestNr = NaN; idx(2) = idx(1); end %Sometimes no testnumber ...

if (length(idx) == 2), StimType = dsID(idx(2)+1:end);
else, StimType = dsID(idx(2)+1:idx(3)-1); end

%---------------------------------------------------------------------------------------------
function [Inc, Step] = GetIndepScale(Val, Tol)

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
function [CalcData, CellInfo] = CalcCurve(dsBB, CellInfo, Thr, Param)

Freq   = Param.freq;
Beat   = Param.beat;
NFreq  = length(Freq);
Period = 1000./Freq;

IndepVal = Param.indepval;
iSubSeqs = Param.isubseqs;

%Calculating rate curve ...
Rate = GetRate(dsBB, iSubSeqs, Param.anwin(1), Param.anwin(2));
[Max, idx] = max(Rate); BestFreq = IndepVal(idx);

RATE.Freq = IndepVal;
RATE.Rate = Rate;
RATE.Max  = Max;
RATE.BF   = BestFreq;
RATE = lowerfields(RATE);

%Calculating histograms on beatfrequencies. 
try, FlipSign = ~CheckBinParam(dsBB, 'bb');
catch, warning(lasterr); FlipSign = logical(0); end    
for n = 1:NFreq, 
    HIST(n) = CycleHist(dsBB, iSubSeqs(n), Beat(n), Param.histnbin, Param.anwin(1), Param.anwin(2));
    if FlipSign,
        HIST(n).Ph = 1 - HIST(n).Ph;
        HIST(n).Y  = fliplr(HIST(n).Y);
    end
end

%Calculating vector strength magnitude and phase curves ...
R       = cat(2, HIST.R);
Ph      = unwrap(cat(2, HIST.Ph)*(2*pi))/2/pi; %Unwrapping ...
RaySig  = cat(2, HIST.pRaySig);
idxSign = find(RaySig <= Param.vsraysig);

if ~isempty(idxSign) & (length(idxSign) > 1),
    SIndepVal = IndepVal(idxSign);
    MaxR = max(R(idxSign)); BestFreq = min(SIndepVal(find(R(idxSign) == MaxR)));
    
    Wg = R(idxSign).*RATE.rate(idxSign); %Synchronicity Rate is weight-factor ...
    P = linregfit(IndepVal(idxSign), Ph(idxSign), Wg);
    [pLinReg, MSerr, DF] = signlinreg(P, IndepVal(idxSign), Ph(idxSign), Wg);
    
    CD = P(1)*1000; CP = P(2); %Characteristic delay in ms, phase in cycles ...
    CPMod = mod(CP, 1);        %Restrict phase to interval [0,+1[ ...
else, [MaxR, BestFreq, CD, CP, CPMod, pLinReg, MSerr, DF] = deal(NaN); end

VS.Freq    = IndepVal;
VS.R       = R;
VS.Ph      = Ph;
VS.RaySig  = RaySig;
VS.MaxR    = MaxR;
VS.BF      = BestFreq;
VS.CD      = CD;
VS.CP      = CP;
VS.CPMod   = CPMod;
VS.pLinReg = pLinReg;
VS.MSerr   = MSerr;
VS.DF      = DF;
VS = lowerfields(VS);

%Calculating ITD curves and composite curve ...
BinCenters     = HIST(1).X;
Delay          = (-Param.itdmaxlag):Param.itdbinwidth:(+Param.itdmaxlag);
[RateP, RateN] = deal(zeros(NFreq, length(Delay)));
for n = 1:NFreq,
    NPeriods = 2*ceil(Param.itdmaxlag/Period(n));
    X = Period(n) * (repmat(BinCenters, 1, (NPeriods/2)) + mmrepeat(0:((NPeriods/2)-1), Param.histnbin));
    X = [-fliplr(X), X];
    Y = repmat(HIST(n).Y, 1, NPeriods);
    RateP(n, :) = interp1(X, Y, Delay, 'cubic');
    HalfNBin = Param.histnbin/2; %Property histnbin is always assigned an even number ...
    Y = [Y(HalfNBin+1:end), Y(1:HalfNBin)];
    RateN(n, :) = interp1(X, Y, Delay, 'cubic');
end
%If logaritmic scale is used for constant frequencies, then weigthed arithmetic average is used
%to assemble the composite curve ... The frequencies itself are used as weight-factor ...
if strcmpi(Param.inc, 'log'),
    SumFreq = sum(Freq);
    CumRate(1, :) = sum(RateP.*repmat(Freq', 1, length(Delay)), 1)/SumFreq;
    CumRate(2, :) = sum(RateN.*repmat(Freq', 1, length(Delay)), 1)/SumFreq;
else, CumRate = [sum(RateP, 1); sum(RateN, 1)]/NFreq; end
DiffRate = -diff(CumRate, 1, 1);

%Taking running average ...
CumRateAv(1, :) = runav(CumRate(1, :), Param.itdrunav);
CumRateAv(2, :) = runav(CumRate(2, :), Param.itdrunav);
DiffRateAv = -diff(CumRateAv, 1, 1);

ITD.Delay    = Delay;
ITD.SupRatep = RateP;
ITD.SupRaten = RateN;
ITD.CumRate  = [CumRate; CumRateAv];
DIFF.Delay   = Delay;
DIFF.Rate    = [DiffRate; DiffRateAv];

%Fast fourier transform on difference composite curve ...
FFT = SpectAna(Delay, DiffRate, 'runavunit', '#', 'runavrange', 0);

%Determine which dominant frequency to be used in the calculation ...
if ~isempty(Thr), DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, FFT.DF, NaN);
else, DomFreq = DetermineCalcDF(Param.calcdf, NaN, FFT.DF, NaN); end
if (DomFreq ~= 0), DomPer = 1000/DomFreq; else, DomPer = NaN; end %Dominant period in ms ...

%Peak ratio on composite curve ...
[ITD.BestItd, ITD.Max] = getmaxloc(Delay, CumRateAv(1, :));
[ITD.Ratio, ITD.Xpeaks, ITD.Ypeaks] = GetPeakRatio(Delay, CumRateAv(1, :), DomFreq);

%Evaluate running average parameters on enveloppe ...
if strcmpi(Param.envrunavunit, 'ms'), 
    RunAvTsup = Param.envrunav;
    RunAvNsup = round(Param.envrunav/Param.itdbinwidth);
    RunAvNeff = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff = RunAvNeff*Param.itdbinwidth;
    Param.envrunav = RunAvNsup;
    RunAvEnvStr = sprintf('%.2fms (%.0f#, %.2fms)', RunAvTsup, RunAvNeff, RunAvTeff);
else,
    FracPer    = Param.envrunav;
    if (FFT.DF ~= 0), RunAvTsup = FracPer*DomPer; else, RunAvTsup = NaN; end
    RunAvNsup  = round(RunAvTsup/Param.itdbinwidth);
    RunAvNeff  = 2*round(RunAvNsup/2)+1; %Effective number of points overwhich RUNAV.M averages (always odd) ...
    RunAvTeff  = RunAvNeff*Param.itdbinwidth;
    Param.envrunav = RunAvNsup;
    RunAvEnvStr = sprintf('%.1f#Per (%.0f#, %.2fms)', FracPer, RunAvNeff, RunAvTeff);
end
CellInfo.ccparamstr = strvcat(CellInfo.ccparamstr, sprintf('RunAv(ENV) = %s', RunAvEnvStr));

%Peak ratio and halfheight width on difference curve ...
YDiffEnv = abs(hilbert(DiffRateAv));
if ~isnan(Param.envrunav), YDiffEnv = runav(YDiffEnv, Param.envrunav); end
DIFF.Env = [YDiffEnv; -YDiffEnv];
DIFF.HH = max(YDiffEnv)/2;
DIFF.HHx = cintersect(Delay, YDiffEnv, DIFF.HH); DIFF.HHW = diff(DIFF.HHx);
[DIFF.BestItd, DIFF.Max] = getmaxloc(Delay, DiffRateAv);
[DIFF.Ratio, DIFF.Xpeaks, DIFF.Ypeaks] = GetPeakRatio(Delay, DiffRateAv, DomFreq);

FFT.Magn = lowerfields(FFT.Magn); FFT = lowerfields(FFT);
ITD = lowerfields(ITD); DIFF = lowerfields(DIFF);

%Reorganizing data ...
CalcData = lowerfields(CollectInStruct(RATE, VS, ITD, DIFF, FFT));
CalcData.ds1 = dsBB;
CalcData.param = Param;

%---------------------------------------------------------------------------------------------
function DF = DetermineCalcDF(ParamCalcDF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCalcDF), 
    if ~isnan(ParamCalcDF), DF = ParamCalcDF;
    elseif ~isnan(ThrCF), DF = ThrCF;
    elseif ~isnan(DifDF), DF = DifDF;
    else, DF = SacDF; end
elseif strcmpi(ParamCalcDF, 'cf'), DF = ThrCF;
elseif strcmpi(ParamCalcDF, 'df'), 
    if ~isnan(DifDF), DF = DifDF;
    else, DF = SacDF; end    
else, DF = NaN; end                

%---------------------------------------------------------------------------------------------
function [DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,sigmX,sigmY,pLinReg_,Mserr_,allX,allY,VSBF]=PlotCurve(Type, CalcData, CellInfo, Param)

FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), CellInfo.cellstr), ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!)...
    'NumberTitle', 'off', ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

if strcmpi(Type, 'cc'), %Superimpose, composite curve and spectrum ...
    %Axis parameters for Delay Curves ...
    [XRange, XStep] = InterpretParam('itdx', Param, CalcData.itd.delay(:));
    
    %Superimpose Curves ...
    AxSIP = axes('Position', [0.10, 0.72, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'XTick', XRange(1):XStep:XRange(2));
    Hdl = line(CalcData.itd.delay, CalcData.itd.supratep, 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 1); 
    title('SuperImpose Curve (+)', 'fontsize', 12);
    xlabel('Delay (ms)'); ylabel('Rate (spk/sec)');
    AxSIN = axes('Position', [0.10, 0.385, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'XTick', XRange(1):XStep:XRange(2));
    Hdl = line(CalcData.itd.delay, CalcData.itd.supraten, 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 1); 
    title('SuperImpose Curve (-)', 'fontsize', 12);
    xlabel('Delay (ms)'); ylabel('Rate (spk/sec)');
    
    %Composite Curve ...
    AxCC = axes('Position', [0.575, 0.72, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'XTick', XRange(1):XStep:XRange(2));
    LnHdl(1) = line(CalcData.itd.delay, CalcData.itd.cumrate(1, :), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'LineWidth', 1, 'tag', 'ccposorig'); 
    LnHdl(2) = line(CalcData.itd.delay, CalcData.itd.cumrate(3, :), 'LineStyle', '-', 'Color', 'b', 'Marker', 'none', 'LineWidth', 2, 'tag', 'ccposrunav'); 
    LnHdl(3) = line(CalcData.itd.delay, CalcData.itd.cumrate(2, :), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'LineWidth', 1, 'tag', 'ccnegorig'); 
    LnHdl(4) = line(CalcData.itd.delay, CalcData.itd.cumrate(4, :), 'LineStyle', '-', 'Color', 'g', 'Marker', 'none', 'LineWidth', 1.5, 'tag', 'ccnegrunav'); 
    LnHdl(5) = line(CalcData.itd.xpeaks, CalcData.itd.ypeaks, 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 7, 'tag', 'peakratioline');
    LnHdl(6) = line([0 0], ylim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'verzeroline');
    LnHdl(7) = line(CalcData.itd.bestitd([1 1]), ylim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'bestitdverline');
    title('Composite Curve', 'fontsize', 12);
    xlabel('Delay (ms)'); ylabel('Rate (spk/sec)');
    text(0, 1, {sprintf('Max = %.0fspk/sec @ %.2fms', CalcData.itd.max, CalcData.itd.bestitd); ...
            sprintf('PeakRatio = %.2f', CalcData.itd.ratio)}, ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    legend(LnHdl([2, 4, 1]), {'Pos', 'Neg', 'Orig'}, 1);
    
    %DiffCorrelation Curve ...
    AxDIFF = axes('Position', [0.575, 0.385, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'XTick', XRange(1):XStep:XRange(2));
    LnHdl(1) = line(CalcData.diff.delay, CalcData.diff.rate(1, :), 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'LineWidth', 1, 'tag', 'difforig'); 
    LnHdl(2) = line(CalcData.diff.delay, CalcData.diff.rate(2, :), 'LineStyle', '-', 'Color', 'b', 'Marker', 'none', 'LineWidth', 2, 'tag', 'diffrunav'); 
    LnHdl([3 4]) = line(CalcData.diff.delay, CalcData.diff.env, 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'LineWidth', 1, 'tag', 'diffenv'); 
    LnHdl(5) = line(CalcData.diff.xpeaks, CalcData.diff.ypeaks, 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2, 'Marker', '.', 'MarkerSize', 7, 'tag', 'peakratioline');
    LnHdl(6) = line([0 0], ylim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'verzeroline');
    LnHdl(7) = line(CalcData.diff.bestitd([1 1]), ylim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'betsitdverline');
    LnHdl([8:10]) = PlotCInterSect(CalcData.diff.hhx, CalcData.diff.hh([1 1]), min(ylim));
    set(LnHdl(8), 'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    title('Diffcor Curve', 'fontsize', 12);
    xlabel('Delay (ms)'); ylabel('DiffRate (spk/sec)');
    text(0, 1, {sprintf('Max = %.0fspk/sec @ %.2fms', CalcData.diff.max, CalcData.diff.bestitd); ...
            sprintf('PeakRatio = %.2f', CalcData.diff.ratio); ...
            sprintf('HHW = %.2f', CalcData.diff.hhw)}, ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    legend(LnHdl([2 1]), {'RunAv', 'Original'}, 1);
    
    %Axis parameters for FFT Curve ...
    if strcmpi(Param.fftyunit, 'p'),
        YVal = CalcData.fft.magn.p;
        YLbl = 'Power';
    else,
        YVal = CalcData.fft.magn.db;
        YLbl = 'Amplitude (dB)';
    end    
    [XRange, XStep] = InterpretParam('fftx', Param, CalcData.fft.freq(:));
    YRange = InterpretParam('ffty', Param, YVal(:));
    
    %FFT on Composite Curve ...
    AxFFT = axes('Position', [0.10, 0.05, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'XTick', XRange(1):XStep:XRange(2), 'YLim', YRange);
    line(CalcData.fft.freq, YVal, 'LineStyle', '-', 'Color', 'b', 'Marker', 'none', 'LineWidth', 1, 'tag', 'curve'); 
    line(CalcData.fft.df([1 1]), ylim, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'verlinedomfreq');
    title('FFT on DifCor', 'fontsize', 12);
    xlabel('Frequency (Hz)'); ylabel(YLbl);
    text(0, 1, {sprintf('DomFreq = %.0fHz', CalcData.fft.df); ...
            sprintf('BandWidth = %.0fHz', CalcData.fft.bw)}, ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    %extract
    DomF=CalcData.fft.df;
    assignin('base','DomF',DomF);
    
    %Additional Information
    AxINFO = axes('Position', [0.575 0.05 0.375 0.235], 'Visible', 'off', 'Box', 'on', 'Color', [0.7 0.7 0.7], ...
        'Units', 'normalized', 'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);
    TxtHdl = text(0.10, 0.5, char(CellInfo.cellstr, '', CellInfo.ccparamstr, '', CellInfo.stimstr, '', CellInfo.thrstr), ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontSize', 8, 'FontWeight', 'normal');
else, %Rate, raster and vector strength curves ...
    %Axis parameters for Frequency curves ...
    XRange = InterpretParam('freqx', Param, Param.indepval);
    
    %Raster plot ...
    AxRAS = axes('Position', [0.10, 0.72, 0.85, 0.235],  'TickDir', 'out', 'Box', 'off');
    RasHdl = RasPlot(CalcData.ds1, Param.isubseqs, AxRAS);
    set(RasHdl, 'Color', 'k');
    %Restricting maximum number of ticks on Y axis ...
    YTick = get(AxRAS, 'YTick'); NYTicks = length(YTick); YLbls = get(AxRAS, 'YTickLabel');
    if (NYTicks > Param.rasmaxytick),
        Step = diff(YTick([1, 2])); ReqStep = diff(YTick([1, end]))/Param.rasmaxytick;
        N = ceil(ReqStep/Step); NewStep = Step*N;
        NewYTick = YTick(1) + NewStep*(0:Param.rasmaxytick-1);
        NewYTick = NewYTick(find(NewYTick <= YTick(end)));
        NewYLbls = YLbls(find(ismember(YTick, NewYTick)));
        set(AxRAS, 'YTick', NewYTick, 'YTickLabel', NewYLbls);
    end
    
    %Rate Curve ...
    AxRATE = axes('Position', [0.575, 0.385, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange);
    Hdl(1) = line(CalcData.rate.freq, CalcData.rate.rate, 'Color', 'b', 'LineStyle', '-', 'Marker', '.', 'LineWidth', 1, 'tag', 'curve'); 
    Hdl(2) = line(CalcData.rate.bf([1 1]), ylim, 'Color', 'k', 'LineStyle', ':', 'Marker', 'none', 'LineWidth', 1, 'tag', 'verlinebestfreq'); 
    Hdl(3) = line(CalcData.rate.bf, CalcData.rate.max, 'Color', 'r', 'LineStyle', 'none', 'Marker', '.', 'LineWidth', 7, 'tag', 'markerbestfreq'); 
    title('Rate Curve', 'fontsize', 12);
    xlabel('Freq (Hz)'); ylabel('Rate (spk/sec)');
    text(0, 1, sprintf('Max = %.0fspk/sec @ %.0fHz', CalcData.rate.max, CalcData.rate.bf), ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    %extract
    RateBF=CalcData.rate.bf;
    assignin('base','RateBF',RateBF);
    
    %Vector strength magnitude plot ...
    AxVSM = axes('Position', [0.10, 0.385, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'YLim', [0 1]);
    %extract
    [Hdl,sigmX,sigmY] = PlotSign(CalcData.vs.freq, CalcData.vs.r, CalcData.vs.raysig, Param.vsraysig);
    assignin('base','sigmX',sigmX);assignin('base','sigmY',sigmY);
    VSBF=CalcData.vs.bf;
    assignin('base','VSBF',VSBF);
    
    Hdl(2) = line(CalcData.vs.bf([1 1]), ylim, 'Color', 'k', 'LineStyle', ':', 'Marker', 'none', 'LineWidth', 1, 'tag', 'verlinebestfreq'); 
    Hdl(3) = line(CalcData.vs.bf, CalcData.vs.maxr, 'Color', 'r', 'LineStyle', 'none', 'Marker', 'o', 'tag', 'markerbestfreq'); 
    title('Vector Strength Magnitude', 'fontsize', 12);
    xlabel('Freq (Hz)'); ylabel('R');
    text(0, 1, {sprintf('Max = %.2f @ %.0fHz', CalcData.vs.maxr, CalcData.vs.bf), ...
            sprintf('BinFreq = %s (Beat)', Param2Str(Param.beat, 'Hz', 0))}, ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

    %Vector strength phase plot ...
    AxVSP = axes('Position', [0.10, 0.05, 0.375, 0.235],  'TickDir', 'out', 'Box', 'off', ...
        'XLim', XRange, 'YLim', [floor(min(CalcData.vs.ph)), ceil(max(CalcData.vs.ph))]);
    %extract
    [Hdl(1),sigpX,sigpY] = PlotSign(CalcData.vs.freq, CalcData.vs.ph, CalcData.vs.raysig, Param.vsraysig);
    assignin('base','sigpX',sigpX);assignin('base','sigpY',sigpY);
    %extract
    Hdl(2) = line(xlim, xlim*CalcData.vs.cd/1000+CalcData.vs.cp, 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'tag', 'linelinreg');
    lineX=xlim;lineY=xlim*CalcData.vs.cd/1000+CalcData.vs.cp;
    assignin('base','lineX',lineX);assignin('base','lineY',lineY);
    
    title('Vector Strength Phase', 'fontsize', 12);
    xlabel('Freq (Hz)'); ylabel('Phase (cyc)');
    text(0, 1, {sprintf('CD = %.2fms', CalcData.vs.cd),...
            sprintf('CP = %.2fcyc', CalcData.vs.cp),...
            sprintf('pLinReg = %.3f', CalcData.vs.plinreg),...
            sprintf('MSerr = %.3f', CalcData.vs.mserr),...
            sprintf('BinFreq = %s (Beat)', Param2Str(Param.beat, 'Hz', 0))}, ...
        'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
    %extract
    CD=CalcData.vs.cd;CP=CalcData.vs.cp;
    assignin('base','CD',CD);assignin('base','CP',CP);
    %extract
    pLinReg_=CalcData.vs.plinreg;Mserr_=CalcData.vs.mserr;
    assignin('base','pLinReg_',pLinReg_);assignin('base','Mserr_',Mserr_);
    allX=CalcData.vs.freq;allY=CalcData.vs.ph;
    assignin('base','allX',allX);assignin('base','allY',allY);
    
    %Additional Information
    AxINFO = axes('Position', [0.575 0.05 0.375 0.235], 'Visible', 'off', 'Box', 'on', 'Color', [0.7 0.7 0.7], ...
        'Units', 'normalized', 'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);
    TxtHdl = text(0.10, 0.5, char(CellInfo.cellstr, '', CellInfo.vsparamstr, '', CellInfo.stimstr, '', CellInfo.thrstr), ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontSize', 8, 'FontWeight', 'normal');
    %addition Shotaro
    DomF=CalcData.fft.df;
    assignin('base','DomF',DomF);
end

%---------------------------------------------------------------------------------------------
function [Range, Step] = InterpretParam(Type, Param, Data)

XMargin = 0.0;
YMargin = 0.5;

switch Type,
case 'freqx',
    Margin = XMargin;
    Range = Param.freqxrange;
    Step  = [];
case 'itdx',
    Margin = XMargin;
    Range = Param.itdxrange;
    Step  = Param.itdxstep;
case 'fftx',
    Margin = XMargin;
    Range = Param.fftxrange;
    Step  = Param.fftxstep;
case 'ffty',
    Margin = YMargin;
    Range = Param.fftyrange;
    Step  = [];
end

if isinf(Range(1)), Range(1) = min(Data)*(1-Margin); end
if isinf(Range(2)), Range(2) = max(Data)*(1+Margin); end

if isequal(Range(1), Range(2)), Range = [Range(1)-0.5, Range(1)+0.5]; end
%---------------------------------------------------------------------------------------------
function [LnHdl,sigX,sigY] = PlotSign(X, Y, Sign, Thr)
%extract significant data
idxNS = find(Sign > Thr);

idxS=find(Sign <= Thr);
sigX=X(idxS);sigY=Y(idxS);

LnHdl = line(X, Y, 'LineStyle', '-', 'Color', 'b', 'Marker', 'o', 'tag', 'curve');
MrkSize = get(LnHdl, 'MarkerSize') * 3.5;
DotHdl = line(X(idxNS), Y(idxNS), 'LineStyle', 'none', 'Color', 'b', 'Marker', '.', 'MarkerSize', MrkSize, 'tag', 'insigndots');

%---------------------------------------------------------------------------------------------