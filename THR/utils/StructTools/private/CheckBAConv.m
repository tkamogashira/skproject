function boolean = CheckBAConv(ds, ReqConv)
%CHECKBACONV    check convention of binaural dataset.
%   CHECKBACONV(ds) checks the convention used for the sign of the values
%   of a binaural independent variable of a dataset. The standard convention
%   for ITD is that a positive ITD denotes a leading contralateral ear. For
%   binaural beats a positive beat designates a higher frequency administrated
%   to the contralateral ear. CHECKBACONV returns true or false.
%
%   CHECKBACONV(ds, Conv) checks a dataset for a supplied binaural convention,
%   which can be 'ipsi'- or 'contra'-lateral ear leads or highest frequency
%   was administrated at the 'ipsi'- or 'contra'-lateral ear.

%B. Van de Sande 18-08-2004

%Check input arguments ...
if ~any(nargin == [1, 2]), error('Wrong number of input arguments.'); end
if (nargin == 1), ReqConv = 'contra'; end

if ~isa(ds, 'dataset'), error('First argument should be dataset object.'); end
Nchan = 2 - sign(ds.chan);
if (Nchan ~= 2), error('Only binaural dataset can have ITD as independent variable.'); end
if strcmpi(ds.FileFormat, 'EDF') | (strcmpi(ds.FileFormat, 'MDF') & strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF')), 
    [isEDFds, isIDF_SPKds, IndepNr] = deal(logical(1), logical(0), ds.indepnr);
elseif strcmpi(ds.FileFormat, 'IDF/SPK') | (strcmpi(ds.FileFormat, 'MDF') & strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK')),
    [isEDFds, isIDF_SPKds, IndepNr] = deal(logical(0), logical(1), 1); 
else, [isEDFds, isIDF_SPKds, IndepNr] = deal(logical(0), logical(0), 1); end
if ~all(isnan(GetFreq(ds, 'fmod binbeat'))), dsType = 'BBmod';
elseif ~all(isnan(GetFreq(ds, 'fcar binbeat'))), dsType = 'BBcar';
else,
    if (IndepNr == 1),
        if strcmpi(ds.indepshortname, 'ITD'), dsType = 'ITD';
        else, error('Dataset must have ITD or BB as independent variable.'); end
    else,
        idx = find(strcmpi({ds.xname. ds.yname}, 'ITD'));
        if isempty(idx), error('Dataset must have ITD or BB as independent variable.');
        else, dsType = 'ITD'; end
    end    
end
if ~ischar(ReqConv) | ~any(strcmpi(ReqConv, {'ipsi', 'contra'})), error('Optional second argument must be ''ipsi''- or ''contra''-lateral ear leads.'); end

%Apply concention ...
if isEDFds, %EDF datasets ...
    %Get recording side and association of DSS number with left or right ear from userdata. The
    %former could have been retrieved from ID of calibration datasets in datafile directory, but
    %this is not always accurate enough ...
    UD = GetUserData(ds);
    if isempty(UD), error('Cannot retrieve userdata information from SGSR server.'); end
    if ~all(ismember({'RecSide', 'DSS1', 'DSS2'}, fieldnames(UD.CellInfo))),
        error('Userdata information related to cells should have the fields ''RecSide'', ''DSS1'' and ''DSS2''.'); 
    else, RecSide = UD.CellInfo.RecSide; end
    %Relationship between DSS number and labels master or slave is stored in the dataset itself ...
    if (ds.DSS(1).Nr == 1), MasterDSSEar = UD.CellInfo.DSS1;
    else, MasterDSSEar = UD.CellInfo.DSS2; end
    if (ds.DSS(2).Nr == 1), SlaveDSSEar = UD.CellInfo.DSS1;
    else, SlaveDSSEar = UD.CellInfo.DSS2; end
    if strcmpi(dsType, 'ITD'), %ITD as independent variable ...
        %Intial delay on master or slave DSS and its sign and the fact that the value of the independent
        %variable is slave minus master initial delay makes it possible to resolve the convention used for
        %the ITD values ...
        
        %Master DSS is ipsilateral ear, so because a positive ITD denotes a remaining delay on the slave DSS
        %this corresponds to a remaining delay on the contralateral ear -> +ITD = Ipsilateral ear leads ...
        if (strncmpi(MasterDSSEar, 'L', 1) & strncmpi(RecSide, 'L', 1)) | (strncmpi(MasterDSSEar, 'R', 1) & strncmpi(RecSide, 'R', 1)),
            ActConv = 'ipsi';
        %Master DSS is contralateral ear -> +ITD = Contralateral ear leads
        elseif (strncmpi(MasterDSSEar, 'L', 1) & strncmpi(RecSide, 'R', 1)) | (strncmpi(MasterDSSEar, 'R', 1) & strncmpi(RecSide, 'L', 1)),
            ActConv = 'contra';
        end
    else, %BB as independent variable ...
        %The frequency vector in the special structure is always organised according the Master-Slave convention 
        %for columns, i.e. the frequency administered at the master DSS is always in the first column and the
        %frequency for the slave DSS is located in the second column. The beatfrequencies are calculated by 
        %subtracting the master frequency from the slave frequency ...
        
        %Master DSS is ipsilateral ear, so when the beat frequency is positive (this is when the frequency 
        %administered at the slave DSS is higher) this denotes a higher frequency supplied at the contralateral
        %ear ...
        if (strncmpi(MasterDSSEar, 'L', 1) & strncmpi(RecSide, 'L', 1)) | (strncmpi(MasterDSSEar, 'R', 1) & strncmpi(RecSide, 'R', 1)),
            if strcmpi(dsType, 'BBcar') & all(sign(GetFreq(ds, 'fcar binbeat')) > 0), ActConv = 'contra';
            elseif strcmpi(dsType, 'BBcar'), ActConv = 'ipsi';
            elseif strcmpi(dsType, 'BBmod') & all(sign(GetFreq(ds, 'fmod binbeat')) > 0), ActConv = 'contra';
            else, ActConv = 'ipsi'; end;
        %Master DSS is contralateral ear, so when the beat frequency is positive (this is when the frequency 
        %administered at the slave DSS is higher) this denotes a higher frequency supplied at the ipsilateral
        %ear ...
        elseif (strncmpi(MasterDSSEar, 'L', 1) & strncmpi(RecSide, 'R', 1)) | (strncmpi(MasterDSSEar, 'R', 1) & strncmpi(RecSide, 'L', 1)),
            if strcmpi(dsType, 'BBcar') & all(sign(GetFreq(ds, 'fcar binbeat')) > 0), ActConv = 'ipsi';
            elseif strcmpi(dsType, 'BBcar'), ActConv = 'contra';
            elseif strcmpi(dsType, 'BBmod') & all(sign(GetFreq(ds, 'fmod binbeat')) > 0), ActConv = 'ipsi';
            else, ActConv = 'contra'; end;
        end
    end
else, %IDF/SPK and SGSR datasets ...
    %Recording side is extracted from the userdata. When recording side is not stored in the userdata
    %then for Farmington datasets this can be retrieved from the dataset field StimParam.stimcntrl.contrachan
    %where one designates left ear and zero right ear (Attention! The contralateral side is stored not the
    %recording side). Newer SGSR datasets have the field SessionInfo.Recording. In all other cases the
    %side of recording is unknown ...
    UD = GetUserData(ds);
    if isempty(UD) | ~ismember('RecSide', fieldnames(UD.CellInfo)) | isempty(UD.CellInfo.RecSide),
        warning('Recording side could not be extracted from userdata.'); 
        if isIDF_SPKds,
            if (ds.StimParam.stimcntrl.contrachan == 1), RecSide = 'R';
            elseif (ds.StimParam.stimcntrl.contrachan == 2), RecSide = 'L';    
            else, error('Cannot determine recording side for this dataset.'); end
        else,
            try, RecSide = ds.SessionInfo.RecordingSide;
            catch, error('Cannot determine recording side for this dataset.'); end
        end
    else, RecSide = UD.CellInfo.RecSide; end
    
    %The association between channel and ear is first retrieved from the userdata system. If this fails
    %then for newer SGSR datasets the field SessionInfo.leftDACear is looked for. Otherwise the standard
    %association of the first channel with left ear and the second with the right is assumed ...
    if isempty(UD) | ~all(ismember({'Chan1', 'Chan2'}, fieldnames(UD.CellInfo))) | ...
        isempty(UD.CellInfo.Chan1) | isempty(UD.CellInfo.Chan2),
        warning('Channel-ear relationship could not be extracted from userdata.'); 
        if ~isIDF_SPKds,
            try, Chan1 = ds.SessionInfo.leftDACear; if strncmpi(Chan1, 'L', 1), Chan2 = 'R'; else, Chan2 = 'L'; end
            catch, Chan1 = 'L'; Chan2 = 'R'; end
        else, Chan1 = 'L'; Chan2 = 'R'; end
    else, Chan1 = UD.CellInfo.Chan1; Chan2 = UD.CellInfo.Chan2; end
    
    if strcmpi(dsType, 'ITD'),
        %The ITD is saved according to the following convention: positive ITD designates ipsilateral
        %channel leads. While recording the only thing known is the recording side and the association
        %between channel and ear (For older datasets this is a fixed convention, for the newer ones this
        %is changeable by the user and stored in the dataset) ...
        %If channel and channel-ear relationship doesn't differ from the settings while recording the
        %convention stays unchanged.
        if isIDF_SPKds,
            if (ds.StimParam.stimcntrl.contrachan == 1), ColRecSide = 'R';
            elseif (ds.StimParam.stimcntrl.contrachan == 2), ColRecSide = 'L';    
            else, error('Cannot determine recording side for this dataset.'); end
        else,    
            try, ColRecSide = ds.SessionInfo.RecordingSide;
            catch, error('Cannot determine recording side for this dataset.'); end
        end
        diffRecSide = ~strncmpi(RecSide, ColRecSide, 1);
            
        if ~isIDF_SPKds,
            try, ColChan1 = ds.SessionInfo.leftDACear; if strncmpi(ColChan1, 'L', 1), ColChan2 = 'R'; else, ColChan2 = 'L'; end
            catch, ColChan1 = 'L'; ColChan2 = 'R'; end
        else, ColChan1 = 'L'; ColChan2 = 'R'; end
        diffChanRel = ~strncmpi(Chan1, ColChan1, 1) | ~strncmpi(Chan2, ColChan2, 1);
            
        if diffRecSide & diffChanRel, ActConv = 'ipsi';
        elseif diffRecSide | diffChanRel, ActConv = 'contra';
        else, ActConv = 'ipsi'; end    
    else,
        if ~all(ds.BeatModFreq == 0) & ~all(isnan(ds.BeatModFreq)),
            ModFreq = ds.ModFreq; if ~strcmpi(Chan1, 'L'), ModFreq = fliplr(ModFreq); end
                
            if all(ModFreq(:, 1) > ModFreq(:, 2)) & strncmpi(RecSide, 'R', 1), ActConv = 'contra';
            elseif all(ModFreq(:, 1) > ModFreq(:, 2)), ActConv = 'ipsi';
            elseif all(ModFreq(:, 1) < ModFreq(:, 2)) & strncmpi(RecSide, 'R', 1), ActConv = 'ipsi';
            else, ActConv = 'contra'; end
        else,
            CarFreq = ds.CarFreq; if ~strcmpi(Chan1, 'L'), CarFreq = fliplr(CarFreq); end
            
            if all(CarFreq(:, 1) > CarFreq(:, 2)) & strncmpi(RecSide, 'R', 1), ActConv = 'contra';
            elseif all(CarFreq(:, 1) > CarFreq(:, 2)), ActConv = 'ipsi';
            elseif all(CarFreq(:, 1) < CarFreq(:, 2)) & strncmpi(RecSide, 'R', 1), ActConv = 'ipsi';
            else, ActConv = 'contra'; end
        end    
    end
end
    
boolean = strcmpi(ActConv, ReqConv);