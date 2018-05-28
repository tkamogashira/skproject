function varargout = CommonParam(varargin)
%COMMONPARAM    manage common paramaters
%   S = COMMONPARAM(DS) returns a structure S with all the common
%   identification and stimulus parameters of the supplied DATASET 
%   object DS.
%   PS = COMMONPARAM returns a PARAMSET object PS with an associated
%   GUI containing all the valid common identification an stimulus
%   parameters.
%   FName = COMMONPARAM(P) returns the fieldname FName in the 
%   structure S of the supplied PARAMETER object P. P must be a
%   member of the PARAMSET object PS. If P is a PARAMSET object
%   COMMONPARAM returns a cell-array of fieldnames with the 
%   fieldnames of all the parameters in the PARAMSET object.

%B. Van de Sande 27-07-2004

%Check input arguments ...
if (nargin > 1), error('Wrong number of input arguments.'); end

%Peform requested action ...
if (nargin == 0), %Return paramset object ...
    PS = CreateParamSet;
    PS = DefineGUI(PS);
    if (nargout == 1), varargout{1} = PS;
    elseif (nargout ~= 0), error('Wrong number of output arguments.'); end
elseif any(strcmpi(class(varargin{1}), {'parameter', 'paramset'})), %Return fieldname of parameter in paramset object ...
    [FName, ErrMsg] = Param2FieldName(varargin{1});
    if (nargout == 1), varargout{1} = FName;
    elseif (nargout == 2), [varargout{1:2}] = deal(FName, ErrMsg);
    elseif (nargout ~= 0),  error('Wrong number of output arguments.'); end
elseif isa(varargin{1}, 'dataset'),
    [S, ErrMsg] = ExtractParam(varargin{1});
    if (nargout == 1), varargout{1} = S;
    elseif (nargout == 2), [varargout{1:2}] = deal(S, ErrMsg);
    elseif (nargout ~= 0),  error('Wrong number of output arguments.'); end
else, error('Wrong input argument.'); end

%-------------------------------locals---------------------------------
function PS = CreateParamSet

%Auxiliary variables ...
INT = 'DQParamInterpreter';

PS = ParamSet('CommonStimParam', 'DataQuest', 'Acquisition of logical expression', 1, [360, 400], mfilename);
%Dataset indentification parameters ...
%                  ID              Def.  Unit      Type     Size  Interpreter 
PS = AddParam(PS, 'FileName',     'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'FileFormat',   'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'iSeq',         'void', '',     'int',     Inf, INT);
PS = AddParam(PS, 'StimType',     'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'iCell',        'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'SeqID',        'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'Time',         'void', '',     'time',    Inf, INT);
PS = AddParam(PS, 'relTime',      'after','',     'char',    1,   INT);
PS = AddParam(PS, 'Place',        'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'Experimenter', 'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'SchName',      'void', '',     'char',    Inf, INT);
%Stimulus presentation parameters ...
PS = AddParam(PS, 'Nsub',         'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'Nrec',         'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'Nrep',         'void', '',     'uint',    Inf, INT);
%Hardware settings ...
PS = AddParam(PS, 'Ntimers',      'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'Nchan',        'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'DSSmode',      'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'DSSnr',        'void', '',     'uint',    Inf, INT);
%Information on independent variable ...
PS = AddParam(PS, 'IndepNr',      'void', '',     'uint',    Inf, INT);
PS = AddParam(PS, 'IndepName',    'void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'IndepUnit',    'void', '',     'char',    Inf, INT);
%Duration parameters ...
PS = AddParam(PS, 'BurstDur',     'void', 'ms',   'interval',  1, INT);
PS = AddParam(PS, 'RepDur',       'void', 'ms',   'interval',  1, INT);
PS = AddParam(PS, 'RiseDur',      'void', 'ms',   'interval',  1, INT);
PS = AddParam(PS, 'FallDur',      'void', 'ms',   'interval',  1, INT);
%SPL, ITD ...
PS = AddParam(PS, 'SPL',          'void', 'dB',   'interval',  1, INT);
PS = AddParam(PS, 'ITD',          'void', 'us',   'interval',  1, INT);
%Tone related stimulus parameters
PS = AddParam(PS, 'CarFreq',      'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'ModFreq',      'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'BeatFreq',     'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'BeatModFreq',  'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'ModDepth',     'void', '%',    'interval',  1, INT);
%Noise ...
PS = AddParam(PS, 'LowFreq',      'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'HighFreq',     'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'BW',           'void', 'Hz',   'interval',  1, INT);
PS = AddParam(PS, 'Rho',          'void', '',     'interval',  1, INT);
PS = AddParam(PS, 'Polarity',     'void', '',     'int',       1, INT);
PS = AddParam(PS, 'RSeed',        'void', '',     'uint',      1, INT);
PS = AddParam(PS, 'NoiseFileName','void', '',     'char',    Inf, INT);
PS = AddParam(PS, 'NoiseSeqID',   'void', '',     'char',    Inf, INT);

%----------------------------------------------------------------------
function [FName, ErrMsg] = Param2FieldName(P)

if isa(P, 'paramset'), %Use recursion ...
    PList = paramlist(P); N = length(PList); FName = cell(1, N);
    for n = 1:N, 
        [FName{n}, ErrMsg] = Param2FieldName(eval(sprintf('P.%s', PList{n})));
        if ~isempty(ErrMsg), FName{n} = ''; end
    end
    ErrMsg = ''; return;
end

[FName, ErrMsg] = deal('');

%LookUp Table with in the first column the name of the parameter and
%the second column the associated fieldname ...
LUT =  {'FileName',     'ID.FileName'; ...
        'FileFormat',   'ID.FileFormat'; ...
        'iSeq',         'ID.iSeq'; ...
        'StimType',     'ID.StimType'; ...
        'iCell',        'ID.iCell'; ...
        'SeqID',        'ID.SeqID'; ...
        'Time',         'ID.Time'; ...
        'Place',        'ID.Place'; ...
        'Experimenter', 'ID.Experimenter'; ...
        'SchName',      'ID.SchName'; ...
        'Nsub',         'Common.Nsub'; ...
        'Nrec',         'Common.Nrec'; ...
        'Nrep',         'Common.Nrep'; ...
        'Ntimers',      'Common.Ntimers'; ...
        'Nchan',        'Common.Nchan'; ...
        'DSSmode',      'Common.DSSmode'; ...
        'DSSnr',        'Common.DSSnr'; ...
        'IndepNr',      'Common.IndepNr'; ...
        'IndepName',    'Common.IndepName'; ...
        'IndepUnit',    'Common.IndepUnit'; ...
        'BurstDur',     'Common.BurstDur'; ...
        'RepDur',       'Common.RepDur'; ...
        'RiseDur',      'Common.RiseDur'; ...
        'FallDur',      'Common.FallDur'; ...
        'SPL',          'Common.SPL'; ...
        'ITD',          'Common.ITD'; ...
        'CarFreq',      'Common.Tone.CarFreq'; ...
        'ModFreq',      'Common.Tone.ModFreq'; ...
        'BeatFreq',     'Common.Tone.BeatFreq'; ...
        'BeatModFreq',  'Common.Tone.BeatModFreq'; ...
        'ModDepth',     'Common.Tone.ModDepth'; ...
        'LowFreq',      'Common.Noise.LowFreq'; ...
        'HighFreq',     'Common.Noise.HighFreq'; ...
        'BW',           'Common.Noise.BW'; ...
        'Rho',          'Common.Noise.Rho'; ...
        'Polarity',     'Common.Noise.Polarity'; ...
        'RSeed',        'Common.Noise.RSeed'; ...
        'NoiseFileName','Common.Noise.FileName'; ...
        'NoiseSeqID',   'Common.Noise.SeqID'};

idx = find(strcmpi(LUT(:, 1), P.name)); %Case-insensitive search ...
if ~isempty(idx), FName = LUT{idx, 2};
else, ErrMsg = sprintf('Parameter ''%s'' is not in fieldname LUT.', P.name); end

%----------------------------------------------------------------------
function PS = DefineGUI(PS)

%Auxiliary variables ...
ED = 'edit'; TG = 'toggle';

%Dataset indentification parameters ...
PS = InitOUIgroup(PS, 'ID', [10 10 195 110], 'ID');
PS = DefineQuery(PS, 'FileName',             0,  ED, 'FileName',    'A0242',                'Name of datafile (CHAR).');
PS = DefineQuery(PS, 'FileFormat',      [90 0],  ED, 'Format',      'IDF/SPK',              'Format of datafile (CHAR).');
PS = DefineQuery(PS, 'iSeq',                20,  ED, 'iSeq',        '45',                   'Sequence number (INT).');
PS = DefineQuery(PS, 'iCell',          [55 20],  ED, 'iCell',       '4',                    'Number of cell (UINT).');
PS = DefineQuery(PS, 'SeqID',         [100 20],  ED, 'SeqID',       '20-12',                'Sequence identifier (CHAR).');
PS = DefineQuery(PS, 'StimType',            40,  ED, 'StimType',    'NRHO',                 'Stimulus type (CHAR).');
PS = DefineQuery(PS, 'SchName',        [85 40],  ED, 'SchName',     'SCH012',               sprintf('Database schema identifier. For SGSR and IDF/SPK datasets this is the same as the stimulus type.\nUse this instead of StimType for a faster search. For EDF datasets this field is equal to the actual\nschema name (CHAR).'));
PS = DefineQuery(PS, 'Time',                60,  ED, 'Time',        'dd-mmm-yyyy HH:MM:SS', 'Recording time (dd-mmm-yyyy HH:MM:SS).');
PS = DefineQuery(PS, 'relTime',       [140 60],  TG, '',           {'after', 'before'},     '');
PS = DefineQuery(PS, 'Place',               80,  ED, 'Place',       'Leuven/Bigscreen',     'Recording place (CHAR).');
PS = DefineQuery(PS, 'Experimenter',  [120 80],  ED, 'Exp',         'dries',                'Name of experimenter (CHAR).');
PS = SeeSaw(PS, 'relTime', 'after', 'before');
%Stimulus presentation parameters ...
PS = InitOUIgroup(PS, 'Presentation', [220 10 150 50], 'Presentation');
PS = DefineQuery(PS, 'Nsub',                 0,  ED, 'Nsub/Nrec',   '5',                    'Number of requested/recorded subsequences (UINT).');
PS = DefineQuery(PS, 'Nrec',            [75 0],  ED, '/',           '4',                    '');
PS = DefineQuery(PS, 'Nrep',                20,  ED, 'Nrep',        '10',                   'Number of repetitions (UINT).');
%Hardware settings ...
PS = InitOUIgroup(PS, 'Hardware', [220 70 150 50], 'Hardware');
PS = DefineQuery(PS, 'Ntimers',              0,  ED, 'Ntimers',     '1',                    'Number of event timers (UINT).');
PS = DefineQuery(PS, 'Nchan',           [70 0],  ED, 'Nchan',       '1',                    'Number of playback channels (UINT).');
PS = DefineQuery(PS, 'DSSmode',             20,  ED, 'DSSmode',     'ton ton',              'Mode of the active DSSs (CHAR).');
PS = DefineQuery(PS, 'DSSnr',          [90 20],  ED, 'DSSnr',       '1 2',                  'Number of the active DSSs (UINT).');
%Information on independent variable ...
PS = InitOUIgroup(PS, 'IndepVar', [10 130 100 50], 'Indep. variable'); 
PS = DefineQuery(PS, 'IndepName',            0,  ED, 'Name',        'Frequency',            'Name of independent variable (CHAR).');
PS = DefineQuery(PS, 'IndepNr',             20,  ED, 'Nr',          '1',                    'Number of independent variables (UINT).');
PS = DefineQuery(PS, 'IndepUnit',     [40, 20],  ED, 'Unit',        'Hz',                   'Unit of inpendent variable (CHAR).');
%Duration parameters ...
PS = InitOUIgroup(PS, 'Duration', [10 190 100 90], 'Duration'); 
PS = DefineQuery(PS, 'BurstDur',             0,  ED, 'BurstDur',    ']10,12[',              'Stimulus duration (INTERVAL).');
PS = DefineQuery(PS, 'RepDur',              20,  ED, 'RepDur',      ']10,12[',              'Interval duration (INTERVAL).');
PS = DefineQuery(PS, 'RiseDur',             40,  ED, 'RiseDur',     ']10,12[',              'Stimulus gating (INTERVAL).');
PS = DefineQuery(PS, 'FallDur',             60,  ED, 'FallDur',     ']10,12[',              'Stimulus gating (INTERVAL).');
%SPL, ITD ...
PS = InitOUIgroup(PS, 'SPL_ITD', [120 130 120 50], 'SPL & ITD'); 
PS = DefineQuery(PS, 'SPL',                  0,  ED, 'SPL',         ']80,90[',              'Sound pressure level (INTERVAL).');
PS = DefineQuery(PS, 'ITD',                 20,  ED, 'ITD',         ']-100,100]',           'Interaural time delay (INTERVAL).');
%Tone related stimulus parameters
PS = InitOUIgroup(PS, 'Tone', [120 190 120 110], 'Tone'); 
PS = DefineQuery(PS, 'CarFreq',             0,   ED, 'CarFreq',     ']100,5000[',           'Carrier Frequency (INTERVAL).');
PS = DefineQuery(PS, 'ModFreq',            20,   ED, 'ModFreq',     ']100,5000[',           'Modulation frequency (INTERVAL).');
PS = DefineQuery(PS, 'BeatFreq',           40,   ED, 'CarBeat',     ']100,5000[',           'Beat on carrier frequency (INTERVAL).');
PS = DefineQuery(PS, 'BeatModFreq',        60,   ED, 'ModBeat',     ']100,5000[',           'Beat on modulation frequency (INTERVAL).');
PS = DefineQuery(PS, 'ModDepth',           80,   ED, 'ModDepth',    ']100,5000[',           'Depth of modulation (INTERVAL).');
%Noise ...
PS = InitOUIgroup(PS, 'Noise', [250 130 120 170], 'Noise'); 
PS = DefineQuery(PS, 'LowFreq',             0,   ED, 'LowFreq',     ']100,5000[',           'Lowest frequency in noise token (INTERVAL).');
PS = DefineQuery(PS, 'HighFreq',           20,   ED, 'HighFreq',    ']100,5000[',           'Highest frequency in noise token (INTERVAL).');
PS = DefineQuery(PS, 'BW',                 40,   ED, 'BW',          ']100,5000[',           'Bandwidth of noise token (INTERVAL).');
PS = DefineQuery(PS, 'Rho',                60,   ED, 'Rho',         ']-1,+1[',              'Correlation of noise token (INTERVAL).');
PS = DefineQuery(PS, 'Polarity',           80,   ED, 'Polarity',    '+1',                   'Polarity of noise token (INT).');
PS = DefineQuery(PS, 'RSeed',             100,   ED, 'RSeed',       '23456',                'Random seed used to generate noise token (UINT).');
PS = DefineQuery(PS, 'NoiseFileName',     120,   ED, 'FileName',    'N1K32',                'Filename where sampled data for noise token is stored (CHAR).');
PS = DefineQuery(PS, 'NoiseSeqID',        140,   ED, 'SeqID',       'AB100',                'Identifier specifying dataset in file where noise token is stored (CHAR).');

%----------------------------------------------------------------------
function [S, ErrMsg] = ExtractParam(ds)

ErrMsg = '';

%Identification fields for a dataset ...
IDTemplate = struct( ...
    'FileName', '', ...             %Name of datafile ...
    'FileFormat', '', ...           %Format of datafile (SGSR, IDF/SPK, EDF, ...) ...
    'iSeq', NaN, ...                %Sequence number in datafile ...
    'StimType', '', ...             %Type of stimulus ...
    'iCell', NaN, ...               %Cell number ...
    'SeqID', '', ...                %Sequence identifier ...
    'Time', repmat(NaN, 1, 6), ...  %MATLAB date vector when sequence was recorded ...
    'Place', '', ...                %Place where sequence was recorded ...
    'Experimenter', '', ...         %Name of experimenter that recorded the sequence ...
    'SchName', '');                 %Name of schema used to store sequence information ...
%Attention! SchName is only useful for EDF datafiles, for other datasets this field
%is empty ...

S.ID = structtemplate(struct(ds.ID), IDTemplate);
%ID.FileName, ID.FileFormat, ID.StimType, ID.SeqID, ID.Place, ID.Experimenter and 
%ID.SchName always contain lower case character strings ...
S.ID.FileName     = lower(S.ID.FileName);
S.ID.FileFormat   = lower(S.ID.FileFormat);
S.ID.StimType     = lower(S.ID.StimType);
S.ID.SeqID        = lower(S.ID.SeqID);
S.ID.Place        = lower(S.ID.Place);
S.ID.Experimenter = lower(S.ID.Experimenter);
S.ID.SchName      = lower(S.ID.SchName);
%Changing ID.Time to MATLAB serial date number which is much easier to use in search 
%queries ...
S.ID.Time = datenum(S.ID.Time([3 2 1 4 5 6]));

%Common stimulus paremeters (present for all datasets) ...
if strcmpi(ds.FileFormat, 'EDF') | (strcmpi(ds.FileFormat, 'MDF') & strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'))
    isEDFds = logical(1);
else
    isEDFds = logical(0); 
end

%Information on subsequences and repetitions ...
S.Common.Nsub         = ds.Sizes.Nsub;
S.Common.NsubRecorded = ds.Sizes.NsubRecorded;
S.Common.Nrep         = ds.Sizes.Nrep;

%Information on event timers used. For SGSR, IDK/SPK datasets only one event timer can
%be used to record spiketimes, therefore Ntimers is only useful for EDF datasets ...
if isEDFds, S.Common.Ntimers = ds.Sizes.Ntimers;
else, S.Common.Ntimers = 1; end

%Information on the playback channels. Nchan is the number of active channels used for
%the datasets. ChanNr contains extra information on these active channels: 1 designates
%left, 2 is right and 0 means both playback channels used. For EDF-datasets each channel
%is assigned a DSS. One of those acts as a master DSS, the other is the slave. One only
%one channel is used, this DSS is always considered the master DSS. When only one DSS
%is used then ChanNr designates the number of the master DSS ...
if ~isnan(ds.Special.ActiveChan), S.Common.Nchan = 2 - sign(ds.Special.ActiveChan);
else, S.Common.Nchan = 0; end
S.Common.ChanNr = ds.Special.ActiveChan;
%When two playback channels are used, the number and mode of the master DSS or the slave
%DSS can be obtained using the following fields ... (This isn't necessary for SGSR, IDF/SPK
%datasets!)
if (S.Common.Nchan == 0),
    S.Common.DSSmode = '';
    S.Common.DSSnr   = NaN;
elseif isEDFds & (S.Common.Nchan == 1),
    S.Common.DSSmode = ds.DSS.Mode;
    S.Common.DSSnr   = ds.DSS(1).Nr;
elseif isEDFds,    
    S.Common.DSSmode = {ds.DSS(1).Mode, ds.DSS(2).Mode};
    S.Common.DSSnr   = [ds.DSS(1).Nr, ds.DSS(2).Nr];
elseif (S.Common.Nchan == 1),
    S.Common.DSSmode = '';
    S.Common.DSSnr   = NaN;
else,    
    S.Common.DSSmode = repmat({''}, 1, S.Common.Nchan);
    S.Common.DSSnr   = repmat(NaN, 1, S.Common.Nchan);
end
    
%Information on the independent variable is restricted to its name and unit. The values
%are not stored because this is redundant information. The independent variable is just
%another stimulus parameter, the only difference is that it is varied. Moreover, for
%EDF-datasets which contain general waveforms(GWAV) the vector with the values of the
%independent variable is very large ...
%For datasets with multiple independent variables the name and unit are stored as a 
%cell-array of strings, with a column for each independent variable ...
if isEDFds, S.Common.IndepNr = ds.IndepNr;
else, S.Common.IndepNr = 1; end    
if (S.Common.IndepNr == 1),
    S.Common.IndepName = ds.IndepName;
    S.Common.IndepUnit = ds.IndepUnit;
elseif (S.Common.IndepNr == 2), %Two independent variables ...
    S.Common.IndepName = {ds.XName, ds.YName};
    S.Common.IndepUnit = {ds.XUnit, ds.YUnit};
else, 
    ErrMsg = sprintf('%s contains more than two independent variables.', ds.title);
    S = struct([]); return;
end

%A stimulus parameter must be a double or a character string. If the stimulus is varied
%then the parameter will be saved as a matrix or a cell-array. The size is always 
%economical and is organized according to the following rule: different settings for
%subsequences is saved in different rows, difference amongst channels is saved in a
%different column. Attention! Values of a stimulus parameter for subsequences that
%weren't recorded are also stored, but the value of the independent variable for these
%subsequences is set to NaN ...
DurParam = ExtractDurParam(ds);
S.Common.RepDur           = DurParam.RepDur;           %Repetition duration in ms ...
S.Common.BurstDur         = DurParam.BurstDur;         %Stimulus duration in ms ...
S.Common.RiseDur          = DurParam.RiseDur;          %Duration of initial rise in ms ...
S.Common.FallDur          = DurParam.FallDur;          %Duration of stimulus fadeout in ms ...
S.Common.ITD              = ExtractITD(ds);            %Interaural delay in microsecs ...
S.Common.SPL              = ExtractSPL(ds);            %Sound Pressure Level in dB ...
FreqParam = ExtractFreqParam(ds);
S.Common.Tone.CarFreq     = FreqParam.CarFreq;         %Carrier frequency in Hz ...
S.Common.Tone.ModFreq     = FreqParam.ModFreq;         %Modulation frequency in Hz ...
S.Common.Tone.BeatFreq    = FreqParam.BeatFreq;        %Beat frequency on carrier in Hz ...
S.Common.Tone.BeatModFreq = FreqParam.BeatModFreq;     %Beat frequency on modulation in Hz ...
if all(isnan(S.Common.Tone.ModFreq))
    S.Common.Tone.ModDepth = NaN; %Modulation depth in percent ...
else
    S.Common.Tone.ModDepth = ExtractModDepth(ds); 
end
NoiseParam = ExtractNoiseParam(ds);
S.Common.Noise.LowFreq    = NoiseParam.LowFreq;        %Lowest frequency in noise token in Hz ...
S.Common.Noise.HighFreq   = NoiseParam.HighFreq;       %Highest frequency in Hz ... 
S.Common.Noise.BW         = abs(NoiseParam.LowFreq-NoiseParam.HighFreq); %Bandwidth of noise token in Hz ...
S.Common.Noise.Rho        = NoiseParam.Rho;            %Correlation of noise token (-1 <> +1) ...
S.Common.Noise.Polarity   = NoiseParam.Polarity;       %Polarity of noise token (+1 or -1) ...
S.Common.Noise.RSeed      = NoiseParam.RSeed;          %Random seed used to generate noise token ...
S.Common.Noise.FileName   = NoiseParam.FileName;       %Filename where sampled data for noise token is stored ... 
S.Common.Noise.SeqID      = NoiseParam.SeqID;          %Optional identifier specifying dataset in file ...
%Information on SPL of a dataset depends on the nature of the stimulus type. If the
%dataset contains spiketimes collected while administrating a tone, then the SPL field
%in a dataset can be used directly. However, when a noise stimulus was presented, there
%is a difference between Madison and SGSR datasets. For SGSR datasets the SPL stored is
%the overall effective SPL for the noise token used and the current calibration file.
%In EDF datasets the attenuator setting is saved and not the effective SPL. This can
%be calculated using a calibration dataset and a GEWAV dataset.
%Attention! A dataset can have noise and tone components in a stimulus, e.g. a tone
%modulated by a noise token. This is possible for SGSR datasets with the BERT stimulus
%and for EDF datasets using a the DSS mode GAM. For SGSR the effective SPL is stored
%for the modulated noise token, for EDF datasets the attenuator setting is saved again,
%and the effective SPL must be calculated based on FFT of the modulated noise token and
%a calibration file.
%Attention! For EDF datasets it is possible that for one playback channel a tone was
%administrated, while the other DSSs was playing a noise token. E.g. R95110, 7-3-RA.
S.Common.isTone  = AnalyzeParam(FreqParam);
S.Common.isNoise = AnalyzeParam(NoiseParam);
%When one of the playback channel was administrated a noise token then the effective SPL
%returned by CALCEFFSPL.M is the only valid SPL.
if S.Common.isNoise, S.Common.SPL = NoiseParam.SPL; end

%----------------------------------------------------------------------
function boolean = AnalyzeParam(S)

Val = struct2cell(S);

numidx  = find(cellfun('isclass', Val, 'double')); Ndouble = length(numidx);
for n = 1:Ndouble, boolean(n) = all(isnan(Val{numidx(n)}(:))); end

charidx = find(cellfun('isclass', Val, 'char')); Nchar = length(charidx);
for n = 1:Nchar, boolean(Ndouble + n) = isempty(Val{charidx(n)}); end

boolean = ~all(boolean);

%----------------------------------------------------------------------