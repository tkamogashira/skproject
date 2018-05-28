function D = EvalPST(varargin)
%EVALPST    evaluates PST histograms
%   EVALPST(DS) evaluate PST histograms for all subsequences.
%   D = EVALPST(DS, SubSeqNrs) evaluate PST histograms only for the specified subsequence
%   numbers. If an output argument is supplied, then the calculated data is returned as a
%   an array of structures. Each structure element contains the data for a single subsequence.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'factory' as only input argument.

% B. Van de Sande 01-08-2005

%After GRAEME K. YATES, DONALD ROBERTSON and BRIAN M. JOHNSTONE, "Very Rapid Adaptation in the Guinea Pig
%Auditory Nerve", HEARING RESEARCH, 17 (1985)
%and LARRY A. WESTERMAN and ROBERT L. SMITH, "Rapid and Short-Term Adaptation in Auditory Nerve Responses",
%HEARING RESEARCH, 15 (1984)

%-------------------------template for scatterplots---------------------------
Template.ds1.filename = ''; 
Template.ds1.seqid    = '';
Template.ds1.icell    = NaN;
Template.ds1.iseq     = NaN;  
Template.subseq       = NaN;
Template.tag          = 0;         %General purpose tag field
Template.createdby    = mfilename; %Name of MATLAB function that generated the data
Template.spl          = NaN;       %Sound pressure level in dB ...
Template.stimdur      = NaN;       %Stimulus duration in ms ...
Template.modfreq      = NaN;       %Modulation frequency in Hz ...
Template.bc           = NaN;       %Bincenters in ms ...
Template.n            = NaN;       %Number of spikes per bin ...
Template.rate         = NaN;       %Rate per bin ...
Template.pst.pkrate   = NaN;       %Peak rate in spk/s ...
Template.pst.ssrate   = NaN;       %Steady state rate in spk/s ... 
Template.pst.p2ssr    = NaN;       %Peak to steady state rate ratio ...
Template.fit.ass      = NaN;       %Steady state respons in spk/s ...
Template.fit.ar       = NaN;       %Respons for rapid adaptation in spk/s ...
Template.fit.ast      = NaN;       %Respons for short term adaptation in spk/s ...
Template.fit.tr       = NaN;       %Decay time for rapid adaptation in ms ...
Template.fit.acf      = NaN;       %Fraction of variance accounted for ...
Template.fit.coc      = NaN;       %Correlation coefficient ...
Template.thr.cf       = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr       = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr      = NaN;       %Threshold at characteristic frequency
Template.thr.q10      = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw       = NaN;       %Width 10dB above threshold (Hz)

%-----------------------------default parameters------------------------------
%Calculation parameters 
DefParam.onset        = 'auto';    %'auto' or value in ms ...
DefParam.rangeunit    = '%';       %'%'(of interval duration) or 'ms' ...
DefParam.onsetrng     = 0.10;      %onset range ...
DefParam.onsetbw      = 0.05;      %onset binwidth ...
DefParam.runavunit    = 'ms';      %'#' or 'ms' ...
DefParam.onsetav      = 1;         %running average range on onset ...
DefParam.offset       = 'stimdur'; %'stimdur' or value in ms ...
DefParam.anwin        = [0 -1];    %in ms (-1 designates repetition duration) ...
DefParam.nbinunit     = 'ms';      %'#' or 'ms' ...
DefParam.nbin         = 1;
DefParam.ssronset     = 'max([0, ($burstdur$-10)])';%Onset for calculation of steady state rate.
                                   %Can be value or aritmetic expression using
                                   %the fields burstdur and repdur ...
DefParam.ssroffset    = 'burstdur';%Offset for calculation of steady state rate.
                                   %Can be value or aritmetic expression using
                                   %the fields burstdur and repdur ...
DefParam.fitnbinunit  = '#';       %'#' or 'ms' ...
DefParam.fitnbin      = 64;
%Plot parameters 
DefParam.plot         = 'yes';  %'yes' or 'no' ...
DefParam.pstxrange    = [-Inf +Inf];
DefParam.pstyunit     = 'rate'; %'rate' or 'count' ...
DefParam.pstyrange    = [-Inf +Inf];

%--------------------------------main program---------------------------------
%Parsing input arguments ...
[ds, SubSeqs, CellInfo, Param] = ParseArgs(DefParam, varargin{:});
if isempty(ds), return; end

%Calculation of actual PST histograms and fitting of exponential curve ...
NSubSeqs = length(SubSeqs);
CalcData = PerformAna(ds, SubSeqs, Param);

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(ds); if isempty(UD), error('To catch block ...'); end
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(CellInfo.datafile, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        [CalcData.thr] = deal(lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10)));
        CellInfo.thrstr = sprintf('CF = %s / SR = %s', Param2Str(CF, 'Hz', 0), Param2Str(SR, 'spk/sec', 1));
    else, [CalcData.thr] = deal(struct([])); CellInfo.thrstr = sprintf('THR data not present'); end    
catch, 
    warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); 
    [CalcData.thr] = deal(struct([])); CellInfo.thrstr = sprintf('THR data not present');
end

%Plotting of histograms if requested ...
if strncmpi(Param.plot, 'y', 1), for n = 1:NSubSeqs, PlotCurve(CalcData(n), CellInfo, Param); end; end

%Return calculated data ... 
if (nargout > 0), 
    for n = 1:NSubSeqs, D(n) = structtemplate(CalcData(n), Template, 'reduction', 'off'); end; 
    D = D(:);
end

%---------------------------------local functions-----------------------------
function [ds, SubSeqs, CellInfo, Param] = ParseArgs(DefParam, varargin)

[ds, SubSeqs, CellInfo, Param] = deal([]);

%Checking input parameters ...
Nargs = length(varargin);
if (Nargs  == 0), error('Wrong number of input arguments.');
elseif (Nargs == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Factory defaults are:');
    disp(DefParam);
    return;
end

if ~isa(varargin{1}, 'dataset'), error('First argument should be dataset.'); 
else, ds = varargin{1}; end

Nrec = ds.nrec;
if (Nargs >= 2) & isnumeric(varargin{2}),
    SubSeqs = varargin{2}; if ~all(ismember(SubSeqs, 1:Nrec)), error('Some subsequences don''t exist.'); end
    Pidx = 3;
else,
    SubSeqs = 1:Nrec;
    Pidx = 2;
end    

%Evaluate optional list of property/values ...
Param = checkproplist(DefParam, varargin{Pidx:end});
Param = CheckParam(ds, Param);

%Assembling stimulus parameters ...
StimParam = GetStimParam(ds);
if isempty(findstr(lower(StimParam.indepunit), 'spl')), warning('Independent variable isn''t SPL.'); end

%Setting shortcuts in calculation parameters ...
if (Param.anwin(2) == -1), Param.anwin(2) = max(StimParam.repdur); end
if strcmpi(Param.offset, 'stimdur'), Param.offset = min(StimParam.burstdur); end

%Assembling cell information ...
CellInfo.datafile = upper(ds.FileName);
CellInfo.seqnr    = ds.iSeq;
CellInfo.dsid     = ds.SeqID;
CellInfo.cellstr  = sprintf('%s <%s>', CellInfo.datafile, CellInfo.dsid);

%Constructing information string on calculation parameters ...
if strcmpi(Param.onset, 'auto'),
    if strcmpi(Param.rangeunit, '%'), s = sprintf('Onset Range = %s', Param2Str(Param.onsetrng, '%', 2));
    else, s = sprintf('Onset Range = %s', Param2Str(Param.onsetrng, 'ms', 2)); end    
    s = strvcat(s, sprintf('Onset BinWidth = %s', Param2Str(Param.onsetbw, 'ms', 2)));
    if strcmpi(Param.runavunit, '#'), s = strvcat(s, sprintf('Onset RunAv = %s', Param2Str(Param.onsetav, '#', 0)));
    else, s = strvcat(s, sprintf('Onset Range = %s', Param2Str(Param.onsetav, 'ms', 2))); end
else, s = sprintf('Onset = %s', Param2Str(Param.onset, 'ms', 2)); end
s = strvcat(s, sprintf('OffSet = %s', Param2Str(Param.offset, 'ms', 2)));
s = strvcat(s, sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0)));
if strcmpi(Param.nbinunit, '#'), s = strvcat(s, sprintf('NBin (Overview) = %s', Param2Str(Param.nbin, '#', 0)));
else, s = strvcat(s, sprintf('NBin (Overview & Pk2Ss) = %s', Param2Str(Param.nbin, 'ms', 2))); end
if strcmpi(Param.fitnbinunit, '#'), s = strvcat(s, sprintf('NBin (Fit) = %s', Param2Str(Param.fitnbin, '#', 0)));
else, s = strvcat(s, sprintf('NBin (Fit) = %s', Param2Str(Param.fitnbin, 'ms', 2))); end
s = strvcat(s, sprintf('SsrOnset = %s', Param2Str(Param.ssronset, 'ms', 1)));
s = strvcat(s, sprintf('SsrOffset = %s', Param2Str(Param.ssroffset, 'ms', 1)));
CellInfo.paramstr = s;

%Constructing information string on stimulus parameters ...
s = sprintf('NChan = %s', Param2Str(StimParam.nchan, '#', 0));
s = strvcat(s, sprintf('BurstDur = %s', Param2Str(StimParam.burstdur, 'ms', 0)));
s = strvcat(s, sprintf('RepDur = %s', Param2Str(StimParam.repdur, 'ms', 0)));
if ~isnan(StimParam.beatcarfreq),
    s = strvcat(s, sprintf('CarFreq = %s', Param2Str(StimParam.carfreq, 'Hz', 0)));
    s = strvcat(s, sprintf('CarBeat = %s', Param2Str(StimParam.beatcarfreq, 'Hz', 0)));
else,
    s = strvcat(s, sprintf('CarFreq = %s', Param2Str(StimParam.carfreq, 'Hz', 0)));
    s = strvcat(s, sprintf('ModFreq = %s', Param2Str(StimParam.modfreq, 'Hz', 0)));
    s = strvcat(s, sprintf('ModBeat = %s', Param2Str(StimParam.beatmodfreq, 'Hz', 0)));
end
s = strvcat(s, sprintf('IndepVal = %s', IndepVal2Str(StimParam.indepval, StimParam.indepunit)));
CellInfo.stimstr = s;

%Reorganize parameters ...
Param = structcat(StimParam, Param);

%-----------------------------------------------------------------------------
function Param = CheckParam(ds, Param)

if ~(ischar(Param.onset) & strcmpi(Param.onset, 'auto')) & ...
   ~(isnumeric(Param.onset) & (length(Param.onset) == 1) & (Param.onset > 0)), 
    error('Invalid value for property onset.'); 
end
if ~isvalidtoggle(Param.rangeunit, {'%', 'ms'}), error('Property rangeunit should be ''%'' or ''ms''.'); end
if ~(strcmpi(Param.rangeunit, '%') & isnumeric(Param.onsetrng) & (length(Param.onsetrng) == 1) & (Param.onsetrng > 0) & (Param.onsetrng <= 1)) & ...
   ~(strcmpi(Param.rangeunit, 'ms') & isnumeric(Param.onsetrng) & (length(Param.onsetrng) == 1) & (Param.onsetrng > 0)),
    error('Invalid value for property onsetrng.');
end
if ~isvalidnbin(Param.onsetbw, 'ms'), error('Invalid value for property onsetbw.'); end
if ~isvalidtoggle(Param.runavunit, {'#', 'ms'}), error('Property runavunit should be ''#'' or ''ms''.'); end
if ~(strcmpi(Param.runavunit, '#') & isnumeric(Param.onsetav) & (length(Param.onsetav) == 1) & (Param.onsetav > 0) & (mod(Param.onsetav, 1) == 0)) & ...
   ~(strcmpi(Param.runavunit, 'ms') & isnumeric(Param.onsetav) & (length(Param.onsetav) == 1) & (Param.onsetav > 0)),
    error('Invalid value for property onsetav.');
end
if ~(ischar(Param.offset) & strcmpi(Param.offset, 'stimdur')) & ...
   ~(isnumeric(Param.offset) & (length(Param.offset) == 1) & (Param.offset > 0)), 
    error('Invalid value for property offset.'); 
end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]), error('Invalid value for property anwin.'); end
if ~isvalidtoggle(Param.nbinunit, {'#', 'ms'}), error('Property nbinuint must be ''#'' or ''ms''.'); end
if ~isvalidnbin(Param.nbin, Param.nbinunit), error('Invalid value for property nbin.'); end
if ~isvalidtoggle(Param.fitnbinunit, {'#', 'ms'}), error('Property fitnbinuint must be ''#'' or ''ms''.'); end
if ~isvalidnbin(Param.fitnbin, Param.fitnbinunit), error('Invalid value for property fitnbin.'); end

if ~isvalidtoggle(Param.plot, {'yes', 'no'}), error('Property plot must be ''yes'' or ''no''.'); end
if ~isinrange(Param.pstxrange, [-Inf +Inf]), error('Invalid value for property pstxrange.'); end
if ~isvalidtoggle(Param.pstyunit, {'rate', 'count'}), error('Property pstyunit must be ''count'' or ''rate''.'); end
if ~isinrange(Param.pstyrange, [-Inf +Inf]), error('Invalid value for property pstyrange.'); end

try,
    if ischar(Param.ssronset),
        Param.ssronset = EvalExpr(parseExpr(Param.ssronset, {'burstdur', 'repdur'}), {ds.burstdur, ds.repdur});
    elseif isnumeric(Param.ssronset) & (length(Param.ssronset) == 1) & (Param.ssronset >= 0),
    else, error('To catch block ...'); end
catch, error('Invalid value for property ''ssronset''.'); end
try,
    if ischar(Param.ssroffset),
        Param.ssroffset = EvalExpr(ParseExpr(Param.ssroffset, {'burstdur', 'repdur'}), {ds.burstdur, ds.repdur});
    elseif isnumeric(Param.ssroffset) & (length(Param.ssroffset) == 1) & (Param.ssroffset >= 0),
    else, error('To catch block ...'); end
catch, error('Invalid value for property ''ssroffset''.'); end

%-----------------------------------------------------------------------------
function boolean = isvalidtoggle(Val, Toggle)

boolean = ischar(Val) & any(strcmpi(Val, Toggle));

%-----------------------------------------------------------------------------
function boolean = isvalidnbin(NBin, Unit)

boolean = (strcmpi(Unit, '#') & isnumeric(NBin) & (length(NBin) == 1) & (NBin > 0) & (mod(NBin, 1) == 0)) | ...
   (strcmpi(Unit, 'ms') & isnumeric(NBin) & (length(NBin) == 1) & (NBin > 0));

%-----------------------------------------------------------------------------
function StimParam = GetStimParam(ds)

StimParam = struct('repdur', [], 'burstdur', [], 'carfreq', [], 'modfreq', [], ...
    'beatcarfreq', [], 'beatmodfreq', [], 'nchan', [], 'indepunit', [], 'indepval', []);
Nrec = ds.nrec;

StimParam.repdur   = ds.Special.RepDur(1); %Repetition duration is always equal for both channels ...
StimParam.burstdur = ds.Special.BurstDur([1, min(2, end)]); %Always two-element columnvector ...
StimParam.carfreq  = ds.Special.CarFreq(1:min(Nrec, end), :);
if all(ds.Special.ModFreq == 0) | all(isnan(ds.Special.ModFreq)), StimParam.modfreq = NaN;
else, StimParam.modfreq = ds.Special.ModFreq(1:min(Nrec, end), :); end
if all(ds.Special.BeatFreq == 0) | all(isnan(ds.Special.BeatFreq)), StimParam.beatcarfreq = NaN;
else, StimParam.beatcarfreq = ds.Special.BeatFreq(1:min(Nrec, end), :); end
if all(ds.Special.BeatModFreq == 0) | all(isnan(ds.Special.BeatModFreq)), StimParam.beatmodfreq = NaN;
else, StimParam.beatmodfreq = ds.Special.BeatModFreq(1:min(Nrec, end), :); end
StimParam.nchan     = 2 - sign(ds.activechan);
StimParam.indepunit = ds.indepunit;
StimParam.indepval  = ds.indepval(1:Nrec);

%-----------------------------------------------------------------------------
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

%-------------------------------------------------------------------------------
function Str = IndepVal2Str(IndepVal, Unit)

Tol = 1e-3; %Numerical tolerance ...

IndepVal = sort(IndepVal);
DiffVal  = unique(roundoff(diff(IndepVal), Tol));
if (length(IndepVal) == 1), StepMode = '';
elseif (length(DiffVal) == 1), Step = DiffVal; StepMode = 'LIN'; %Linear ...
else, Step = log2(IndepVal(2)/IndepVal(1)); StepMode = 'LOG'; end %Logaritmic ...

if strcmp(StepMode, 'LIN'), Str = sprintf('[%.0f..%.0f@%s] (%s)', min(IndepVal), max(IndepVal), Val2Str(Step), Unit);
elseif strcmp(StepMode, 'LOG'), Str = sprintf('[%.0f..%.0f@%s(Oct)] (%s)', min(IndepVal), max(IndepVal), Val2Str(Step), Unit); 
else, Str = sprintf('%.0f(%s)', IndepVal, Unit); end

%-------------------------------------------------------------------------------
function V = roundoff(V, Tol)

V = round(V/Tol)*Tol;

%-------------------------------------------------------------------------------
function Str = Val2Str(Val)

if mod(Val, 1), Str = sprintf('%.2f', Val);
else, Str = sprintf('%.0f', Val); end

%-----------------------------------------------------------------------------
function CalcData = PerformAna(ds, SubSeqs, Param)

NSubSeqs = length(SubSeqs);
for n = 1:NSubSeqs,
    %Calculate PST histogram as overview ...
    if strcmpi(Param.nbinunit, 'ms'), NBin = round(diff(Param.anwin)/Param.nbin); 
    else, NBin = Param.nbin; end
    PSTovw = CalcPST(ds, SubSeqs(n), Param.anwin, NBin);
    
    %PST histogram used for adaptation curve fitting ...
    OnSet = GetOnSet(ds, SubSeqs(n), Param); OffSet = Param.offset; WinDur = OffSet-OnSet;
    if strcmpi(Param.fitnbinunit, 'ms'), NBin = round(WinDur/Param.fitnbin); 
    else, NBin = Param.fitnbin; end
    PSTfit = CalcPST(ds, SubSeqs(n), [OnSet, OffSet], NBin);
    
    %Unconstrained minimization of the sum of squares function ...
    Cstart = [200 200 0 5];
    warning off;
    fun = @(x) SSq(x, PSTfit.BC, PSTfit.Rate);
    options = optimset('display', 'off', 'largescale', 'off');
    C = fminunc(fun, Cstart, options);
    warning on;
    AcF = CalcAccFrac(C, PSTfit.BC, PSTfit.Rate);
    CoC = corrcoef(AdaptationFunc(C, PSTfit.BC), PSTfit.Rate); CoC = CoC(1, 2);
    
    %Reorganizing calculated data ...
    CalcData(n).ds1       = emptyDataSet(ds); %Dataset structure ...
    CalcData(n).subseq    = SubSeqs(n);       %Subsequence number ...
    if ~isempty(findstr(lower(Param.indepunit), 'spl'))
        CalcData(n).spl = Param.indepval(SubSeqs(n)); %Sound pressure level in dB ...
    else
        CalcData(n).spl = NaN;
    end
    CalcData(n).stimdur   = min(Param.burstdur); %Stimulus duration in ms ...
    CalcData(n).bc        = PSTovw.BC;        %Bincenters in ms ...
    CalcData(n).n         = PSTovw.N;         %Number of spikes per bin ...
    CalcData(n).rate      = PSTovw.Rate;      %Rate per bin ...
    CalcData(n).fit.onset = OnSet;            %Onset of curve fitting in ms ...
    CalcData(n).fit.offset= OffSet;           %Offset of curve fitting in ms ...
    CalcData(n).fit.bc    = PSTfit.BC;        %Bincenters in ms ...
    CalcData(n).fit.n     = PSTfit.N;         %Number of spikes per bin ...
    CalcData(n).fit.rate  = PSTfit.Rate;      %Rate per bin ...
    CalcData(n).fit.yn    = AdaptationFunc(C, PSTfit.BC)*WinDur*ds.nrep/1e3/NBin;
    CalcData(n).fit.yrate = AdaptationFunc(C, PSTfit.BC);
    CalcData(n).fit.ass   = C(1);             %Steady state respons in spk/s ...
    CalcData(n).fit.ar    = C(2);             %Respons for rapid adaptation in spk/s ...
    CalcData(n).fit.ast   = C(3);             %Respons for short term adaptation in spk/s ...
    CalcData(n).fit.tr    = C(4);             %Decay time for rapid adaptation in ms ...
    CalcData(n).fit.acf   = AcF;              %Fraction of variance accounted for ...
    CalcData(n).fit.coc   = CoC;              %Correlation coefficient ...
    
    %Calculation of peak to steady state ratio ...
    CalcData(n).pst.pkrate = max(PSTovw.Rate);
    CalcData(n).pst.ssrate = getrate(ds, n, Param.ssronset, Param.ssroffset);
    CalcData(n).pst.p2ssr  = CalcData(n).pst.pkrate/CalcData(n).pst.ssrate;

    %Constructing information string ...
    s = sprintf('Ass = %s', Param2Str(CalcData(n).fit.ass, 'spk/s', 2));
    s = strvcat(s, sprintf('Ar = %s', Param2Str(CalcData(n).fit.ar, 'spk/s', 2)));
    s = strvcat(s, sprintf('Ast = %s', Param2Str(CalcData(n).fit.ast, 'spk/s', 2)));
    s = strvcat(s, sprintf('Tr = %s', Param2Str(CalcData(n).fit.tr, 'ms', 2)));
    s = strvcat(s, sprintf('AccF = %s', Param2Str(CalcData(n).fit.acf, '', 2)));
    s = strvcat(s, sprintf('CoC = %s', Param2Str(CalcData(n).fit.coc, '', 2)));
    s = strvcat(s, sprintf('PkRate = %s', Param2Str(CalcData(n).pst.pkrate, 'spk/s', 1)));
    s = strvcat(s, sprintf('SsRate = %s', Param2Str(CalcData(n).pst.ssrate, 'spk/s', 1)));
    s = strvcat(s, sprintf('Pk2SsRatio = %s', Param2Str(CalcData(n).pst.p2ssr, '', 3)));
    CalcData(n).calcstr = s;
end

%-----------------------------------------------------------------------------
function PST = CalcPST(ds, SubSeq, AnWin, NBin)

Nrep = ds.nrep;
SpkTimes = anwin(ds.spt(SubSeq, :), AnWin);
SpkTimes = cat(2, SpkTimes{:});
if isempty(SpkTimes), SpkTimes = Inf; end

BinWidth = diff(AnWin)/NBin;
Edges = AnWin(1):BinWidth:AnWin(2);
N     = histc(SpkTimes, Edges); N(end) = [];
BC    = (AnWin(1)+BinWidth/2):BinWidth:(AnWin(2)-BinWidth/2);
Rate  = N*1e3/BinWidth/Nrep;
    
PST = CollectInStruct(BC, N, Rate);

%-----------------------------------------------------------------------------
function OnSet = GetOnSet(ds, SubSeq, Param)

if strcmpi(Param.onset, 'auto'),
    if strncmpi(Param.rangeunit, '%', 1), Rng = Param.onsetrng*max(Param.repdur); 
    else, Rng = Param.onsetrng; end
    NBin = Rng/Param.onsetbw; %No rounding ...
    if strncmpi(Param.runavunit, 'ms', 1), RunAvN = round(Rng/Param.onsetav); 
    else, RunAvN = Param.onsetav; end
    AnWin = [Param.anwin(1) Param.anwin(1)+Rng];
    PST = CalcPST(ds, SubSeq, AnWin, NBin);
    OnSet = GetMaxLoc(PST.BC, runav(PST.N, RunAvN));
else, OnSet = Param.onset; end

%-----------------------------------------------------------------------------
function A = AdaptationFunc(C, t)
%Adaptation function: an exponential rapid adaptation combined with a linear
%short term adaptation ...
%Input      : time (ms)
%Output     : respons (spk/s)
%Parameters :
Ass = C(1); %Steady state respons in spk/s
Ar  = C(2); %Respons for rapid adaptation in spk/s
Ast = C(3); %Respons for short term adaptation in spk/s
Tr  = C(4); %Decay time for rapid adaptation in ms

A = Ar*exp(-t/Tr) - Ast*t + Ass;

%-----------------------------------------------------------------------------
function Y = SSq(X, XData, YData)
%Sum of square function for the adaptation function ...
Y = sum((YData-AdaptationFunc(X, XData)).^2);

%-----------------------------------------------------------------------------
function Fr = CalcAccFrac(C, XData, YData)
%Calculate fraction of variance accounted for ...
Res = SSq(C, XData, YData);
Var = sum((YData-mean(YData)).^2);

Fr = 1-(Res/Var);

%-----------------------------------------------------------------------------
function PlotCurve(Data, CellInfo, Param)

FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), CellInfo.cellstr), ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!)...
    'NumberTitle', 'off', ...
    'PaperType', 'A4', ...
    'PaperOrientation', 'landscape', ...
    'PaperPositionMode', 'auto');

AxHdl = axes('Position', [0.05 0.05 0.70 0.90], 'NextPlot', 'add');
if strcmpi(Param.pstyunit, 'rate'), Hdl = bar(Data.bc, Data.rate, 1); 
else, Hdl = bar(Data.bc, Data.n, 1); end
set(Hdl, 'EdgeColor', [0.5 0.5 0.5], 'FaceColor', [0.5 0.5 0.5]);

if strcmpi(Param.pstyunit, 'rate'), Hdl = bar(Data.fit.bc, Data.fit.rate, 1); 
else, Hdl = bar(Data.fit.bc, Data.fit.n, 1); end
set(Hdl, 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.3 0.3 0.3]);

IndepStr = sprintf('%.0f %s', Param.indepval(Data.subseq), Param.indepunit);
title(sprintf('PST histogram (%s)', IndepStr), 'fontsize', 12); 
xlabel('Time (ms)');
if strcmpi(Param.pstyunit, 'rate'), ylabel('Rate (spk/s)'); else, ylabel('#Spikes'); end
AxLim = GetLimits(Data, Param); axis(AxLim);

if strcmpi(Param.pstyunit, 'rate'), line(Data.fit.bc, Data.fit.yrate, 'LineStyle', '--', 'Color', 'k');
else, line(Data.fit.bc, Data.fit.yn, 'LineStyle', '--', 'Color', 'k'); end
line(Data.fit.onset([1 1]), ylim, 'LineStyle', '--', 'Color', 'k');
line(Data.fit.offset([1 1]), ylim, 'LineStyle', '--', 'Color', 'k');

C = cleanstr(cellstr(char(['\fontsize{11}' CellInfo.cellstr '\fontsize{9}'], sprintf('\\fontsize{11}SubSeq %d\\fontsize{9}', Data.subseq), ['\fontsize{11}' IndepStr '\fontsize{9}'], '', '\fontsize{11}StimParam\fontsize{9}', CellInfo.stimstr, '', '\fontsize{11}CalcParam\fontsize{9}', CellInfo.paramstr, '', '\fontsize{11}CalcData\fontsize{9}', Data.calcstr)));
PrintInfo([0.80 0.05 0.15 0.90], C);

%-----------------------------------------------------------------------------
function Lim = GetLimits(Data, Param)

if isinf(Param.pstxrange(1)), Lim(1) = Param.anwin(1); 
else, Lim(1) = Param.pstxrange(1); end
if isinf(Param.pstxrange(2)), Lim(2) = Param.anwin(2); 
else, Lim(2) = Param.pstxrange(2); end
if isinf(Param.pstyrange(1)), Lim(3) = 0; 
else, Lim(3) = Param.pstyrange(1); end
if isinf(Param.pstyrange(2)) & strcmpi(Param.pstyunit, 'rate'), Lim(4) = max([Data.rate(:); Data.fit.rate(:); Data.fit.yrate(:)]); 
elseif isinf(Param.pstyrange(2)), Lim(4) = max([Data.n(:); Data.fit.n(:); Data.fit.yn(:)]); 
else, Lim(4) = Param.pstyrange(2); end

%-----------------------------------------------------------------------------