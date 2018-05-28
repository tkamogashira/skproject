function CompareSCCXCC(varargin)
%COMPARESCCXCC  compare crosscorrelograms.
%   COMPARESCCXCC(T, FileName, iSeqP or SeqIDP, iSubSeqP, iSeqN or iSubSeqN, 
%   iSubSeqN, Fbound)
%   COMPARESCCXCC(T, RowNr, Fbound)
%   
%   E.g.:
%       D = LoadSCCXCCTable('a0241', '($thr1.cf$ < $thr2.cf$) & (log2($thr2.cf$./$thr1.cf$) < 1/3)');
%       CompareSCCXCC(D, 'a0241', 23, 1, 23, 2, 250);
%       CompareSCCXCC(D, 'a0241', 23, 1, 23, 2, 250, 'leftyunit', 'dist', 'normcoratio', 0.01);
%       CompareSCCXCC(D, 'a0241', 23, 1, 23, 2, 250, 'leftyunit', 'oct', 'normcoratio', 0.01);
% 
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 08-07-2005

%Attention! To restrict the number of crosscorrelograms in other ways then 
%by distance in tuning frequency, use STRUCTFILTER on the supplied table ...

%-------------------------------default parameters---------------------------
%Table parameters ...
DefParam.filenamefield = 'ds1p.filename';
DefParam.iseqpfield    = 'ds1p.iseq';
DefParam.seqidpfield   = 'ds1p.seqid';
DefParam.isubseqpfield = 'ds1p.isubseq';
DefParam.iseqnfield    = 'ds1n.iseq';
DefParam.seqidnfield   = 'ds1n.seqid';
DefParam.isubseqnfield = 'ds1n.isubseq';
DefParam.freqfield     = {'dac1.fft.df', 'sac1.fft.df', 'thr1.cf'}; %Can be character string ...
%Calculation parameters ...
DefParam.anwin         = [0 +Inf];     %in ms (Infinite designates stimulus duration) ...
DefParam.cortype       = 'cross';      %'auto' or 'cross' ...
DefParam.corbinwidth   = 0.05;         %in ms ...
DefParam.cormaxlag     = 5;            %in ms ...   
DefParam.fboundunit    = 'freq';       %'freq' or 'dist' ...
%Plot parameters ...
DefParam.fysitd        = [-0.4, +0.4]; %in ms (no fysiological range plotted when NaN) ...
DefParam.plotsecpeaks  = 'yes';        %'yes' or 'no' ...
DefParam.corxrange     = [-5 +5];      %in ms ...
DefParam.corxstep      = 1;            %in ms ...
DefParam.leftyunit     = 'freq';       %'freq', 'dist' or 'oct' ...
DefParam.rightyunit    = 'oct';        %'freq', 'dist' or 'oct' ...
DefParam.normcoratio   = 10;           %ratio between units of left ordinate and normalized
                                       %coincidences of a correlogram ...
DefParam.plotunitbox   = 'yes';        %'yes' or 'no' ...

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); 
    disp(DefParam);
    return;
else, [IDStr, CorType, List, RefIdx, Param] = ParseArgs(DefParam, varargin{:}); end

%Calculate auto- or crosscorrelograms ...
if strcmpi(Param.cortype, 'cross'),
    [Lag, NormCo, Max, LagatMax] = List2CrossCorFncs(CorType, List, RefIdx, Param);
else, [Lag, NormCo, Max, LagatMax] = List2AutoCorFncs(CorType, List, Param); end
[NormCo, Max] = ScaleCorFncs(NormCo, Max, CorType, List, Param);

%Display crosscorrelograms ...
DisplayCorFncs(IDStr, List, RefIdx, Lag, NormCo, Max, LagatMax, Param);

%----------------------------------------------------------------------------
function [IDStr, CorType, List, RefIdx, Param] = ParseArgs(DefParam, varargin)

Nargs = length(varargin);

%Get table ...
if (Nargs < 3), error('Wrong number of input arguments.'); 
elseif ~isstruct(varargin{1}), error('First argument must be structure-array.');
else, T = varargin{1}; end

%Get reference fiber ...
if (Nargs >= 3) & all(cellfun('isclass', varargin(2:3), 'double') & (cellfun('length', varargin(2:3)) == 1)),
    %COMPARESCCXCC(T, RowNr, Fbound)
    [RowNr, Fbound] = deal(varargin{2:3}); Pidx = 4;
elseif (Nargs >= 7) & all(cellfun('isclass', varargin([4, 6, 7]), 'double')) & ...
    (ischar(varargin{3}) | isnumeric(varargin{3})) & (ischar(varargin{5}) | isnumeric(varargin{5})),
    %COMPARESCCXCC(T, FileName, iSeqP or SeqIDP, iSubSeqP, iSeqN or iSubSeqN, iSubSeqN, Fbound)
    [FileName, iSubSeqP, iSubSeqN, Fbound] = deal(varargin{[2, 4, 6, 7]});
    FileName = RmBlanks(lower(FileName)); 
    if ischar(varargin{3}), SeqIDP = varargin{3};
    else, iSeqP = RmBlanks(lower(varargin{3})); end    
    if ischar(varargin{5}), SeqIDN = varargin{5};
    else, iSeqN = RmBlanks(lower(varargin{5})); end    
    Pidx = 8;
else, error('Wrong input arguments.'); end

%Check properties ...
Param = CheckPropList(DefParam, varargin{Pidx:end});
CheckParam(Param);

%Check and disassemble table ...
ReqFields = [{Param.filenamefield, Param.iseqpfield, Param.seqidpfield, Param.isubseqpfield}, cellstr(Param.freqfield), {Param.iseqnfield, Param.seqidnfield, Param.isubseqnfield}];
[Data, FNames] = destruct(T); NElem = length(T);
if ~all(ismember(ReqFields, FNames)), error('Supplied table doesn''t have all required fields.'); end

%Check and acquire information on reference fiber. Only frequency of the reference fiber
%is necessary ...
if exist('RowNr', 'var'),
    if (length(T) < RowNr), error('Row number not present in supplied table.'); end

    FileName = RmBlanks(lower(ExtractFields(Data(RowNr, :), FNames, Param.filenamefield))); FileName = FileName{1};
    iSeqP    = ExtractFields(Data(RowNr, :), FNames, Param.iseqpfield);
    SeqIDP   = RmBlanks(lower(ExtractFields(Data(RowNr, :), FNames, Param.seqidpfield))); SeqIDP = SeqIDP{1};
    iSubSeqP = ExtractFields(Data(RowNr, :), FNames, Param.isubseqpfield);
    iSeqN    = ExtractFields(Data(RowNr, :), FNames, Param.iseqnfield);
    SeqIDN   = RmBlanks(lower(ExtractFields(Data(RowNr, :), FNames, Param.seqidnfield))); SeqIDN = SeqIDN{1};
    iSubSeqN = ExtractFields(Data(RowNr, :), FNames, Param.isubseqnfield);
    
    if isnan(iSeqN) | isnan(iSubSeqN), CorType = 'cor'; [iSeqN, iSubSeqN] = deal(NaN); SeqIDN = '';
    else, CorType = 'dif'; end    
else,
    [SrchFNames, SrchKey] = deal({Param.filenamefield}, {FileName});
    if exist('iSeqP', 'var'),
        SrchFNames = [SrchFNames, {Param.iseqpfield}];
        SrchKey    = [SrchKey, {iSeqP}];
        CmdP       = 'SeqIDP = RmBlanks(lower(ExtractFields(Data(RowNr, :), FNames, Param.seqidpfield))); SeqIDP = SeqIDP{1};';
    else,
        SrchFNames = [SrchFNames, {Param.seqidpfield}];
        SrchKey    = [SrchKey, {SeqIDP}];
        CmdP       = 'iSeqP = ExtractFields(Data(RowNr, :), FNames, Param.iseqpfield);';
    end
    SrchFNames = [SrchFNames, {Param.isubseqpfield}];
    SrchKey    = [SrchKey, {iSubSeqP}];
    if exist('iSeqN', 'var'),
        if ~isnan(iSeqN),
            CorType    = 'dif';
            SrchFNames = [SrchFNames, {Param.iseqnfield}];
            SrchKey    = [SrchKey, {iSeqN}];
            CmdN       = 'SeqIDN = RmBlanks(lower(ExtractFields(Data(RowNr, :), FNames, Param.seqidnfield))); SeqIDN = SeqIDN{1};';
        else, 
            CorType    = 'cor';
            CmdN       = 'SeqIDN = '''';';
        end    
    else,
        if ~isempty(SeqIDN),
            CorType    = 'dif';
            SrchFNames = [SrchFNames, {Param.seqidnfield}];
            SrchKey    = [SrchKey, {SeqIDN}];
            CmdN       = 'iSeqN = ExtractFields(Data(RowNr, :), FNames, Param.iseqnfield);';
        else,
            CorType    = 'cor';
            CmdN       = 'iSeqN = NaN;';
        end    
    end
    if strcmpi(CorType, 'dif'),
        SrchFNames = [SrchFNames, {Param.isubseqnfield}];
        SrchKey    = [SrchKey, {iSubSeqN}];
    end
    
    RowNr = min(SearchTable(Data, FNames, SrchFNames, SrchKey));
    if isempty(RowNr), error('Reference input not present in table.'); end
    
    eval(CmdP); eval(CmdN);
end
NFreqFields = length(Param.freqfield); FreqFNidx = FNames2idx(FNames, Param.freqfield);
Freqs = denan(cat(2, Data{RowNr, FreqFNidx})); Fref = Freqs(1);

%Assemble list ...
Freqs = [reshape(cat(1, Data{:, FreqFNidx}), NElem, NFreqFields), repmat(Inf, NElem, 1)];
for n = 1:NFreqFields, Freqs(~isnan(Freqs(:, n)), (n+1):end) = NaN; end
Freqs = denan(Freqs'); Freqs(isinf(Freqs)) = NaN;

if (strcmpi(Param.fboundunit, 'dist')),
    Frng = greenwood(Fref) + [-1, +1]*Fbound;
    Ridx = find((greenwood(Freqs) >= greenwood(Fref)-Fbound) & ...
        (greenwood(Freqs) <= (greenwood(Fref)+Fbound))); Freqs = Freqs(Ridx);
else, 
    Frng = Fref + [-1, +1]*Fbound;
    Ridx = find((Freqs >= Fref-Fbound) & (Freqs <= Fref+Fbound)); Freqs = Freqs(Ridx); 
end

if strcmpi(CorType, 'dif'),
    ExIdx = find(cellfun('isempty', Data(Ridx, FNames2idx(FNames, Param.seqidnfield))));
    Ridx(ExIdx) = []; Freqs(ExIdx) = [];
end

IDFields = {Param.filenamefield, Param.iseqpfield, Param.isubseqpfield, Param.iseqnfield, Param.isubseqnfield};
Cidx = FNames2idx(FNames, IDFields);

[dummy, idx] = unique(upper(cv2str(Data(Ridx, Cidx))), 'rows');
Ridx = Ridx(idx); Freqs = Freqs(idx);

[Freqs, idx] = sort(Freqs); Ridx = Ridx(idx);
Dists = greenwood(Freqs); Octs = log2(Freqs/Fref);

IDFields = {Param.filenamefield, Param.seqidpfield, Param.iseqpfield, Param.isubseqpfield, Param.seqidnfield, Param.iseqnfield, Param.isubseqnfield};
Cidx = FNames2idx(FNames, IDFields);

F = {'filename', 'seqidp', 'iseqp', 'isubseqp', 'seqidn', 'iseqn', 'isubseqn', 'freq', 'dist', 'oct'};
D = [Data(Ridx, Cidx), num2cell(Freqs), num2cell(Dists), num2cell(Octs)];
List = cell2struct(D, F, 2);

%Find index of reference input in list ...
if strcmpi(CorType, 'dif'),
    SrchFNames  = {Param.filenamefield, Param.iseqpfield, Param.isubseqpfield, Param.iseqnfield, Param.isubseqnfield};
    SrchKey     = {FileName, iSeqP, iSubSeqP, iSeqN, iSubSeqN};
else,
    SrchFNames  = {Param.filenamefield, Param.iseqpfield, Param.isubseqpfield};
    SrchKey     = {FileName, iSeqP, iSubSeqP};
end    
RefIdx = SearchTable(Data(Ridx, :), FNames, SrchFNames, SrchKey);

%Substitution of shortcuts in properties ...
if isinf(Param.anwin(2)), 
    if strcmpi(CorType, 'cor'), ds = dataset(FileName, iSeqP); Param.anwin(2) = min([ds.burstdur]);
    else,    
        dsP = dataset(FileName, iSeqP); dsN = dataset(FileName, iSeqN); 
        Param.anwin(2) = min([dsP.burstdur, dsN.burstdur]);
    end
end

%Create figure caption and title string ...
if strcmpi(CorType, 'dif'),
    IDStr = sprintf('%s <%s>(%d) & <%s>(%d) (Fref = %.0f, Frng = [%.0f ... %.0f])', ...
        upper(List(RefIdx).filename), ...
        upper(List(RefIdx).seqidp), ...
        List(RefIdx).isubseqp, ...
        upper(List(RefIdx).seqidn), ...
        List(RefIdx).isubseqn, ...
        Fref, Frng);
else,
    IDStr = sprintf('%s <%s>(%d) (Fref = %.0f, Frng = [%.0f ... %.0f])', ...
        upper(List(RefIdx).filename), ...
        upper(List(RefIdx).seqidp), ...
        List(RefIdx).isubseqp, ...
        Fref, Frng);
end

%----------------------------------------------------------------------------
function Value = ExtractFields(Data, FNames, FieldName)

if iscellstr(FieldName), %Recursion ...
    N = length(FieldName); Value = cell(1, N);
    for n = 1:N, Value{n} = ExtractFields(Data, FNames, FieldName{n}); end
else,
    idx = find(strcmpi(FNames, FieldName));
    if isempty(idx), Value = [];
    else, 
        Value = Data(:, idx);
        if all(cellfun('isclass', Value, 'double') & (cellfun('length', Value) == 1)), Value = cat(1, Value{:}); 
        elseif all(cellfun('isclass', Value, 'char')), Value = RmBlanks(lower(Value)); end
    end
end

%----------------------------------------------------------------------------
function idx = FNames2idx(FNames, ReqFNames)

ReqFNames = cellstr(ReqFNames); N = length(ReqFNames);
idx = zeros(1, N); for n = 1:N, idx(n) = find(strcmpi(FNames, ReqFNames{n})); end

%----------------------------------------------------------------------------
function idx = SearchTable(Data, FNames, SrchFNames, SrchKey)

SrchFNames = cellstr(SrchFNames); NSrchFields = length(SrchFNames);
SrchData   = ExtractFields(Data, FNames, SrchFNames);

NElem = size(Data, 1); idx = 1:NElem;
for n = 1:NSrchFields, idx = intersect(idx, find(ismember(SrchData{n}, SrchKey{n}))); end

%----------------------------------------------------------------------------
function Str = RmBlanks(Str)

if iscellstr(Str), %Recursion ...
    N = length(Str); for n = 1:N, Str{n} = RmBlanks(Str{n}); end
    return;
end
    
idx = find(~isspace(Str));
if ~isempty(idx), Str = Str(min(idx):max(idx)); 
else, Str = ''; end

%----------------------------------------------------------------------------
function CheckParam(Param)

if ~ischar(Param.filenamefield) | ~any(size(Param.filenamefield, 1) == [0, 1]), error('Invalid value for property filenamefield.'); end
if ~ischar(Param.iseqpfield) | ~any(size(Param.iseqpfield, 1) == [0, 1]), error('Invalid value for property iseqpfield.'); end
if ~ischar(Param.seqidpfield) | ~any(size(Param.seqidpfield, 1) == [0, 1]), error('Invalid value for property seqidpfield.'); end
if ~ischar(Param.isubseqpfield) | ~any(size(Param.isubseqpfield, 1) == [0, 1]), error('Invalid value for property isubseqpfield.'); end
if ~ischar(Param.iseqnfield) | ~any(size(Param.iseqnfield, 1) == [0, 1]), error('Invalid value for property iseqnfield.'); end
if ~ischar(Param.seqidnfield) | ~any(size(Param.seqidnfield, 1) == [0, 1]), error('Invalid value for property seqidnfield.'); end
if ~ischar(Param.isubseqnfield) | ~any(size(Param.isubseqnfield, 1) == [0, 1]), error('Invalid value for property isubseqnfield.'); end
if ~ischar(Param.freqfield) & ~iscellstr(Param.freqfield), error('Invalid value for property freqfield.'); end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]) | ~isinrange(Param.anwin, [0, +Inf]), error('Invalid value for property anwin.'); end
if ~any(strcmpi(Param.cortype, {'auto', 'cross'})), error('Property cortype must be ''auto'' or ''cross''.'); end
if ~isnumeric(Param.corbinwidth) | (length(Param.corbinwidth) ~= 1) | (Param.corbinwidth <= 0), error('Invalid value for property corbinwidth.'); end
if ~isnumeric(Param.cormaxlag) | (length(Param.cormaxlag) ~= 1) | (Param.cormaxlag <= 0), error('Invalid value for property cormaxlag.'); end
if ~any(strcmpi(Param.fboundunit, {'freq', 'dist'})), error('Property fboundunit must be ''freq'' or ''dist''.'); end
if ~isnan(Param.fysitd) & ~isinrange(Param.fysitd, [-Inf, +Inf]), error('Property fysitd must be NaN or a two-element numeric vector.'); end
if ~any(strcmpi(Param.plotsecpeaks, {'yes', 'no'})), error('Property plotsecpeaks must be ''yes'' or ''no''.'); end
if ~isinrange(Param.corxrange, [-Inf +Inf]), error('Invalid value for property corxrange.'); end
if ~isnumeric(Param.corxstep) | (length(Param.corxstep) ~= 1) | (Param.corxstep <= 0), error('Invalid value for property corxstep.'); end
if ~any(strcmpi(Param.leftyunit, {'freq', 'dist', 'oct'})), error('Property leftyunit must be ''freq'', ''dist'' or ''oct''.'); end
if ~any(strcmpi(Param.rightyunit, {'freq', 'dist', 'oct'})), error('Property rightyunit must be ''freq'', ''dist'' or ''oct''.'); end
if ~isnumeric(Param.normcoratio) | (length(Param.normcoratio) ~= 1) | (Param.normcoratio <= 0), error('Invalid value for property normcoratio.'); end
if ~any(strcmpi(Param.plotunitbox, {'yes', 'no'})), error('Property plotunitbox must be ''yes'' or ''no''.'); end

%----------------------------------------------------------------------------
function [Lag, NormCo, Max, LagatMax] = List2CrossCorFncs(CorType, List, RefIdx, Param)

%Preallocation ...
[dummy, Lag] = SPTCORR([], [], Param.cormaxlag, Param.corbinwidth);
N = length(List); NormCo = zeros(N, length(Lag));

%Calculate all difcorrelograms (DIF) ...
if strcmpi(CorType, 'dif'),
    %Load reference cell ...
    [Spt1p, Spt1n] = LoadSpkTr(List(RefIdx), Param.anwin);
    %Calculation of autocorrelogram ...
    NormCo(RefIdx, :) = CalcCorFnc(Spt1p, Spt1n, Param);
    
    %Calculation of crosscorrelograms ...
    for n = setdiff(1:N, RefIdx),
        %Load compare cell ...
        [Spt2p, Spt2n] = LoadSpkTr(List(n), Param.anwin);
        %Calculate crosscorrelogram ...
        NormCo(n, :) = CalcCorFnc(Spt1p, Spt1n, Spt2p, Spt2n, Param);
    end
else, %Calculate shuffled crosscorrelograms (SCC) ...
    WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
    
    %Load reference cell ...
    Spt1 = LoadSpkTr(List(RefIdx), Param.anwin);

    %Calculation of autocorrelogram ...
    [Ysac, dummy, NC] = SPTCORR(Spt1, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    NormCo(RefIdx, :) = ApplyNorm(Ysac, NC);
    
    %Calculation of crosscorrelograms ...
    for n = setdiff(1:N, RefIdx),
        %Load compare cell ...
        Spt2 = LoadSpkTr(List(n), Param.anwin);
        %Calculate crosscorrelogram ...
        [Yscc, dummy, NC] = SPTCORR(Spt1, Spt2, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
        NormCo(n, :) = ApplyNorm(Yscc, NC);
    end
end

%Extract main and secundary peaks from correlograms ...
[Max, LagatMax] = deal(zeros(N, 3));
for n = 1:N, [LagatMax(n, 2), Max(n, 2), LagatMax(n, [1 3]), Max(n, [1 3])] = GetPeaks(Lag, NormCo(n, :)); end

%----------------------------------------------------------------------------
function [Lag, NormCo, Max, LagatMax] = List2AutoCorFncs(CorType, List, Param)

%Preallocation ...
[dummy, Lag] = SPTCORR([], [], Param.cormaxlag, Param.corbinwidth);
N = length(List); NormCo = zeros(N, length(Lag));

%Calculate all difcorrelograms (DIF) ...
if strcmpi(CorType, 'dif'),
    %Calculation of autocorrelograms ...
    for n = 1:N,
        [SptP, SptN] = LoadSpkTr(List(n), Param.anwin);
        %Calculate crosscorrelogram ...
        NormCo(n, :) = CalcCorFnc(SptP, SptN, Param);
    end
else, %Calculate shuffled autocorrelograms (SAC) ...
    WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
    
    %Calculation of autocorrelograms ...
    for n = 1:N,
        Spt = LoadSpkTr(List(n), Param.anwin);
        %Calculate autocorrelogram ...
        [Ysac, dummy, NC] = SPTCORR(Spt, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
        NormCo(n, :) = ApplyNorm(Ysac, NC);
    end
end

%Extract main and secundary peaks from correlograms ...
[Max, LagatMax] = deal(zeros(N, 3));
for n = 1:N, [LagatMax(n, 2), Max(n, 2), LagatMax(n, [1 3]), Max(n, [1 3])] = GetPeaks(Lag, NormCo(n, :)); end

%----------------------------------------------------------------------------
function [SptP, SptN] = LoadSpkTr(ListEntry, AnWin)

if (nargout == 1),
    dsP  = dataset(ListEntry.filename, ListEntry.iseqp); 
    SptP = anwin(dsP.spt(ListEntry.isubseqp, :), AnWin);
elseif (nargout == 2)    
    dsP = dataset(ListEntry.filename, ListEntry.iseqp); 
    dsN = dataset(ListEntry.filename, ListEntry.iseqn); 
    
    SptP = anwin(dsP.spt(ListEntry.isubseqp, :), AnWin);
    SptN = anwin(dsN.spt(ListEntry.isubseqn, :), AnWin);
end

%----------------------------------------------------------------------------
function CorFnc = CalcCorFnc(varargin)

%Check input arguments ...
if (nargin == 5), 
    [Spt1p, Spt1n, Spt2p, Spt2n, Param] = deal(varargin{:});

    WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...

    [Ypp, dummy, NC] = SPTCORR(Spt1p, Spt2p, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
    Ypp = ApplyNorm(Ypp, NC);
    [Ynn, dummy, NC] = SPTCORR(Spt1n, Spt2n, Param.cormaxlag, Param.corbinwidth, WinDur); %SCC ...
    Ynn = ApplyNorm(Ynn, NC);
    [Ypn, dummy, NC] = SPTCORR(Spt1p, Spt2n, Param.cormaxlag, Param.corbinwidth, WinDur); %XCC ...
    Ypn = ApplyNorm(Ypn, NC);
    [Ynp, dummy, NC] = SPTCORR(Spt1n, Spt2p, Param.cormaxlag, Param.corbinwidth, WinDur); %XCC ...
    Ynp = ApplyNorm(Ynp, NC);
    
    Yscc = mean([Ypp; Ynn]); Yxcc = mean([Ypn; Ynp]); 
    CorFnc = Yscc - Yxcc;
else, 
    [Spt1p, Spt1n, Param] = deal(varargin{:});
    
    WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
    
    [Ypp, dummy, NC] = SPTCORR(Spt1p, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ypp = ApplyNorm(Ypp, NC);
    [Ynn, dummy, NC] = SPTCORR(Spt1n, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ynn = ApplyNorm(Ynn, NC);
    [Ypn, dummy, NC] = SPTCORR(Spt1p, Spt1n, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ypn = ApplyNorm(Ypn, NC);
    [Ynp, dummy, NC] = SPTCORR(Spt1n, Spt1p, Param.cormaxlag, Param.corbinwidth, WinDur); %XAC ...
    Ynp = ApplyNorm(Ynp, NC);
    
    Ysac = mean([Ypp; Ynn]); Yxac = mean([Ypn; Ynp]);
    CorFnc = Ysac - Yxac;    
end

%----------------------------------------------------------------------------
function Y = ApplyNorm(Y, N)

if ~all(Y == 0), Y = Y/N.DriesNorm;
else, Y = ones(size(Y)); end

%----------------------------------------------------------------------------
function [NormCo, Max] = ScaleCorFncs(NormCo, Max, CorType, List, Param)

%Remove asymptote of one from SCCs/SACs ...
if strcmpi(CorType, 'cor'), [NormCo, Max] = deal(NormCo-1, Max-1); end

switch lower(Param.leftyunit)
case 'freq', Yunits = cat(1, List.freq);
case 'dist', Yunits = cat(1, List.dist);
case 'oct',  Yunits = cat(1, List.oct); end

N = size(NormCo, 2);
NormCo = NormCo*Param.normcoratio + repmat(Yunits, 1, N);
Max    = Max*Param.normcoratio + repmat(Yunits, 1, 3);

%----------------------------------------------------------------------------
function DisplayCorFncs(IDStr, List, RefIdx, Lag, NormCo, Max, LagatMax, Param)

CaptionTxt = sprintf('%s: %s', upper(mfilename), IDStr);

%Create table with correlogram information ...
structview(flipud(List), 'titletxt', CaptionTxt, ...
    'fields', {'filename', 'seqidp', 'isubseqp', 'seqidn', 'isubseqn', 'freq', 'dist', 'oct'}, ...
    'indexrow', 'on');

%Creating figure ...
FigHdl = figure('Name', CaptionTxt, ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Position for axes-objects ...
Pos = [0.10, 0.10, 0.80, 0.80];

%Create axes-object for right ordinate ...
AxHdlX = axes('Position', Pos, 'TickDir', 'out', 'YAxisLocation', 'right', 'XTick', [], 'XTickLabel', '');
ylabel(GetYLabel(Param.rightyunit));

%Creating axes-object for actual correlograms ...
[MinX, MaxX, XTicks] = GetXLim(Lag, Param.corxrange, Param.corxstep); [MinY, MaxY] = GetYLim(NormCo);
AxHdl = axes('Position', Pos, 'Box', 'off', 'TickDir', 'out', 'XLim', [MinX, MaxX], 'XTick', XTicks, 'YLim', [MinY, MaxY]);

if ~any(isnan(Param.fysitd)), PlotFysITDRange(MinY, MaxY, Param.fysitd); end %Plotting fysiological ITD as yellow rectangle ...
PlotVerLine(MinY, MaxY, 0); %Plot vertical line at zero lag ...

LnHdls = line(Lag, NormCo, 'LineStyle', '-', 'Marker', 'none', 'tag', 'corfncs'); set(LnHdls(RefIdx), 'LineWidth', 1.5);

if strcmpi(Param.plotsecpeaks, 'yes'), 
    line(LagatMax(:, 1), Max(:, 1), 'LineStyle', 'none', 'Marker', 'v', 'Color', 'k','MarkerFace', [1 1 1], 'tag', 'leftsecpeaks'); 
    line(LagatMax(:, 2), Max(:, 2), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k','MarkerFace', [1 1 1], 'tag', 'primpeaks'); 
    line(LagatMax(:, 3), Max(:, 3), 'LineStyle', 'none', 'Marker', '^', 'Color', 'k','MarkerFace', [1 1 1], 'tag', 'rightsecpeaks'); 
end
title(IDStr, 'FontSize', 12);
xlabel('Delay (ms)'); ylabel(GetYLabel(Param.leftyunit));

%Plot right ordinate ...
switch lower(Param.leftyunit),
case 'freq', YTicks = unique(cat(2, List.freq));
case 'oct',  YTicks = unique(cat(2, List.oct));
case 'dist', YTicks = unique(cat(2, List.dist)); end
switch lower(Param.rightyunit),
case 'freq', YTickLabel = num2str(unique(cat(1, List.freq)), 4);
case 'oct',  YTickLabel = num2str(unique(cat(1, List.oct)), 2);
case 'dist', YTickLabel = num2str(unique(cat(1, List.dist)), 4); end
set(AxHdlX, 'YLim', [MinY, MaxY], 'YTick', YTicks, 'YTickLabel', YTickLabel);

%Plot unitbox if requested ...
if strcmpi(Param.plotunitbox, 'yes'),
    %Find coordinates of lower left corner ...
    [Xllc, Yllc] = deal(MinX + 0.025*abs(diff([MinX, MaxX])), MinY + 0.025*abs(diff([MinY, MaxY])));
    %Find width and height of box ...
    [Width, Height] = deal(0.005*abs(diff([MinX, MaxX])), 1*Param.normcoratio);
    
    %Plot unitbox ...
    rectangle('Position', [Xllc, Yllc, Width, Height], 'EdgeColor', 'k', 'FaceColor', [1 1 1], 'LineStyle', '-');
    rectangle('Position', [Xllc, Yllc, Width, Height/2], 'EdgeColor', 'k', 'FaceColor', [0 0 0], 'LineStyle', '-');
    
    %Plot legend ...
    text(Xllc+Width+0.0005*abs(diff([MinX, MaxX])), Yllc, '0.0', 'fontsize', 5, 'fontweight', 'light');
    text(Xllc+Width+0.0005*abs(diff([MinX, MaxX])), Yllc+Height, '1.0', 'fontsize', 5, 'fontweight', 'light');
end

%----------------------------------------------------------------------------
function [MinVal, MaxVal, Ticks] = GetXLim(Values, Range, Step)

Margin = 0.00;
 
if isinf(Range(1)), MinVal = min(Values(:))*(1-Margin); else MinVal = Range(1); end
if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
Ticks = MinVal:Step:MaxVal;

%----------------------------------------------------------------------------
function [MinVal, MaxVal] = GetYLim(Values)

Margin = 0.05;

MinVal = min(Values(:))*(1-Margin);
MaxVal = max(Values(:))*(1+Margin);

%----------------------------------------------------------------------------
function Str = GetYLabel(YUnit)

switch lower(YUnit)
case 'freq', Str = 'Frequency (Hz)';
case 'dist', Str = 'Coclear Distance (mm)';
case 'oct',  Str = '\DeltaFrequency (Oct)'; end

%----------------------------------------------------------------------------
function PlotVerLine(MinY, MaxY, C)

line(C([1 1]), [MinY, MaxY], 'Color', 'k', 'LineStyle', ':');

%----------------------------------------------------------------------------
function PlotFysITDRange(MinY, MaxY, FysRng)

YRng = [MinY, MaxY];
RectHdl = patch(FysRng([1 2 2 1]), YRng([1 1 2 2]), [1 1 0.75], 'EdgeColor', [1 1 0.75], 'FaceColor', [1 1 0.75]);
line(FysRng([1 1]), YRng, 'Color', [0 0 0], 'LineStyle', ':');
line(FysRng([2 2]), YRng, 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------