function ArgOut = EvalSACXAC(varargin)
%EVALSACXAC  calculate the SAC, XAC, SUM- and DIFCOR.
%   T = EVALSACXAC(ds1, SubSeqs1, ds2, SubSeqs2) calculates the SAC, XAC,
%   SUM- and DIFCOR from the specified subsequences. If subsequences are
%   given as vectors, for each corresponding subsequence pair a calculation
%   is performed.
%   E.g.:
%           ds1 = dataset('A0242', -135);
%           ds2 = dataset('A0242', -136);
%           EvalSACXAC(ds1, 50:10:80, ds2, 50:10:80);
%
%   T = EVALSACXAC(ds, SubSeqs) where SubSeqs is a two-element vector,
%   specifying the subsequence pair used for the calculation.
%   E.g.:
%           ds = dataset('A0242', 369);
%           EvalSACXAC(ds, [+1, -1]);
%   If SubSeqs as a scalar, then only a SAC is calulated.
%   E.g.:
%           ds = dataset('A0242', 369);
%           EvalSACXAC(ds, +1);
% 
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   All calculations are cached. To clear the current cache use 'clrcache' 
%   as only input argument.

%B. Van de Sande 13-10-2004

%% -----------------------------------template-----------------------------
Template.ds1.filename         = '';        %Datafile name for datasets
Template.ds1.icell            = NaN;       %Cell number of datasets
Template.ds1.iseq             = NaN;       %Sequence number of first dataset
Template.ds1.seqid            = '';        %Identifier of first dataset
Template.ds1.isubseq          = NaN;       %Subsequence number of spiketrain used for first dataset
Template.ds1.spkrate          = NaN;
Template.ds1.nspike           = NaN;
Template.ds2.iseq             = NaN;       %Sequence number of second dataset
Template.ds2.seqid            = '';        %Identifier of second dataset
Template.ds2.isubseq          = NaN;       %Subsequence number of spiketrain used for second dataset
Template.ds2.spkrate          = NaN;
Template.ds2.nspike           = NaN;
Template.tag                  = 0;         %General purpose tag field
Template.createdby            = mfilename; %Name of MATLAB function that generated the data
Template.stim.burstdur        = NaN;       %Stimulus duration in ms
Template.stim.repdur          = NaN;       %Repetition duration in ms
Template.stim.nrep            = [NaN, NaN];%Number of repetitions
Template.stim.spl             = [NaN, NaN];%Sound pressure level in dB
Template.stim.effspl1         = NaN;       %Effective SPL in dB
Template.stim.effspl2         = NaN;
Template.stim.effspl          = NaN;
Template.ac.max               = NaN;       %Maximum of shuffled autocorrelogram (DriesNorm)
Template.ac.saczero           = NaN;       %Value at delay zero of shuffled autocorrelogram (DriesNorm)
Template.ac.xaczero           = NaN;       %Value at delay zero of XAC (DriesNorm)
Template.ac.zeroratio         = NaN;       %Ratio of values at delay zero for XAC and SAC
Template.ac.peakratio         = NaN;       %Ratio of secundary versus primary peak in autocorrelogram
Template.ac.hhw               = NaN;       %Half height width on autocorrelogram (ms)
Template.ac.fft.df            = NaN;       %Dominant frequency in autocorrelogram (Hz)
Template.ac.fft.bw            = NaN;       %Bandwidth (Hz)
Template.diff.max             = NaN;       %Maximum of diffcorrelogram (DriesNorm)
Template.diff.peakratio       = NaN;       %Ratio of secundary versus primary peak in diffcorrelogram
Template.diff.hhw             = NaN;       %Half height with on envelope of diffcorrelogram (ms)
Template.diff.fft.df          = NaN;       %Dominant frequecny in diffcorrelogram (Hz)
Template.diff.fft.bw          = NaN;       %Bandwidth (Hz)
Template.sum.max              = NaN;       %Maximum of sumcorrelogram (DriesNorm)
Template.sum.hhw              = NaN;       %Half height with on sumcorrelogram (ms)
Template.sum.fft.bf           = NaN;       %Best frequency of sumcor spectrum (Hz)
Template.sum.fft.cof          = NaN;       %Cutoff frequency of sumcor spectrum (Hz)
Template.thr.cf               = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr               = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr              = NaN;       %Threshold at characteristic frequency
Template.thr.q10              = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw               = NaN;       %Width 10dB above threshold (Hz)
Template.rcn.thr              = NaN;       %Noise threshold (dB) derived from NSPL curve ...

%% -------------------------------default parameters-----------------------
%Syntax parameters ...
DefParam.subseqinput   = 'indepval'; %'indepval' or 'subseq' ...
%Calculation parameters ...
DefParam.verbose       = 'yes';      %'yes' or 'no' ...
DefParam.cache         = 'yes';      %'yes' or 'no' ...
DefParam.anwin         = [0 +Inf];   %in ms (Infinite designates stimulus duration) ...
DefParam.corbinwidth   = 0.05;       %in ms ...
DefParam.cormaxlag     = 5;          %in ms ...   
DefParam.envrunavunit  = '#';        %'#' or 'ms' ...
DefParam.envrunav      = 1;          %in ms or number of periods ...
DefParam.acfftrunav    = 100;        %in Hz ...
DefParam.diffftrunav   = 100;        %in Hz ...
DefParam.sumfftrunav   = 0;          %in Hz ...
DefParam.cutofflevel   = 3;          %in dB (3 or 6dB) ...
DefParam.calcdf        = NaN;        %in Hz, NaN (automatic), 'cf' or 'df' ...
DefParam.effsplcf      = NaN;        %in Hz, NaN (automatic) 'cf' or 'df' ...
DefParam.effsplbw      = 1/3;        %in octaves ... 
%Plot parameters ...
DefParam.plot          = 'yes';      %'yes' or 'no' ...
DefParam.corxrange     = [-5 +5];    %in ms ...
DefParam.corxstep      = 1;          %in ms ...
DefParam.fftxrange     = [0 500];    %in Hz ...
DefParam.fftxstep      = 50;         %in Hz ...
DefParam.fftyunit      = 'dB';       %'dB' or 'P' ...
DefParam.fftyrange     = [-20 0];
DefParam.ismashed      = false;      % Whether the dataset is mashed.

%----------------------------------main program------------------------------
%% Evaluate input arguments ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'clrcache')
    EmptyCacheFile(mfilename);
    return;
else
    [ds1, ds2, Spt1, Spt2, Info, StimParam, Param] = ParseArgs(DefParam,...
        varargin{:}); 
end

%% Retrieving data from SGSR server ...
try
    UD = getuserdata(Info(1).ds1.filename, Info(1).ds1.icell);
    if isempty(UD)
        error('To catch block ...');
    end
    %Threshold curve information ...
    if ~isempty(UD.CellInfo) && ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(Info(1).ds1.filename, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = EvalTHR(dsTHR, 'plot', 'no');
        s = sprintf('Threshold curve:');
        s = strvcat(s, sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID));
        s = strvcat(s, sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), ...
            Param2Str(Thr, 'dB', 0)));
        s = strvcat(s, sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)));
        s = strvcat(s, sprintf('BW = %s', Param2Str(BW, 'Hz', 1)));
        s = strvcat(s, sprintf('Q10 = %s', Param2Str(Q10, '', 1)));
        Str = s;
        Thr = lowerFields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    else
        Thr = struct([]);
    end
    %Rate curve information ...
    if isfield(UD.CellInfo, 'RCNTHR')
        Rcn.thr = UD.CellInfo.RCNTHR;
        s = sprintf('Intensity curve:');
        s = strvcat(s, sprintf('THR = %s', Param2Str(UD.CellInfo.RCNTHR, 'dB', 0)));
        Rcn.str = s;
    else
        Rcn = struct([]); 
    end    
catch 
    warning('%s\nAdditional information from SGSR server is not included.',...
        lasterr); 
    [Thr, Rcn] = deal(struct([]));
end

%% Calculate data ... Caching system ...
NCalc = length(Info);
for n = 1:NCalc
    if (NCalc > 1) && strcmpi(Param.verbose, 'yes')
        fprintf('Calculating correlograms %d/%d ...\n', n, NCalc);
    end    
    if strcmpi(Param.cache, 'yes')
        SearchParam = structcat( ...
            getfields(Info(n), {'ds1', 'ds2'}), ... %Combinatorics...datasets and subsequences used in correlation...
            getfields(Param, {'anwin', 'corbinwidth', 'cormaxlag', 'envrunavunit', ...
            'envrunav', 'diffftrunav', 'sumfftrunav', 'cutofflevel', 'calcdf'})); %Calculation parameters...
        CacheData = FromCacheFile(mfilename, SearchParam);
        if isempty(CacheData)
            if isequal(Info(n).ds1.iseq, Info(n).ds2.iseq) && isequal(Info(n).ds1.isubseq, Info(n).ds2.isubseq)
                CalcData(n) = CalcDifCor(Spt1(n, :), 'nodiag', Thr, Param);
            else
                CalcData(n) = CalcDifCor(Spt1(n, :), Spt2(n, :), Thr, Param);
            end
            ToCacheFile(mfilename, +1000, SearchParam, CalcData(n));
        else 
            CalcData(n) = CacheData;
            if strcmpi(Param.verbose, 'yes')
                fprintf('Data retrieved from cache ...\n');
            end
        end    
    elseif isequal(Info(n).ds1.iseq, Info(n).ds2.iseq) && isequal(Info(n).ds1.isubseq, Info(n).ds2.isubseq)
        CalcData(n) = CalcDifCor(Spt1(n, :), 'nodiag', Thr, Param);
    else
        CalcData(n) = CalcDifCor(Spt1(n, :), Spt2(n, :), Thr, Param);
    end
end

%Calculating effective SPL ...
for n = 1:NCalc
    FilterBW = Param.effsplbw;    
    if ~isempty(Thr)
        FilterCF = DetermineCalcDF(Param.effsplcf, Thr.cf, CalcData(n).diff.fft.df, CalcData(n).ac.fft.df);
    else
        FilterCF = DetermineCalcDF(Param.effsplcf, NaN, CalcData(n).diff.fft.df, CalcData(n).ac.fft.df);
    end
    
    if isnan(FilterCF)
        warning('Calculating overall effective SPL, because center frequency for filter cannot be extracted.');
        [FilterCF, FilterBW] = deal([]);
    end
    
    try 
        EffSPL = CalcEffSPL(ds1, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', ds1.chan);
        if isequal(length(unique(EffSPL)), 1)
            StimParam(n).effspl1 = EffSPL(1); 
        elseif isequal(length(EffSPL), ds1.nsub)
            StimParam(n).effspl1 = EffSPL(Info(n).ds1.isubseq);
        end
    catch
        warning(lasterr); StimParam(n).effspl1 = NaN;
    end
    try 
        EffSPL = CalcEffSPL(ds2, 'filtercf', FilterCF, 'filterbw', FilterBW, 'channel', ds2.chan);
        if isequal(length(unique(EffSPL)), 1)
            StimParam(n).effspl2 = EffSPL(1); 
        elseif isequal(length(EffSPL), ds2.nsub)
            StimParam(n).effspl2 = EffSPL(Info(n).ds2.isubseq);
        end
    catch
        warning(lasterr); StimParam(n).effspl2 = NaN;
    end
    
    if ~isnan(StimParam(n).effspl1) && ~isnan(StimParam(n).effspl2)
        StimParam(n).effspl = CombineSPLs(StimParam(n).effspl1, StimParam(n).effspl2);
    elseif ~isnan(StimParam(n).effspl1)
        StimParam(n).effspl = StimParam(n).effspl1;
    else
        StimParam(n).effspl = StimParam(n).effspl2;
    end
    
    s = sprintf('EffSPL = %s', Param2Str(StimParam(n).effspl, 'dB', 0));
    StimParam(n).str = strvcat(StimParam(n).str, s);
end
                
%% Display data ...
if strcmpi(Param.plot, 'yes'), 
    for n = 1:NCalc
        PlotDifCor(Info(n), StimParam(n), Thr, Rcn, Param, CalcData(n));
    end
end

%% Return output if requested ...
if (nargout > 0), 
    nspike1 = CalcData.ds1.nspike;
    rate1 = 	CalcData.ds1.spkrate;
    nspike2 = CalcData.ds2.nspike;
    rate2 = CalcData.ds2.spkrate;
    [CalcData.ds1] = deal(Info.ds1);
    [CalcData.ds2] = deal(Info.ds2);
    CalcData.ds1.nspike = nspike1;
    CalcData.ds1.spkrate = rate1;
    CalcData.ds2.nspike = nspike2;
    CalcData.ds2.spkrate = rate2;
    [CalcData.thr] = deal(Thr);
    [CalcData.rcn] = deal(Rcn);
    for n = 1:NCalc
        ArgOut(n) = structtemplate(structcat(CalcData(n), struct('stim', StimParam(n))), Template);
    end
end

%% ---------------------------------local functions------------------------
function [ds1, ds2, Spt1, Spt2, Info, StimParam, Param] = ParseArgs(DefParam, varargin)

%% Checking input arguments ...
Nds = length(find(cellfun('isclass', varargin, 'dataset')));
if (Nds == 1), %T = EVALSACXAC(ds, SubSeqs)
    if (length(varargin) < 2), error('Wrong number of input arguments.'); end
    if ~isa(varargin{1}, 'dataset'), error('First argument should be dataset.'); end
    
    if isnumeric(varargin{2}) && (length(varargin{2}) == 1),
        [ds1, ds2] = deal(varargin{1});
        [InputVec1, InputVec2] = deal(varargin{2});
    elseif isnumeric(varargin{2}) && isequal(sort(size(varargin{2})), [1, 2]),
        [ds1, ds2] = deal(varargin{1});
        [InputVec1, InputVec2] = deal(varargin{2}(1), varargin{2}(2));
    else
        error('Second argument should be a scalar or two-element numeric vector.');
    end
        
    ParamIdx = 3;
elseif (Nds == 2), %T = EVALSACXAC(ds1, SubSeqs1, ds2, SubSeqs2)
    if (length(varargin) < 4), error('Wrong number of input arguments.'); end
    
    ds1 = varargin{1};
    if ~isa(ds1, 'dataset'), error('First argument should be dataset.'); end
    ds2 = varargin{3};
    if ~isa(ds2, 'dataset'), error('Third argument should be dataset.'); end
    if ~isequal(ds1.filename, ds2.filename) || ~isequal(ds1.icell, ds2.icell)
        error('Datasets weren''t collected from the same cell.');
    end
    
    if ~isnumeric(varargin{2}) || ~any(size(varargin{2}) == 1)
        error('Second argument should be a numeric vector.');
    end
    if ~isnumeric(varargin{4}) || ~any(size(varargin{4}) == 1)
        error('Forth argument should be a numeric vector.');
    end
    if ~isequal(length(varargin{2}), length(varargin{4}))
        error('Subsequence vectors for datasets should be of same length.');
    end
    [InputVec1, InputVec2] = deal(varargin{2}, varargin{4});
    
    ParamIdx = 5;
else
    error('Invalid input arguments.');
end

%% Retrieving properties and checking their values ...
Param = checkproplist(DefParam, varargin{ParamIdx:end});
CheckParam(Param);

%% Unraveling and reorganizing input arguments ...
if strcmpi(Param.subseqinput, 'subseq'), 
    [iSubSeq1, iSubSeq2] = deal(InputVec1, InputVec2);
    [IndepVal1, IndepVal2] = deal(ds1.indepval(iSubSeq1), ds2.indepval(iSubSeq2));
else
    [IndepVal1, IndepVal2] = deal(InputVec1, InputVec2);
    if ~all(ismember(IndepVal1, ds1.indepval))
        error(['One of the values for the independent variable of first' ...
            'dataset doesn''t exist.']);
    end
    if ~all(ismember(IndepVal2, ds2.indepval))
        error(['One of the values for the independent variable of second' ...
            'dataset doesn''t exist.']);
    end
    for n = 1:length(IndepVal1), 
        iSubSeq1(n) = find(ds1.indepval == IndepVal1(n)); 
        iSubSeq2(n) = find(ds2.indepval == IndepVal2(n));
    end
end
Spt1 = ds1.spt(iSubSeq1, :);
Spt2 = ds2.spt(iSubSeq2, :);
[ds1, ds2] = deal(EmptyDataset(ds1), EmptyDataset(ds2));

%% Assembling dataset information ...
N = length(IndepVal1);
Info.ds1.filename = ds1.filename;
Info.ds1.icell    = ds1.icell;
Info.ds1.iseq     = ds1.iseq;
Info.ds1.seqid    = ds1.seqid;
Info.ds1.mashed   = '';
if Param.ismashed
%TODO   Info.ds1.mashed = ['mashed#' num2str(ds1.ID.mashed)];
end
Info.ds2.iseq     = ds2.iseq;
Info.ds2.seqid    = ds2.seqid;
Info.ds2.mashed   = '';
if Param.ismashed
%TODO   Info.ds2.mashed = ['mashed#' num2str(ds2.ID.mashed)];
end

Info = repmat(Info, N, 1);
for n = 1:N
    Info(n).ds1.isubseq  = iSubSeq1(n);
    Info(n).ds1.indepval = IndepVal1(n);
    Info(n).ds1.indepunit = ds1.indepunit;
    Info(n).ds2.isubseq  = iSubSeq2(n);
    Info(n).ds2.indepval = IndepVal2(n);
    Info(n).ds2.indepunit = ds2.indepunit;
end

% Collecting and reorganizing stimulus parameters ...
for n = 1:N
    StimParam(n) = GetStimParam(ds1, iSubSeq1(n), ds2, iSubSeq2(n));
end

%% Substitution of shortcuts in properties ...
if isinf(Param.anwin(2))
    Param.anwin(2) = min([StimParam.burstdur]);
end

%% Format parameter information ...
if isnan(Param.calcdf)
    CalcDFStr = 'auto';
elseif ischar(Param.calcdf)
    CalcDFStr = lower(Param.calcdf);
else
    CalcDFStr = Param2Str(Param.calcdf, 'Hz', 0);
end
s = sprintf('AnWin = %s', Param2Str(Param.anwin, 'ms', 0));
s = strvcat(s, sprintf('BinWidth = %s', Param2Str(Param.corbinwidth, 'ms', 2)));
s = strvcat(s, sprintf('MaxLag = %s', Param2Str(Param.cormaxlag, 'ms', 0)));
s = strvcat(s, sprintf('Calc. DF = %s', CalcDFStr));
s = strvcat(s, sprintf('RunAv(Env) = %.2f(%s)', Param.envrunav, Param.envrunavunit));
s = strvcat(s, sprintf('RunAv(Dft on DIFCOR) = %s', Param2Str(Param.diffftrunav, 'Hz', 0)));
s = strvcat(s, sprintf('RunAv(Dft on SUMCOR) = %s', Param2Str(Param.sumfftrunav, 'Hz', 0)));
s = strvcat(s, sprintf('CutOffLevel = %s', Param2Str(Param.cutofflevel, 'dB', 0)));
Param.str = s;

%----------------------------------------------------------------------------
function CheckParam(Param)

%Syntax parameters ...
if ~any(strcmpi(Param.subseqinput, {'indepval', 'subseq'}))
    error('Property subseqinput must be ''indepval'' or ''subseq''.');
end

%Calculation parameters ...
if ~any(strcmpi(Param.verbose, {'yes', 'no'}))
    error('Property verbose must be ''yes'' or ''no''.');
end
if ~any(strcmpi(Param.cache, {'yes', 'no'}))
    error('Property cache must be ''yes'' or ''no''.');
end
if ~isnumeric(Param.anwin) | (size(Param.anwin) ~= [1,2]) ...
        | ~isinrange(Param.anwin, [0, +Inf]) %#ok
    error('Invalid value for property anwin.');
end
if ~isnumeric(Param.corbinwidth) || (length(Param.corbinwidth) ~= 1) ...
        || (Param.corbinwidth <= 0)
    error('Invalid value for property corbinwidth.');
end
if ~isnumeric(Param.cormaxlag) || (length(Param.cormaxlag) ~= 1) ...
        || (Param.cormaxlag <= 0)
    error('Invalid value for property cormaxlag.');
end
if ~any(strcmpi(Param.envrunavunit, {'#', 'ms'}))
    error('Property envrunavunit must be ''#'' or ''ms''.');
end
if ~isnumeric(Param.envrunav) || (length(Param.envrunav) ~= 1) ...
        || (Param.envrunav < 0)
    error('Invalid value for property envrunav.');
end
if ~isnumeric(Param.acfftrunav) || (length(Param.acfftrunav) ~= 1) ...
        || (Param.acfftrunav < 0)
    error('Invalid value for property acfftrunav.');
end
if ~isnumeric(Param.diffftrunav) || (length(Param.diffftrunav) ~= 1) ...
        || (Param.diffftrunav < 0)
    error('Invalid value for property diffftrunav.');
end
if ~isnumeric(Param.sumfftrunav) || (length(Param.sumfftrunav) ~= 1) ...
        || (Param.sumfftrunav < 0)
    error('Invalid value for property sumfftrunav.');
end
if ~isnumeric(Param.cutofflevel) || (length(Param.cutofflevel) ~= 1) ...
        || ~ismember(Param.cutofflevel, [3, 6])
    error('Invalid value for property cutofflevel.');
end
if ~(isnumeric(Param.calcdf) && ((Param.calcdf > 0) || isnan(Param.calcdf)))...
        && ~(ischar(Param.calcdf) && any(strcmpi(Param.calcdf, {'cf', 'df'}))), 
    error('Property calcdf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if ~(isnumeric(Param.effsplcf) && ((Param.effsplcf > 0) || isnan(Param.effsplcf))) ...
        && ~(ischar(Param.effsplcf) && any(strcmpi(Param.effsplcf, {'cf', 'df'})))
    error('Property effsplcf must be positive integer, NaN, ''cf'' or ''df''.'); 
end
if ~isnumeric(Param.effsplbw) || (length(Param.effsplbw) ~= 1) || (Param.effsplbw <= 0)
    error('Invalid value for property effsplbw.');
end

%Plot parameters ...
if ~any(strcmpi(Param.plot, {'yes', 'no'}))
    error('Property plot must be ''yes'' or ''no''.');
end
if ~isinrange(Param.corxrange, [-Inf +Inf])
    error('Invalid value for property corxrange.');
end
if ~isnumeric(Param.corxstep) || (length(Param.corxstep) ~= 1) || (Param.corxstep <= 0)
    error('Invalid value for property corxstep.');
end
if ~isinrange(Param.fftxrange, [0 +Inf])
    error('Invalid value for property fftxrange.');
end
if ~isnumeric(Param.fftxstep) || (length(Param.fftxstep) ~= 1) || (Param.fftxstep <= 0)
    error('Invalid value for property fftxstep.');
end
if ~any(strcmpi(Param.fftyunit, {'dB', 'P'}))
    error('Property fftyunit must be ''dB'' or ''P''.');
end
if ~isinrange(Param.fftyrange, [-Inf +Inf])
    error('Invalid value for property fftyrange.');
end

%----------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) || all(isequal(C{:}))
    Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2)
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1)
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%----------------------------------------------------------------------------
function StimParam = GetStimParam(ds1, iSubSeq1, ds2, iSubSeq2)

%If stimulus and repetition duration is not the same for different channels or different 
%datasets or both, then the minimum value is used. NaN's are automatically removed by min
%function ...
StimParam.burstdur = round(min([ds1.burstdur(:); ds2.burstdur(:)]));
StimParam.repdur   = round(min([ds1.repdur(:); ds2.repdur(:)]));

%Repetition numbers for both datasets ...
StimParam.nrep = [ds1.nrep, ds2.nrep];

%Sound pressure level (dB) is always returned as a two element vector ... When one of the
%datasets is a binaural dataset and the SPL administered at the ears is different, then 
%the SPLs are combined using the power average ...
spl1 = GetSPL(ds1);
spl1 = CombineSPLs(spl1(iSubSeq1, 1), spl1(iSubSeq1, end));
spl2 = GetSPL(ds2);
spl2 = CombineSPLs(spl2(iSubSeq2, 1), spl2(iSubSeq2, end));
StimParam.spl = [spl1, spl2];

%Format stimulus parameters ...
s = sprintf('BurstDur = %s', Param2Str(StimParam.burstdur, 'ms', 0));
s = strvcat(s, sprintf('IntDur = %s', Param2Str(StimParam.repdur, 'ms', 0)));
s = strvcat(s, sprintf('#Reps = %s', Param2Str(StimParam.nrep, '', 0)));
s = strvcat(s, sprintf('SPL = %s', Param2Str(unique(StimParam.spl), 'dB', 0)));
StimParam.str = s;

%----------------------------------------------------------------------------
function CalcData = CalcDifCor(Spt1, Spt2, Thr, Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...

if ischar(Spt2) && strcmpi(Spt2, 'nodiag'),
    %Correlation of noise token responses of a cell with the responses of that same cell to that same noise
    %token. The spiketrains are derived from the same cell so this is called a Shuffled AutoCorrelogram (or SAC).
    [Ysac, T, NC] = SPTCORR(anwin(Spt1, Param.anwin), 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); %SAC ...
    Ysac = ApplyNorm(Ysac, NC);
    
    %Performing spectrum analysis on the SAC. Because an autocorrelogram has a DC component this is
    %removed first ...
    FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz', 'RunAvRange', Param.acfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum, therefore all
    %magnitude units need to be changed ...
    FFTsac.Magn.P  = FFTsac.Magn.A;
    FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
    FFTsac.Magn.dB = FFTsac.Magn.dB/2;

    %Determine which dominant frequency to be used in the calculation ...
    if ~isempty(Thr)
        DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, NaN, FFTsac.DF);
    else
        DomFreq = DetermineCalcDF(Param.calcdf, NaN, NaN, FFTsac.DF);
    end
    
    if (DomFreq ~= 0)
        DomPer = 1000/DomFreq; 
    else
        DomPer = NaN; 
    end %Dominant period in ms ...
    
    %Calculating the ratio of the secondary over the primary peak for the SAC and
    %the half height width on the peak (relative to asymptote one)...
    HalfMaxSac = ((max(Ysac)-1)/2)+1;
    SacHHWx = cintersect(T, Ysac, HalfMaxSac);
    SacHHW = abs(diff(SacHHWx));
    [SacPeakRatio, SacXPeaks, SacYPeaks] = getpeakratio(T, Ysac, DomFreq);
    
    %Reorganizing calculated data ...
    CalcData.delay         = T;
    CalcData.ac.normco     = Ysac;
    CalcData.ac.max        = max(Ysac);
    CalcData.ac.peakratio  = SacPeakRatio;
    CalcData.ac.peakratiox = SacXPeaks;
    CalcData.ac.peakratioy = SacYPeaks;
    CalcData.ac.hhw        = SacHHW;
    CalcData.ac.hhwx       = SacHHWx;
    CalcData.ac.halfmax    = HalfMaxSac;
    CalcData.ac.fft.freq   = FFTsac.Freq;
    CalcData.ac.fft.p      = FFTsac.Magn.P;   
    CalcData.ac.fft.db     = FFTsac.Magn.dB;
    CalcData.ac.fft.df     = FFTsac.DF;
    CalcData.ac.fft.bw     = FFTsac.BW;
    [CalcData.diff, CalcData.sum] = deal(struct([]));
else    
    %Correlation of noise token A+ responses of a cell with the responses of that
    %same cell to that same noise token. If spiketrains are derived from the same
    %cell this is called a Shuffled Auto-Correlogram (or SAC). 'Shuffled' because
    %of the shuffling of repetitions in order to avoid to correlation of a repetition
    %with itself. The terminolgy AutoCorrelogram is only used when comparing
    %spiketrains collected from the same cell.
    %The suffix -m designates the second result of SPTCORR when isMashed is
    %true. See help sptcorr
    [Ypp, T, NC, Yppm, Tm, NCm] = SPTCORR(ANWIN(Spt1, Param.anwin), 'nodiag',...
        Param.cormaxlag, Param.corbinwidth, WinDur, '', Param.ismashed); %SAC...
    spkrate1 = NC.Rate1;
    nspike1 = NC.Nspike1;
    Ypp = ApplyNorm(Ypp, NC);
    if Param.ismashed
        Yppm = ApplyNorm(Yppm, NCm);
    end
    %Correlation of noise token A- responses of a cell with the responses of that
    %same cell to that same noise token.
    [Ynn, T, NC, Ynnm, Tm, NCm] = SPTCORR(ANWIN(Spt2, Param.anwin), 'nodiag',...
        Param.cormaxlag, Param.corbinwidth, WinDur, '', Param.ismashed); %SAC...
    spkrate2 = NC.Rate2;
    nspike2 = NC.Nspike2;
    Ynn = ApplyNorm(Ynn, NC);
    if Param.ismashed
        Ynnm = ApplyNorm(Ynnm, NCm);
    end
    %Correlation of noise token A+ responses of a cell with the responses of that
    %same cell to a different noise token, in this case A-. Because of the fact
    %that we correlate across stimuli this type of correlogram is designated XAC,
    %when comparing responses from the same cell.
    [Ypn, T, NC, Ypnm, Tm, NCm] = ...
        SPTCORR(ANWIN(Spt1, Param.anwin), ANWIN(Spt2, Param.anwin),...
        Param.cormaxlag, Param.corbinwidth, WinDur, '', Param.ismashed); %XAC ...
    Ypn = ApplyNorm(Ypn, NC);
    if Param.ismashed
        Ypnm = ApplyNorm(Ypnm, NCm);
    end
    %Correlation of noise token A- responses of a cell with the responses of that
    %same cell to a different noise token, in this case A+.
    [Ynp, T, NC, Ynpm, Tm] = ...
        SPTCORR(ANWIN(Spt2, Param.anwin), ANWIN(Spt1, Param.anwin),...
        Param.cormaxlag, Param.corbinwidth, WinDur, '', Param.ismashed); %XAC ...
    %TODO normalisation??
    
    %Calculation of the DIFCOR by taking the average of the two SACs and the two
    %XACs and subtracting the second from the first, also calculating the SUMCOR
    %by averaging the two ...
    Ysac = mean([Ypp; Ynn]); 
    %Yxac = mean([Ypn; Ynp]);
    Yxac = Ypn; %Changed on 02-04-2004 ...
    Ydifcor = Ysac - Yxac;
    Ysumcor = mean([Ysac; Yxac]);
    if Param.ismashed
        Ysacm = mean([Yppm; Ynnm]);
        Yxacm = Ypnm;
    end
    %Performing spectrum analysis on the DIFCOR. Because a difcor has no DC
    %component in comparison with other correlograms, this almost always results
    %in a representative dominant frequency ...
    FFTdif = spectana(T, Ydifcor, 'RunAvUnit', 'Hz', 'RunAvRange', Param.diffftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum,
    %therefore all magnitude units need to be changed ...
    FFTdif.Magn.P  = FFTdif.Magn.A;
    FFTdif.Magn.A  = sqrt(FFTdif.Magn.A);
    FFTdif.Magn.dB = FFTdif.Magn.dB/2;

    %Performing spectrum analysis on the SAC. Because an autocorrelogram has a DC
    %component this is removed first ...
    FFTsac = spectana(T, detrend(Ysac, 'constant'), 'RunAvUnit', 'Hz',...
        'RunAvRange', Param.acfftrunav);
    %The magnitude spectrum of a correlogram function is actually a power spectrum,
    %therefore all magnitude units need to be changed ...
    FFTsac.Magn.P  = FFTsac.Magn.A;
    FFTsac.Magn.A  = sqrt(FFTsac.Magn.A);
    FFTsac.Magn.dB = FFTsac.Magn.dB/2;
    
    %Determine which dominant frequency to be used in the calculation ...
    if ~isempty(Thr)
        DomFreq = DetermineCalcDF(Param.calcdf, Thr.cf, FFTdif.DF, FFTsac.DF);
    else
        DomFreq = DetermineCalcDF(Param.calcdf, NaN, FFTdif.DF, FFTsac.DF);
    end
    if (DomFreq ~= 0)
        DomPer = 1000/DomFreq;
    else
        DomPer = NaN;
    end %Dominant period in ms ...
    
    %Calculating the ratio of the secundary over the primary peak for the SAC and
    %the half height width on the peak (relative to asymptote one)...
    HalfMaxSac = ((max(Ysac)-1)/2)+1;
    SacHHWx = cintersect(T, Ysac, HalfMaxSac);
    SacHHW = abs(diff(SacHHWx));
    [SacPeakRatio, SacXPeaks, SacYPeaks] = getpeakratio(T, Ysac, DomFreq);
    
    %Calculating envelope and Half Height Width of DIFCOR ...
    if strcmpi(Param.envrunavunit, 'ms')
        EnvRunAvN = round(Param.envrunav/Param.corbinwidth);
    else
        EnvRunAvN = round((Param.envrunav*DomPer)/Param.corbinwidth);
    end
    Yenv = runav(abs(hilbert(Ydifcor)), EnvRunAvN); 
    HalfMaxEnv = max(Yenv)/2;
    DifHHWx = cintersect(T, Yenv, HalfMaxEnv);
    DifHHW = abs(diff(DifHHWx));
    
    %Calculating the ratio of the secundary over the primary peak for the DIFCOR
    [DifPeakRatio, DifXPeaks, DifYPeaks] = getpeakratio(T, Ydifcor, DomFreq);
    
    %Calculating the maximum and Half Height Width on the SUMCOR ...
    MaxSum = max(Ysumcor);
    HalfMaxSum = ((MaxSum - 1)/2) + 1;
    SumHHWx = cintersect(T, Ysumcor, HalfMaxSum);
    SumHHW = abs(diff(SumHHWx));
    
    %Performing spectrum analysis on the SUMCOR. Because a sumcor has a prominent
    %DC component in comparison with other correlograms, detrending is necessary
    %to get a representative dominant frequency ...
    FFTsum = spectana(T, detrend(Ysumcor, 'constant'), 'RunAvUnit', 'Hz',...
        'RunAvRange', Param.sumfftrunav);
    FFTsum.Magn.dB = FFTsac.Magn.dB/2;
    
    %Extracting Best and CutOff Frequecy from spectrun of SUMCOR, because the
    %spectrum can be considered as that of a low pass filter ...
    [MaxP, PCutOff, BestFreq, CutOffFreq] = AssessLowPassFilter(FFTsum.Freq,...
        FFTsum.Magn.P(2, :), FFTsum.Magn.dB(2, :), Param.cutofflevel);
    
    %Reorganizing calculated data ...
    CalcData.delay           = T;
    CalcData.ac.normco       = [Ysac; Yxac];
    if Param.ismashed
        CalcData.delaym      = Tm;
        CalcData.ac.normcom  = [Ysacm; Yxacm];
    end
    CalcData.ac.max          = max(Ysac);
    CalcData.ac.saczero      = Ysac(T == 0);
    CalcData.ac.xaczero      = Yxac(T == 0);
    CalcData.ac.zeroratio    = CalcData.ac.xaczero(1)/CalcData.ac.saczero(1);
    CalcData.ac.peakratio    = SacPeakRatio;
    CalcData.ac.peakratiox   = SacXPeaks;
    CalcData.ac.peakratioy   = SacYPeaks;
    CalcData.ac.hhw          = SacHHW;
    CalcData.ac.hhwx         = SacHHWx;
    CalcData.ac.halfmax      = HalfMaxSac;
    CalcData.ac.fft.freq     = FFTsac.Freq;
    CalcData.ac.fft.p        = FFTsac.Magn.P;   
    CalcData.ac.fft.db       = FFTsac.Magn.dB;
    CalcData.ac.fft.df       = FFTsac.DF;
    CalcData.ac.fft.bw       = FFTsac.BW;
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
    CalcData.sum.normco      = Ysumcor;
    CalcData.sum.max         = MaxSum;
    CalcData.sum.hhw         = SumHHW;
    CalcData.sum.hhwx        = SumHHWx;
    CalcData.sum.halfmax     = HalfMaxSum;
    CalcData.sum.fft.freq    = FFTsum.Freq;
    CalcData.sum.fft.p       = FFTsum.Magn.P;   
    CalcData.sum.fft.db      = FFTsum.Magn.dB;
    CalcData.sum.fft.maxp    = MaxP;
    CalcData.sum.fft.pcutoff = PCutOff;
    CalcData.sum.fft.bf      = BestFreq;
    CalcData.sum.fft.cof     = CutOffFreq;
    CalcData.ds1.spkrate     = spkrate1;
    CalcData.ds1.nspike      = nspike1;
    CalcData.ds2.spkrate     = spkrate2;
    CalcData.ds2.nspike      = nspike2;
end

%----------------------------------------------------------------------------
function Y = ApplyNorm(Y, N)
if ~all(Y == 0)
    Y = Y/N.DriesNorm;
else
    Y = ones(size(Y));
end

%----------------------------------------------------------------------------
function DF = DetermineCalcDF(ParamCalcDF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCalcDF)
    if ~isnan(ParamCalcDF)
        DF = ParamCalcDF;
    elseif ~isnan(DifDF)
        DF = DifDF;
    elseif ~isnan(SacDF)
        DF = SacDF;
    else
        DF = ThrCF;
    end
elseif strcmpi(ParamCalcDF, 'cf')
    DF = ThrCF;
elseif strcmpi(ParamCalcDF, 'df')
    if ~isnan(DifDF)
        DF = DifDF;
    else
        DF = SacDF;
    end
else
    DF = NaN;
end

%----------------------------------------------------------------------------
function [MaxP, PCutOff, BestFreq, CutOffFreq] = AssessLowPassFilter(Freq, MagnP, MagndB, CutOffLevel)

MaxP     = max(MagnP);
PCutOff  = MaxP * 10^(-CutOffLevel/10);
BestFreq = getmaxloc(Freq, MagndB);

idx = find((MagndB < -CutOffLevel) & (Freq > BestFreq),1,'first');
if ~isempty(idx) && (idx ~= 1)
    CutOffFreq = interp1(MagndB([idx-1, idx]), Freq([idx-1, idx]), -CutOffLevel);
else
    CutOffFreq = NaN;
end    

%----------------------------------------------------------------------------
function PlotDifCor(Info, StimParam, Thr, Rcn, Param, CalcData)

%Creating frequently used character strings ...
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq),
    [CellNr, TestNr] = unraveldsID(Info.ds1.seqid);
    IDStr = sprintf('%s <%d-%d>@%.0f%s', Info.ds1.filename, CellNr, TestNr,...
        Info.ds1.indepval, Info.ds1.indepunit);
    %Normalisation Coincidence count ...
    NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');
else
    [CellNr1, TestNr1] = unraveldsID(Info.ds1.seqid);
    [CellNr2, TestNr2] = unraveldsID(Info.ds2.seqid);
    IDStr = sprintf('%s <%d-%d-%s>@%.0f%s & <%d-%d-%s>@%.0f%s', Info.ds1.filename,...
        CellNr1, TestNr1, Info.ds1.mashed, Info.ds1.indepval, Info.ds1.indepunit,...
        CellNr2, TestNr2, Info.ds2.mashed, Info.ds2.indepval, Info.ds2.indepunit);
    %Normalisation Coincidence count ...
    NormStr = sprintf('Norm. Count\n(N_{rep}*(N_{rep}-1)*r^2*\\Delta\\tau*D)');
end

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

%Header ...
Str = { IDStr, sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))};
AxHDR = axes('Position', [0.05 0.85 0.45 0.10], 'Visible', 'off');
text(0.5, 0.5, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle',...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 12);

%Extra information ...
AxINF = axes('Position', [0.55 0.85 0.45 0.10], 'Visible', 'off');
if ~isempty(Rcn),
    text(0.0, 0.5, char(Param.str, '', Rcn.str), 'Units', 'normalized',...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'demi', 'FontSize', 9);
else
    text(0.0, 0.5, Param.str, 'Units', 'normalized', 'VerticalAlignment', 'middle',...
        'HorizontalAlignment', 'left', 'FontWeight', 'demi', 'FontSize', 9);
end    
if ~isempty(Thr)
    text(0.625, 0.5, char(Thr.str, '', StimParam.str), 'Units', 'normalized',...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left',...
        'FontWeight', 'demi', 'FontSize', 9);
else
    text(0.625, 0.5, char(sprintf('THR data not present'), '', StimParam.str),...
        'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left', ...
        'FontWeight', 'demi', 'FontSize', 9);
end    

%Plotting SAC and XAC ...
X = CalcData.delay;
Y = CalcData.ac.normco;
[MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.corxrange, Param.corxstep);
AxCOR = axes('Position', [0.10 0.63 0.85 0.165], 'Box', 'off', 'TickDir', 'out');
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq)
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none', 'LineWidth', 2, 'Color', 'b');
    title('SAC', 'FontSize', 12);
    TxtStr =  {sprintf('Max: %.2f', CalcData.ac.max),...
        sprintf('PeakRatio: %.2f', CalcData.ac.peakratio), ...
        sprintf('HHW: %.2fms', CalcData.ac.hhw)};
else
    LnHdl = line(X, Y, 'LineStyle', '-', 'Marker', 'none'); 
    set(LnHdl(1), 'LineWidth', 2, 'Color', 'b');
    set(LnHdl(2), 'LineWidth', 0.5, 'Color', 'g');
    if Param.ismashed
        Xm = CalcData.delaym;
        Ym = CalcData.ac.normcom;
        LnHdlm = line(Xm, Ym, 'LineStyle', '-', 'Marker', 'none'); 
        set(LnHdlm(1), 'LineWidth', 2, 'Color', 'r');
        set(LnHdlm(2), 'LineWidth', 0.5, 'Color', 'c');
    end
    title('SAC and XAC', 'FontSize', 12);
    legend({'SAC', 'XAC'}, 1);
    TxtStr = {sprintf('Max: %.2f', CalcData.ac.max), ...
        sprintf('ZeroValues(SAC/XAC): %.2f/%.2f', CalcData.ac.saczero, CalcData.ac.xaczero), ...            
        sprintf('ZeroRatio: %.2f', CalcData.ac.zeroratio), ...
        sprintf('PeakRatio: %.2f', CalcData.ac.peakratio), ...
        sprintf('HHW: %.2fms', CalcData.ac.hhw)};
end
xlabel('Delay(ms)');
ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.09, 0.5, 0]);
set(AxCOR, 'XLim', [MinX MaxX], 'XTick', XTicks); 
YRange = get(AxCOR, 'YLim'); MinY = YRange(1); MaxY = YRange(2);
PlotPeakRatio(CalcData.ac.peakratiox, CalcData.ac.peakratioy, 'b'); 
LnHdl = plotcintersect(CalcData.ac.hhwx, CalcData.ac.halfmax([1 1]), MinY);
set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
PlotVerZero(MinY, MaxY);
text(MinX, MaxY, TxtStr, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 9);

%Plotting DIFCOR ...
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq),
    AxDIF = CreateEmptyAxis([0.10 0.365 0.375 0.165]);
else
    X = CalcData.delay;
    Y = CalcData.diff.normco; 
    AxDIF = axes('Position', [0.10 0.365 0.375 0.165], 'Box', 'off', 'TickDir', 'out');
    LnHdl = line(X, Y); 
    set(LnHdl(1), 'LineStyle', '-', 'Color', [1 0 0], 'LineWidth', 2);
    set(LnHdl(2), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    set(LnHdl(3), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    title('DIFCOR', 'FontSize', 12);
    xlabel('Delay(ms)');
    ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.15, 0.5, 0]);
    set(AxDIF, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(AxDIF, 'YLim');
    MinY = YRange(1); MaxY = YRange(2);
    PlotVerZero(MinY, MaxY); PlotHorZero(MinX, MaxX);
    PlotPeakRatio(CalcData.diff.peakratiox, CalcData.diff.peakratioy, 'r');
    LnHdl = plotcintersect(CalcData.diff.hhwx, CalcData.diff.halfmax([1 1]), MinY);
    set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    text(MinX, MaxY, {sprintf('Max: %.2f', CalcData.diff.max), ...
        sprintf('PeakRatio: %.2f', CalcData.diff.peakratio), ...
        sprintf('HHW: %.2fms', CalcData.diff.hhw)}, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
        'FontSize', 9);
end

%Plotting SUMCOR ...
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq),
    AxSUM = CreateEmptyAxis([0.575 0.365 0.375 0.165]);    
else
    X = CalcData.delay; Y = CalcData.sum.normco; 
    AxSUM = axes('Position', [0.575 0.365 0.375 0.165], 'Box', 'off', 'TickDir', 'out');
    LnHdl = line(X, Y); 
    title('SUMCOR', 'FontSize', 12);
    xlabel('Delay(ms)'); ylabel(NormStr, 'Units', 'normalized', 'Position', [-0.15, 0.5, 0]);
    set(AxSUM, 'XLim', [MinX MaxX], 'XTick', XTicks);  
    YRange = get(AxSUM, 'YLim'); MinY = 0; MaxY = YRange(2); set(AxSUM, 'YLim', [MinY, MaxY]);
    PlotVerZero(MinY, MaxY);
    LnHdl = plotcintersect(CalcData.sum.hhwx, CalcData.sum.halfmax([1 1]), MinY);
    set(LnHdl(1), 'LineStyle', '-', 'Color', [0 0 0], 'LineWidth', 0.5);
    text(MinX, MaxY, {sprintf('Max: %.2f', CalcData.sum.max), sprintf('HHW: %.2fms', CalcData.sum.hhw)}, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 9);
end

%Plotting discrete fourier transform of DIFCOR or SAC...
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq)
    FFT = CalcData.ac.fft;
    TitleStr = 'DFT on SAC';
else
    FFT = CalcData.diff.fft;
    TitleStr = 'DFT on DIFCOR';
end
X = FFT.freq;
if strcmpi(Param.fftyunit, 'dB')
    Y = FFT.db;
    YLblStr = 'Power (dB, 10 log)'; 
else
    Y = FFT.p;
    YLblStr = 'Power';
end
if ~isnan(FFT.df),
    Ord = floor(log10(FFT.df*2))-1;
    MinX = 0;
    MaxX = round(FFT.df*2*10^-Ord)*10^Ord;
    XTicks = 'auto';
else
    [MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.fftxrange, Param.fftxstep);
end    
[MinY, MaxY] = GetAxisLim('Y', Y, Param.fftyrange);
AxDFT = axes('Position', [0.10 0.10 0.375 0.165], 'Box', 'off', 'TickDir', 'out');
LnHdl = line(X, Y);
set(LnHdl(2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 0.5);
set(LnHdl(1), 'LineStyle', ':', 'Color', 'k', 'LineWidth', 0.5);
title(TitleStr, 'FontSize', 12);
xlabel('Freq(Hz)'); ylabel(YLblStr);
if ~ischar(XTicks)
    set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
else
    set(AxDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY]);
end    
YRange = get(AxDFT, 'YLim');
MinY = YRange(1);
MaxY = YRange(2);
line(FFT.df([1,1]), [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':'); %Vertical line at dominant frequency ...
text(MinX, MaxY, {sprintf('DomFreq: %.2fHz', FFT.df), sprintf('BandWidth: %.2fHz', FFT.bw)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 9);
legend({'Orig', 'RunAv'}, 1);

%Plotting discrete fourier transform of SUMCOR ...
if isequal(Info.ds1.iseq, Info.ds2.iseq) && isequal(Info.ds1.isubseq, Info.ds2.isubseq),
    AxSDFT = CreateEmptyAxis([0.575 0.10 0.375 0.165]);    
else
    X = CalcData.sum.fft.freq; 
    if strcmpi(Param.fftyunit, 'dB'), 
        Y = CalcData.sum.fft.db; 
        YLblStr = 'Power (dB, 10 log)';
        COLevel = -Param.cutofflevel;
    else 
        Y = CalcData.sum.fft.p;
        YLblStr = 'Power'; 
        COLevel = CalcData.sum.fft.pcutoff;
    end
    [MinX, MaxX, XTicks] = GetAxisLim('X', X, Param.fftxrange, Param.fftxstep); 
    [MinY, MaxY] = GetAxisLim('Y', Y, Param.fftyrange);
    AxSDFT = axes('Position', [0.575 0.10 0.375 0.165], 'Box', 'off', 'TickDir', 'out');
    LnHdl = line(X, Y);
    set(LnHdl(2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 0.5);
    set(LnHdl(1), 'LineStyle', ':', 'Color', 'k', 'LineWidth', 0.5);
    title('DFT on SUMCOR', 'FontSize', 12);
    xlabel('Freq(Hz)'); ylabel(YLblStr);
    set(AxSDFT, 'XLim', [MinX MaxX], 'YLim', [MinY MaxY], 'XTick', XTicks); 
    YRange = get(AxSDFT, 'YLim'); MinY = YRange(1);
    MaxY = YRange(2);
    line(CalcData.sum.fft.cof([1 1]), [MinY, COLevel], 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
    line([MinX, CalcData.sum.fft.cof], COLevel([1 1]), 'Color', 'k', 'LineStyle', '-', 'Marker', 'none');
    line(CalcData.sum.fft.bf([1 1]), YRange, 'Color', 'k', 'LineStyle', ':', 'Marker', 'none');
    text(MinX, MinY, {sprintf('BestFreq: %.2fHz', CalcData.sum.fft.bf), sprintf('CutOffFreq: %.2fHz', CalcData.sum.fft.cof)},'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontSize', 9);
    legend({'Orig', 'RunAv'}, 1);
end

%----------------------------------------------------------------------------
function [MinVal, MaxVal, Ticks] = GetAxisLim(AxisType, Values, Range, Step)

if strcmpi(AxisType, 'x'), %Abcissa ...
    Margin = 0.00;
    
    if isinf(Range(1)), MinVal = min(Values(:))*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
    Ticks = MinVal:Step:MaxVal;
else %Ordinate ...    
    Margin = 0.05;
    
    if isinf(Range(1)), MinVal = min([0; Values(:)])*(1-Margin); else MinVal = Range(1); end
    if isinf(Range(2)), MaxVal = max(Values(:))*(1+Margin); else MaxVal = Range(2); end
end

%----------------------------------------------------------------------------
function PlotPeakRatio(XPeaks, YPeaks, Color)

line(XPeaks, YPeaks, 'Color', Color, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 12); 

%----------------------------------------------------------------------------
function PlotVerZero(MinY, MaxY)

line([0, 0], [MinY, MaxY], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------
function PlotHorZero(MinX, MaxX)

line([MinX, MaxX], [0, 0], 'Color', [0 0 0], 'LineStyle', ':');

%----------------------------------------------------------------------------
function AxHdl = CreateEmptyAxis(Pos)

%Create axis object ... 
AxHdl = axes('Position', Pos, 'Box', 'on', 'Color', [0.8 0.8 0.8], 'Units', 'normalized', ...
    'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);

%Create Text object ...
TxtHdl = text(0.5, 0.5, sprintf('No plot to be\ngenerated'));
set(TxtHdl, 'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'center', ...
             'Color', 'k', ...
             'FontAngle', 'normal', ...
             'FontSize', 12, ...
             'FontWeight', 'normal');
         
%----------------------------------------------------------------------------        