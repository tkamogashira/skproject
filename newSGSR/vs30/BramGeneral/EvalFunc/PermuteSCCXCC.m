function ArgOut = PermuteSCCXCC(varargin)
%PERMUTESCCXCC  calculate crosscorrelogram of all permutations.
%   PERMUTESCCXCC calculates crosscorrelograms of all permutations of two
%   inputs from a given list of inputs. The inclusion list must be a text
%   file and is 'PERMUTESCCXCC.LST' by default (located in the same directory
%   as this file). See this file for more information on the format to be
%   used. A structure-array is returned where each row corresponds to a
%   different permutation.
%   
%   PERMUTESCCXCC('FOO.LST') uses the file 'FOO.LST' to determine the inputs
%   to include in the calculations.
%   
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 28-07-2005

%Attention! STRUCTFILTER can be used on the returned table to select only those
%permutations where the reference or first input to the correlation function is
%tuned to a lower frequency. The user is free to choose between CF or DF as 
%measure for the tuning of an input ...

%-------------------------------default parameters---------------------------
%The following two properties cannot be altered by the user using the property/
%value system, but must be set in the program code ...
DefParam.evalfncname    = 'evalsccxcc';
DefParam.evalfncproplst = {'plot', 'no', 'subseqinput', 'indepval'};
%Fields to include in the resulting structure-array ...
DefParam.incfields      = {'ds1p.filename', 'ds1p.icell', 'ds1p.iseq', 'ds1p.seqid', ...
        'ds1p.isubseq', 'ds1n.iseq', 'ds1n.seqid', 'ds1n.isubseq', 'ds2p.filename', ...
        'ds2p.icell', 'ds2p.iseq', 'ds2p.seqid', 'ds2p.isubseq', 'ds2n.iseq', 'ds2n.seqid', ...
        'ds2n.isubseq', 'tag', 'stim.avgspl1', 'stim.avgspl2', 'stim.avgspl', 'thr1.cf', ...
        'thr1.sr', 'thr2.cf', 'thr2.sr', 'rc1.mean', 'rc2.mean', 'sac1.max', 'sac1.fft.df', ...
        'dac1.max', 'dac1.fft.df', 'sac2.max', 'sac2.fft.df', 'dac2.max', 'dac2.fft.df', ...
        'scc.max', 'scc.lagatmax', 'scc.maxsecpks', 'scc.lagsecpks', 'scc.fft.df', 'dcc.max', ...
        'dcc.rate', 'dcc.lagatmax', 'dcc.maxsecpks', 'dcc.lagsecpks', 'dcc.fft.df', 'dcc.fft.bw', ...
        'dcc.env.lagatmax', 'dcc.env.hhw'};
%Memory limit in megabytes which cannot be exceeded while calculating the cross-
%correlograms ...
DefParam.limitmem       = 'no';
DefParam.maxmemsize     = 25;
DefParam.tmpfilename    = mfilename;
DefParam.tmpdir         = tempdir;

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
else, [LstFileName, Param, CalcParam] = ParseArgs(DefParam, varargin{:}); end

%Loading inclusion list ...
IncList = LoadIncList(LstFileName); N = length(IncList);

%Calculation of crosscorrelogram of all two-element permutations ...
[Hdl, S, FileList] = InitializeCalc(LstFileName);
Ntotal = N*(N-1); Ncount = 0;
for i = 1:N, for j = setdiff(1:N, i),
    try,
        [ds1p, ds1n] = LoadDataSets(IncList(i));
        [iSubSeq1p, iSubSeq1n] = deal(IncList(i).indepvalp, IncList(i).indepvaln);
        [ds2p, ds2n] = LoadDataSets(IncList(j));
        [iSubSeq2p, iSubSeq2n] = deal(IncList(j).indepvalp, IncList(j).indepvaln);
        T = feval(Param.evalfncname, ds1p, iSubSeq1p, ds1n, iSubSeq1n, ds2p, iSubSeq2p, ds2n, iSubSeq2n, CalcParam);
        S = [S; ReduceFields(T, Param.incfields)];
    catch, warning(lasterr); end
    
    if strcmpi(Param.limitmem, 'yes'), [S, FileList] = CheckMemory(S, FileList, Param); end
    
    Ncount = Ncount + 1;
    if ishandle(Hdl), waitbar(Ncount/Ntotal, Hdl); else, InterruptCalc(Hdl, FileList); end
end; end
if ishandle(Hdl), close(Hdl); end

%Return structure-array or filename list ...
if strcmpi(Param.limitmem, 'yes'),
    FileList = FinalizeCalc(S, FileList, Param);
    if (nargout > 0), ArgOut = FileList; end
elseif (nargout > 0), ArgOut = S; end

%----------------------------------------------------------------------------
function [LstFileName, Param, CalcParam] = ParseArgs(DefParam, varargin)

%Retrieve filename of inclusion list ...
Nargs = length(varargin);
if ~mod(Nargs, 2), %Even number of input arguments ...
    LstFileName = lower(fullfile(fileparts(which(mfilename)), [mfilename, '.lst']));
    PropIdx = 1;
else, %Odd number ...
    ErrMsg = 'First argument must be filename of inclusion list to be used.';
    
    LstFileName = varargin{1}; PropIdx = 2;
    if ~ischar(LstFileName) | (size(LstFileName, 1) ~= 1), error(ErrMsg); end
    
    [Path, FileName, FileExt] = fileparts(LstFileName);
    if isempty(FileName), error(ErrMsg); end
    if isempty(FileExt), FileExt = '.lst'; end
    if isempty(Path), Path = fileparts(which([FileName, FileExt])); end
    
    LstFileName = lower(fullfile(Path, [FileName, FileExt]));
end
if ~exist(LstFileName, 'file'), error(sprintf('Inclusion list ''%s'' doesn''t exist.', LstFileName)); end

%Check property/value list ...
[EvalFncName, EvalFncPropLst] = deal(DefParam.evalfncname, DefParam.evalfncproplst);

DefParam  = rmfield(DefParam, {'evalfncname', 'evalfncproplst'}); 
CalcParam = rmfield(feval(EvalFncName, 'factory'), EvalFncPropLst(1:2:end)); 

Param = CheckPropList(structcat(DefParam, CalcParam), varargin{PropIdx:end});

CalcParam = getfields(Param, fieldnames(CalcParam));
CalcParam = structcat(CalcParam, struct(EvalFncPropLst{:}));
feval(EvalFncName, 'checkprops', CalcParam);

Param = structcat(createstruct('evalfncname', EvalFncName, 'evalfncproplst', EvalFncPropLst), getfields(Param, fieldnames(DefParam)));
CheckParam(Param);

%----------------------------------------------------------------------------
function CheckParam(Param)

if ~any(strcmpi(Param.limitmem, {'yes', 'no'})), error('Property limitmem must be ''yes'' or ''no''.'); end
if ~isnumeric(Param.maxmemsize) | (length(Param.maxmemsize) ~= 1) | (Param.maxmemsize <= 0), error('Invalid value for property maxmemsize.'); end
if ~ischar(Param.tmpfilename) | (size(Param.tmpfilename, 1) ~= 1), error('Invalid value for property tmpfilename'); end
[Path, FileName, FileExt] = fileparts(Param.tmpfilename);
if ~isempty(Path), error('Property tmpfilename cannot include path information.'); end
if ~isempty(FileExt), error('Property tmpfilename cannot include file extension information.'); end
if isempty(FileName), error('Property tmpfilename must be a valid filename.'); end
if ~ischar(Param.tmpdir) | (size(Param.tmpdir, 1) ~= 1), error('Invalid value for property tmpdir.'); end
if ~exist(Param.tmpdir, 'dir'), error('Directory supplied by tmpdir property dosen''t exist.'); end
if ~iscellstr(Param.incfields) & ~ischar(Param.incfields), error('Property incfields must be string or cell-array of strings.'); end

%----------------------------------------------------------------------------
function S = LoadIncList(ListFileName)
%Load inclusion list from file into structure-array ...

try, [FileName, iSeqP, IndepValP, iSeqN, IndepValN] = textread(ListFileName, '%s%d%f%d%f', 'commentstyle', 'matlab');
catch, error(sprintf('Inclusion list ''%s'' has invalid format:\n%s.', ListFileName, lasterr)); end

idx = find(xor(isnan(iSeqN), isnan(IndepValN)))+1;
if ~isempty(idx), error(sprintf('Inclusion list ''%s'' has invalid format:\nSequence and subsequence number must be both NaN (row %d).', ListFileName, idx)); end

N = length(FileName); S = struct('filename', '', 'iseqp', [], 'indepvalp', [], 'iseqn', [], 'indepvaln', []);
S = repmat(S, N, 1);

FileName = lower(FileName); [S.filename] = deal(FileName{:});
Args = num2cell(iSeqP); [S.iseqp] = deal(Args{:});
Args = num2cell(IndepValP); [S.indepvalp] = deal(Args{:});
Args = num2cell(iSeqN); [S.iseqn] = deal(Args{:});
Args = num2cell(IndepValN); [S.indepvaln] = deal(Args{:});

%----------------------------------------------------------------------------
function [Hdl, S, FNlist] = InitializeCalc(LstFileName)

%Setup progression bar ...
[dummy, FileName, FileExt] = fileparts(LstFileName); DispName = upper([FileName, FileExt]);
Hdl = waitbar(0, sprintf('Assembling table for %s ...', DispName), 'Name', upper(mfilename), 'CreateCancelBtn', 'delete(gcf);');

%Create empty structure-array and list of filenames ...
S = []; FNlist = cell(0);

%----------------------------------------------------------------------------
function [S, FNlist] = CheckMemory(S, FNlist, Param)

MbSize = getfield(whos('S'), 'bytes')*2^-20;
if (MbSize >= Param.maxmemsize),
    FileExt = '.mat';
    FileName = sprintf('%s_%d', Param.tmpfilename, length(FNlist)+1);
    FullFileName = fullfile(Param.tmpdir, [FileName, FileExt]);
    save(FullFileName, 'S'); S = [];
    FNlist = [FNlist, {FullFileName}];
end

%----------------------------------------------------------------------------
function InterruptCalc(Hdl, FileList)

if ishandle(Hdl), close(Hdl); end
N = length(FileList); for n = 1:N, delete(FileList{n}); end
error('Calculation interrupted by user.');

%----------------------------------------------------------------------------
function FNlist = FinalizeCalc(S, FNlist, Param)

FileExt = '.mat';
FileName = sprintf('%s_%d', Param.tmpfilename, length(FNlist)+1);
FullFileName = fullfile(Param.tmpdir, [FileName, FileExt]);
save(FullFileName, 'S');
FNlist = [FNlist, {FullFileName}];

%----------------------------------------------------------------------------
function [dsP, dsN] = LoadDataSets(ListEntry)
%Load datasets for a given inclusion list entry ...

try,
    if ~isnan(ListEntry.iseqp), dsP = dataset(ListEntry.filename, ListEntry.iseqp);
    else, dsP = dataset; end
catch, error(sprintf('Could not load dataset ''%s''(%d).', ListEntry.filename, ListEntry.iseqp)); end
try, 
    if ~isnan(ListEntry.iseqn), dsN = dataset(ListEntry.filename, ListEntry.iseqn);
    else, dsN = dataset; end    
catch, error(sprintf('Could not load dataset ''%s''(%d).', ListEntry.filename, ListEntry.iseqn)); end

%----------------------------------------------------------------------------
function S = ReduceFields(S, IncFields)

%Return structure with order of fieldnames as requested ...
[Data, FieldNames] = destruct(S);
N = length(IncFields); idx = zeros(1, N);
for n = 1:N, 
    tmpidx = find(strcmpi(FieldNames, IncFields{n}));
    if isempty(tmpidx), idx(n) = NaN; else, idx(n) = tmpidx; end 
end
S = construct(Data(:, denan(idx)), FieldNames(denan(idx)));

%----------------------------------------------------------------------------