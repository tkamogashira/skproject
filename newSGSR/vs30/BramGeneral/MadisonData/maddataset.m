function ds = maddataset(FileName, dsID, varargin)
%MADDATASET    convert Madison data to a dataset object
%   ds = MADDATASET(FileName, dsID or SeqNr) returns dataset-object loaded from datafile recorded
%   at the University of Wisconsin. The name of the datafile is given in FileName, the extension is .DAT by
%   default. The ID can be given to specify the dataset to be loaded. This identifier must be a character
%   string giving the cellnumber, testnummer and stimulustype separated by a dash.
%   A dataset can also be identified by its sequence number. Sometimes a sequence number isn't unique. However
%   this can only be the case for NSPL and OSCOR-stimuli. When this occurs, the sequence number denotes the
%   OSCOR-dataset.
%
%   The type of stimuli that can be loaded are NSPL, OSCR, OSCRCTL, OSCRTD or BB. NSPL designates an itensity
%   function for noise stimuli (mostly OSCOR-noise stimulus at a given modulation frequency), OSCOR denotes the
%   interaural adminstration of oscillating correlation (OSCOR) stimuli for different modulation frequency.
%   OSCRCTL is the control stimulus and OSCRTD is the delay-function for OSCOR-noise at a given modulation
%   frequency. BB designates binaural beat-stimulus responses. It is important to note that the IDs of these
%   stimulustypes do not correspond to the orginal IDs in the Madison datafile. Conversion is done via the
%   Microsoft Excel spreadsheet MADISONDATA.XLS located in the madison data directory.
%
%   Dataset objects with responses to oscillating correlation (OSCOR) noise are timewarped to correct a stimulus
%   artefact that was introduced while recording.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default values, use 'list' as only property.
%
%   Attention! These results are cached in C:\usr\"UserName"\madisondata\cache\.
%
%   See also DATASET

%B. Van de Sande 22-12-2004, timewarping of AN-data delayed until after correlation ...

%Standaard parameters ...
DefParam.cache = 'y'; %yes or no ...

ds = dataset; %Leeg dataset object ...

%Input argumenten nagaan ...
if nargin < 2
    error('Wrong number of input arguments');
end

Param = checkproplist(DefParam, varargin{:});
if ~any(strncmpi(Param.cache, {'y', 'n'}, 1))
    error('Invalid value for property cache.');
end

switch class(dsID)
    case 'char'
        [dummy, dummy, dsID, DataType] = unraveldsID(dsID);
        [DataFile, Cell] = CheckMadisondsID(FileName, dsID, DataType);
        DataType = upper(DataType);
    case 'double'
        SeqNr = dsID;
        NElem = prod(size(SeqNr));
        if NElem > 1
            ds = [];
            for n = 1:NElem
                ds = [ds; maddataset(FileName, SeqNr(n))];
            end
            ds = reshape(ds, size(SeqNr));
            return;
        else
            DataFile = CheckMadisonDataFile(FileName);
            OrgdsID = GetMadisondsID(fullfile(DataFile.Path, [DataFile.FileName, DataFile.FileExt]), SeqNr);
            [CellNr, TestNr, DataType, ExtraInfo] = ConvMadisonOrgdsID(DataFile, OrgdsID);
            DataType = upper(DataType);
            if isempty(DataType)
                error(sprintf('Sequence number %d cannot be converted.', SeqNr));
            end
            dsID = OrgdsID;
            Cell = CollectInStruct(dsID, CellNr, TestNr, ExtraInfo);
        end
    otherwise
        error('Wrong input arguments.');
end

[ThrCurveParam, Localisation] = GetMadisonCellParam(DataFile, Cell.CellNr);

%Bestandorganisatie ...
if ~exist([DataFile.Path 'CACHE\'], 'dir')
    mkdir(DataFile.Path, 'CACHE'); 
    warning('CACHE-directory didn''t exist and was created.');
end

DataFileName  = fullfile(DataFile.Path, [DataFile.FileName DataFile.FileExt]);
CacheFileName = fullfile(DataFile.Path, '\CACHE\MADDATASET.CACHE');

if strncmpi(Param.cache, 'y', 1)
    %Nagaan of gegevens reeds in cache zitten ...
    SearchParam.DataFile = [DataFile.FileName DataFile.FileExt];
    SearchParam.CellNr   = Cell.CellNr;
    SearchParam.TestNr   = Cell.TestNr;
    SearchParam.DataType = DataType;
    %Oorspronkelijk gewoon CACHE-systeem gebruikt, maar dit laat niet toe om de CACHE te kopieren van de ene
    %gebruiker naar de andere... daarom overgeschakeld naar HASH-systeem met STORAGE-functie
    %Data = FromCacheFile(CacheFileName, SearchParam);
    Data = GetFromHashFile(CacheFileName, SearchParam);
else
    Data = []; 
end

if ~isempty(Data)
    ds = Data; 
    return;
else %Anders gegevens inladen ...
    switch DataType
        case 'NSPL'
            Var = GetMadisonIndepVar(DataFileName, Cell.dsID);
            if ~strncmpi(Var.Name, 'SPL', 3), error('Unknown datatype'); end

            SptCell = GetMadisonSpkTimes(DataFileName, Cell.dsID, 1);

            Values = Var.Low:Var.LinInc:Var.High;
            %Aantal subsequenties ...
            NSubRecorded = size(SptCell, 1);
            NSubSeq      = length(Values);
            %Onafhankelijke variabele analyseren ...
            Name      = 'Intensity';
            ShortName = 'Level';
            Unit      = 'dB SPL';
            PlotScale = 'linear';
            Values    = GetIndepValues(Values(1:NSubRecorded), NSubSeq);
            IndepVar  = CollectInStruct(Values, Name, ShortName, Unit, PlotScale);
            %Stimulus parameters analyseren ... Hier worden twee extra stimulus parameters toegevoegd, namelijk
            %ModFreq en RecordingSide ... Belangrijk is dat indien een parameter als onafhankelijke variabele is
            %opgegeven dan heeft dit voorrang op de constante waarde ...
            StimParam               = GetMadisonStimParam(DataFileName, Cell.dsID);
            StimParam.SPL           = NaN;
            StimParam.ModFreq       = GetModFreq(Cell.dsID);
            StimParam.CarFreq       = NaN;
            StimParam.RecordingSide = 1;
            %Dataset nummer en recording time achterhalen ...
            [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID);

            ds = MakeDataSet(DataFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam);
            if any(strncmp({StimParam.MasterDSS.GWID, StimParam.SlaveDSS.GWID}, 'AB', 2)) | any(strncmp({StimParam.MasterDSS.GWID, StimParam.SlaveDSS.GWID}, 'HPAB', 4))
                warning(sprintf('%s <%d-%d-%s> is being timewarped. This may take a while.', DataFile.FileName, Cell.CellNr, Cell.TestNr, DataType));
                ds = timewarp(ds);
            end
        case 'NITD'
            IndepVar = GetMadisonIndepVar(DataFileName, Cell.dsID);
            if ~strncmpi(IndepVar(1).Name, 'DELAY', 4), error('Unknown datatype'); end
            if (length(IndepVar) == 2) & strncmpi(IndepVar(2).Name, 'SPL', 3), SPL = IndepVar(2).High; end

            SptCell = GetMadisonSpkTimes(DataFileName, Cell.dsID, 1);

            Values = IndepVar(1).Low:IndepVar(1).LinInc:IndepVar(1).High;
            %Aantal subsequenties ...
            NSubRecorded = size(SptCell, 1);
            NSubSeq      = length(Values);
            %Onafhankelijke variabele analyseren ...
            Name      = 'Interaural time';
            ShortName = 'ITD';
            Unit      = '\mus';
            PlotScale = 'linear';
            Values    = GetIndepValues(Values(1:NSubRecorded), NSubSeq);
            IndepVar  = CollectInStruct(Values, Name, ShortName, Unit, PlotScale);
            %Stimulusparameters analyseren ...
            StimParam               = GetMadisonStimParam(DataFileName, Cell.dsID);
            StimParam.ModFreq       = NaN;
            StimParam.CarFreq       = NaN;
            StimParam.ITD           = NaN;
            if exist('SPL', 'var'), StimParam.SPL = SPL; end
            StimParam.RecordingSide = 1; %Moet vervangen worden met waarde in Cell.ExtraInfo ...
            %Dataset nummer en recording time achterhalen ...
            [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID);

            ds = MakeDataSet(DataFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam);
        case {'OSCR', 'OSCRCTL'}
            switch Cell.ExtraInfo %Extra informatie is de conversie methode ...
                case 'MAN'
                    error(sprintf('%s <%d-%d-%s> has to be loaded manually', DataFile.FileName, Cell.CellNr, Cell.TestNr, DataType));
                case 'DSN'
                    switch Localisation
                        case 'IC', ModFreq = [1,2,5,10,20,50,75,100,150,200,300,400,500,750,1000]; NSubSeq = 15;
                        case 'AN', ModFreq = [NaN,NaN,NaN,NaN,1,2,5,10,20,50,75,100,150,200,300,400,500,750,1000]; NSubSeq = 19;
                    end

                    Var = GetMadisonIndepVar(DataFileName, Cell.dsID);
                    if ~strncmp(Var.Name, 'DSNUM', 5), error('Unknown datatype'); end
                    SptCell = GetMadisonSpkTimes(DataFileName, Cell.dsID, 1);

                    NSubRecorded = size(SptCell,1); ModFreq = ModFreq(1:NSubRecorded);

                    %Stimulusparameters analyseren ...
                    StimParam = GetMadisonStimParam(DataFileName, Cell.dsID);
                case 'SEQ'
                    NSubSeq = 15;

                    [ModFreq, SPL] = deal([]); [CellList, SptCell] = deal(cell(0));

                    %Spiketimes inlezen voor eerste modulatie frequency ...
                    CellList{1} = Cell.dsID;

                    Var1 = GetMadisonIndepVar(DataFileName, CellList{1});
                    if ~strncmp(Var1.Name, 'SPL', 3), error('Unknown datatype'); end
                    SptCell1 = GetMadisonSpkTimes(DataFileName, CellList{1}, 1);

                    % Modulatiefrequentie achterhalen ...
                    NewModFreq = GetModFreq(CellList{1}); if isnan(NewModFreq), error('Unknown datatype'); end
                    ModFreq    = [ModFreq NewModFreq];

                    %Spiketimes inlezen voor tweede tweede modulatie frequency ...
                    CellList{2} = GetNextMadisondsID(DataFileName, CellList{1});
                    if isempty(CellList{2}), error('Unknown datatype'); end

                    Var2 = GetMadisonIndepVar(DataFileName, CellList{2});
                    if ~strncmp(Var2.Name, 'SPL', 3), error('Unknown datatype'); end
                    SptCell2 = GetMadisonSpkTimes(DataFileName, CellList{2}, 1);

                    %Modulatiefrequentie achterhalen ...
                    NewModFreq = GetModFreq(CellList{2}, CellList{1}); if isnan(NewModFreq), error('Unknown datatype'); end
                    ModFreq    = [ModFreq NewModFreq];

                    %Indien nodig SPL-level waarop experiment uitgevoerd is achterhalen en
                    %van eerste dataset enkel subsequentie onthouden bij juiste SPL-level
                    if Var2.Low == Var2.High
                        SPL = Var2.Low;
                        SptCell(1,:) = SptCell1(((SPL - Var1.Low)/Var1.LinInc + 1),:);
                    else, error('Unknown datatype'); end
                    SptCell(2,:) = SptCell2(1,:);

                    %Spiketimes inlezen voor volgende modulatiefrequenties ...
                    Nr = 3;
                    while 1
                        CellList{Nr} = GetNextMadisondsID(DataFileName, CellList{Nr-1});
                        if isempty(CellList{Nr}), break; end %Einde van file bereikt ... (Niet bestaande dsID uitgesloten!)

                        %Spiketimes lezen ...
                        VarN = GetMadisonIndepVar(DataFileName, CellList{Nr});
                        if isempty(VarN) | ~strncmp(VarN(1).Name, 'SPL', 3), break; end
                        SptCellN = GetMadisonSpkTimes(DataFileName, CellList{Nr}, 1);

                        %Modulatiefrequentie achterhalen ...
                        NewModFreq = GetModFreq(CellList{Nr}, CellList{Nr-1}); if isnan(NewModFreq), break; end
                        ModFreq    = [ModFreq NewModFreq];

                        %Spiketimes bewaren ...
                        if (size(SptCellN, 1) > 1) | (VarN.Low ~= VarN.High) | (VarN.Low ~= SPL), error('Unknown dataset'); end
                        SptCell(Nr, :) = SptCellN(1, :);

                        Nr = Nr + 1;
                    end

                    %Stimulusparameters analyseren ...
                    StimParam = GetMadisonStimParam(DataFileName, Cell.dsID);

                    Cell.dsID = CellList(1:end-1);
            end
            %Onafhankelijke variabele analyseren ...
            Name      = 'Modulation frequency';
            ShortName = 'MF';
            Unit      = 'Hz';
            PlotScale = 'log';
            Values    = GetIndepValues(ModFreq, NSubSeq);
            IndepVar  = CollectInStruct(Values, Name, ShortName, Unit, PlotScale);
            %Stimulusparameters analyseren ...
            switch Localisation
                case 'IC'
                    %Voor OSCR-datasets is de DSS die niet gewijzigd werd deze die als GWID 'A', 'B', 'HPA' of 'HPB'
                    %bevat ... Voor OSCRCTL datasets is de SlaveDSS steeds deze die niet gewijzigd wordt ...
                    if strcmp(DataType, 'OSCRCTL' ) | any(strcmpi(StimParam.SlaveDSS.GWID, {'A', 'B', 'HPA', 'HPB'})),
                        StimParam.MasterDSS.GWID = 'AB1,AB2,AB5,AB10,AB20,AB50,AB75,AB100,AB150,AB200,AB300,AB400,AB500,AB750,AB1000';
                    else,
                        StimParam.SlaveDSS.GWID = 'AB1,AB2,AB5,AB10,AB20,AB50,AB75,AB100,AB150,AB200,AB300,AB400,AB500,AB750,AB1000';
                    end
                case 'AN'
                    StimParam.MasterDSS.GWID = '+A,+B,-A,-B,AB1,AB2,AB5,AB10,AB20,AB50,AB75,AB100,AB150,AB200,AB300,AB400,AB500,AB750,AB1000';
                    StimParam.SlaveDSS.GWID  = '';
            end
            if exist('SPL'), StimParam.SPL = SPL; end
            StimParam.ModFreq       = NaN;
            StimParam.CarFreq       = NaN;
            StimParam.RecordingSide = 1;
            %Dataset nummer en recording time achterhalen ...
            if iscell(Cell.dsID), [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID{1});
            else [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID); end

            ds = MakeDataSet(DataFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam);

            %Timewarping of AN-data is delayed until after correlation ...
            %NEW SINCE 22-12-2004
            switch Localisation
                case 'IC'
                    warning(sprintf('%s <%d-%d-%s> is being timewarped. This may take a while.', DataFile.FileName, Cell.CellNr, Cell.TestNr, DataType));
                    ds = timewarp(ds);
                case 'AN',
                    warning(sprintf('Timewarping of %s <%d-%d-%s> is delayed until after correlation.', DataFile.FileName, Cell.CellNr, Cell.TestNr, DataType));
            end
        case 'OSCRTD'
            IndepVar = GetMadisonIndepVar(DataFileName, Cell.dsID);
            if isempty(IndepVar), error('Unknown datatype'); end;
            %Indien SPL als onafhankelijke variabele is opgegeven dan deze achterhalen ...
            SPLIndepVarNr = strfindcell(char(IndepVar.Name), 'SPL');
            if ~isempty(SPLIndepVarNr), SPL = IndepVar(SPLIndepVarNr).Low; end

            IndepVarNr = strfindcell(char(IndepVar.Name), 'DELAY');
            Var = IndepVar(IndepVarNr);

            SptCell = GetMadisonSpkTimes(DataFileName, Cell.dsID, IndepVarNr);

            Values = Var.Low:Var.LinInc:Var.High;
            %Aantal subsequenties ...
            NSubRecorded = size(SptCell, 1);
            NSubSeq      = length(Values);
            %Onafhankelijke variabele analyseren ...
            Name      = 'Interaural time';
            ShortName = 'ITD';
            Unit      = '\mus';
            PlotScale = 'linear';
            Values    = GetIndepValues(Values(1:NSubRecorded), NSubSeq);
            IndepVar  = CollectInStruct(Values, Name, ShortName, Unit, PlotScale);
            %Stimulus parameters analyseren ...
            StimParam               = GetMadisonStimParam(DataFileName, Cell.dsID);
            if exist('SPL'), StimParam.SPL = SPL; end
            StimParam.ModFreq       = sscanf(Cell.ExtraInfo, '%dhz'); %Extra informatie is de modulatie frequentie ...
            StimParam.CarFreq       = NaN;
            StimParam.ITD           = NaN;
            StimParam.RecordingSide = 1;
            %Dataset nummer en recording time achterhalen ...
            [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID);

            ds = MakeDataSet(DataFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam);
            warning(sprintf('%s <%d-%d-%s> is being timewarped. This may take a while.', DataFile.FileName, Cell.CellNr, Cell.TestNr, DataType));
            ds = timewarp(ds);
        case 'BB'
            IndepVar = GetMadisonIndepVar(DataFileName, Cell.dsID);
            if isempty(IndepVar) | length(IndepVar) ~= 2 | ...
                    ~strncmp(IndepVar(1).Name, 'SPL', 3) | ~strncmp(IndepVar(2).Name, 'FCARR', 5), error('Unknown datatype'); end;
            SPL = IndepVar(1).Low;
            Var = IndepVar(2);

            SptCell = GetMadisonSpkTimes(DataFileName, Cell.dsID, 2);

            %Stimulus parameters afhalen om beat-frequenties te kunnen berekenen ...
            StimParam = GetMadisonStimParam(DataFileName, Cell.dsID);
            %????????????????????????????????????????????????????????????????????????????????????????????????????
            %Bij omgekeerd aanbieden van de stimuli moeten de beatfrequencies omgekeerd worden ... Is bizar want
            %spiketimes worden in de status-tabel altijd in stijgende volgorde opgeslagen en GetMadisonSpkTimes
            %zet deze dan terug in de omgekeerde volgorde indien nodig.
            %????????????????????????????????????????????????????????????????????????????????????????????????????
            if strcmpi(Var.Order, 'descending'), Values = fliplr(abs((Var.Low:Var.LinInc:Var.High) - StimParam.CarFreq));
            else, Values = abs((Var.Low:Var.LinInc:Var.High) - StimParam.CarFreq); end
            %Aantal subsequenties ...
            NSubRecorded = size(SptCell, 1);
            NSubSeq      = length(Values);
            %Onafhankelijke variabele analyseren ...
            Name      = 'Binaural Beat Frequency';
            ShortName = 'BB Freq.';
            Unit      = 'Hz';
            PlotScale = 'linear';
            Values    = GetIndepValues(Values(1:NSubRecorded), NSubSeq);
            IndepVar  = CollectInStruct(Values, Name, ShortName, Unit, PlotScale);
            %Stimulus parameters analyseren ...
            StimParam.SPL           = SPL;
            StimParam.ModFreq       = NaN;
            StimParam.ITD           = NaN;
            StimParam.FilterType    = NaN;
            StimParam.RecordingSide = 1;
            [StimParam.MasterDSS.GWID, StimParam.SlaveDSS.GWID] = deal(NaN);
            %Dataset nummer en recording time achterhalen ...
            [DSNr, dummy, RecTime] = GetMadisonDSInfo(DataFileName, Cell.dsID);

            ds = MakeDataSet(DataFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam);
    end
    if strncmpi(Param.cache, 'y', 1),
        Data = ds;
        %Oorspronkelijk gewoon CACHE-systeem gebruikt, maar dit laat niet toe om de CACHE te kopieren van de ene
        %gebruiker naar de andere... daarom overgeschakeld naar HASH-systeem met STORAGE-functie
        %ToCacheFile(CacheFileName, +10000, SearchParam, Data);
        PutInHashFile(CacheFileName, SearchParam, Data, +1009);
    end
end

%----------------%
% LOKALE FUNTIES %
%----------------%
function IndepValues = GetIndepValues(IndepValues, NSubSeqs)

SubSeqRecorded = length(IndepValues);

if SubSeqRecorded < NSubSeqs
    IndepValues = [IndepValues repmat(NaN, 1, NSubSeqs - SubSeqRecorded)];
end

function ModFreq = GetModFreq(dsID, PrevdsID)

ModFreq = NaN;

if nargin == 1, PrevdsID = ''; end

if ~isempty(findstr(dsID, 'oscr'))
    if isempty(PrevdsID), ModFreq = 1; end
elseif ~isempty(findstr(dsID, 'ab'))
    if isempty(PrevdsID) & strcmp(dsID(end-2:end), '-ab'), ModFreq = 1; return; end
    if ~isempty(PrevdsID) & isempty(findstr(PrevdsID, 'oscr')) & isempty(findstr(PrevdsID, 'ab')), return; end
    Nrs = sscanf(dsID, '%d-%d-ab%d');
    if (ndims(Nrs) == 2) & (length(Nrs) == 3), ModFreq = Nrs(3); end
elseif ~isempty(findstr(dsID, 'hz'))
    if ~isempty(PrevdsID) & isempty(findstr(PrevdsID, 'oscr')) & isempty(findstr(PrevdsID, 'hz')), return; end
    Nrs = sscanf(dsID, '%d-%d-%dhz');
    if (ndims(Nrs) == 2) & (length(Nrs) == 3), ModFreq = Nrs(3); end
end

function ds = MakeDataSet(FullFileName, DSNr, RecTime, Cell, DataType, NSubSeq, SptCell, IndepVar, StimParam)

[Path, FileName, FileExt] = fileparts(FullFileName);

%Dataset object aanmaken ...
ds.ID.FileName     = FileName;
ds.ID.FileFormat   = 'MADDATA';
ds.ID.FullFileName = FullFileName;
ds.ID.iSeq         = DSNr;
ds.ID.StimType     = DataType;
ds.ID.iCell        = Cell.CellNr;
ds.ID.SeqID        = sprintf('%d-%d-%s', Cell.CellNr, Cell.TestNr, DataType);
ds.ID.OrgSeqID     = upper(Cell.dsID);
ds.ID.Time         = RecTime;
ds.ID.Place        = 'University of Wisconsin(Madison)';
ds.ID.Experimenter = 'unknown';

ds.Sizes.Nsub         = NSubSeq;
ds.Sizes.NsubRecorded = size(SptCell, 1);
ds.Sizes.Nrep         = size(SptCell, 2);

ds.Data.SpikeTimes   = SptCell;
ds.Data.OtherData    = [];

ds.Stimulus.IndepVar = IndepVar;

ds.Stimulus.StimParam = StimParam;

ds.Stimulus.Special.RepDur      = StimParam.RepDur;
ds.Stimulus.Special.BurstDur    = StimParam.BurstDur;
ds.Stimulus.Special.CarFreq     = NaN;
ds.Stimulus.Special.ModFreq     = StimParam.ModFreq;
ds.Stimulus.Special.BeatFreq    = NaN;
ds.Stimulus.Special.BeatModFreq = NaN;
ds.Stimulus.Special.ActiveChan  = 1;

ds.Settings.SessionInfo.startTime       = RecTime;
ds.Settings.SessionInfo.dataFile        = FullFileName;
ds.Settings.SessionInfo.SeqRecorded     = [1:ds.Sizes.NsubRecorded];
ds.Settings.SessionInfo.RecordingSide   = StimParam.RecordingSide;
ds.Settings.SessionInfo.DAchannel       = 1;

ds = dataset(ds, 'convert');
