function EDFds = EDFdataset(varargin)
%EDFDATASET EDF dataset constructor
%   DS = EDFDATASET(FileName, dsID or iSeq) loads a data set from an EDF datafile with name FileName into
%   memory. The data set in the datafile must be specified by its unique identifier or ist sequence number.
%
%   See also VIEWEDF, EDF2LUT, DATASET

%B. Van de Sande 09-07-2004

%Constructor with no arguments creates empty object ...
if nargin == 0
    EDFds = class(createEmptyEDFdataset, 'EDFdataset', dataset);
    return
elseif nargin == 1 && isa(varargin{1}, 'EDFdataset')
    EDFds = varargin{1};
    return %Copy constructor ...
    
    % - by abelius: generate EDFdataset object from struct
elseif nargin == 2 && isstruct(varargin{1}) && isequal('convert', lower(varargin{2}))
    EDFds = struct2EDFdataset(varargin{1});
    return
    % - end abelius 
    
elseif nargin ~= 2
    error('Wrong number of input arguments.');
end

%Creation of dataset object from data on disk ...
%Variables after parsing are LUT, HDR, dsID, iSeq, FileName and FullFileName
[FullFileName, FileName] = parseEDFFileName(varargin{1});
if ~exist(FullFileName, 'file')
    error('First argument should be name of EDF.');
end

[LUT, HDR] = EDF2LUT(FileName);

switch class(varargin{2})
    case 'char'
        dsID = lower(varargin{2});
        iSeq = find(strcmp(cellstr(char(LUT.IDstr)), dsID));
        if isempty(iSeq)
            error('Dataset with ID %s doesn''t exist in %s.', dsID, FileName);
        end
    case 'double'
        iSeq = varargin{2};
        NElem = numel(iSeq);
        if NElem > 1  %Multiple sequences with same schema requested ...
            EDFds = [];
            for n = 1:NElem
                EDFds = [EDFds; EDFdataset(FileName, iSeq(n))];
            end
            EDFds = reshape(EDFds, size(iSeq));
            return;
        else
            if iSeq <= 0 || iSeq > HDR.NEntries
                error(sprintf('%d is not a valid sequence number for %s.', iSeq, FileName));
            end
            dsID = LUT(iSeq).IDstr;
        end
    otherwise
        error('Second argument should be dataset ID or sequence number of dataset that needs to be converted.');
end

%Caching system only implemented for slower machines, because on SIKIO and computers with a comparable configuration
%loading of datasets never takes more than 200 millisec (on average about 120 ms) ...
% [dummy, CacheFileName] = fileparts(mfilename);
% SearchParam = CollectInStruct(FileName, iSeq);
% EDFds = FromCacheFile(CacheFileName, SearchParam);
% if ~isempty(EDFds), return; end

%Load dataset information according to schema name ...
fid = fopen(FullFileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open file %s.', FullFileName);
end

DsLoc = LUT(iSeq).DsLoc;
SchName = LUT(iSeq).SchName;

DsHdr = readEDFDsHeader(fid, DsLoc);                %Reading mandatory dataset header ...
if ~strcmpi(DsHdr.DsID, LUT(iSeq).IDstr) || ~strcmpi(DsHdr.ExpType, LUT(iSeq).ExpType) || ...
        ~strcmpi(DsHdr.SchName, LUT(iSeq).SchName)
    error('Incompatibility between directory entry and dataset header for dataset with ID %s in EDF %s.', dsID, FileName);
end
[DsData, Err] = readEDFDsData(fid, DsLoc, SchName); %Reading dataset datafields ...
switch Err
    case 1
        error('Dataset with ID %s in EDF %s has %s as schema type. This type of schema is not yet implemented.', dsID, FileName, LUT(iSeq).SchName);
    case 2
        error('Error while trying to read schema type %s from dataset with ID %s in EDF %s.', LUT(iSeq).SchName, dsID, FileName);
end

SchData = structcat(DsHdr, DsData);

switch SchName
    case 'calib'
        %Reorganize schema data and extracting calibration curves ...
        CalibParam = extractSCHCalibParam(SchData);
        IndepVarParam = extractSCHIndepVarParam(SchData);
        IndepVal   = IndepVarParam.Values;
        IndepRange = length(IndepVal);

        %Assembling fields of SGSR dataset object ...
        ID    = assembleDSfieldID(FileName, FullFileName, LUT(iSeq));
        Sizes = assembleDSfieldSizes(IndepRange, IndepRange, CalibParam.Nharm);

        Data.SpikeTimes = [];
        Data.OtherData.calibCurve.freq      = IndepVal';
        Data.OtherData.calibCurve.magnitude = DsData.DATA.CALDAT.SPLMAX;
        Data.OtherData.calibCurve.phase     = DsData.DATA.CALDAT.PHASE;

        IndepVar.Name      = 'Frequency';
        IndepVar.ShortName = 'Frequency';
        IndepVar.Values    = IndepVal;
        IndepVar.Unit      = 'Hz';
        IndepVar.PlotScale = 'linear';

        Special.RepDur      = NaN;
        Special.BurstDur    = NaN;
        Special.CarFreq     = IndepVal;
        Special.ModFreq     = NaN;
        Special.BeatFreq    = NaN;
        Special.BeatModFreq = NaN;
        Special.ActiveChan  = CalibParam.DSSNr;

        StimParam = CalibParam;
        Stimulus = CollectInStruct(IndepVar, Special, StimParam);

        Settings = assembleDSfieldSettings;

        %Assembling extra fields for EDF dataset object ...
        TimerNrs    = []; NTimers = 0;
        DSS         = assembleDSfieldDSS(struct('Nr', 1, 'MasterNr', CalibParam.DSSNr, 'MasterIdx', [], 'MasterMode', 'TON', 'SlaveNr', [], 'SlaveIdx', [], 'SlaveMode', ''));
        EDFIndepVar = assembleDSfieldEDFIndepVar(IndepVarParam);
        EDFData     = struct([]);
    case 'sch005',
        %Reorganize schema data and extracting general waveform parameters ...
        GenWaveFormParam = extractSCHGenWaveFormParam(SchData);
        IndepVarParam    = extractSCHIndepVarParam(SchData);
        IndepVal   = IndepVarParam.Values;
        IndepRange = GenWaveFormParam.NPoints;
        Duration   = calcGEWAVDuration(GenWaveFormParam); %In milliseconds ...

        %Assembling fields of SGSR dataset object ...
        ID    = assembleDSfieldID(FileName, FullFileName, LUT(iSeq));
        Sizes = assembleDSfieldSizes(IndepRange, IndepRange, 1);

        Data.SpikeTimes = [];
        Data.OtherData.WaveForm.time      = IndepVal';     %In microseconds ...
        Data.OtherData.WaveForm.amplitude = DsData.GWDATA; %Always stored as double ...

        IndepVar.Name      = 'Time';
        IndepVar.ShortName = 'Time';
        IndepVar.Values    = IndepVal;
        IndepVar.Unit      = '\mus';
        IndepVar.PlotScale = 'linear';

        Special.RepDur      = Duration;
        Special.BurstDur    = Duration;
        Special.CarFreq     = NaN;
        Special.ModFreq     = NaN;
        Special.BeatFreq    = NaN;
        Special.BeatModFreq = NaN;
        Special.ActiveChan  = NaN;

        StimParam = GenWaveFormParam;
        Stimulus = CollectInStruct(IndepVar, Special, StimParam);

        Settings = assembleDSfieldSettings;

        %Assembling extra fields for EDF dataset object ...
        TimerNrs    = []; NTimers = 0;
        DSS         = struct([]);
        EDFIndepVar = assembleDSfieldEDFIndepVar(IndepVarParam);
        EDFData     = struct([]);
    case 'sch008',
        %Reorganize schema data and extracting threshold curve ...
        [DSSParam, Err] = extractSCHDSSParam(SchData);
        if Err
            error('Internal inconsistency in dataset: Master and Slave DSS index''s are incorrectly stored.');
        end
        if (DSSParam.Nr > 1) & (~strcmp(DSSParam.MasterMode, DSSParam.SlaveMode))
            error(sprintf('Mode for Master and Slave DSS is different for dataset with ID %s of EDF %s. Cannot convert these datasets.', dsID, FileName));
        end

        [Nrep, NrepM, NrepS] = extractSCHNRep(SchData, DSSParam);
        if ~isequal(Nrep, NrepM)
            error(sprintf('Internal inconcistency in EDF %s for dataset with ID %s. Two different values for number of repetitions of Master DSS.', FileName, dsID));
        end
        if (DSSParam.Nr > 1) & (~isequal(Nrep, NrepM, NrepS))
            error(sprintf('Number of repetitions for Master and Slave DSS are different for dataset with ID %s of EDF %s. Cannot convert these datasets.', dsID, FileName));
        end

        IndepVarParam = extractSCHIndepVarParam(SchData, DSSParam);
        IndepVal   = IndepVarParam.Values;
        IndepRange = length(IndepVal);

        Freq = IndepVal';
        %Real numbers in VAX format sometimes contain the special negative number -909090, this is equal to NaN
        %in IEEE floating point real numbers ...
        Threshold = DsData.DATA.THSPL;
        Threshold(find(Threshold == -909090)) = NaN;
        Threshold = [ Threshold, repmat(NaN, 1, IndepRange-length(Threshold)) ];

        GenStimParam  = extractSCHGenStimParam(SchData, DSSParam);
        ThrCurveParam = extractSCHThrCurveParam(SchData);

        %Assembling fields of SGSR dataset object ...
        ID    = assembleDSfieldID(FileName, FullFileName, LUT(iSeq));
        %For SGSR datasets containing a threshold curve the Sizes.Nsub field contains
        %the number of subsequences that where requested, including the extra initial
        %subsequence in which the spontaneous activity for the cell or fiber is recorded.
        %This isn't the case for EDF datasets with schema SCH008, where Size.Nsub stands
        %for the subsequences that where requested, excluding the SA collection ...
        %The other fields in the Sizes structure are all set to one ...
        Sizes = assembleDSfieldSizes(IndepRange, 1, Nrep);

        Data.SpikeTimes = [];
        Data.OtherData.thrCurve.freq      = Freq;
        Data.OtherData.thrCurve.threshold = Threshold;

        Stimulus = assembleDSfieldTHRStimulus(DSSParam, GenStimParam, ThrCurveParam, IndepVarParam, Threshold);
        Settings = assembleDSfieldSettings;

        %Assembling extra fields for EDF dataset object ...
        TimerNrs    = 0;
        NTimers = 1;
        DSS         = assembleDSfieldDSS(DSSParam);
        EDFIndepVar = assembleDSfieldEDFIndepVar(IndepVarParam);
        EDFData     = assembleDSfieldEDFData([], TimerNrs);
    case {'sch006', 'sch012', 'sch016'},
        [DSSParam, Err] = extractSCHDSSParam(SchData);
        if Err
            error('Internal inconsistency in dataset: Master and Slave DSS index''s are incorrectly stored.');
        end
        if (DSSParam.Nr > 1) & (~strcmp(DSSParam.MasterMode, DSSParam.SlaveMode))
            warning(sprintf('Mode for Master and Slave DSS is different for dataset with ID %s of EDF %s.', dsID, FileName));
        end
        if ~any(strcmp(DSSParam.MasterMode, {'ton', 'am', 'gwr'}))
            warning(sprintf('Mode for Master and Slave DSS is %s for dataset with ID %s of EDF %s. This mode is not implemented yet.', DSSParam.MasterMode, dsID, FileName));
        end

        IndepVarParam = extractSCHIndepVarParam(SchData, DSSParam);
        StatTbParam  = extractSCHStatTbParam(SchData, DsLoc);
        [StatTb, Nsub, NsubRec, Err] = readEDFStatTb(fid, DsLoc, StatTbParam, IndepVarParam); %Reading status table ...
        switch Err,
            case 1
                error('Dataset with ID %s of EDF %s has a status table of type %d. Status tables of that type are not yet implemented.', dsID, FileName, DsData.STFORM);
            case 2
                error('Dataset with ID %s of EDF %s has a status table with more than one pointer. These kind of status tables are not yet implemented.', dsID, FileName);
            case 3
                error('Dataset with ID %s of EDF %s has more than two independent variables, and cannot be converted.', dsID, FileName);
        end

        [Nrep, NrepM, NrepS] = extractSCHNRep(SchData, DSSParam);
        if ~isequal(Nrep, NrepM)
            error('Internal inconcistency in EDF %s for dataset with ID %s. Two different values for number of repetitions of Master DSS.', FileName, dsID);
        end
        if (DSSParam.Nr > 1) && (~isequal(Nrep, NrepM, NrepS))
            error('Number of repetitions for Master and Slave DSS are different for dataset with ID %s of EDF %s. Cannot convert these datasets.', dsID, FileName);
        end
        TimerNrs = extractSCHTimerNrs(SchData);
        NTimers = length(TimerNrs);
        TimeBase = extractSCHTimeBase(SchData, DSSParam);
        if isempty(TimeBase)
            error('Cannot extract valid timebase (fixed-point real numbers) for dataset with ID %s of EDF %s.', dsID, FileName);
        end
        [SpkTimes, WarnStr] = readEDFSpkTimes(fid, StatTb, Nrep, TimeBase, TimerNrs); %Reading actual spiketimes ...
        if ~isempty(WarnStr)
            warning(WarnStr);
        end

        [IndepVarParam, SchData, Err] = reduceIndepVarParam(IndepVarParam, SchData);
        if Err
            error('');
        end %Not yet implemented ...

        [GenStimParam, Schdata, Err] = extractSCHGenStimParam(SchData, DSSParam);
        switch Err
            case 1
                error('Invalid DCP expression used in specification of general stimulus parameters.');
            case 2
                error('Ranges of a general stimulus parameter for master and slave DSS are not compatible.');
        end
        [FreqParam, SchData, Err] = extractSCHFreqParam(SchData, IndepVarParam, DSSParam);
        switch Err
            case 1
                error('Invalid DCP expression used in specification of frequency parameters.');
            case 2
                error('Ranges of a frequency parameter for master and slave DSS are not compatible.');
        end
        [GWParam, ShiftGWParam, SchData, Err] = extractSCHGWParam(SchData, DSSParam);
        switch Err
            case 1
                error('Invalid DCP expression used in specification of general waveform parameters.');
            case 2
                error('Ranges of a general waveform parameter for master and slave DSS are not compatible.');
        end

        %Adjust independent variable settings for binaural datasets if necessary ...
        [IndepVarParam, Err] = adjustIndepVarParam(IndepVarParam, GenStimParam, DSSParam);
        if Err
            error('');
        end %Not yet implemented ...

        %Assembling fields of SGSR dataset object ...
        ID    = assembleDSfieldID(FileName, FullFileName, LUT(iSeq));
        Sizes = assembleDSfieldSizes(Nsub, NsubRec, Nrep);

        %Only spiketimes recorded with first event timer (UET) are stored in the parent dataset ...
        Data.SpikeTimes = SpkTimes(:, :, 1);
        Data.OtherData  = [];

        Stimulus = assembleDSfieldStimulus(Nsub, NsubRec, DSSParam, FreqParam, GWParam, ShiftGWParam, GenStimParam);
        Settings = assembleDSfieldSettings;

        %Assembling extra fields for EDF dataset object ...
        DSS         = assembleDSfieldDSS(DSSParam);
        EDFIndepVar = assembleDSfieldEDFIndepVar(IndepVarParam, Nsub, NsubRec);
        EDFData     = assembleDSfieldEDFData(SpkTimes, TimerNrs);
    otherwise
        error(sprintf('Dataset with ID %s of EDF %s has a %s schema. Conversion of schemata of that type is yet implemented.', dsID, FileName, SchName));
end

fclose(fid);

EDFds = struct('ID', struct('SchName', upper(SchName)), 'Sizes', struct('Ntimers', NTimers), ...
    'EDFData', EDFData, 'TimerNrs', TimerNrs, 'DSS', DSS, 'EDFIndepVar', EDFIndepVar, 'SchData', SchData);
ds    = localStructTemplate(CollectInStruct(ID, Sizes, Data, Stimulus, Settings), struct(dataset));
ds    = dataset(ds, 'convert');
EDFds = class(EDFds, 'EDFdataset', ds);

%Caching system ...
% Ncache = 1e3; ToCacheFile(CacheFileName, Ncache, SearchParam, EDFds);

%------------------------------------------------local functions--------------------------------------------------
function Sn = localStructTemplate(S, T)
%Local version of structtemplate: no checking if variable classes are matched between template and original
%structure and no reduction of matrices to fit size of template matrix ...

Sn = T;
FNames = fieldnames(T);
NFields = length(FNames);

for n = 1:NFields
    FieldName = FNames{n}; 
    TFieldValue = getfield(T, FieldName);

    if isa(TFieldValue, 'struct')
        if ismember(FieldName, fieldnames(S))
            Ssub = getfield(S, FieldName);
        else
            continue; 
        end
        Ssub = localStructTemplate(Ssub, TFieldValue);
        Sn = setfield(Sn, FieldName, Ssub);

    elseif ismember(FieldName, fieldnames(S))
        Sn = setfield(Sn, FieldName, getfield(S, FieldName)); 
    end
end

% - by abelius: Generate an EDFdataset object from a structure
function Obj = struct2EDFdataset(EDFstruct)
% - generate dataset Obj to inherit from
% - if dataset object is in the struct from earlier declaration use that
% one, otherwise create an empty one. 
if isfield(EDFstruct, 'dataset') && isa(EDFstruct.dataset, 'dataset')
    ds = EDFstruct.dataset;
    EDFstruct = rmfield(EDFstruct, 'dataset');
elseif ~isfield(EDFstruct, 'dataset')
    ds = dataset();
else
    error('%s\n', 'There is a field called ''dataset'' is your structure, this is an error since its the name of the superclass', ...
        'Plz remove the ''dataset'' field');
end

% - generate empty EDFdataset to validate given struct
empty = createEmptyEDFdataset;
if ~isequal(fieldnames(empty), fieldnames(EDFstruct)),
    error(['Candidate dataset object does not have the correct set of ',...
        'generic fieldnames in correct order.' ,...
        char(13) 'Type "struct(EDFdataset)" to examine the generic dataset structure.']);
end

% - generate Obj when all is OK
Obj = class(EDFstruct, 'EDFdataset', ds);

%-----------------------------------------------------------------------------------------------------------------