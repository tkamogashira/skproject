function SptCell = GetMadisonSpkTimes(FileName, dsID, ReqIndepVar)

SptCell = cell(0);

%Parameters nagaan ..
if ~any(nargin == [2,3])
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end
if ~ischar(dsID)
    error('Second argument should be dataset ID');
end
if nargin == 2
    ReqIndepVar = 0;
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

%Informatie inladen ...
DSHeader = GetMadisonDSHeader(fid, DirEntry.DataSetLocation);
Data = LoadMadisonSchemeType(fid, DSHeader.SchemaName);
if isempty(Data)
    return
end

%Alle spiketimes worden opgeslagen als unsigned integers van 32bit. Indien de TimeBase niet gegeven is in
%variable TBASE dan is de schaal afhankelijk van de duur van het herhalingsinterval(ms):
%                   0 to 64                 1 microsec
%                  64 to 640               10 microsecs
%                 640 to 6400             100 microsecs
%                6400 to 64000              1 millisec
%               64000 to 640000            10 millisecs
%              640000 to 6400000          100 millisecs
%             6400000 to 64000000           1 second
%            64000000 to 640000000         10 seconds
TimeBase = Data.TBASE * 1000; %TBASE is schaalfactor voor seconden, in SGSR dataset spiketimes opgeslaan in ms ...
if TimeBase <= 0 
    DSSNr = Data.MDSS;
    RepInt = Data.DDSDAT(DSSNr).REPINT;
    if RepInt > 0 && RepInt <= 64
        TimeBase = 0.001;
    elseif RepInt > 64 && RepInt <= 640
        TimeBase = 0.01;
    elseif RepInt > 640 && RepInt <= 6400
        TimeBase = 0.1;
    elseif RepInt > 6400 && RepInt <= 64000
        TimeBase = 1;
    elseif RepInt > 64000 && RepInt <= 640000
        TimeBase = 10;
    elseif RepInt > 640000 && RepInt <= 6400000
        TimeBase = 100;
    elseif RepInt > 6400000 && RepInt <= 64000000
        TimeBase = 1000;
    elseif RepInt > 64000000 && RepInt <= 640000000
        TimeBase = 10000;   
    else
        error('Invalid interval duration.');
    end
end

%Informatie over STATUS tabel herorganiseren ...
STTableForm  = Data.STFORM;
NPointers    = Data.NUMPT;
DSFileOffSet = 512 * (DirEntry.DataSetLocation-1);
Location     = (4*(Data.LSTAT-1)) + DSFileOffSet; %In words (4 bytes) tov begin van dataset ...

%Enkel gegevens met STATUS-tabel 2 kunnen ingeladen worden, bovendien mag er enkel spiketime gegevens
%aanwezig zijn ...
if ~isequal(STTableForm, 2), error('Can only load spiketimes for dataset with STATUS table type 2'); end
if ~isequal(NPointers, 1), error('Dataset contains more than spiketime information'); end

%Informatie over onafhankelijke variabelen inlezen ...
NVar   = Data.NUMV;
VNames = cellstr(Data.VNAME);

switch NVar
case 1
    Range = local_GetRange(Data.XVAR);
    Inc   = abs(Data.XVAR.INC);
case 2
    Range = [local_GetRange(Data.XVAR), local_GetRange(Data.YVAR)];
    Inc   = [abs(Data.XVAR.INC), abs(Data.YVAR.INC)];
    
    %Alle onafhanklijke variabelen die geen variatie ondergaan hebben eigenlijk een increment van nul
    idx = Range == 1;
    Inc(idx) = 0; 
case 3 %Meer dan drie variabelen kunnen niet ingeladen worden ...
    error('Can''t load datasets with three independent variables.');
end

%De variabelen worden opgeslaan in volgorde van hun variatie, de onafhankelijke variabele
%met de snelste variatie moet eerst komen, gevolgd door de variabele met de traagste variatie.
%Dit geldt niet als er geen verschil in variatie is tussen de onafhankelijke variabelen ...
if diff(Inc) ~= 0
    [Dummy, i] = sort(Inc);
    Range = Range(fliplr(i));
    VNames = VNames(fliplr(i));
end

%Aantal entries in de statustabel is gegeven door de volgende formule. Indien er twee variabelen zijn wordt
%tussen elke verandering in de eerste variabele, dit is de variabele met de minste variatie, een pointer 
%opgeslagen die verwijst naar spikes opgenomen tijdens afwezigheid van elke stimulus(spontane activiteit).
switch NVar
    case 1
        NEntries = NPointers * Range;
    case 2
        NEntries = NPointers * Range(1) * (Range(2)+1);
end

%Indien de eerste onafhankelijke variabele geen variatie ondergaat, dan bevat enkel eerste element van STATUS
%tabel spontane activiteit informatie ... (Enkel bij DEL-datasets opgemerkt, deze hebben twee onafhankelijke 
%variabelen, SPL en DELAY. De eerste onafhankelijke variabele ondergaat geen variatie)
if (Data.XVAR.HIGH - Data.XVAR.LOW) == 0
    OnlyOneSpon = 1;
    isSpon = 0;
    TablePos = Location + 4;
    NEntries = NEntries/2;
else
    OnlyOneSpon = 0;
    isSpon = 1;
    TablePos = Location;
end

%Spiketimes inlezen ... Spiketimes worden ingeladen in 3dimensionele cell-array, met in de rijen de variatie van de
%eerste onafhankelijke variabele, in de kolommen de variatie van de tweede onafhankelijke variabele en in de paginas
%de verschillende repetities ...
NRep        = Data.NREPMD;
IndepVar1Nr = 1;
IndepVar2Nr = 1;
for EntryNr = 1:NEntries
    fseek(fid, TablePos, 'bof');
    Pointer = freadVAXG(fid, 1, 'int32'); 
    TablePos = ftell(fid);
    if (NVar > 1) && isSpon
        isSpon = 0;
        continue
    end
    Location = ((Pointer-1)*4) + DSFileOffSet;
    if Pointer > 0 %Negatieve pointers in STATUS-tabel betekenen dat de desbetreffende conditie niet opgenomen werd ...
        fseek(fid, Location, 'bof');
        Reps = freadVAXG(fid, NRep, 'uint32');
        for RepNr = 1:NRep
            SptCell{IndepVar1Nr, IndepVar2Nr, RepNr} = ...
                double(freadVAXG(fid, Reps(RepNr), 'uint32'))' *TimeBase;
        end
    end
    if NVar > 1 && ~OnlyOneSpon
        IndepVar2Nr = IndepVar2Nr + 1;
        if IndepVar2Nr > Range(2)
            isSpon = 1;
            IndepVar1Nr = IndepVar1Nr + 1;
            IndepVar2Nr = 1;
        end
    else
        IndepVar1Nr = IndepVar1Nr + 1;
    end
end

fclose(fid);

%Cell-array met spiketimes herorganiseren ... volgorde van variabelen terug naar oorspronkelijke staat 
%terugbrengen en aanpassen van subsequenties aan de volgorde van variatie van de variabelen.
[Row, Col, Pages] = size(SptCell);
Range = [local_GetRange(Data.XVAR), local_GetRange(Data.YVAR)];

OrigVNames = cellstr(Data.VNAME);
if ~isequal(VNames, OrigVNames)
    for PageNr = 1:Pages
        SptCellNew(:,:,PageNr) = flipud(rot90(SptCell(:,:,PageNr)));
    end
    SptCell = SptCellNew;
    [Row, Col] = swap(Row, Col);
end    

if (Data.XVAR.OPRES == 2)
    SizeDiff = Range(1) - Row;
    if SizeDiff ~= 0
        for PageNr = 1:Pages
            SptCell(SizeDiff+1:Range(1), :, PageNr) = ...
                SptCell(Row:-1:1, :, PageNr);
            [SptCell{1:SizeDiff, :, PageNr}] = deal([]);
        end
    else
        SptCell = flipdim(SptCell, 1);
    end
elseif (Data.XVAR.OPRES == 3)
    warning(['Random presentation of first independent variable transformed ' ...
        'to normal low-high presentation.']);
end    
if (NVar > 1) && (Data.YVAR.OPRES == 2)
    SizeDiff = Range(2) - Col;
    if SizeDiff ~= 0
        for PageNr = 1:Pages
            SptCell(:, SizeDiff+1:Range(2), PageNr) = SptCell(:, Col:-1:1, PageNr);
            [SptCell{:, 1:SizeDiff, PageNr}] = deal([]);
        end
    else
        SptCell = flipdim(SptCell, 2);
    end
elseif (NVar > 1) && (Data.YVAR.OPRES == 3)
    warning(['Random presentation of second independent variable transformed ' ...
        'to normal low-high presentation.']);
end

%De gevraagde onafhankelijke variabele teruggeven ... Indien variatie in twee onafhankelijke variabelen
%dan wordt de niet gevraagde variabele constant gehouden op zijn eerste waarde ...
switch ReqIndepVar
    case 1
        SptCell = squeeze(SptCell(:, 1, :));
        if Range(1) == 1
            SptCell = SptCell';
        end %Indien de gevraagde variabele geen variatie kent
    case 2
        SptCell = squeeze(SptCell(1, :, :));
        if Range(2) == 1
            SptCell = SptCell';
        end %Indien de gevraagde variabele geen variatie kent
end

%Lokale functie: local_GetRange ...
function Range = local_GetRange(VAR)
    
    switch VAR.LOGLIN
        case 1
            Range = fix(((VAR.HIGH - VAR.LOW)/VAR.INC) + 1);
        case 2
            Range = fix(((VAR.HIGH - VAR.LOW)/VAR.SOCT) + 1);
    end
    