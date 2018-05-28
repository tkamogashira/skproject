function dsm = spikemasher(ds1,N)

% SPIKEMASHER  Combine spike times from multiple repetitions in one dataset
%   DSM = SPIKEMASHER(DS1,N)  N repetitions in dataset DS1 are combined in
%   one repetition and returned in fake dataset DSM.
%
%   Example -
%       ds1 = dataset('D0923b','2-4-NRHO')
%       dsm = spikemasher(ds1,3);

% MMCL 31/08/2009
% RdN

% get input datasets
spk1 = ds1.Data.SpikeTimes;

Nsize = size(ds1.Data.SpikeTimes);
Nrep = Nsize(2);
Nsub = Nsize(1);

% combine spike times
vec = 1:N;
mspk = [];
mSpikeTimes = cell(Nsub,floor(Nrep/N));

for m = 1:Nsub
    for n = 1:floor(Nrep/N)
        locVec = vec+(N*(n-1));
        for o = 1:length(vec)
            tspk = spk1{m,locVec(o)};
            mspk = [mspk tspk];
        end
        mSpikeTimes{m,n} = sort(mspk);
        mspk = [];
    end
end

%-- make fake dataset --
% get ds info
ID = ds1.ID;
if isfield(ID,'mashed')
   ID.mashed = ID.mashed + N; 
else
    ID.mashed = N;
end
Sizes = ds1.Sizes;
Sizes.Nrep = floor(Nrep/N);
Stimulus = ds1.Stimulus;
Stimulus.StimParam.reps = floor(Nrep/N);
Settings = ds1.Settings;

% add spike times
Data = ds1.Data;
Data.SpikeTimes = mSpikeTimes;

% collect different categories
dsm = CollectInStruct(ID, Sizes, Data, Stimulus, Settings);

% cast as dataset class
dsm = localDatasetClass(dsm);

%--------------------------------- Locals --------------------------------
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

%--------------------------------------------------------------------------
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
