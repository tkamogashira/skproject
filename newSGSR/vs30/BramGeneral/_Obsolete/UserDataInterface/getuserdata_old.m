function UD = getuserdata(varargin)
%GETUSERDATA get userdata
%   UD = GETUSERDATA(ExpName) gets all relevant userdata for the experiment with name ExpName. This includes 
%   all user information, thus also information on every cell and every dataset that was recorded during the
%   experiment.
%   UD = GETUSERDATA(ExpName, CellNr) gives userdata on the experiment, information on the cell and information
%   on all the datasets associated with this cell.
%   UD = GETUSERDATA(ExpName, dsID) or UD = GETUSERDATA(ds) returns userdata for a given dataset which
%   consists of the information on the experiment, the cell from which this dataset was recorded and
%   the information on the dataset itself.
%
%   See also INITUSERDATA, EDITUSERDATA

%B. Van de Sande 22-09-2004

persistent NetProbeStat;
if ~isstruct(NetProbeStat)
    NetProbeStat = struct('expname', {}, 'probetime', {}); 
end

%Parameters nagaan ...
[Mode, ExpName, CellNr, SeqNr] = parseArg(varargin);

%Localisatie van userdata nagaan ...
ServerName    = strrep(servername, ':', ''); 
ServerDirInfo = serverdir;
evalc(['dos(sprintf(' ...
    '''net use %s \\\\lan-srv-01.med.kuleuven.be\\datawriter ' ...
    '5monkey /USER:datawriter'', servername))']);

if isempty(ServerName)
    error('Cannot get the name of the SGSR server. SGSR should be reconfigured.'); 
end
sURL = sprintf('file://%s/%s/%s%s.m', ServerName, ...
    strrep(ServerDirInfo.UsrData(2:end), '\', '/'), ExpName, UsrDFPostFix);

d1 = dir([ dataDir '\' ExpName '.spk']);
d2 = dir([ dataDir '\' ExpName '.dat']);
if isempty(d1) && isempty(d2)
    error('Experiment %s doesn''t exist or no local copy of this experiment.', ExpName); 
end

% %Nagaan of CACHE nog synchroon is met server zoniet file overhalen en parsen. Dit wordt
% %enkel gedaan om de 5 minuten, wel individueel bijgehouden voor elke experiment ...
% CacheFileName = fullfile(tempdir, 'userdata.cache'); 
% SearchParam = ExpName;
% CacheData = FromCacheFile(CacheFileName, SearchParam);
CacheData = []; % skip cache (Kevin)

Delay = 5*60;
idx = find(strcmpi({NetProbeStat.expname}, ExpName));
if ~isempty(idx) && ~isempty(CacheData) && (((now-NetProbeStat(idx).probetime)*60*60*24) < Delay)
    UD = CacheData.UD;
else
    ScriptLastModified = ProbeNetFile(sURL);
    if isempty(idx)
        NetProbeStat(end+1).expname = lower(ExpName);
        NetProbeStat(end).probetime = now;
    else
        NetProbeStat(idx).probetime = now; 
    end
    
    if isempty(ScriptLastModified) && isempty(CacheData)
        error('No userdata present for experiment %s.', ExpName);
    elseif isempty(ScriptLastModified)
        warning('No connection with SGSR-server, using cache instead.');
        UD = CacheData.UD;
    elseif isempty(CacheData) || (CacheData.Time < ScriptLastModified)
        UD = parseUD(ExpName, GetNetTxtFile(sURL)); %Parsen van userdata ...
%         Time = ScriptLastModified; 
%         CacheData = CollectInStruct(Time, UD);
%         ToCacheFile(CacheFileName, +1000, SearchParam, CacheData);
    else
        UD = CacheData.UD; 
    end
end

%De gevraagde informatie teruggeven ...
switch Mode
    case 'exp' %Alle informatie teruggeven indien enkel experimentnaam werd opgegeven ...
    case 'cell' %Experiment informatie, de informatie over de gevraagde cel zelf,
        %plus informatie over alle datasets voor die cel teruggeven ...
        SeqNrs = getSeqNrs4Cell(log2lut(ExpName), CellNr);
        UD = AdjustUDforCell(UD, CellNr);
        UD = AdjustUDforDS(UD, SeqNrs);
    case 'ds' %Experiment informatie, de informatie over de cel waar dataset toe
        %behoort en informatie over de gevraagde dataset zelf teruggeven ...
        UD = AdjustUDforCell(UD, CellNr);
        UD = AdjustUDforDS(UD, SeqNr);
end

%------------------------------------------locale functies----------------------
function [Mode, ExpName, CellNr, SeqNr] = parseArg(ArgList)

[Mode, ExpName, CellNr, SeqNr] = deal([]);

switch length(ArgList)
    case 1
        if isa(ArgList{1}, 'char'), ExpName = ArgList{1}; Mode = 'exp';
        elseif isa(ArgList{1}, 'dataset')
            ds = ArgList{1};
            [ExpName, dsID, SeqNr, CellNr] = deal(ds.FileName, ds.SeqID, ...
                ds.iSeq, ds.iCell);
            if isnan(CellNr)
                warning(['No cell number for this dataset. Cell related ' ...
                    'information cannot be returned.']);
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
                warning(['No cell number for this dataset. Cell related '...
                    'information cannot be returned.']);
                CellNr = NaN;
            end
            Mode = 'ds';
        else
            error('Wrong input arguments.');
        end
    otherwise
        error('Wrong number of input arguments.');
end

function UD = AdjustUDforCell(UD, CellNr)

if all(isnan(CellNr))
    UD.CellInfo = struct([]);
else
    UD.CellInfo = UD.CellInfo(ismember(cat(2, UD.CellInfo.Nr), CellNr));
end

function UD = AdjustUDforDS(UD, SeqNr)

UD.DSInfo = UD.DSInfo(ismember(cat(2, UD.DSInfo.SeqNr), SeqNr));
