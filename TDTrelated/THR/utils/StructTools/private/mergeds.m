function ds = MergeDS(varargin)
%MERGEDS  merge dataset objects
%   DS = MERGEDS(DS1, SubSeqs1, DS2, SubSeqs2, ..., DSN, SubSeqsN) merges
%   subsequences of multiple datasets recorded from the same cell or fiber
%   with exactly the same stimulus parameters and number of repetitions. If
%   the repetition numbers are different then merging will include only those
%   repetitions which are present in all datasets.
%
%   DS = MERGEDS(DS1, DS2, ..., DSN) merges subsequences of multiple datasets
%   if the values for the independent variable are different. The same 
%   restrictions apply as in the previous case. If the values of the independent
%   variable are the same then the repetitions of the datasets are merged.
%   This can only be done if datasets were recorded from the same cell or fiber
%   and with exactly the same stimulus parameters and with the same values of the
%   independent variable, except for a possible difference in repetition numbers.
%   In the latter case the values of the independent variable are always sorted.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also MANAGEMDF, MDF2LUT and ISMDF

%B. Van de Sande 13-09-2005

%-----------------------------default parameters---------------------------
DefParam.iseq        = 0;          %sequence number in datafile ...
DefParam.subseqinput = 'indepval'; %'indepval' or 'subseq' ...
DefParam.sortsubseqs = 'yes';      %'yes' or 'no' ...
DefParam.numtol      = 1e-3;       %numerical tolerance (NaN for no tolerance) ...

%--------------------------------------------------------------------------
%Parsing input parameters ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
else, [DSarray, SubSeqs, Param] = ParseArgs(DefParam, varargin{:}); end

%Actual merging of datasets ...
ID = MergeIDField(Param, DSarray);

if isempty(SubSeqs), [Sizes, Data] = MergeReps(DSarray);
else, [Sizes, Data] = MergeSubSeqs(DSarray, SubSeqs); end

[IndepVar, SIdx] = MergeIndepVar(Param, DSarray, SubSeqs);
Data.SpikeTimes = Data.SpikeTimes(SIdx, :);
Special = MergeSpecial(DSarray, SubSeqs, SIdx);
StimParam = MergeStimParam(DSarray);
Stimulus = CollectInStruct(IndepVar, Special, StimParam);

%Settings-field isn't merged for debugging purposes ...
Settings.SessionInfo  = {DSarray.session};
Settings.RecordParams = {DSarray.recparam};

ds = dataset(CollectInStruct(ID, Sizes, Data, Stimulus, Settings), 'convert');

%--------------------------local functions----------------------------
function [DSarray, SubSeqs, Param] = ParseArgs(DefParam, varargin)

NArgs = length(varargin);
FirstPropIdx = min(find(cellfun('isclass', varargin, 'char')));
if isempty(FirstPropIdx), FirstPropIdx = NArgs+1; end

Param = CheckPropList(DefParam, varargin{FirstPropIdx:end});
CheckParam(Param);

DSIdx = find(cellfun('isclass', varargin(1:FirstPropIdx-1), 'dataset') | ...
    cellfun('isclass', varargin(1:FirstPropIdx-1), 'edfdataset')); 
NDS = length(DSIdx);
SubSeqsIdx = find(cellfun('isclass', varargin(1:FirstPropIdx-1), 'double')); NSubSeqs = length(SubSeqsIdx);

try, DSarray = [varargin{DSIdx}]; catch, error('Datasets of different stimulus types can never be merged.'); end

%DS = MERGEDS(DS1, SubSeqs1, DS2, SubSeqs2, ..., DSN, SubSeqsN)
if isequal(NDS, NSubSeqs) & isequal(union(DSIdx, SubSeqsIdx), 1:(2*NDS)) & isequal(DSIdx+1, SubSeqsIdx),
    ReqInput = varargin(SubSeqsIdx); SubSeqs = cell(0);
    if strcmpi(Param.subseqinput, 'indepval'),
        for n = 1:NDS, 
            if ~all(ismember(ReqInput{n}, ApplyTolerance(DSarray(n).xval(1:DSarray(n).nrec), Param.numtol))), 
                error('Not all requested subsequences for a dataset exist or were recorded.'); 
            else, SubSeqs{n} = find(ismember(ApplyTolerance(DSarray(n).xval(1:DSarray(n).nrec), Param.numtol), ReqInput{n})); end; 
        end
    else,
        for n = 1:NDS, if ~all(ismember(ReqInput{n}, 1:DSarray(n).nrec)), error('Not all requested subsequences for a dataset exist or were recorded.'); end; end
        SubSeqs = ReqInput;
    end
%DS = MERGEDS(DS1, DS2, ..., DSN)
elseif isequal(NSubSeqs, 0) & isempty(SubSeqsIdx) & all(ismember(DSIdx, 1:NDS)),
    for n = 1:NDS, IndepVals{n} = denan(sort(DSarray(n).indepval)); end
    if isequal(IndepVals{:}), SubSeqs = cell(0);
    else, for n = 1:NDS, SubSeqs{n} = 1:DSarray(n).nrec; end; end
else, error('Syntax error'); end

%---------------------------------------------------------------------
function CheckParam(Param)

if ~isnumeric(Param.iseq) | (length(Param.iseq) ~= 1) | (Param.iseq < 0), error('Invalid value for property iseq.'); end
if ~any(strcmpi(Param.sortsubseqs, {'yes', 'no'})), error('Property sortsubseqs must be ''yes'' or ''no''.'); end
if ~any(strcmpi(Param.subseqinput, {'indepval', 'subseq'})), error('Property subseqinput must be ''indepval'' or ''subseq''.'); end
if ~isnumeric(Param.numtol) | (length(Param.numtol) ~= 1) | (Param.numtol <= 0), error('Invalid value for property numtol.'); end

%---------------------------------------------------------------------
function Value = ApplyTolerance(Value, Tol)

if ~isnan(Tol), Value = round(Value/Tol)*Tol; end

%---------------------------------------------------------------------
function ID = MergeIDField(Param, DSarray)

FileName = upper({DSarray.FileName});
if ~isequal(FileName{:}), error('Datasets originate from different experiments.');
else, FileName = [FileName{1} '-MERGE']; end    

FileFormat   = 'MDF';
%The FullFileName-field normally contains a reference to the original datafile from
%which the dataset was extracted, so this field becomes obsolete ...
FullFileName = ''; 
%Sequence number is only practical when merged datasets are saved to disk in a new
%datafile ...
iSeq         = Param.iseq;         

%For EDF-datasets the name of the schemas must be equal for all datasets that are
%merged, for SGSR- and IDF/SPK-datasets the stimulus type must be the same ...
if strcmpi(class(DSarray), 'edfdataset'),
    SchName = upper({DSarray.SchName});
    if ~isequal(SchName{:}), error('Datasets have different schema type.');
    else, StimType = upper(DSarray(1).StimType); end
else,
    StimType = upper({DSarray.StimType});
    if ~isequal(StimType{:}), error('Datasets have different stimulus types.');
    else, StimType = StimType{1}; end    
end

%Cell number and sequence identifier from the first dataset given is used
%and the original comments from this dataset are also preserved. The sequence
%identifier doesn't need to contain information about the merge procedure. This
%is already present in the name of the datafile and in the datafile format ...
iCell = unique(cat(2, DSarray.iCell));
if (length(iCell) ~= 1), 
    warning('Datasets were recorded from different cells or fibers.'); 
    iCell = char2num(DSarray(1).seqID, 1, '-');
end    
SeqID = DSarray(1).seqID;

Time = round(datevec(now)); Time([1, 3]) = Time([3, 1]);
if inLeuven, Place = ['Leuven/' compuname]; 
elseif inUtrecht, Place = ['Utrecht/' compuname]; 
else Place = ['**/' compuname]; end

Experimenter = '';

%Extra field is added with all ID-fields of the original datasets ...
OrigID = cat(1, DSarray.ID);

ID = CollectInStruct(FileName, FileFormat, FullFileName, iSeq, StimType, iCell, SeqID, Time, ...
    Place, Experimenter, OrigID);

%---------------------------------------------------------------------
function [Sizes, Data] = MergeSubSeqs(DSarray, SubSeqs)

Data = cat(1, DSarray.Data);

Nreps = cellfun('size', {Data.SpikeTimes}, 2);
if (length(unique(Nreps)) ~= 1), warning('Reducing number of repetitions for some datasets.'); end
Nrep = min(Nreps);
[Nsub, NsubRecorded] = deal(sum(cellfun('length', SubSeqs)));

Sizes = CollectInStruct(Nsub, NsubRecorded, Nrep);

NDS = length(DSarray); SpikeTimes = cell(0);
for n = 1:NDS, SpikeTimes = [SpikeTimes; Data(n).SpikeTimes(SubSeqs{n}, 1:Nrep)]; end    

%OtherData-field of the datasets to be merged is concatenated to a structure array. If
%they are empty for all datasets then this field will stay empty in the merged dataset ...
if ~all(cellfun('isempty', {Data.OtherData})), warning('Some of the datasets contain data other then spiketimes.'); end
OtherData = cat(1, Data.OtherData);

Data = CollectInStruct(SpikeTimes, OtherData);

%---------------------------------------------------------------------
function [Sizes, Data] = MergeReps(DSarray)

Data = cat(1, DSarray.Data);

if (length(unique(cat(2, DSarray.nsub))) ~= 1), error('Number of subsequences aren''t equal for all datasets.');
else, Nsub = DSarray(1).nsub; end
NsubRecorded = max(cat(2, DSarray.nrec));
Nrep = sum(cellfun('size', {Data.SpikeTimes}, 2));

Sizes = CollectInStruct(Nsub, NsubRecorded, Nrep);

NDS = length(DSarray); SpikeTimes = cell(0);
for n = 1:NDS,
    [dummy, SIdx] = sort(DSarray(n).indepval);
    SpikeTimes = [SpikeTimes, Data(n).SpikeTimes(SIdx, :)];    
end
%OtherData-field of the datasets to be merged is concatenated to a structure array. If
%they are empty for all datasets then this field will stay empty in the merged dataset ...
if ~all(cellfun('isempty', {Data.OtherData})), warning('Some of the datasets contain data other then spiketimes.'); end
OtherData = cat(1, Data.OtherData);

Data = CollectInStruct(SpikeTimes, OtherData);

%---------------------------------------------------------------------
function [IndepVar, SIdx] = MergeIndepVar(Param, DSarray, SubSeqs);

IndepVar = descstruct(cat(1, DSarray.Stimulus), 'IndepVar');

Name = {IndepVar.Name};
if ~isequal(Name{:}), error('Datasets have different independent variables.'); 
else, Name = Name{1}; end

ShortName = IndepVar(1).ShortName;

if isempty(SubSeqs), Values = IndepVar(1).Values;
else,
    NDS = length(DSarray); Values = [];
    for n = 1:NDS, Values = [Values; reshape(IndepVar(n).Values(SubSeqs{n}), length(SubSeqs{n}), 1)]; end
end
uValues = unique(Values);
if ~isequal(sort(Values), uValues), warning('Duplicate values for independent variable.');
elseif (length(unique(diff(uValues))) ~= 1), warning('Values of independent variable in merged datasets don''t have a fixed increment.'); end

if isempty(SubSeqs) | strcmpi(Param.sortsubseqs, 'yes'), [Values, SIdx] = sort(Values); 
else, SIdx = 1:length(Values); end

Unit = IndepVar(1).Unit;
PlotScale = IndepVar(1).PlotScale;

IndepVar = CollectInStruct(Name, ShortName, Values, Unit, PlotScale);

%---------------------------------------------------------------------
function Special = MergeSpecial(DSarray, SubSeqs, SIdx)

if (length(unique(cat(2, DSarray.dachan))) ~= 1), error('Number of active channels is different for datasets.');
else, ActiveChan = DSarray(1).dachan; end

RepDurs = {DSarray.repdur};
if ~isequal(RepDurs{:}), error('Repetition duration is different for datasets.');
else, RepDur = DSarray(1).RepDur; end

BurstDurs = {DSarray.burstdur};
if ~isequal(BurstDurs{:}), error('Stimulus duration is different for datasets.');
else, BurstDur = DSarray(1).BurstDur; end

CarFreqs     = {DSarray.carfreq};
ModFreqs     = {DSarray.modfreq};
if isempty(SubSeqs),
    if isEqualIncNaNs(CarFreqs{:}), 
        CarFreq = CarFreqs{1}; 
        if (size(CarFreq, 1) > 1), CarFreq = CarFreq(SIdx, :); end
    else, error('Carrier frequency is different for datasets.'); end

    if isEqualIncNaNs(ModFreqs{:}), 
        ModFreq = ModFreqs{1};
        if (size(ModFreq, 1) > 1), ModFreq = ModFreq(SIdx, :); end
    else, error('Modulation frequency is different for datasets.'); end
else,
    NDS = length(SubSeqs);

    if any(cellfun('size', CarFreqs, 1) > 1),
        CarFreq = [];
        for n = 1:NDS, CarFreq = [CarFreq; CarFreqs{n}(SubSeqs{n}, :)]; end
        CarFreq = CarFreq(SIdx, :);
    elseif isEqualIncNaNs(CarFreqs{:}), CarFreq = CarFreqs{1};
    else, error('Carrier frequency is different for datasets.'); end
    
    if any(cellfun('size', ModFreqs, 1) > 1),
        ModFreq = [];
        for n = 1:NDS, ModFreq = [ModFreq; ModFreqs{n}(SubSeqs{n}, :)]; end
        ModFreq = ModFreq(SIdx, :);
    elseif isEqualIncNaNs(ModFreqs{:}), ModFreq = ModFreqs{1};
    else, error('Modulation frequency is different for datasets.'); end
end
BeatFreq    = CarFreq(:,end)-CarFreq(:,1);
BeatModFreq = ModFreq(:,end)-ModFreq(:,1);

Special = CollectInStruct(RepDur, BurstDur, CarFreq, ModFreq, BeatFreq, ...
    BeatModFreq, ActiveChan);

%---------------------------------------------------------------------
function StimParam = MergeStimParam(DSarray)

StimParam = descstruct(cat(1, DSarray.Stimulus), 'StimParam');
[DiffFNames, DiffVal] = StructArrayCmp(StimParam);
NFields = length(DiffFNames); NDS = length(DSarray);
if (NFields > 0),
    Nindent  = 5;
    MaxWidth = size(char(DiffFNames), 2) + Nindent;
    
    warnmsg = repmat([blanks(MaxWidth), ': '], NFields, 1);
    for n = 1:NFields,
        FName = DiffFNames{n}; Len = length(FName);
        warnmsg(n, MaxWidth-Len+1:MaxWidth) = FName;
    end
    for n = 1:(NDS-1), warnmsg = [warnmsg, Val2Str(DiffVal(:, n)), repmat(', ', NFields, 1)]; end    
    warnmsg = [warnmsg, Val2Str(DiffVal(:, end))];
    warnmsg = strvcat('The following stimulus parameters are different:', warnmsg);
    warnmsg = [warnmsg, repmat(sprintf('\n'), (NFields+1), 1)];
    warnmsg = warnmsg'; warnmsg = warnmsg(1:end-1)';
    warning(warnmsg);
end    

StimParam = DSarray(1).StimParam;

%---------------------------------------------------------------------
function [FN, V] = StructArrayCmp(S)

[FN, V] = deal(cell(0)); C = num2cell(S);

if ~isequal(C{:}),
   FNames  = fieldnames(S(1)); NFields = length(FNames);
   for n = 1:NFields,
      Vals = eval(sprintf('{S.%s};', FNames{n}));
      if isstruct(Vals{1}),
          if (length(Vals{1}) > 1),
              warning('Dataset contains structure-array in StimParam-field. Not comparing these fields.');
          else,    
              [FNadd, Vadd] = StructArrayCmp(cat(2, Vals{:})); %Recursion ...
              FN = [FN(:); FNadd]; V = [V; Vadd];
          end    
      elseif iscell(Vals{1}) & (length(Vals{1}) == 2) & all(cellfun('isclass', Vals{1}, 'struct')),
          Arg = []; for i = 1:length(Vals), Arg = [Arg, Vals{i}{1}]; end
          [FNadd1, Vadd1] = StructArrayCmp(Arg);
          FNAdd1 = AddChannel(FNadd1, 1);
          Arg = []; for i = 1:length(Vals), Arg = [Arg, Vals{i}{2}]; end
          [FNadd2, Vadd2] = StructArrayCmp(Arg);
          FNAdd2 = AddChannel(FNadd2, 2);
          FN = [FN(:); FNadd1; FNadd2]; V = [V; Vadd1; Vadd2];
      elseif ~isEqualIncNaNs(Vals{:}),
          FN = [FN(:); FNames(n)]; V = [V; Vals];
      end
   end
end

%---------------------------------------------------------------------
function Str = Val2Str(Vals)

N = length(Vals); Str = '';
for n = 1:N,
    ClassType = class(Vals{n});
    switch ClassType
    case 'double', Str = strvcat(Str, mat2str(Vals{n}));
    otherwise,     Str = strvcat(Str, sprintf('<%s>', ClassType)); end
end

%---------------------------------------------------------------------
function FN = AddChannel(FN, Nr)

N = length(FN);
for n = 1:N, FN{n} = [FN{n}, ' (#', int2str(Nr) ')']; end

%---------------------------------------------------------------------
function boolean = isEqualIncNaNs(varargin)

if (nargin == 1), error('Not enough input arguments.'); end

if any(~cellfun('isclass', varargin, 'double')), boolean = isequal(varargin{:});
elseif ~all(cellfun('isclass', varargin, 'double')), boolean = logical(0);
else,
    Sz = size(varargin{1});
    idxNaN = find(isnan(varargin{1}));
    NotNaNValues = varargin{1}(setdiff(1:numel(varargin{1}), idxNaN));
    
    boolean = logical(1); n = 2;
    while boolean & (n <= nargin),
        curArg = varargin{nargin};
        curNotNaNValues = curArg(find(~isnan(curArg(:))));
        boolean = isequal(size(curArg), Sz) & isequal(idxNaN, find(isnan(curArg))) & ...
            isequal(curNotNaNValues(:), NotNaNValues(:));
        n = n + 1;
    end
end

%---------------------------------------------------------------------