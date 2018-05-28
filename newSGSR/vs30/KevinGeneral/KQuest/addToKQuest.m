function skippedSeq = addToKQuest(dataFile)

skippedSeq = {};
try
    noCache = 1;
    % P: convert experiment log file to lookup table, nochache: force new
    % read, ignoring any cache
    lookUpTable = log2lut(dataFile, noCache);
catch
    skippedSeq = [skippedSeq; 'DF: <' dataFile '> -- log2lut -- ' str2line(lasterr, ' - ')];
    warning(['There was an error processing DF: ' dataFile '.']);
    return
end

% Prepare queries
seqQuery = 'INSERT INTO KQuest_Seq VALUES ';
indepQuery = 'INSERT INTO KQuest_Indep VALUES ';
subSeqQuery = 'INSERT INTO KQuest_SubSeq VALUES ';
CFQuery = 'INSERT INTO UserData_CellCF VALUES ';

seqQueryAltered = 0;
indepQueryAltered = 0;
subSeqQueryAltered = 0;
CFQueryAltered = 0;

% mym('status') returns 1 if the connection is closed
if mym(10,'status') % connection closed
    mym(10,'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
    % use database ExpData
    mym(10,'use ExpData');
end

presentSeq = mym(10,['select iSeq from KQuest_Seq where FileName = "' dataFile '"']);

DSUpdate = {};
nSeq = 0;
nSubSeq = 0;
nIndep = 0;
CFCellNrs = [];
for cLUT = 1:length(lookUpTable)
    if find(presentSeq == lookUpTable(cLUT).iSeq) % skip datasets that are already there
        DSUpdate = [DSUpdate; 'Skipping DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (' num2str(cLUT) '/' num2Str(length(lookUpTable)) ')'];
        disp(DSUpdate);
    else
        DSUpdate = [DSUpdate; 'Processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (' num2str(cLUT) '/' num2str(length(lookUpTable)) ')'];
        if ~mod(cLUT, 5)
            disp(DSUpdate);
            DSUpdate = {};
        end

        try
            ds = dataset(dataFile, lookUpTable(cLUT).iSeq);
        catch
            skippedSeq = [skippedSeq; 'DF: <' dataFile '> DS: <' lookUpTable(cLUT).IDstr, '> -- DS -- ' str2line(lasterr, ' - ')];
            warning(['There was an error processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (iSeq: ' num2str(lookUpTable(cLUT).iSeq) ').']);
            continue
        end
        
        if ( isequal('edf', lower(ds.FileFormat)) || isequal('mdf', lower(ds.FileFormat)) || isequal('harris', lower(ds.FileFormat)) ) ...
            && ( isequal('CALB', ds.ExpType) || isequal('GWAV', ds.ExpType))
                warning(['Skipped processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (ExpType: ' ds.ExpType ').']);
        end
        
        if isequal('edf', lower(ds.FileFormat)) || isequal('mdf', lower(ds.FileFormat)) || isequal('harris', lower(ds.FileFormat))
            if isequal('CALB', ds.ExpType) || isequal('GWAV', ds.ExpType)
                warning(['Skipped processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (ExpType: ' ds.ExpType ').']);
                continue
            end
        end
        
        nSub = ds.Sizes.NsubRecorded;

        % Sequence information
        try
            SchName = lower(ds.ID.SchName);
        catch
            SchName = '';
        end

        timeStr = [num2str(ds.ID.Time(3)) '-' num2str(ds.ID.Time(2)) '-' num2str(ds.ID.Time(1)) ' ' ...
            num2str(ds.ID.Time(4)) ':' num2str(ds.ID.Time(5)) ':' num2str(ds.ID.Time(6))];
        
        % get Nchan
        Nchan = 2 - sign(ds.Special.ActiveChan);
        if isnan(Nchan)
            Nchan = 0;
        end

        % get Nsub and Nrec
        if strcmpi(ds.FileFormat, 'SGSR') && strcmpi(ds.StimType, 'THR')
            [Nsub, Nrec] = deal(ds.nsub - 1);
        else
            Nsub = ds.nsub; 
            Nrec = ds.nrec;
        end
        
        Nrep = ds.Nrep;
		
		% by abel: space holder for spike column
		spike = [];

        seqQuery = [seqQuery '(NULL, ' ...
            '"' lower(dataFile) '", ' ...
            '"' lower(ds.ID.FileFormat) '", ' ...
            num2str(ds.ID.iSeq) ', ' ...
            num2str(ds.ID.iCell) ', ' ...
            '"' lower(ds.ID.SeqID) '", ' ...
            '"' lower(ds.ID.StimType) '", ' ...
            '"' SchName '", ' ...
			'"' spike '", ' ...
            '"' timeStr '", ' ...
            '"' lower(ds.ID.Place) '", ' ...
            '"' lower(ds.ID.Experimenter) '", ' ...
            num2str(Nsub) ', ' ...
            num2str(Nrec) ', ' ...
            num2str(Nrep) ', ' ...
            num2str(Nchan) '),'];
        nSeq = nSeq + 1;
        seqQueryAltered = 1;

        % Independant variables
        if strcmpi(ds.FileFormat, 'EDF') || (strcmpi(ds.FileFormat, 'MDF') && strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'))
            isEDFds = true;
        else
            isEDFds = false;
        end

        if isEDFds
            IndepNr = ds.IndepNr;
        else
            IndepNr = 1;
        end

        if isequal(1, IndepNr)
            IndepName = {ds.IndepName};
            IndepUnit = {ds.IndepUnit};
        elseif isequal(2, IndepNr) %Two independent variables ...
            IndepName = {ds.XName, ds.YName};
            IndepUnit = {ds.XUnit, ds.YUnit};
        else
            skippedSeq = [skippedSeq; 'DF: <' dataFile '> -- DS: <' lookUpTable(cLUT).IDstr, '> -- Indepvars'];
            warning(['Skipped processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (contains more than two independent variables).']);
            continue
        end

        for cIndep = 1:IndepNr
            indepQuery = [indepQuery '(NULL, ' ...
                '"' lower(dataFile) '", ' ...
                '"' num2str(ds.ID.iSeq) '", ' ...
                num2str(cIndep) ', ' ...
                '"' lower(IndepName{cIndep}) '", ' ...
                '"' lower(IndepUnit{cIndep}) '"),'];
            indepQueryAltered = 1;
            nIndep = nIndep + 1;
        end

        % repetitions
        SPL = localExpandEconomicalMatrix( ExtractSPL(ds), nSub );
        ITD = localExpandEconomicalMatrix( ExtractITD(ds), nSub, 1 );

        NoiseParam = ExtractNoiseParam(ds);
        Noise_LowFreq = localExpandEconomicalMatrix(NoiseParam.LowFreq, nSub );
        Noise_HighFreq = localExpandEconomicalMatrix(NoiseParam.LowFreq, nSub );
        Noise_BW = Noise_LowFreq - Noise_HighFreq;
        Noise_Rho = localExpandEconomicalMatrix(NoiseParam.Rho, nSub );
        Noise_Polarity = localExpandEconomicalMatrix(NoiseParam.Polarity, nSub, 1);
        Noise_RSeed = localExpandEconomicalMatrix(NoiseParam.RSeed, nSub );
        Noise_FileName = localExpandEconomicalMatrix(NoiseParam.FileName, nSub );
        Noise_SeqID = localExpandEconomicalMatrix(NoiseParam.SeqID, nSub );

        FreqParam = ExtractFreqParam(ds);
        if all(isnan(FreqParam.ModFreq))
            ModDepth = NaN; %Modulation depth in percent ...
        else
            ModDepth = ExtractModDepth(ds);
        end
        Tone_CarFreq = localExpandEconomicalMatrix(FreqParam.CarFreq, nSub );
        Tone_ModFreq = localExpandEconomicalMatrix(FreqParam.ModFreq, nSub );
        Tone_BeatFreq = localExpandEconomicalMatrix(FreqParam.BeatFreq, nSub , 1);
        Tone_BeatModFreq = localExpandEconomicalMatrix(FreqParam.BeatModFreq, nSub , 1);
        Tone_ModDepth = localExpandEconomicalMatrix(ModDepth, nSub );

        DurParam = ExtractDurParam(ds);
        BurstDur = localExpandEconomicalMatrix(DurParam.BurstDur, nSub );
        RepDur = localExpandEconomicalMatrix(DurParam.RepDur, nSub );
        RiseDur = localExpandEconomicalMatrix(DurParam.RiseDur, nSub );
        FallDur = localExpandEconomicalMatrix(DurParam.FallDur, nSub );

        for cSub = 1:nSub
            if ~mod(cSub,1000)
                disp(DSUpdate); 
                DSUpdate = {};
                disp(['   Subseq ' num2str(cSub) ' of ' num2str(nSub)]);
            end
            subSeqQuery = [subSeqQuery ' (NULL, ' ...
                '"' lower(dataFile) '", ' ...
                num2str(ds.ID.iSeq) ', ' ...
                num2str(cSub) ', ' ...
				'"",'...                           %by Abel: Placeholder for RepAccept
                num2str(SPL(cSub, 1)) ', ' ...
                num2str(SPL(cSub, 2)) ', ' ...
                num2str(ITD(cSub)) ', ' ...
                num2str(Noise_LowFreq(cSub, 1)) ', ' ...
                num2str(Noise_LowFreq(cSub, 2)) ', ' ...
                num2str(Noise_HighFreq(cSub, 1)) ', ' ...
                num2str(Noise_HighFreq(cSub, 2)) ', ' ...
                num2str(Noise_BW(cSub, 1)) ', ' ...
                num2str(Noise_BW(cSub, 2)) ', ' ...
                num2str(Noise_Rho(cSub, 1)) ', ' ...
                num2str(Noise_Rho(cSub, 2)) ', ' ...
                num2str(Noise_Polarity(cSub)) ', ' ...
                num2str(Noise_RSeed(cSub, 1)) ', ' ...
                num2str(Noise_RSeed(cSub, 2)) ', ' ...
                '"' lower(Noise_FileName{cSub, 1}) '", ' ...
                '"' lower(Noise_FileName{cSub, 2}) '", ' ...
                '"' lower(Noise_SeqID{cSub, 1}) '", ' ...
                '"' lower(Noise_SeqID{cSub, 2}) '", ' ...
                num2str(Tone_CarFreq(cSub, 1)) ', ' ...
                num2str(Tone_CarFreq(cSub, 2)) ', ' ...
                num2str(Tone_ModFreq(cSub, 1)) ', ' ...
                num2str(Tone_ModFreq(cSub, 2)) ', ' ...
                num2str(Tone_BeatFreq(cSub)) ', ' ...
                num2str(Tone_BeatModFreq(cSub)) ', ' ...
                num2str(Tone_ModDepth(cSub, 1)) ', ' ...
                num2str(Tone_ModDepth(cSub, 2)) ', ' ...
                num2str(BurstDur(cSub, 1)) ', ' ...
                num2str(BurstDur(cSub, 2)) ', ' ...
                num2str(RepDur(cSub, 1)) ', ' ...
                num2str(RepDur(cSub, 2)) ', ' ...
                num2str(RiseDur(cSub, 1)) ', ' ...
                num2str(RiseDur(cSub, 2)) ', ' ...
                num2str(FallDur(cSub, 1)) ', ' ...
                num2str(FallDur(cSub, 2)) '),' ...
                ];
            subSeqQueryAltered = 1;
            nSubSeq = nSubSeq + 1;
        end
        
        if isempty(find(CFCellNrs == ds.ID.iCell, 1)) && ~isnan(ds.ID.iCell)
            try
                ignoreUserData = 1;
                THR = getThr4DS(ds, ignoreUserData);
                CF = THR.CF;
                SR = THR.SR;
				minTHR = THR.Thr;
				Q10 = THR.Q10;
                CFCellNrs = [CFCellNrs, ds.ID.iCell];
                CFQuery = [CFQuery ' ("' lower(dataFile) '", ' num2str(ds.ID.iCell) ', NULL, ' num2str(CF) ...
					', ' num2str(SR) ', ' num2str(minTHR) ', ' num2str(Q10) ', 0),'];
                % CFQuery = [CFQuery ' (''' lower(dataFile) ''', ' num2str(ds.ID.iCell) ', NULL, ' num2str(CF) ', ' num2str(SR) '),'];
                CFQueryAltered = 1;
            catch
                skippedSeq = [skippedSeq; 'DF: <' dataFile '> DS: <' lookUpTable(cLUT).IDstr, '> -- CF/SR -- ' str2line(lasterr, ' - ')];
                warning(['There was an error processing DF: ' dataFile ' DS: ' lookUpTable(cLUT).IDstr ' (could not get CF).']);
            end
        end
    end
end

disp(DSUpdate);

seqQuery = strrep(seqQuery, 'NaN', 'NULL');
seqQuery = strrep(seqQuery, '\', '\\');
seqQuery = [seqQuery(1:end-1) ';'];
indepQuery = strrep(indepQuery, 'NaN', 'NULL');
indepQuery = strrep(indepQuery, '\', '\\');
indepQuery = [indepQuery(1:end-1) ';'];
subSeqQuery = strrep(subSeqQuery, 'NaN', 'NULL');
subSeqQuery = strrep(subSeqQuery, '\', '\\');
subSeqQuery = [subSeqQuery(1:end-1) ';'];
CFQuery = strrep(CFQuery, 'NaN', 'NULL');
CFQuery = strrep(CFQuery, '\', '\\');
CFQuery = [CFQuery(1:end-1) ';'];

% Execute queries
try
    mym(10,'start transaction;')
    if nSeq
        disp(['-----> processing query: seqQuery; ' seqQuery]);
        mym(10,seqQuery),
    end
    if ~isempty(CFCellNrs)
        disp(['-----> processing query: CFCellNrs; ' CFQuery]);
        mym(10,CFQuery),
    end
    if nIndep
        disp(['-----> processing query: indepQuery; ' indepQuery]);
        mym(10,indepQuery),
    end
    if nSubSeq
        disp(['-----> processing query: subSeqQuery; ' subSeqQuery]);
        mym(10,subSeqQuery),
    end
    mym(10,'commit');
    disp('-----> storage in DB ok!; ')
catch
    mym(10,'rollback');
    disp('There was an error with your queries:');
    disp(seqQuery);
    disp(CFQuery);
    disp(indepQuery);
    disp(subSeqQuery);
    error(lasterr);
end

mym(10,'close');


%% Local functions
function MOut = localExpandEconomicalMatrix(MIn, nSub, nColumns)

if nargin < 2
    error('This function takes at least 2 arguments.');
end
if nargin > 3
    error('This function takes at most 3 arguments.');
end
if isequal(2, nargin)
    nColumns = 2;
end

if ischar(MIn)
    MIn = repmat({MIn}, nSub, nColumns);
else
    if isequal(1, size(MIn, 1))
        MIn = repmat(MIn, nSub, 1);
    end
    if isequal(1, size(MIn, 2))
        MIn = repmat(MIn, 1, nColumns);
    end
end
MOut = MIn;
