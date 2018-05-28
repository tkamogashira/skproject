function UD = getuserdata( varargin )
%GETUSERDATA Get userdata for specified recordings
%DESCRIPTION 
% Checks the userdata database for information on an experiment,
% cell or dataset. For info on cells and datasets one should consider the
% following flow: 
%                 1) Look at specific cell info in the UserData_Cell table. 
%                 2) If nothing was found, inherit default values from the
%                 experiment using the UserData_Exp table.
%                 3) If still nothing is found, return an empty struct since
%                 there is no info on the cell/dataset
%
%INPUT
%  varargin{1} = "Experiment filename"
%                 All info on each cell/dataset in the experiment is
%                 returned.
%  varargin{1} = "dataset"
%                 Returns only info on the specific dataset. If none are
%                 found the values are inherited from the experiment.
%  varargin{1} = "dataset" && varargin{1} = "sequence identifier dataset"
%                 See above
%  varargin{1} = Experiment filename && varargin{2} = "Cell number"
%                 All info on the datasets of a single cell are returned.
%                 Default values are inherited from the experiment.
%OUTPUT
% Struct containing info:
%        UD.Experiment:     Values from experiment
%        UD.DSInfo:         Remarks on datasets
%        UD.CellInfo:       Specific info on cell
%EXAMPLES
%
%SEE ALSO

%% ---------------- CHANGELOG -----------------------
%  Mon Jan 17 2011  Abel	Added return when no data found
%							Added more useful warnings
%  Wed Apr 13 2011  Abel	Bugfix design DSInfo: Skip AdjustDSforDS if
%                           UD.DSInfo is empty

%% ---------------- TODO -----------------------
% Print some warning if the dataset was marked as: IGNORE ?

UD.Experiment = struct([]);
UD.DSInfo = struct([]);
UD.CellInfo = struct([]);

thisVersion = version('-release');
versionNumber = str2double(thisVersion(1:find(isdigit(thisVersion), 1, 'last')));
if versionNumber >= 13
	if mym(10,'status')
		try
			mym(10,'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
			mym(10,'use ExpData');
		catch
			UD = [];
			return
		end
	end
	
	[Mode, ExpName, CellNr, SeqNr] = localParseArg(varargin);
	
	%% Get info for the experiment from table UserData_Exp based on FileName
	% get all userdata for ExpName
	[Aim, Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, RecLoc, RecSide, Species, StimChan] = ...
		mym(10,['SELECT Aim, Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, RecLoc, RecSide, Species, StimChan FROM UserData_Exp WHERE FileName = "' ExpName '";']);
	
	for cRow = 1:size(Aim, 1)
		UD.Experiment(cRow).Aim = Aim{cRow};
		UD.Experiment(cRow).Chan1 = Chan1{cRow};
		UD.Experiment(cRow).Chan2 = Chan2{cRow};
		UD.Experiment(cRow).DSS1 = DSS1{cRow};
		UD.Experiment(cRow).DSS2 = DSS2{cRow};
		UD.Experiment(cRow).Eval = Eval{cRow};
		UD.Experiment(cRow).ExposedStr = ExposedStr{cRow};
		UD.Experiment(cRow).RecLoc = RecLoc{cRow};
		UD.Experiment(cRow).RecSide = RecSide{cRow};
		UD.Experiment(cRow).Species = Species{cRow};
		UD.Experiment(cRow).StimChan = StimChan{cRow};
	end
	
	%% Get info for the dataset from table UserData_DS based on FileName. 
	%Not all datasets are listed in this table, only when a special entry
	%was made (see below)
	% includes:
	%  Eval = 'remarks on the DS'
	%  Ignore = logical (ignore DS)
	%  iSeq = DS sequence number
	[Eval, Ignore, iSeq] = ...
		mym(10,['SELECT Eval, Ignore_DS, iSeq FROM UserData_DS WHERE FileName = "' ExpName '";']);
	
	[BadSeq, BadSubSeq] = mym(10,['SELECT iSeq, SubSeq_Nr FROM UserData_BadSubSeq WHERE FileName = "' ExpName '" AND Bad = 1;']);
	
	for cRow = 1:size(Eval, 1)
		UD.DSInfo(cRow).SeqNr = iSeq(cRow);
		if ~isnan(iSeq(cRow))
			SeqID = mym(10, ['SELECT SeqID FROM KQuest_Seq WHERE FileName="' ExpName '" AND iSeq=' num2str(iSeq(cRow)) ';']);
		else
			SeqID = '';
		end
		UD.DSInfo(cRow).dsID = SeqID{1};
		UD.DSInfo(cRow).Ignore = Ignore(cRow);
		UD.DSInfo(cRow).Eval = Eval{cRow};
		
		idx = BadSeq == iSeq(cRow);
		UD.DSInfo(cRow).BadSubSeq = BadSubSeq(idx)';
	end
	
	
	%% Get info for the cell from table UserData_Cell based on FileName.
	[Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, FTCTHR, HistDepth, Ignore, Nr, RCNTHR, RecLoc, ...
		RecSide, iPass, iPen] = ...
		mym(10,['SELECT Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, FTCTHR, HistDepth, Ignore_Cell, Nr, ' ...
		'RCNTHR, RecLoc, RecSide, iPass, iPen FROM UserData_Cell WHERE FileName = "' ExpName '";']);
	
	[iCell, THRSeq] = mym(10,['SELECT iCell, THRSeq FROM UserData_CellCF WHERE FileName = "' ExpName '";']);

	for cRow = 1:size(Chan1, 1)
		UD.CellInfo(cRow).Chan1 = Chan1{cRow};
		UD.CellInfo(cRow).Chan2 = Chan2{cRow};
		UD.CellInfo(cRow).DSS1 = DSS1{cRow};
		UD.CellInfo(cRow).DSS2 = DSS2{cRow};
		UD.CellInfo(cRow).Eval = Eval{cRow};
		UD.CellInfo(cRow).ExposedStr = ExposedStr{cRow};
		UD.CellInfo(cRow).FTCTHR = FTCTHR(cRow);
		UD.CellInfo(cRow).HistDepth = HistDepth(cRow);
		UD.CellInfo(cRow).Ignore = Ignore(cRow);
		UD.CellInfo(cRow).Nr = Nr(cRow);
		UD.CellInfo(cRow).RCNTHR = RCNTHR(cRow);
		UD.CellInfo(cRow).RecLoc = RecLoc{cRow};
		UD.CellInfo(cRow).RecSide = RecSide{cRow};
		UD.CellInfo(cRow).iPass = iPass(cRow);
		UD.CellInfo(cRow).iPen = iPen(cRow);
		
		idx = iCell == Nr(cRow);
		UD.CellInfo(cRow).THRSeq = THRSeq(idx)';
	end
	
	%By Abel
	%Return empty UD if nothing was found
	if isempty(UD.Experiment) && isempty(UD.DSInfo) && isempty(UD.CellInfo)
		UD = [];
		warning('SGSR:Info', 'No userdata found for datafile:%s/Cell:%d', ...
			ExpName, CellNr);
		return;
	end
	
	
	%Return requested information
	switch Mode
		case 'exp' %return information as is
		case 'cell' %Only return information for this cell
			SeqNrs = getSeqNrs4Cell(log2lut(ExpName), CellNr);
			UD = AdjustUDforCell(UD, CellNr);
			
			%by Abel (see below)
			%SeqNrs may contain multiple entries since a single cell may
			%have mutiple datasets
			if ~isempty(UD.DSInfo)
				UD = AdjustUDforDS(UD, SeqNrs);
			end
			
		case 'ds' %Only return information for this dataset
			UD = AdjustUDforCell(UD, CellNr);
			
			%by Abel: Skip AdjustDSforDS if UD.DSInfo is empty
			%DSInfo is obtained from UserData_DS which contains only entries in
			%special cases (for example when a comment was made or a sequence
			%should be ignored). If nothing was found in UserData_DS, no
			%additional info is needed. However UD should not be cleared and
			%UD.CellInfo should be returned.
			if ~isempty(UD.DSInfo)
				UD = AdjustUDforDS(UD, SeqNr);
			end
	end
	
	mym close;
else
	warning('Userdata only works in Matlab 7 or higher.');
end

%% Local functions
function [Mode, ExpName, CellNr, SeqNr, dsID] = localParseArg(ArgList)

[Mode, ExpName, CellNr, SeqNr, dsID] = deal([]);

switch length(ArgList)
	case 1
		if isa(ArgList{1}, 'char')
			ExpName = ArgList{1};
			Mode = 'exp';
		elseif isa(ArgList{1}, 'dataset')
			ds = ArgList{1};
			[ExpName, dsID, SeqNr, CellNr] = deal(ds.FileName, ds.SeqID, ds.iSeq, ds.iCell);
			if isnan(CellNr)
				warning('No cell number for this dataset. Cell related information cannot be returned.');
			end
			Mode = 'ds';
		else
			error('Wrong input arguments.');
		end
	case 2
		ExpName = ArgList{1};
		if ~ischar(ExpName)
			error('Wrong input arguments.');
		end
		if isa(ArgList{2}, 'double')
			CellNr = ArgList{2};
			Mode = 'cell';
		elseif isa(ArgList{2}, 'char')
			dsID = ArgList{2};
			[SeqNr, dsID] = GetSeqNr4dsID(log2lut(ExpName), dsID);
			if isnan(SeqNr)
				error('Dataset identifier is not unique.');
			end
			try
				CellNr = unraveldsID(dsID);
				if isempty(CellNr)
					error('To catch block ...');
				end
			catch
				warning('No cell number for this dataset. Cell related information cannot be returned.');
				CellNr = NaN;
			end
			Mode = 'ds';
		else
			error('Wrong input arguments.');
		end
	otherwise
		error('Wrong number of input arguments.');
end

%% AdjustUDforCell
function UD = AdjustUDforCell(UD, CellNr)

if all(isnan(CellNr))
	UD.CellInfo = struct([]);
else
	idx = ismember(cat(2, UD.CellInfo.Nr), CellNr);
	UD.CellInfo = UD.CellInfo(idx);
end

%% AdjustUDforDS
function UD = AdjustUDforDS(UD, SeqNr)

idx = ismember(cat(2, UD.DSInfo.SeqNr), SeqNr);
UD.DSInfo = UD.DSInfo(idx);

%by Abel: make output compatible
if all(idx == 0)
	return	%No userdata found
end
if isnan(UD.DSInfo.Ignore)
	UD.DSInfo.Ignore = false;
end
