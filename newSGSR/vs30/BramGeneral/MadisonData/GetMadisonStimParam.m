function StimParam = GetMadisonStimParam(FileName, dsID)

StimParam = struct([]);

%Parameters nagaan ..
if nargin ~= 2
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end
if ~ischar(dsID)
    error('Second argument should be dataset ID');
end

%Openen van Madison datafile in binaire mode ...
fid = fopen(FileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open datafile');
end

%Directory structuur inlezen ...
DirHeader = GetMadisonDirHeader(fid);

%Zoeken naar DS ...
Found = 0;
for EntryNr = 1:DirHeader.NEntries
    DirEntry = GetMadisonDirEntry(fid, EntryNr);
    if strcmpi(dsID, DirEntry.DataSetID)
        Found = 1;
        break
    end
end
if ~Found
    return
end

%Stimulus parameters achterhalen ...
DSHeader = GetMadisonDSHeader(fid, DirEntry.DataSetLocation);
Data = LoadMadisonSchemeType(fid, DSHeader.SchemaName);

NrDSSUsed    = Data.NUMDSS; DSSNrs = [Data.DSSDAT.DSSN];
MasterDSSNr  = Data.MDSS; 
MasterDSSidx = find(DSSNrs == MasterDSSNr);
if NrDSSUsed > 1
    switch MasterDSSidx
        case 1
            SlaveDSSidx = 2;
        case 2
            SlaveDSSidx = 1;
    end
    SlaveDSSNr = DSSNrs(SlaveDSSidx);
end   

StimParam(1).BurstDur   = Data.DSSDAT(MasterDSSidx).DUR1;
StimParam(1).RepDur     = Data.DSSDAT(MasterDSSidx).REPINT;
if strcmp(StimParam(1).BurstDur, 'STMDUR')
    StimParam(1).BurstDur = Data.DSSDAT(SlaveDSSidx).DUR1;
end
if strcmp(StimParam(1).RepDur, 'REPINT')
    StimParam(1).RepDur   = Data.DSSDAT(SlaveDSSidx).REPINT;
end

if strcmp(Data.DSSDAT(MasterDSSidx).SPL, 'SPL')
    StimParam(1).SPL = Data.DSSDAT(SlaveDSSidx).SPL;
else
    StimParam(1).SPL = Data.DSSDAT(MasterDSSidx).SPL;
end
%Indien SPL de waarde heeft van 99 of 999 dan betekent dit dat de intensiteit opgegeven werd als een van de 
%onafhankelijke variabelen ... De waarde CONSPL wordt niet gebruikt om aan te geven of SPL constant is of niet ...
if any(StimParam(1).SPL == [99, 999])
    warning('SPL-value is 99 or 999dB, assuming SPL specified as independent variable.');
    StimParam(1).SPL = NaN; 
end 

StimParam(1).FilterType = EnhanceFilterType(Data.DSSDAT(MasterDSSidx).GWFIL);

%Enkel nodig voor BB-datasets, hier geldt dat de Slave-waarde steeds de carrierfrequentie bevat behalve als
%deze de waarde FCARR-1 bevat. Bij andere datasets zijn beide waarden NaN.
if NrDSSUsed > 1
    if strcmp(Data.DSSDAT(SlaveDSSidx).FREQ, 'FCARR-1')
        StimParam(1).CarFreq = Data.DSSDAT(MasterDSSidx).FREQ;
    else
        StimParam(1).CarFreq = Data.DSSDAT(SlaveDSSidx).FREQ;
    end
else
    StimParam(1).CarFreq = Data.DSSDAT(MasterDSSidx).FREQ;
end

%ITD voor relevante datasets wordt gegeven door DELM in microseconden. Steeds wordt de Slave DSS vertraagd ...
%Bij niet relevante datasets is ITD 0 ...
if NrDSSUsed > 1
    StimParam(1).ITD = Data.DSSDAT(SlaveDSSidx).DELM;
else
    StimParam(1).ITD = 0;
end

StimParam(1).MasterDSS.DSSNr = MasterDSSNr;
StimParam(1).MasterDSS.GWID  = Data.DSSDAT(MasterDSSidx).GWID;

if NrDSSUsed > 1
    StimParam(1).SlaveDSS.DSSNr = SlaveDSSidx;
    StimParam(1).SlaveDSS.GWID  = Data.DSSDAT(SlaveDSSidx).GWID;
else
    StimParam(1).SlaveDSS.DSSNr = 0;
    StimParam(1).SlaveDSS.GWID  = '';
end

%Alle ongekende en ongebruikte stimulus parameters toch meegeven met dataset ...
StimParam(1).MadisonJunk = Data;

fclose(fid);

function FilterType = EnhanceFilterType(FilterType)

switch FilterType
    case 'N1K16'
        FilterType = '32K';
    case {'N1K2', 'N1K32', 'N2K32', 'MVGD:[JORIS.IC]HPN1K32', ...
            'MVGD:[JORIS]N2K32', 'ANN1K32', 'MVGD:[JORIS.IC]HPN', ...
            'MVFD0:[JORIS]HPN1K32', 'MVFD0:[JORIS]HPN1K', ...
            'MVGD:[JORIS]HPN1K32', 'MVGD:[JORIS]HPN1K3'}
    FilterType = '64K';
end
