function IndepVar = GetMadisonIndepVar(FileName, dsID)

IndepVar = [];

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

%Onafhankelijke variabelen informatie ...
DSHeader = GetMadisonDSHeader(fid, DirEntry.DataSetLocation);
Data = LoadMadisonSchemeType(fid, DSHeader.SchemaName);
if isempty(Data)
    return
end

%Informatie herorganiseren ...
NVar   = Data.NUMV;
VNames = cellstr(Data.VNAME);
if strncmp(VNames{NVar}, 'NONE', 4)
    NVar = NVar - 1;
end
VNames = VNames(1:NVar);

IndepVar = struct('Low', [], 'High', [], 'LinInc', [], 'LogInc', [], ...
    'Scale', [], 'Order', []);
switch NVar
    case 1
        IndepVar = EnhanceIndepVar(AssignStruct(IndepVar, Data.XVAR));
    case 2
        IndepVar = EnhanceIndepVar(AssignStruct(IndepVar, ...
            [Data.XVAR; Data.YVAR]));
    case 3
        IndepVar = EnhanceIndepVar(AssignStruct(IndepVar, ...
            [Data.XVAR; Data.YVAR; Data.ZVAR]));    
end

for N = 1:NVar
    IndepVar = setfield(IndepVar, {N}, 'Name', VNames{N});
end

fclose(fid);
