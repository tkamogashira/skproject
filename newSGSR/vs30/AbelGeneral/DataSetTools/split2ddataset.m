function dsArray = split2ddataset(varargin)
%SPLIT2DDATASET

%% ---------------- CHANGELOG -----------------------
%  Wed Feb 16 2011  Abel   
%   Initial creation

%% ---------------- Default parameters ---------------
% Define all needed options
Defaults = struct();
Defaults.version = 0.01;
Defaults.maxargs = 3;
Defaults.minargs = 3;
Defaults.splitby = 'SPL';
Defaults.help = {[mfilename '(ds, ''splitby'', ''SPL||FCAR||FMOD'')']};


%% ---------------- Main function ----------------------
%% Get arguments based on template
% - if no arguments or 'factory' just print help message and exit
if (nargin == 0)
	printhelp(Defaults, 1);
elseif strcmpi (varargin{1}, 'factory')
	printhelp(Defaults, 1);
end

% - first argument should be an EDF type dataset
myDataset = varargin{1};
if ~isa(myDataset, 'dataset') && ~strcmp(myDataset.FileFormat, 'EDF')
	printhelp(Defaults, 'First argument should be an EDF type dataset', 1);
end

% - get user supplied arguments and set default
if (nargin > 1)
	Param = getarguments(Defaults, varargin(2:end));
else
	Param = Defaults;
end
Param.dataset = myDataset;

%% Transform dataset
% Translate to structures
Param.edfstruct = struct(myDataset);
Param.dsstruct = struct(myDataset.dataset);

% Get the indep variables
if (length(Param.edfstruct.EDFIndepVar) < 2)
	error('Dataset is not 2 dimensional');
end
indepNames = getIndepvar_(Param.edfstruct);
Param.splitby = upper(Param.splitby);
splitByOk = strcmp(Param.splitby, indepNames);
Param.indepidx = find(splitByOk == 0);
indepName = lower(indepNames{Param.indepidx});

if ~any(splitByOk)
	error('Split option %s was not found within the dataset variables:%s %s',...
		Param.splitby, indepNames{1}, indepNames{2});
end

% Get dataset params
spikes = Param.dataset.spt;
carrierFreqs = Param.dataset.fcar;
modulationFreqs = Param.dataset.fmod;
spls = GetSPL(Param.dataset);

% Set 'splitby' specific values 
switch Param.splitby
	case {'FMOD'}
		Param.unique = denan(unique(modulationFreqs));
		toExtract = {'spl', 'fcar'};
		uName = 'fmod';
		stimType = Param.dataset.stimtype
		
		if strcmpi(stimType, 'RAM')
			Param.stimtype = 'RCM';
		elseif strcmpi(stimType, 'RA')
			Param.stimtype = 'RC';
		else
			Param.stimtype = '???';
		end
		
	case {'FCAR'}
		Param.unique = denan(unique(carrierFreqs));
		toExtract = {'spl', 'fmod'};
		uName = 'fcar';
		stimType = Param.dataset.stimtype
		
		if strcmpi(stimType, 'RAM')
			Param.stimtype = 'RCM';
		elseif strcmpi(stimType, 'RA')
			Param.stimtype = 'RC';
		else
			Param.stimtype = '???';
		end
		
	case 'SPL'
		Param.unique = denan(unique(spls));
		toExtract = {'fcar', 'fmod'};
		uName = 'spl';
		stimType = Param.dataset.stimtype;
		
		if strcmpi(stimType, 'RAM')
			Param.stimtype = 'MTF';
		elseif strcmpi(stimType, 'RA')
			Param.stimtype = 'FS';
		else
			Param.stimtype = '???';
		end
	otherwise
		error('Split option %s was not found within the dataset variables:%s %s',  Param.splitby, indepNames{1}, indepNames{2});
end

% Loop over 'splitby' values
Param.LOG = {sprintf('transformed to %s format by %d', Param.stimtype, mfilename)};
lengthUnique = length(Param.unique);
dsArray = cell(1, lengthUnique);
for n = 1:lengthUnique
	idx = find(Param.dataset.(uName) == Param.unique(n));
	Param.(uName) = Param.unique(n);
	Param.spikes = spikes(idx,:);
	DStruct = Param.dsstruct;
	EDFStruct = Param.edfstruct;
	
	for i = 1:length(toExtract)
		vName = toExtract{i};
		vValue =  Param.dataset.(vName);
		if length(vValue) >= lengthUnique
			Param.(vName) = vValue(idx,:);
		else
			Param.(vName) = vValue;
		end
	end		
	
	%build IPX dataset for 'splitby'
	nRows = size(Param.spikes, 1);
	DStruct.Data.SpikeTimes = Param.spikes;
	DStruct.Stimulus.Special.SPL = Param.spl;
	DStruct.Stimulus.StimParam.SPL = Param.spl;
	%DStruct.Stimulus.IndepVar.Values = 1:nRows;
	DStruct.Stimulus.IndepVar = EDFStruct.EDFIndepVar(Param.indepidx);
	DStruct.Stimulus.IndepVar.Values = Param.(indepName);
	DStruct.ID.StimType = Param.stimtype;
	DStruct.Sizes.Nsub = nRows;
	DStruct.Sizes.NsubRecorded = nRows;
	DStruct.Stimulus.Special.CarFreq = Param.fcar;
	DStruct.Stimulus.Special.BeatFreq = Param.fcar;
	DStruct.Stimulus.Special.ModFreq = Param.fmod;
	DStruct.Stimulus.Special.BeatModFreq = Param.fmod;
	DStruct.Stimulus.StimParam.FreqParam.ModFreq = Param.fmod;
	DStruct.Stimulus.StimParam.FreqParam.CarFreq = Param.fcar;
	DStruct.ID.LOG = Param.LOG;
	DS = dataset(DStruct, 'convert');
	
	%build EDF dataset for 'splitby'
	EDFStruct.Sizes = updatestruct(DS.Sizes, EDFStruct.Sizes);
	EDFStruct.EDFIndepVar = EDFStruct.EDFIndepVar(Param.indepidx);
	EDFStruct.EDFIndepVar.Values = Param.(indepName);	
	EDFStruct.EDFData.SpikeTimes0 = DS.spt;
	EDFStruct.dataset = DS;
	DS = EDFdataset(EDFStruct, 'convert');
	
    dsArray{1,n} = DS;
	
end

end

%% ---------------- Local functions --------------------
%getIndepvar:	Retrieve the variable from the dataset
function indepNames = getIndepvar_(EDFstruct)
indepNames = cell(1,2);
for n=1:2
	name = upper(EDFstruct.EDFIndepVar(n).DCPName);
	if length(name) > 4 
		name = name(1:4);
	end
	indepNames{n} = name;
end
end

