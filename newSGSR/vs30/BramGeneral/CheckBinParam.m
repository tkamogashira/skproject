function [boolean, param] = CheckBinParam(ds, ParamType)
%CHECKBINPARAM  check convention of binaural stimulus parameter.
%   CHECKBINPARAM(ds, ParamType) checks the convention of the binaural parameter
%   for the supplied dataset object ds. ParamType specifies what type of parameter
%   must be checked, this can be the interaural time difference('itd') or the 
%   binaural beat on the carrier or modulation frequency('bb').
%   The standard convention for the sign of the interaural time difference is that
%   a positive ITD denotes a leading contralateral ear. For binaural beats a positive
%   beat designates a higher frequency administrated to the contralateral ear. If the
%   sign of the binaural parameter is stored according to these conventions true is
%   returned, otherwise false is given back.

%B. Van de Sande 13-09-2004


%% ---------------- CHANGELOG -----------------------
%  Fri Apr 29 2011  Abel   
%   - Added output struct for all BinParams
%  Tue May 3 2011  Abel   
%   - Rewrite to support getDSEntryFromUserdata()
%  Tue May 3 2011  PXJ   
%   - Changed convention 
%  Tue May 31 2011  Abel   
%   - Added beatFreq to output 

%--------------------------------------LUT------------------------------------------
%Defining lookup table (LUT) for the fieldname where the values of the binaural
%parameter is located in the dataset object. This LUT is only used for Farmington and
%SGSR datasets ...
LUT = struct('StimType', {}, 'ParamType', {}, 'StorageType', {}, 'FieldName', {});

LUTentry.StimType    = 'ITD';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'Tdiff';
LUTentry.FieldName   = 'indepval';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'ITD';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'NTD';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'Tdiff';
LUTentry.FieldName   = 'indepval';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'IID';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'IID';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'BFS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'FS';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'FS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'FSlog';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'FSlog';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'BB';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'SPL';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'SPL';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'NSPL';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'ARMIN';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.delay(%d)';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'NRHO';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.delay(%d)';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'THR';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.delay(%d)';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'BERT';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'CFS';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'CFS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'CSPL';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'CSPL';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'CTD';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'Tdiff';
LUTentry.FieldName   = 'indepval';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'ICI';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = ''; %??
LUTentry.FieldName   = ''; %??
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'PS';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = ''; %??
LUTentry.FieldName   = ''; %??
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'PS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'FM';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'LMS';
LUTentry.ParamType   = 'ITD';
LUTentry.StorageType = 'delay';
LUTentry.FieldName   = 'StimParam.indiv.stim{%d}.delay';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'LMS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

LUTentry.StimType    = 'BMS';
LUTentry.ParamType   = 'BB';
LUTentry.StorageType = 'Fbeat';
LUTentry.FieldName   = 'fbeatmod,fbeat';
LUT = [LUT; LUTentry];

%Attention! SGSR and Farmington datasets with stimulus type WAV and BN don't have binaural 
%stimulus parameters. SGSR and Farmington datasets with stimulus type IMS and EREV are not
%included in this LUT ...

%-----------------------------------------------------------------------------------

%Check input arguments ...
if (nargin ~=  2)
	error('Wrong number of input arguments.');
elseif ~isa(ds, 'dataset')
	error('First argument should be dataset object.');
elseif ~ischar(ParamType) || ~any(strcmpi(ParamType, {'itd', 'bb'}))
	error('Second argument should be ''itd'' or ''bb''.');
end

%Thorough check of supplied dataset ...
[dsType, ChanNr] = CheckDataSet(ds);
if (ChanNr ~= 2)
	error('Supplied dataset must have two active channels.');
end

%Check convention used for the requested binaural parameter ...
[RecSide, RecSideOrigin] = ExtractRecSide(ds, dsType); %Extract recording side ...
[Chan1atEar, ChanMapOrigin] = ExtractChanMapping(ds, dsType); %Extract channel mapping, i.e. which channel (or DSS) is associated with what ear ...

switch lower(dsType),
	case {'sgsr', 'idf/spk'},
		LUTEntry = GetLUTEntry(LUT, ds.StimType, ParamType);
		if isempty(LUTEntry)
			error('Dataset with stimulus type ''%s'' doesn''t have binaural parameter of type ''%s''.', ds.StimType, ParamType); 
		end
		
		switch lower(ParamType),
			case 'itd',
				%The ITD is stored in the dataset according to the following convention: positive ITD designates
				%ipsilateral channel leads. While recording the only thing known to the software is the recording
				%side and the association between channel and ear (For older datasets this is a fixed convention,
				%for the newer ones this is changeable by the user and stored in the dataset). If channel and channel
				%mapping doesn't differ from the settings while recording the convention stays unchanged ...
				
				WarnMsg = 'Assumed %s while recording cannot be checked because absence of userdata information.';
				
				if ~strcmpi(RecSideOrigin, 'ud')
					WrongRecSide = false; 
					warning(WarnMsg, 'recording side');
				else
					WrongRecSide = ~strcmpi(RecSide, ExtractRecSide(ds, dsType, 'ds'));
				end
				
				if ~strcmpi(ChanMapOrigin, 'ud')
					WrongChanMap = false; 
					warning(WarnMsg, 'channel mapping');
				else
					WrongChanMap = ~strcmpi(Chan1atEar, ExtractChanMapping(ds, dsType, 'ds')); 
				end
				
				boolean = xor(WrongRecSide, WrongChanMap);
			case 'bb',
				%The frequency vector in the special structure is always organised in the following way: the
				%frequency administered at channel 1 is always in the first column and the frequency
				%at channel 2 in the second column. The beat frequencies are calculated by subtracting the
				%frequency of the first channel from those of the second channel...
				if strcmpi(LUTEntry.StorageType, 'fbeat')
					Fbeat = GetBinParamValues(ds, LUTEntry.FieldName);
				else
					Fbeat = diff([GetBinParamValues(ds, LUTEntry.FieldName, 2), GetBinParamValues(ds, LUTEntry.FieldName, 1)], 1, 2); 
				end
				if isempty(Fbeat) | (~all(Fbeat > 0) & ~all(Fbeat < 0))
					error('No valid beat frequency present in supplied dataset.'); 
				end
				
				
				% ds.fcar(:,1) is always channel1 (see dataset() )
				freqChan1 = ds.fcar(:,1);
				freqChan2 = ds.fcar(:,2);
				
				%check if channel1 is on the contra side
				isChan1Contra = ~isequal(Chan1atEar, RecSide);
				
				%Beat freq = (freq Contra) - (freq Ipsi)
				%First get Contra and Ipsi freq
				if isChan1Contra
					freqContra = freqChan1;
					freqIpsi = freqChan2;
					
					%Save column numbers (idx) of the carrier frequency of ipsi and contra
					%Master (always first column) == Contra
					contraColumnNrInCarFreq = 1;
					ipsiColumnNrInCarFreq = 2;
				else
					freqContra = freqChan2;
					freqIpsi = freqChan1;
					
					%Save column numbers (idx) of the carrier frequency of ipsi and contra
					%Master (always first column) == Ipsi
					contraColumnNrInCarFreq = 2;
					ipsiColumnNrInCarFreq = 1;
				end
				
				%Beat freq = (freq Contra) - (freq Ipsi)
				beatFreq = freqContra - freqIpsi;
				%Positive beat IF (freq Contra) - (freq Ipsi) > 0
				beatIsPos = all(beatFreq >0);
				
				%IF beat is positive, standard conventions apply. IF
				%negative flip
				if beatIsPos
					boolean = true;
				else
					boolean = false;
				end
				
% 				
% 				
% 				%If Channel 1 = recording side (thus is connected to the ipsilateral ear), and the beat frequency is positive
% 				%(i.e. freq channel 2 > freq channel 1), then: return true (standard situation)
% 				%Else Channel 1 is opposite to the recording side (thus is connected to the contralateral ear), so when the beat frequency is positive 
% 				%(i.e. freq channel 2 > freq channel 1), then: return false
% 				if isequal(Chan1atEar, RecSide)
% 					boolean = all(Fbeat > 0);
% 					
% 					%Save column numbers (idx) of the carrier frequency correlated to ipsi and contra
% 					%chan1 at rec location == ipsi channel 
% 					ipsiColumnNrInCarFreq = 1;
% 					contraColumnNrInCarFreq = 2;
% 				else
% 					boolean = ~all(Fbeat > 0); 
% 					
% 					
% 					%Save column numbers (idx) of the carrier frequency correlated to ipsi and contra
% 					%chan1 at rec location == ipsi channel 
% 					ipsiColumnNrInCarFreq = 2;
% 					contraColumnNrInCarFreq = 1;
% 				end		
		end
		
	case 'edf',
		%Extract master-slave mapping, i.e. which DSS is given the flag master and which one is slave ...
		MasteratChanNr = ExtractMasterMapping(ds);
		if (MasteratChanNr == 1)
			MasteratEar = Chan1atEar;
		elseif strcmpi(Chan1atEar, 'l')
			MasteratEar = 'r';
		else
			MasteratEar = 'l'; 
		end
		
		switch lower(ParamType),
			case 'itd',
				%Intial delay on master or slave DSS is stored in the datasets (StimParam.Delay) and
				%organised according the Master-Slave convention for columns, i.e. the delay administered
				%at the master DSS is always in the first column and the delay for the slave DSS in the
				%second column. For datasets with ITD as independendent variable the interaural time
				%differences are calculated as slave minus master initial delay ...
				
				%If master DSS is ipsilateral ear, then because a positive ITD denotes a remaining delay on
				%the slave DSS this corresponds to a remaining delay on the contralateral ear. Thus :
				%                            +ITD = ipsilateral ear leads
				boolean = ~isequal(MasteratEar, RecSide);
			case 'bb',
                %By PXJ:
                % fbeat information stored in the dataset is unreliable (Jane's search SRPP program does
                % not take master/slave situation into account to determine
                % beat sign, see e.g. R00001-9 and R00001-10
                
				% ds.fcar(:,1) is always Master (see EDFdataset() )
                freqMaster = ds.fcar(:,1);
                freqSlave = ds.fcar(:,2);
				
				%check if Master is on the contra side
				isMasterContra = ~isequal(MasteratEar, RecSide);
				
				%Beat freq = (freq Contra) - (freq Ipsi)
				%First get Contra and Ipsi freq
				if isMasterContra
					freqContra = freqMaster;
					freqIpsi = freqSlave;
					
					%Save column numbers (idx) of the carrier frequency of ipsi and contra
					%Master (always first column) == Contra
					contraColumnNrInCarFreq = 1;
					ipsiColumnNrInCarFreq = 2;
				else
					freqContra = freqSlave;
					freqIpsi = freqMaster;
					
					%Save column numbers (idx) of the carrier frequency of ipsi and contra
					%Master (always first column) == Ipsi
					contraColumnNrInCarFreq = 2;
					ipsiColumnNrInCarFreq = 1;
				end
					
				%Beat freq = (freq Contra) - (freq Ipsi)
				beatFreq = freqContra - freqIpsi;
				%Positive beat IF (freq Contra) - (freq Ipsi) > 0
                beatIsPos = all(beatFreq >0);
                
				%IF beat is positive, standard conventions apply. IF
				%negative flip 
                if beatIsPos
                    boolean = true;
                else
                    boolean = false;
                end
                
% 				%The frequency vector in the special structure is always organised according the Master-Slave
% 				%convention for columns, i.e. the frequency administered at the master DSS is always in the
% 				%first column and the frequency for the slave DSS is located in the second column. The beat
% 				%frequencies are calculated by subtracting the master frequency from the slave frequency ...
% 				
% 				%First check if there is a beat on a modulation frequency, otherwise check for a
% 				%beat on a carrier frequency ...
% 				Fbeat = GetBinParamValues(ds, 'fbeatmod,fbeat');
% 				if isempty(Fbeat) | (~all(Fbeat > 0) & ~all(Fbeat < 0))
% 					error('No valid beat frequency present in supplied dataset.'); 
% 				end
% 				
% 				%Master DSS associated with the ipsilateral ear, so when the beat frequency is positive
% 				%(this is when the frequency administered at the slave DSS is higher) this denotes a higher
% 				%frequency supplied at the contralateral ear ...
% 				if isequal(MasteratEar, RecSide)
% 					boolean = all(Fbeat > 0);
% 					%Master DSS is contralateral ear, so when the beat frequency is positive (this is when
% 					%the frequency administered at the slave DSS is higher) this denotes a higher frequency supplied
% 					%at the ipsilateral ear ...
% 				else
% 					boolean = ~all(Fbeat > 0);
% 				end
		end
	otherwise,
		error('Dataset type ''%s'' not yet implemented.', ParamType);
end
%% Prepare output struct()
% Save variables in output structure
saveParam = { 'ParamType', 'dsType', 'ChanNr', 'RecSide', 'RecSideOrigin',...
	'Chan1atEar', 'ChanMapOrigin', 'ipsiColumnNrInCarFreq', 'contraColumnNrInCarFreq',...
	'MasteratChanNr', 'beatFreq'};
for n=1:length(saveParam);
	if exist(saveParam{n})
		param.(saveParam{n}) = eval(saveParam{n});
	end
end

%----------------------------------local functions----------------------------------
function [dsType, NChan] = CheckDataSet(ds)

NChan = 2 - sign(ds.chan);

if strcmpi(ds.FileFormat, 'edf') | (strcmpi(ds.FileFormat, 'mdf') & strcmpi(ds.ID.OrigID(1).FileFormat, 'edf')), dsType = 'edf';
elseif strcmpi(ds.FileFormat, 'idf/spk') | (strcmpi(ds.FileFormat, 'mdf') & strcmpi(ds.ID.OrigID(1).FileFormat, 'idf/spk')), dsType = 'idf/spk';
else, dsType = 'sgsr'; end

%-----------------------------------------------------------------------------------
function LUTEntry = GetLUTEntry(LUT, StimType, ParamType)

idx = find(strcmpi({LUT.StimType}, StimType) & strcmpi({LUT.ParamType}, ParamType));
if isempty(idx), LUTEntry = [];
elseif (length(idx) > 1), error(sprintf('%s contains invalid LUT.', mfilename));
else, LUTEntry = LUT(idx); end

%-----------------------------------------------------------------------------------
function [RecSide, Origin] = ExtractRecSide(ds, dsType, Source)
%The recording side is looked for in the userdata. When this information is not stored
%in the userdata then for Farmington datasets this can be retrieved from the dataset
%field StimParam.stimcntrl.contrachan where one designates left ear and zero right ear
%(Attention! The contralateral side is stored not the recording side).
%Newer SGSR datasets have the field SessionInfo.Recording. In all other cases the side
%of recording is unknown ...

if (nargin == 2)
	Source = 'ud'; 
end
[DataFile, CellNr] = deal(ds.FileName, ds.icell); %Information for messages ...

try %Extract recording side from UserDataInterface(UDI) ...
	Origin = 'ud';
	
	if strcmpi(Source, 'ds')
		error('skipuserdata');
	end

	%by Abel: updated code for use with getRecSideFromUserdata()
	RecSide = lower(getDSEntryFromUserdata(ds, 'RecSide'));
	if isempty(RecSide)
		error('nouserdata');
	end
	if ~strncmpi(RecSide, {'l', 'r'}, 1)
		error('wrongvalue');
	end
	
	RecSide = RecSide(1);
% 	UD = struct([]);
% 	try
% 		UD = getuserdata(ds);
% 	end
% 	if isempty(UD)
% 		error('nouserdata');
% 	end
	
% 	if ~ismember('RecSide', fieldnames(UD.CellInfo))
% 		error('nofield');
% 	else
% 		RecSide = UD.CellInfo.RecSide;
% 	end
% 	if ~strncmpi(RecSide, {'l', 'r'}, 1)
% 		error('wrongvalue');
% 	else
% 		RecSide = lower(RecSide(1));
% 	end
catch %Try to extract recording side from the dataset itself ...
	Origin = 'ds';
	
	switch lasterr,
		case 'nouserdata', warning(sprintf('No userdata present for %s. Trying to extract recording side from dataset.', DataFile));
		case 'nofield', warning(sprintf('The field ''RecSide'' is not present in userdata for ''%s''.  Trying to extract recording side from dataset.', DataFile));
		case 'wrongvalue', warning(sprintf('Recording side for cell %d in userdata of datafile ''%s'' is not valid.  Trying to extract recording side from dataset.', CellNr, DataFile)); 
	end
		
		switch dsType,
			case 'sgsr',
				if isfield(ds.SessionInfo, 'RecordingSide'), RecSide = ds.SessionInfo.RecordingSide;
				else, error('Recording side could not be determined for supplied dataset.'); end
				if strncmpi(RecSide, {'l', 'r'}, 1), RecSide = lower(RecSide(1));
				else, error('Recording side could not be determined for supplied dataset.'); end
			case 'idf/spk',
				if (ds.StimParam.stimcntrl.contrachan == 1), RecSide = 'r';
				elseif (ds.StimParam.stimcntrl.contrachan == 2), RecSide = 'l';
				else, error('Recording side could not be determined for supplied dataset.'); end
			case 'edf', error('Recording side could not be determined for supplied dataset.'); 
		end
end

%-----------------------------------------------------------------------------------
function [Chan1atEar, Origin] = ExtractChanMapping(ds, dsType, Source)
%The association between channel and ear is first retrieved from the userdata system.
%If this fails then for newer SGSR datasets the field SessionInfo.leftDACear is looked
%for. Otherwise the standard association of the first channel with left ear and the
%second with the right is assumed for Farmington and SGSR datasets. For EDF datasets
%only the userdata can be used to determine the channel mapping (It could have been
%retrieved from ID of calibration datasets in datafile directory, but this is not always
%accurate enough) ...

if (nargin == 2)
	Source = 'ud'; 
end
[DataFile, CellNr] = deal(ds.FileName, ds.icell); %Information for messages ...

try %Extract channel mapping from UserDataInterface(UDI) ...
	Origin = 'ud';
	
	if strcmpi(Source, 'ds')
		error('skipuserdata');
	end
% 	UD = struct([]);
% 	try
% 		UD = getuserdata(ds);
% 	end
% 	if isempty(UD)
% 		error('nouserdata');
% 	end
	
	switch lower(dsType),
		case {'sgsr', 'idf/spk'}
			Chan1atEar = lower(getDSEntryFromUserdata(ds, 'Chan1'));
			
% 			
% 			if ~ismember('Chan1', fieldnames(UD.Experiment))
% 				error('nofield');
% 			else
% 				Chan1atEar = UD.Experiment.Chan1;
% 			end
		case 'edf',
			Chan1atEar = lower(getDSEntryFromUserdata(ds, 'DSS1'));
			
% 			if ~ismember('DSS1', fieldnames(UD.Experiment))
% 				error('nofield');
% 			else
% 				Chan1atEar = UD.Experiment.DSS1;
% 			end
	end
	if ~strncmpi(Chan1atEar, {'l', 'r'}, 1)
		error('wrongvalue');
	end
	Chan1atEar = Chan1atEar(1);
% 	else
% 		Chan1atEar = lower(Chan1atEar(1));
% 	end
catch
	Origin = 'ds';
	
	switch lasterr,
		case 'nouserdata', warning(sprintf('No userdata present for %s. Trying to extract channel mapping from dataset.', DataFile));
		case 'nofield', warning(sprintf('The field ''Chan1'' or ''DSS1'' is not present in userdata for ''%s''.  Trying to extract channel mapping from dataset.', DataFile));
		case 'wrongvalue', warning(sprintf('Channel mapping for cell %d in userdata of datafile ''%s'' is not valid.  Trying to extract mapping from dataset.', CellNr, DataFile)); end
		
		switch dsType,
			case 'sgsr',
				if isfield(ds.SessionInfo, 'leftDACear')
					Chan1atEar = ds.SessionInfo.leftDACear;
					if strncmpi(Chan1atEar, {'l', 'r'}, 1)
						Chan1atEar = lower(Chan1atEar(1));
					else
						error('Channel mapping derived from dataset is invalid.');
					end
				else
					Chan1atEar = 'l';
				end
			case 'idf/spk'
				Chan1atEar = 'l';
			case 'edf'
				error('Channel mapping could not be determined for supplied dataset.');
		end
end

%-----------------------------------------------------------------------------------
function MasteratChanNr = ExtractMasterMapping(ds)
%Relationship between DSS number and labels master or slave is stored in the dataset
%itself ...

MasteratChanNr = ds.DSS(1).Nr; 

%-----------------------------------------------------------------------------------
function V = GetBinParamValues(ds, FieldName, varargin)
%Features: 1)comma-separated list of fieldnames, which are assessed in the given order ...
%          2)branch specification by separating fieldnames with a dot ...
%          3)channel specification ...

FNames = cleanStr(Words2cell(FieldName, ',')); 
N = length(FNames);
if (N > 1), %Recursion ...
    for n = 1:N, 
        V = GetBinParamValues(ds, FNames{n}, varargin{:}); 
        if ~isempty(V)
			return;
		end
    end
else
    if (nargin == 3), ChanNr = varargin{1}; 
		FieldName = sprintf(FieldName, ChanNr); 
	end
    %Attention! The specified fieldname is not always present in a dataset. This does not
    %mean that the LUT is invalid, the binaural parameters stored in the specified field
    %could have been added in a newer version of the dataset ...
    try
        V = eval(sprintf('ds.%s', FieldName)); 
        if all(isnan(V)) | all(V == 0)
			error('To catch block ...'); 
		end
	catch
		V = []; 
	end
end

%-----------------------------------------------------------------------------------