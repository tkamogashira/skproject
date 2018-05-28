function d = dataset(varargin)
% DATASET - constructor for dataset object. Contains an entire sequence.
%   DS = DATASET(E, I) reads sequence number I from experiment E
%   and stores it in a variable DS of the dataset object class.
%   E may only contain the filename, no extension or folder. 
%   The folder of the datafile is the current DATADIR; the extension
%   depends of the sign of I as follow: I>0 indicates sequence I
%   of an SGSR datafile; I<0 indicates sequence abs(I) of an
%   IDF/SPK datafile.
%   
%   The format of dataset objects is largely independent of the
%   type of measurement (or stimulus type). Thus the DATASET format is
%   a convenient starting point for a large collection of standard
%   ways to visualize and/or process data. Moreover, the dataset 
%   variable stores the complete set of stimulus parameters defining the
%   measurement. Thus dataset variables are also the starting point of 
%   more specific data processing.
%
%   See also DATADIR, DATABROWSE, GETDATASET.

if nargin<1
   % create empty dataset
   s = localEmptyDatasetStruct; % struct that contains compulsary fields & subfields
   d = localDatasetClass(s);
   return;
end

if isequal('debug',varargin{1})
   keyboard;
   return;
elseif isa(varargin{1}, 'dataset')
   d = varargin{1};
   return;
elseif isstruct(varargin{1}) && isequal('convert', lower(varargin{2}))
   d = varargin{1};
   d = localDatasetClass(d);
   return;
end

%special case for Harris data  -> delegate to appropriate fnc
% if isHarris(varargin{1})
%     d = HarrisDataset(varargin{1:2});
%     return;
% end

%special case of Madison & merged data -> delegate to appropriate fnc
try
   EDF = isEDF(varargin{1});
   MDF = isMDF(varargin{1});
catch
   [EDF, MDF] = deal(false);
end % try

if EDF, 
   d = EDFdataset(varargin{:});
   return;
elseif MDF,
   d = ManageMDF(varargin{1}, 'get', varargin{2:end});
   return;
end
 
% read data from datafile
FN = PDPtestSetName(varargin{1});
iSeq = varargin{2};
if ischar(iSeq), 
   [iSeq, isIDF] = ID2iseq(FN, iSeq, 'useLut'); 
elseif isnumeric(iSeq) && length(iSeq)>1, 
   % recursive call - concatenate single elements
   N = numel(iSeq);
   d = [];
   for ii=1:N,
      d = [d; dataset(FN, iSeq(ii))];
   end
   d = reshape(d, size(iSeq));
   return;
else % sign of iSeq determines data style by convention
   isIDF = (iSeq<0);
end

if isIDF
    ConstrMode = 'readFarm';
else
    ConstrMode = 'readSGSR';
end

% if inUtrecht|inLeuven|inRotterdam, % filename is enough; ignore directory
%    [dum fn] = fileparts(FN);
%    fn = upper(fn);
% else, % use full filename to be sure
   fn = FN;
% end
RetrieveParam = CollectInStruct(fn, iSeq, ConstrMode); % Unique determiner of dataset

%-- Remove comment!!! --%
% d = FromCacheFile('DataSet', RetrieveParam);
% if nargin<3,
%    if ~isempty(d),
%       return;
%    end
% end

switch ConstrMode,
case 'readSGSR', % an SGSR filename and sequence number is given
   %------identifiers
   if ischar(iSeq), iSeq = id2iseq(FN, iSeq, 'useLut'); end
   [dd FullDataPath] = GetSGSRdata(FN, iSeq);
   [ppp, FileName] = fileparts(dd.Header.SessionInfo.dataFile);
   FileFormat = 'SGSR';
   StimType = upper(dd.Header.StimName);
   SeqID = ''; iCell = NaN; % defaults
   if dd.Header.SessionInfo.requestID,
      SeqID = iseq2id(FN, iSeq);
      try
          iCell = str2num(strtok(SeqID,'-'));
      end
   end
   Time = dd.Header.Today;
   Place = getFieldOrdef(dd.Header,'Place',Location([]));
   %------sizes and data
   Nsub = dd.Header.Nsubseq;
   NsubRecorded = dd.Header.NsubseqRecorded;
   OtherData = rmfield(dd, {'Header' , 'SpikeTimes'});
   if isequal('THR', StimType),
      Nrep = 1; % spont activity
      SpikeTimes = dd.SpikeTimes.SubSeq.Rep;
      RepDur = NaN;
      Name = 'Frequency';
      ShortName = 'Frequency';
      Values = dd.Header.plotVarValues(2:end);
      Unit = 'Hz';
      IndepVar = CreateIndepVarStruct(Name, ShortName, Values, Unit);
      RepDur = dd.Header.StimParams.interval;
   else
      Rinf = dd.SpikeTimes.spikes.RECORDinfo;
      Nrep = cat(1,Rinf.Nrep); Nrep = Nrep(end);
      SpikeTimes = FormatSpikes(dd.SpikeTimes.spikes);
      RepDur = cat(1,Rinf.repDur); % the true values; sampling may cause rounding errors
      IndepVar = []; % see below
   end
   %----Stimulus parameters
   Special = [];
   if isfield(dd.Header,'StimSpecials'),
      Special = dd.Header.StimSpecials;
   end;
   if isempty(Special),
      clear Special;
      [BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan] = ...
         ExtractSpecialParams(dd);
   end
   StimParam = dd.Header.StimParams;
   SessionInfo = dd.Header.SessionInfo;
   try
       Experimenter = dd.Header.SessionInfo.Experimenter;
   catch
       Experimenter = '';
   end
   RecordParams = dd.Header.RecordParams;
   % independent variable
   if isempty(IndepVar),
      if isfield(dd.Header, 'IndepVar'),
         IndepVar = dd.Header.IndepVar;
         IndepVar.Values(NsubRecorded+1:Nsub) = NaN; % unrecorded
      else
         Name = getFieldOrDef(dd.Header, 'IndepVarName', 'XXX');
         ShortName = getFieldOrDef(dd.Header, 'IndepShortVarName', 'X');
         Values = dd.Header.plotVarValues;
         Unit = dd.Header.varUnit;
         IndepVar = CreateIndepVarStruct(Name, ShortName, Values, Unit);
      end
   end
case 'readFarm', % an IDF/SPK filename and sequence number is given
   %------identifiers
   [IDF, FullDataPath] = idfget(FN, iSeq);
   SPK = SPKget(FN, iSeq);
   [dum, FileName] = fileparts(FN);
   FileFormat = 'IDF/SPK';
   StimType = upper(IDFstimname(IDF.stimcntrl.stimtype));
   SeqID = iseq2id(FN, iSeq);
   iCell = str2num(char(strtok(SeqID,'-')));
   if isempty(iCell), iCell=NaN; end;
   
   Time = IDF.stimcntrl.today;
   Place = Location([]); % unknown
   %------sizes and data
   Nsub = length(SPK.subseqInfo);
   NsubRecorded = IDF.stimcntrl.max_subseq;
   OtherData = [];
   % Rinf = dd.SpikeTimes.spikes.RECORDinfo;
   Nrep = IDF.stimcntrl.repcount;
   SpikeTimes = cell(Nsub,Nrep);
   SpikeTimes = SPK.spikeTime;
   RepDur = IDF.stimcntrl.interval;
   IndepVar = []; % see below
   %----Stimulus parameters
   [BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan] = ExtractSpecialParams(IDF);
   StimParam = IDF;
   SessionInfo = []; Experimenter = '';
   try
       [dum, RecordParams] = log2lut(fn);
   catch
       RecordParams = [];
   end
   % independent variable
   if isempty(IndepVar),
      SMS = IDF2SMS(IDF);
      PI = SMS.PRP.plotInfo;
      Name = getFieldOrdef(PI, 'xlabel', 'XXX'); Name = trimspace(strtok(Name,'('));
      ShortName = Name; % simple, but see if we can do better:
      [Name, ShortName] = IDFxvarnames(StimType, Name, ShortName); 
      Values = getFieldOrdef(PI, 'varValues', NaN);
      Unit = getFieldOrdef(PI,'varValueUnit', '');
      try % to extract xunits anyhow
         if isempty(Unit),
            xx=flipLR(getFieldOrDef(PI, 'xlabel','*'));
            if ~isequal(xx,'*'),
               xx = flipLR(strtok(xx,'('));
               Unit = strtok(xx,')');
            end
         end
      end % try
      PlotMode = getFieldOrdef(PI,'XScale', 'linear');
      IndepVar = CreateIndepVarStruct(Name, ShortName, Values, Unit, PlotMode);
   end
   % IndepVar.Values
   upsideDownUETvalues = isequal('NSPL',StimType);
   [IndepVar.Values playOrder] = local_findSPKorder(IndepVar.Values, SPK, NsubRecorded, upsideDownUETvalues);
   [CarFreq, ModFreq, BeatFreq, BeatModFreq] ...
      = localSortSpecialVal(playOrder, CarFreq, ModFreq, BeatFreq, BeatModFreq);
   % special "new" noise parameters hidden in old IDF/SPK param list
   if isequal('NTD',StimType), 
      [StimParam.Flow, StimParam.Fhigh, StimParam.Rho, StimParam.RandomSeed, StimParam.SPL] ...
         = extractNewNoiseParams(IDF);
   elseif isequal('NSPL',StimType),
      [StimParam.Flow, StimParam.Fhigh, StimParam.Rho, ...
            StimParam.RandomSeed, StimParam.startSPL, StimParam.endSPL, ...
            StimParam.stepSPL, StimParam.noiseSign] = extractNewNoiseParams(IDF);
   end
   if isequal('LMS',StimType),  % correct reverse storage convention
      ModFreq = IndepVar.Values;
   end

otherwise,
   error(['Unknown Constructor Mode ''' ConstrMode '''']);
end % switch/case

% conversion
FullFileName = RemoveFileExtension(FullDataPath);

% identification
ID = CollectInStruct(FileName, FileFormat, FullFileName, iSeq, StimType, iCell, SeqID, Time, Place, Experimenter);

% sizes
Sizes = CollectInStruct(Nsub, NsubRecorded, Nrep);

% Special parameters involving timing and frequencies. 
% Params that are not applicable (e.g. carrier freq for noise bands) 
% are empty by convention.
if ~exist('Special','var'),
   Special = CreateSpecialVarStruct(RepDur, BurstDur, ...
      CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan);
end
% StimParam is the *complete* info about a measurement, i.e., the measurement can be 
%   .. reconstructed using it (apart from global settings below)
Stimulus = CollectInStruct(IndepVar, Special, StimParam);
% Settings contain "context,"  i.e. parameter settings not specific for this stimulus
Settings = CollectInStruct(SessionInfo, RecordParams);
% output
Data = CollectInStruct(SpikeTimes, OtherData);

% collect different categories
d = CollectInStruct(ID, Sizes, Data, Stimulus, Settings);

d = localDatasetClass(d);
Ncache = 2e3; if atOto || atKiwi || atSikio, Ncache=20e3; end;
% ToCacheFile('DataSet', Ncache, RetrieveParam, d);   %by DK - trying to % avoid problems in reading CACHE (error "File maybe corrupt" with multiple MATLAB computations  

%---------------------------
function ed = localEmptyDatasetStruct
% empty dataset struct containing compulsary fields and subfields
persistent ED % cache
if ~isempty(ED), ed=ED; return; end
ID = struct('FileName','' , 'FileFormat','' , 'FullFileName','' , 'iSeq',[] , ...
   'StimType','' , 'iCell',[] , 'SeqID','' , 'Time',[] , 'Place','', 'Experimenter', '');
%-------------
Sizes = struct('Nsub',0 , 'NsubRecorded',0 , 'Nrep', 0);
%-------------
Data = struct('SpikeTimes',[] , 'OtherData', []); Data.SpikeTimes = {};
%-------------
IndepVar = struct('Name', '', 'ShortName', '', 'Values', [], 'Unit', '', 'PlotScale', '');
Special = struct('RepDur', [], 'BurstDur', [], 'CarFreq', [], 'ModFreq', [],   ...
   'BeatFreq', [], 'BeatModFreq', [], 'ActiveChan', []);
StimParam = [];
Stimulus = CollectInStruct(IndepVar, Special, StimParam);
%-------------
Settings = struct('SessionInfo',[] , 'RecordParams', []);
%-------------
ed = CollectInStruct(ID, Sizes, Data, Stimulus, Settings);
ED = ed; % store cache

function d = localDatasetClass(d)
% tests if generic structure of d is OK and invokes a class call
if ~isstruct(d), error('Candidate dataset object is not a struct.'); end
% top-level field names: use localEmptyDatasetStruct as a reference.
ED = localEmptyDatasetStruct;
if ~isequal(fieldnames(ED), fieldnames(d)),
   error(['Candidate dataset object does not have the correct set of ',...
         'generic fieldnames in correct order.' ,...
         char(13) 'Type "struct(dataset)" to examine the generic dataset structure.']);
end
% subfields are compulsory, impose them on the candidate w/o overwriting preent values
FNS = fieldnames(ED);
for ii=1:length(FNS),
   fn = FNS{ii};
   f = d.(fn);
   ef = ED.(fn);
   f = combineStruct(ef, f); % fields of f take precedence
   d.(fn) = f;
end
d = class(d, 'DataSet');


function cmd = localUnpackCom(Names, ValueName)
% constructs command string that will unpack a cell array named ValueName
N = length(Names);
cmd = '';
for ii=1:N,
   cmd = [cmd ' ' Names{ii} '=' ValueName '{' num2str(ii)  '} ; '];
end

function [Values, II] = local_findSPKorder(Values, SPK, Nrec, reverseSPKorder)
II =nan; % this value indicates that no randomization has been applied, ...
%  so that the play order can be derived from the stimulus parameters.
if nargin<4, reverseSPKorder=0; end;
UU = spkUETvar(SPK);
Nsub = size(UU,1);
InterruptedAndStupid = (Nrec<Nsub) & all(all(UU(Nrec+1:end,:)==0));
if InterruptedAndStupid,
   warning(['Incomplete data collection *and* exotic convention of UET var' ...
       'storage: extraction of independent variable may be corrupted.']);
end
UU(UU<-1e20)=0; % PDP-11  value for NaN is something like -1e30
s1 = std(UU(:,1));
s2 = std(UU(:,2));
if (s1>s2), ch = 1; else ch=2; end;
uu = UU(:,ch); % param values from the most interesting channel, in order of presentation
if reverseSPKorder, uu=-uu; end; % exceptional dataset types like NSPL where attenuation is stored but level is varied
if InterruptedAndStupid && ~all(diff(uu(1:Nrec))>=0) && ~all(diff(uu(1:Nrec))<=0),
   error('Unable to retrieve random order of presentation from incomplete data.');
end
Values = sort(Values); % default order: ascending
if all(diff(uu)>=0) || all(diff(uu)<=0), % forward or reverse, that's the question
   if length(uu)>1, 
      if mean(diff(uu))<0, % strictly descending
         Values = flipud(Values); 
      end
   end
else % randomized shit
   [dum, II] = sort(uu);
   Values(II) = Values;
end
% substitute nans for unrecorded subseqs
if Nrec<Nsub, Values(Nrec+1:Nsub) = nan; end;


function [CarFreq, ModFreq, BeatFreq, BeatModFreq] ...
   = localSortSpecialVal(playOrder, CarFreq, ModFreq, BeatFreq, BeatModFreq)
if isnan(playOrder), return; end;
if size(CarFreq,1)>1,
   try CarFreq(playOrder,:) = CarFreq(end:-1:1,:); end;
end
if size(ModFreq,1)>1,
   try ModFreq(playOrder,:) = ModFreq(end:-1:1,:); end;
end
if size(BeatFreq,1)>1,
   try BeatFreq(playOrder,:) = BeatFreq(end:-1:1,:); end;
end
if size(BeatModFreq,1)>1,
   try BeatModFreq(playOrder,:) = BeatModFreq(end:-1:1,:); end;
end
