function UD = parseUD(ExpName, S)
%PARSEUD parse userdata on experiment
%   UD = PARSEUD(FN) parses userdata given by character string S.

%B. Van de Sande 28-04-2004
%Attention! EDF datafiles contain datasets with no cell number. Moreover a dataset
%cannot be uniquely identified by a cell and testnumber ...

%--------------------------------------------hoofd programma--------------------------------------------------------

%Parameters nagaan ...
if nargin < 1
    error('Wrong number of input arguments.'); 
end
if ~ischar(S)
    error('Second argument should be a character string to evaluate.'); 
end

%Gegevens over experiment nagaan. Deze gegevens worden achteraf gebruikt om consistentie na te gaan van vermelde
%gegevens ...                               STRUCTUUR ExpFacts
ExpFacts.ExpName = ExpName;
clear ExpName;
try 
    force = 1;
    ExpFacts.LUT = log2lut(ExpFacts.ExpName, force); 
catch
    error(sprintf('Experiment %s doesn''t exist or no local copy of this experiment.', ExpFacts.ExpName)); 
end

if isempty(ExpFacts.LUT)
    UD.Experiment = [];
    UD.CellInfo = [];
    UD.DSInfo = [];
    return
end

try
    ExpFacts.CellNrs = uniqueRemoveNaNs(char2num(char(ExpFacts.LUT.IDstr))');
catch
    ExpFacts.CellNrs = [];
end
ExpFacts.NCells  = length(ExpFacts.CellNrs);
ExpFacts.SeqNrs  = cat(2, ExpFacts.LUT.iSeq); 
ExpFacts.NSeqs = length(ExpFacts.SeqNrs);
ExpFacts.dsIDs   = cellstr(char(ExpFacts.LUT.IDstr));

%Parser van MATLAB gebruiken ... (Zware Miserie :-) )
eval(S); 
clear S;

%Nagaan of bij ingeven van de vaste velden (Experiment, CellInfo, DSInfo, CellInfo_*, DSInfo_*) geen typfouten 
%zijn binnengeslopen ...
FNames  = who';  % Kevin: zeer vuile code :(
idx = find(ismember(FNames, 'ExpFacts')); 
FNames(idx) = [];
idx = find(ismember(FNames, 'force')); 
FNames(idx) = [];

NFields = length(FNames);
idx = [find(ismember(FNames, {'Experiment', 'CellInfo', 'DSInfo'})), findregexp(FNames, 'CellInfo_*'), findregexp(FNames, 'DSInfo_*')];
if ~isempty(setdiff(1:NFields, idx))
    error('One of the superfields doesn''t exist.'); 
end

%Gegevens samenstellen, verder parsen, consistentie nagaan en herorganiseren ...
%... Algemene informatie gerelateerd aan experiment ... Opgelet, deze informatie kan niet gecheckt worden op 
%typfouten!                                 STRUCTUUR Experiment
if ~strcmpi(Experiment.Name, ExpFacts.ExpName)
    error('Name of experiment is not consistent with name of script.'); 
end
%Nagaan of de waarden van de velden Species en ExposedStr wil toegelaten zijn. Voor het veld
%Species zijn de waarden beperkt tot J(ava), R(hesus),C(at), P (Guinea Pig), G(erbil), voor het veld
%ExposedStr is dit AN, CN, TB, SOC, IC, LL, DAS ...
if ~any(strcmpi(Experiment.Species, {'', 'J', 'R', 'C', 'P', 'G'})), 
    error('Invalid species name. Possible species are J(ava), R(hesus),C(at), P (Guinea Pig), G(erbil).');
end
if ~any(strcmpi(Experiment.ExposedStr, {'', 'AN', 'CN', 'TB', 'SOC', 'IC', 'LL', 'DAS'})), 
    error('Invalid abbreviation for exposed structure. Possible abbreviations are AN, CN, TB, SOC, IC, LL, DAS.');
end

%... Informatie over individuele cellen ... De default waarden worden opgegeven in de structuur CellInfo. 
%                                           STRUCTUUR DefCellInfo, CellInfo
DefCellInfo = CellInfo; clear CellInfo;

if any(ismember({'Nr', 'SeqNr', 'dsID'}, fieldnames(DefCellInfo))), error('''Nr'', ''SeqNr'' and ''dsID'' cannot be used as names for an extra subfield of CellInfo.'); end

DefCellInfo = checkDefaults(DefCellInfo, Experiment);

CellInfo = repmat(DefCellInfo, 1, ExpFacts.NCells);
Tmp = num2cell(ExpFacts.CellNrs); 
if ~isempty(Tmp)
    [CellInfo.Nr] = deal(Tmp{:});
end
clear Tmp;

CellList = who('CellInfo_*');
if ~isempty(CellList)
    for n = 1:length(CellList)
        Tmp{n} = eval(CellList{n}); 
    end    
else
    Tmp = cell(0); 
end
CellInfo = adjustCellInfo(CellInfo, ExpFacts, CellList, Tmp{:});
clear Tmp;

CellInfo = unravelRef(CellInfo, ExpFacts, Experiment);

NFields = length(fieldnames(CellInfo));
CellInfo = rofields(CellInfo, [NFields, 1:NFields-1]); 

%... Dataset-informatie ... De default waarden worden opgegeven in de structuur DSInfo. 
%                                           STRUCTUUR DefDSInfo, DSInfo
DefDSInfo = DSInfo; clear DSInfo;

if any(ismember({'Nr', 'SeqNr', 'dsID'}, fieldnames(DefDSInfo))), error('''Nr'', ''SeqNr'' and ''dsID'' cannot be used as names for an extra subfield of DSInfo.'); end

DefDSInfo = checkDefaults(DefDSInfo, DefCellInfo, Experiment);
    
DSInfo = repmat(DefDSInfo, 1, ExpFacts.NSeqs);
Tmp = num2cell(ExpFacts.SeqNrs); 
if ~ isempty(Tmp)
    [DSInfo.SeqNr] = deal(Tmp{:});
end
clear Tmp;

[DSInfo.dsID] = deal(ExpFacts.dsIDs{:});
DSList = who('DSInfo_*');
if ~isempty(DSList)
    for n = 1:length(DSList)
        Tmp{n} = eval(DSList{n}); 
    end
else
    Tmp = cell(0); 
end
DSInfo = adjustDSInfo(DSInfo, CellInfo, ExpFacts, DSList, Tmp{:});
clear Tmp;

%Twee keer ontrafelen van DSInfo, dit om eventuele referenties in DefCellInfo naar experiment
%ook op te lossen ...
DSInfo = unravelRef(DSInfo, ExpFacts, Experiment, DefCellInfo);
DSInfo = unravelRef(DSInfo, ExpFacts, Experiment, DefCellInfo);

NFields = length(fieldnames(DSInfo));
DSInfo = rofields(DSInfo, [NFields, NFields-1, 1:NFields-2]);

%Samenstellen van alle gegevens in structuur UD (UserData) ...
UD = CollectInStruct(Experiment, CellInfo, DSInfo);

%-------------------------------------------lokale functies--------------------------------------------------------
function V = uniqueRemoveNaNs(V)

idx = ~isnan(V);
V = unique(V(idx));

%function V = uniqueRespectNaNs(V)

%N = length(V);
%stridx = [1, find(isnan(V))+1];
%endidx = [find(isnan(V))-1, N];
%idx = vectorzip(stridx, endidx);

%Tmp = []; N = length(idx);
%for n = 1:2:N, Tmp = [Tmp, unique(V(idx(n):idx(n+1))), NaN]; end
%V = Tmp(1:end-1);

function Def = checkDefaults(Def, varargin)
%De default waarden voor een bepaald superveld worden opgegeven in de structuur CellInfo voor cel gerelateerde 
%informatie, respectievelijk DSInfo voor dataset informatie. Indien velden van deze structuur ook voorkomen in een 
%hoger superveld, dan mag de waarde die hier aan toegevoegd wordt niet expliciet zijn, maar mag dit enkel een 
%verwijzing zijn naar een hoger superveld. Dit gebeurt via de syntax: from_<structuurnaam> ...

DefName = inputname(1); DefName = strrep(DefName, 'Def', '');
DefFNames  = fieldnames(Def);
DefNFields = length(DefFNames);

S = varargin; NS = nargin - 1; SFNames = cell(0);
for n = 1:NS, 
    SNames{n} = strrep(inputname(n+1), 'Def', ''); 
    SFNames   = cat(1, SFNames, fieldnames(S{n}));
end
SNames  = lower(SNames);
SFNames = unique(SFNames);

idx = find(ismember(DefFNames, SFNames))';
for n = idx,
    Value = lower(getfield(Def, DefFNames{n}));
    if ~ischar(Value) | ~strncmpi(Value, 'from_', 5),
        error(sprintf('%s contains fields which are present in previous superfields. The value of those fields\ncan only be defined via the syntax ''from_<superfield>''.'), DefName);
    else, 
        [dummy, SuperFName] = strtok(Value, '_'); SuperFName(1) = [];
        idx = find(ismember(SNames, SuperFName));
        if isempty(idx), 
            error(sprintf('%s of %s contains reference to superfield %s. This superfield doesn''t exist.', DefFNames{n}, DefName, SuperFName));
        elseif ~isfield(S{idx}, DefFNames{n}), 
            error(sprintf('%s of %s contains reference to superfield %s. This superfield doesn''t contain such a subfield.', DefFNames{n}, DefName, SuperFName));
        end
    end    
end    

function CellInfo = adjustCellInfo(CellInfo, ExpFacts, CellList, varargin)

if isempty(CellList), return; end

AllowedCells  = ExpFacts.CellNrs;
AllowedFNames = sort(fieldnames(CellInfo)); AllowedFNames(find(strcmp(AllowedFNames, 'Nr'))) = [];
FieldsMentionedLUT = repmat({''}, length(AllowedCells), length(AllowedFNames));

%De cellen die in het script vermeldt worden, worden gesorteerd volgens hun nummer. Dit is vooral belangrijk bij
%het opgeven van een reeks van cellen met oneindig ...
List = char(CellList); List(:, 1:length('CellInfo_')) = []; CellNrs = char2num(List, 1, '_');

idx = min(find(isnan(CellNrs)));
if ~isempty(idx), error(sprintf('%s is not a valid syntax for specifying cell information.', CellList{idx})); end

[dummy, idx] = sort(CellNrs);
CellList = CellList(idx); varargin = varargin(idx);

NCells = length(CellList);
for n = 1:NCells,
    EntryName   = CellList{n};
    EntryStruct = varargin{n};
    
    %Twee syntaxes zijn toegelaten om specifieke informatie over een cel of meerdere cellen aan te geven, dit
    %gebeurt als volgt: CellInfo_<cellnr1>_<cellnr2> wijzigt velden voor alle cellen met celnummer vanaf cellnr1 
    %tot en met cellnummer cellnr2. Individuele cellen kunnen geadresseerd worden via de volgende syntax:
    %CellInfo_<cellnr> ... 
    [CellNrs, dummy, Err] = sscanf(EntryName, 'CellInfo_%f');
    if Err, [CellNrs, dummy, Err] = sscanf(EntryName, 'CellInfo_%f_%f'); end
    if Err, [CellNrs, dummy, Err] = sscanf(EntryName, 'CellInfo_%f_vec'); end
    if Err, error(sprintf('%s is not a valid syntax for specifying cell information.', EntryName)); end
    
    %Om typwerk te beperken kunnen er meerdere cellen via eenzelfde vermelding gezet worden naar verschillende
    %waarden ... Dit gebeurt via de syntax CellInfo_<cellnr1>_vec = { ... , ... }; waarbij elk element in de cell
    %array uitgedeeld wordt over de cellen beginnende bij cellnr1 tot en met alle elementen uitgedeeld zijn ...
    if strfind(EntryName, 'vec'),
        FNames = fieldnames(EntryStruct); NFields = length(FNames);
        EntryCell = struct2cell(EntryStruct); MaxNEntries = max(cellfun('length', EntryCell));
        
        try, CellNrs(2) = AllowedCells(find(AllowedCells == CellNrs(1)) +  MaxNEntries - 1);
        catch, error(sprintf('Vector assignment %s exceeds number of cells present.', EntryName)); end
        
        for f = 1:NFields,
            Values = getfield(EntryStruct, FNames{f});
            if ~iscell(Values), error('%s : when using vector assignment, the value of a field must be given as a cell array.', EntryName); end
            
            NEntries = length(Values);
            for n = 1:NEntries, EntryStruct = setfield(EntryStruct, {n}, FNames{f}, Values{n}); end
            
            for n = NEntries+1:MaxNEntries, 
                idx = find(AllowedCells == CellNrs(1)) + n - 1;
                Value = getfield(CellInfo, {idx}, FNames{f});
                EntryStruct = setfield(EntryStruct, {n}, FNames{f}, Value); 
            end
        end
    end;
    
    %Indien twee cel nummers opgegeven werden om gegevens van een range van cellen te wijzigen, dan mag oneindig
    %(Inf) gebruikt worden als laatste cel nummer ...
    if any(isnan(CellNrs)), error('NaN cannot be used when specifying cell information.'); end
    if isinf(CellNrs(1)), error('Inf can only be used to specify the end of a range of cells to adjust information for.'); end
    if length(CellNrs) == 1, [StrNr, StpNr] = deal(CellNrs);
    elseif isinf(CellNrs(2)), [StrNr, StpNr] = deal(CellNrs(1), max(AllowedCells));
    else, [StrNr, StpNr] = deal(CellNrs(1), CellNrs(2)); end
    
    %Nagaan of opgegeven veldnamen wel toegelaten zijn ...
    if ~all(ismember(fieldnames(EntryStruct), AllowedFNames)), 
        if isequal(StrNr, StpNr), error(sprintf('One of the subfields of CellInfo for cell %d doesn''t exist.', StrCellNr)); 
        else, error(sprintf('One of the subfields of CellInfo for cells %d - %d doesn''t exist.', StrNr, StpNr)); end
    end
        
    %Nagaan of de cellen waarvan gegevens voorhanden zijn in de script wel bestaat voor dit experiment ...
    if ~all(ismember([StrNr, StpNr], AllowedCells)),
        if isequal(StrNr, StpNr), error(sprintf('Cell %d doesn''t exist in %s, but information is nonetheless supplied in script.', StrNr, ExpFacts.ExpName)); 
        else, error(sprintf('One or more of the cells %d - %d don''t exist in %s, but information is nonetheless supplied in script.', StrNr, StpNr, ExpFacts.ExpName)); end
    end
    
    Cellidx = find(ismember(AllowedCells, StrNr:StpNr));
    
    %Belangrijk is dat een dubbele verwijzing naar een veld van een bepaalde cel een waarschuwing moet geven ...
    FNames = sort(fieldnames(EntryStruct)); NFields = length(FNames);
    idx = find(ismember(FNames, FieldsMentionedLUT(Cellidx, :)));
    if ~isempty(idx),
        if isequal(StrNr, StpNr), warning(sprintf('%s is/are mentioned more than once for the cell %d.', formatcell(FNames(idx), {'''', ''''}, ','), StrNr));
        else, warning(sprintf('%s is/are mentioned more than once for one of the cells between %d and %d.', formatcell(FNames(idx), {'''', ''''}, ','), StrNr, StpNr)); end    
    end
    fidx = find(ismember(AllowedFNames, FNames)); 
    FieldsMentionedLUT(Cellidx, fidx) = repmat(FNames', length(Cellidx), 1);
    
    %Informatie in CellInfo structuur aanpassen ...
    CellInfo(Cellidx) = expandstruct(EntryStruct, CellInfo(Cellidx)); 
end

function DSInfo = adjustDSInfo(DSInfo, CellInfo, ExpFacts, DSList, varargin)

if isempty(DSList), return; end

%Indien er subvelden gemeenschappelijk zijn tussen DSInfo en CellInfo, dan voor elke cel nagaan welke datasets 
%hiermee overeen komen en de gemeenschappelijke velden voor die datasets gelijk zetten aan de waarde in CellInfo ...
FNames = fieldnames(DSInfo); C = struct2cell(DSInfo');
CellFNames = fieldnames(CellInfo);
fidx = find(ismember(FNames, CellFNames));
for n = 1:ExpFacts.NCells,
    CellNr = ExpFacts.CellNrs(n);
    [dummy, idx] = getSeqNrs4Cell(ExpFacts.LUT, CellNr);
    for f = fidx', C(f, idx) = {getfield(CellInfo, {n}, FNames{f})}; end
end
DSInfo = cell2struct(C, FNames)';

%Informatie over datasets gegeven in script verwerken ...
AllowedFNames = fieldnames(DSInfo); idx = find(strcmp(AllowedFNames, 'SeqNr')); AllowedFNames(idx) = [];

%De datasets die in het script vermeldt worden, worden gesorteerd volgens hun sequentienummer. Dit is vooral 
%belangrijk bij het opgeven van een reeks van datasets met oneindig ...
List = char(DSList); List(:, 1:length('DSInfo_')) = [];
Nrs = char2num(List, 2, '_');

idx = min(find(any(isnan(Nrs), 2)));
if ~isempty(idx), error(sprintf('%s is not a valid syntax for specifying dataset information.', DSList{idx})); end;

[dummy, idx] = sort(Nrs(:, 2)); Nrs = Nrs(idx, :);
[dummy, idx] = sort(Nrs(:, 1));

DSList = DSList(idx); varargin = varargin(idx);

NSeqs = length(DSList);
for n = 1:NSeqs,
    EntryName   = DSList{n};
    EntryStruct = varargin{n};
    
    %Syntax is DSInfo_<cellnr>_<testnr> wijzigt velden voor de dataset met celnummer cellnr en testnummer gegeven
    %door testnr ... 
    %Meerdere sequenties kunnen gewijzigd worden via de volgende syntax: DSInfo_<cnr1>_<tnr1>_<cnr1>_<tnr2> ... Door
    %het celnummer en testnummer van het einde van de reeks op oneindig (Inf) te zetten worden alle sequenties
    %bedoeld vanaf de opgegeven sequenties tot de laatste van de dataset ...
    [Nrs, dummy, Err] = sscanf(EntryName, 'DSInfo_%f_%f');
    if Err, [Nrs, dummy, Err] = sscanf(EntryName, 'DSInfo_%f_%f_vec'); end
    if Err, [Nrs, dummy, Err] = sscanf(EntryName, 'DSInfo_%f_%f_%f_%f'); end
    if Err, error(sprintf('%s is not a valid syntax for specifying dataset information.', EntryName)); end
    
    if any(isnan(Nrs)), error('NaN cannot be used when specifying dataset information.'); end
    if any(isinf(Nrs([1,2]))), error('Inf can only be used to specify the end of a range of datasets to adjust information for.'); end
    
    if length(Nrs) == 2, [StrSeqNr, StpSeqNr] = deal(getSeqNr4Nrs(Nrs(1), Nrs(2), ExpFacts));
    else,
        StrSeqNr = getSeqNr4Nrs(Nrs(1), Nrs(2), ExpFacts);
        if any(isinf(Nrs([3, 4]))), StpSeqNr = ExpFacts.SeqNrs(end);
        else, StpSeqNr = getSeqNr4Nrs(Nrs(3), Nrs(4), ExpFacts); end
    end    
    
    %Om typwerk te beperken kunnen er meerdere sequenties via eenzelfde vermelding gewijzigd worden naar verschillende
    %waarden ... Dit gebeurt via de syntax DSInfo_<cellnr>_<testnr>_vec = { ... , ... }; waarbij elk element in de
    %cell array uitgedeeld wordt over de sequenties beginnende bij <cellnr-testnr> tot en met alle elementen 
    %uitgedeeld zijn ...
    if strfind(EntryName, 'vec'),
        FNames = fieldnames(EntryStruct); NFields = length(FNames);
        EntryCell = struct2cell(EntryStruct); MaxNEntries = max(cellfun('length', EntryCell));
        
        try StpSeqNr = ExpFacts.SeqNrs(find(ExpFacts.SeqNrs == StrSeqNr) +  MaxNEntries - 1);
        catch, error(sprintf('Vector assignment %s exceeds number of sequences present.', EntryName)); end;    
        
        for f = 1:NFields,
            Values = getfield(EntryStruct, FNames{f});
            if ~iscell(Values), error('%s : when using vector assignment, the value of a field must be given as a cell array.', EntryName); end
            
            NEntries = length(Values);
            for n = 1:NEntries, EntryStruct = setfield(EntryStruct, {n}, FNames{f}, Values{n}); end
            
            for n = NEntries+1:MaxNEntries, 
                idx = find(ExpFacts.SeqNrs == StrSeqNr(1)) + n - 1;
                Value = getfield(DSInfo, {idx}, FNames{f});
                EntryStruct = setfield(EntryStruct, {n}, FNames{f}, Value); 
            end
        end
    end;
    
    %Nagaan of opgegeven veldnamen wel toegelaten zijn ...
    if ~all(ismember(fieldnames(EntryStruct), AllowedFNames)), 
        error(sprintf('One of the subfields of DSInfo for dataset <%s> doesn''t exist.', dsID)); 
    end
    
    %Informatie in DSInfo structuur aanpassen ...
    idx = find(ExpFacts.SeqNrs == StrSeqNr):find(ExpFacts.SeqNrs == StpSeqNr);
    DSInfo(idx) = expandstruct(EntryStruct, DSInfo(idx)); 
end

function S = unravelRef(S, ExpFacts, varargin)
%Verwijzingen die momenteel toegelaten worden zijn de volgende:
% seq_<stimtype>_<first|last> : voor de gegeven cel zoeken naar subsequentie met het gegeven stimulustype, indien
%                               er meerdere zijn dan wordt naargelang de waarde van de tweede parameter de hoogste
%                               of de laagste genomen. Het veld word gevuld met het sequentienummer. Indien voor die
%                               cel geen afleiding met de gevraagde stimulus gebeurde, dan wordt NaN teruggegeven.
%                               (Enkel voor CellInfo mogelijk!)
% from_<superfield>           : deze verwijzing wordt vervangen door de waarde van het veld met dezelfde naam in een 
%                               opgegeven hoger gelegen veld of superfield.

C = struct2cell(S');
FNames = fieldnames(S);
[NFields, NElem] = size(C);
SName = inputname(1);

IDList = char(ExpFacts.LUT.IDstr);
try
    AllCellNrs = char2num(IDList)';
catch
    AllCellNrs = [];
end

idx = find(strncmpi(C, 'seq_', 4))';
if ~isempty(idx) && ~strcmp(SName, 'CellInfo')
    error('A reference with syntax seq_<stimtype>_<first|last> can only be used for cell related information.'); 
end
for n = idx
    Tokens = parseStr(C{n}, '_');
    [FieldNr, idx] = ind2sub([NFields, NElem], n); 
    CellNr = ExpFacts.CellNrs(idx);
    try
        [StimType, Mode] = deal(Tokens{2:end});
        if ~ischar(StimType) || ~any(strcmpi(Mode, {'first', 'last'}))
            error('To catch block...'); 
        end
    catch
        error('Wrong sequence reference syntax for cell %d in field ''%s''. Syntax must be seq_<stimtype>_<first|last>.', CellNr, FNames{FieldNr}); 
    end
    
    idx = intersect(find(AllCellNrs == CellNr), strfindcell(upper(IDList), upper(StimType)));
    if isempty(idx)
        C{n} = NaN;       
    elseif strcmpi(Mode, 'last')
        C{n} = ExpFacts.SeqNrs(max(idx));
    else
        C{n} = ExpFacts.SeqNrs(min(idx)); 
    end
end

idx = find(strncmpi(C, 'from_', 4))';
if ~isempty(idx)
    %Hoger gelegen velden herorganiseren ...
    SFS = varargin; NSFS = nargin - 2; SFNames = cell(0);
    for n = 1:NSFS 
        SNames{n} = strrep(inputname(n+2), 'Def', ''); 
        SFNames   = cat(1, SFNames, fieldnames(SFS{n}));
    end
    SNames  = lower(SNames);
    SFNames = unique(SFNames);
    
    for n = idx
        [FNidx, N] = ind2sub([NFields, NElem], n); 
        FName = FNames{FNidx};
        switch SName
            case 'CellInfo'
                IDstr = sprintf('cell with number %d', S(N).Nr);
            case 'DSInfo'
                IDstr = sprintf('dataset <%s>', S(N).dsID); 
        end
        
        [dummy, SuperFName] = strtok(lower(C{n}), '_'); 
        SuperFName(1) = [];
        idx = find(ismember(SNames, SuperFName));
        if isempty(idx)
            error(sprintf('Information on %s contains reference to superfield %s. This superfield doesn''t exist.', IDstr, SuperFName));
        elseif ~isfield(SFS{idx}, FName)
            error(sprintf('Information on %s contains reference to superfield %s. This superfield doesn''t contain such a subfield.', IDstr, SuperFName)); 
        end
        C{n} = getfield(SFS{idx}, FName); 
    end
end

S = cell2struct(C, FNames)';

function SeqNr = getSeqNr4Nrs(CellNr, TestNr, ExpFacts)

%Nagaan of de dataset waarvoor gegevens voorhanden zijn in de script wel bestaat voor dit experiment ...
dsID  = sprintf('%d-%d', CellNr, TestNr);
SeqNr = GetSeqNr4dsID(ExpFacts.LUT, dsID);
if isnan(SeqNr)
    error(sprintf('Dataset <%s> doesn''t exist in %s, but information is nonetheless supplied in script.', dsID, ExpFacts.ExpName)); 
end    

function Sn = expandstruct(S, T)

NT = length(T); 
TC = struct2cell(T');
TFNames = fieldnames(T);

NS = length(S);
SC = struct2cell(S');
SFNames = fieldnames(S);

if NS == 1
    SC = repmat(SC, 1, NT); 
end

%idx = find(ismember(TFNames, SFNames));
%for n = 1:length(idx), TC(idx(n), :) = SC(n, :); end;
for n = 1:length(SFNames)
    idx = find(ismember(TFNames, SFNames{n}));
    TC(idx, :) = SC(n, :);   
end    

Sn = cell2struct(TC, TFNames)';