function ArgOut = DataQuest(varargin)
%DATAQUEST  search for datasets by stimulus parameters.
%   DATAQUEST opens a GUI for searching datasets by stimulus parameters
%   using a previously generated search database. If no search database
%   exists for the current datafile directory, use DATAQUEST ` to
%   create one.
%   DATAQUEST(Expr) searches the database for all datasets which stimulus
%   parameters correspond to the supplied logical expression given by the
%   character string Expr. Any MATLAB expression that returns a logical
%   vector is valid. The names of the stimulus parameters are the names of
%   the fields used in the dataset object and they must be enclosed between
%   dollar signs. E.g. :
%     DATAQUEST('strcmpi($ID.StimType$, ''spl'') & ($Common.SPL$ == 90)')
%   If an output argument is given then DATAQUEST returns a structure-array
%   containing a listing of datasets corresponding to the requested query.
%   Otherwise the same listing is displayed.
%
%   DATAQUEST INIT or DATAQUEST('INIT') builds, resumes building or updates
%   the database for the current datafile directory.
%   DATAQUEST CLEAR or DATAQUEST('CLEAR') clears the database for the current
%   datafile directory.
%   DATAQUEST CLEAR CACHE or DATAQUEST('CLEAR', 'CACHE') clears only the caching
%   system associated with the current database.
%   DATAQUEST CLEAR SchemaID or DATAQUEST('CLEAR', 'SchemaID') clears the 
%   database for the current datafile directory, but only those tables with
%   the specified schema. The schema identifier of a table is the SGSR stimulus
%   type or the EDF schema name. E.g.:
%                          DATAQUEST CLEAR NRHO
%   DATAQUEST FIELDS or DATAQUEST('FIELDS') returns the names of the fields
%   that are common between all database tables. If an output argument is given
%   the list of fieldnames is returned as a cell-array of strings, otherwise
%   the list is displayed.
%   DATAQUEST FIELDS SchemaID or DATAQUEST('FIELDS', 'SchemaID') returns the
%   names of the all fields that are in a database table with the specified
%   schema identifier.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 25-04-2005

%-------------------------------implementation details-------------------------
%... Note on organization of the database ...
%The database contains multiple tables. Some columns or fieldnames of these
%tables are common, e.g. ID.XXX and General.XXX fieldnames, other fieldnames are
%different for each table and are defined by a schema type. For SGSR, IDF/SPK
%datasets the stimulus type designates the schema type, for EDF datasets this
%is the name of the schema of the dataset.
%To avoid memory problems while assembling the database, a table is divided in
%chunks with a maximum number of rows.
%... Note on fieldnames and their values in the database ...
%A fieldname is case-sensitive and for branched structures fieldnames can be
%given using the dot as a fieldname separator. To reduce the length of fieldnames
%aliases can be used. An alias is case-insensitive and must be unique, i.e. an
%alias can be associated with only one fieldname. But multiple aliases may refer
%to the same fieldname. For fieldnames where the value is a matrix or a cell-array
%of strings a suffix of the form #ElemNr or #FncName can be used to restrict the
%value to a scalar or string respectively. For cell-array of strings this also acts
%as a dereferencing operator, i.e. it returns a character string instead of a
%cell-array whenever possible. Aliases may contain such a suffix! According to
%the type of field the columns correspond to different channels, different
%independent variables, etc ...
%... Note on logical expressions ...
%Use the fieldname ID.SchName (or one of it aliases) to restrict the search to
%a subset of the database, which results in a much shorter search time. This
%field contains the schema name for EDF datasets and the stimulus type for
%SGSR or IDF/SPK datasets. Use ID.SchName instead of ID.StimType for SGSR or 
%IDF/SPK dataets because this should give much shorter search times.
%------------------------------------------------------------------------------

%-------------------------------default parameters-----------------------------
%Directory where actual datafiles can be found ...
DefParam.datadir     = datadir;
%Directory where initialisation files can be found. The initialisation files
%are the alias database and the script files associated with the different SchemaIDs.
%The directory does not include the cache file and the logfile created while building
%the database, which are stored in the data directory. Attention! The user-specific
%temporary directory cannot be used for the cache file because different users may be
%using DATAQUEST on the same data directory ...
DefParam.initdir     = fileparts(which(mfilename));
%Directoy where WinZip Command Line utility can be found ...
DefParam.unzipprog   = 'c:\program files\winzip\wzunzip.exe';
%Memory usage during buildup of database can be controlled using the following two
%properties. Each table-entry is 6 Kilobyte by average, thus tables of a thousand
%entries take 6 Megabyte. Ten of them in memory uses 60Mb in total, which should
%be less than the amount of RAM of most lab PCs. Attention! Keep the number of
%elements as large as possible, because this shortens the search time ...
DefParam.maxntables  = 10;   %Maximum number of database tables in buffer memory ...
DefParam.maxnentries = 1000; %Largest size of a single database table ...
%Algorithm used for searching the database. Must be 'fast' or 'caching' ...
DefParam.srchalgortm = 'fast';
%Maximum number of entries in the caching system ...
DefParam.maxncache   = 1000;
%The default root branch used for a fieldname. If a fieldname doesn't begin with
%'ID', 'Common' or 'Specific', the fieldname is assumed to be in this root branch ...
DefParam.rootbranch  = 'Specific';
%Character string (or cell-array of strings) with fieldname to return for
%database entries which match the logical expression ...
DefParam.outfields   = {'ID.FileName', 'ID.iSeq'};
%Display results on command line interface('cli') or as a spreadsheet('table') ...
DefParam.outmode     = 'table';

%----------------------------------main program-------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
else, [Cmd, Arg, Param] = ParseArgs(DefParam, varargin{:}); end

%Perform requested action ...
switch Cmd
case 'init'
    BuildDataBase(Param);
case 'clear', ClearDataBase(Arg, Param);
case 'fields', 
    FNames = DataBaseFields(Arg, Param);
    %Display or return cell-array ...
    if (nargout == 0),
        if strcmpi(Arg, 'common'),
            HdrStr  = 'Names of fields common to all tables:';
            WarnStr = sprintf('No database present for ''%s''.', Param.datadir);
        else, 
            HdrStr = sprintf('Names of the fields in table with schema ID ''%s'':', Arg); 
            WarnStr = sprintf('No database table with schema ID ''%s'' present for ''%s''.', Arg, Param.datadir);
        end
        
        if isempty(FNames), warning(WarnStr);
        else, 
            Sep = ', '; Nelem = length(FNames); Nchar = cellfun('length', FNames)+length(Sep);
            WinSz = get(0, 'CommandWindowSize'); Margin = 5; MaxWidth = WinSz(1)-2*Margin-length(Sep);
            disp(HdrStr); Bidx = 1;
            while Bidx <= Nelem,
                Eidx = Bidx + max(find(cumsum(Nchar(Bidx:end)) <= MaxWidth)) - 1;
                fprintf([blanks(Margin), cellstr2str(FNames(Bidx:Eidx), Sep), Sep, '\n']);
                Bidx = Eidx + 1;
            end
            fprintf([repmat('\b', 1, length(Sep)+1), '\n']);
        end
    else, ArgOut = FNames; end
case 'search', 
    %Acquire the logical expression ...
    if isempty(Arg),
        [Expr, Param] = QueryLogicExpr(Param); 
        if isnumeric(Expr) & (Expr == 0), return; end    
    else, Expr = Arg; end
    
    %Search the database ...
    T = SearchDataBase(Expr, Param);
    
    %Display or return structure-array ...
    if (nargout == 0),
        if strcmpi(Param.outmode, 'table'), 
            if isempty(T), warndlg(sprintf('No datasets found that match\nrequested logical expression.'), upper(mfilename));
            else, structview(T, 'titletxt', upper(mfilename), 'indexrow', 'off'); end
        else, 
            if isempty(T), warning(sprintf('No datasets found that match requested logical expression.')); 
            else, structdisp(T, 'indexrow', 'off'); end
        end
    else, ArgOut = T; end
end

%---------------------------------local functions-----------------------------
function [Cmd, Arg, Param] = ParseArgs(DefParam, varargin)

if isempty(varargin), Cmd = 'search'; Arg = ''; Pidx = 1;
elseif ischar(varargin{1}) & strcmpi(varargin{1}, 'init'),
    Cmd = lower(varargin{1}); Arg = ''; Narg = length(varargin);
    if (Narg == 1), Pidx = 2; 
    elseif (Narg >= 3) & ischar(varargin{2}) & any(strcmpi(fieldnames(DefParam), varargin{2})), Pidx = 2;
    else, error('Invalid syntax'); end
elseif ischar(varargin{1}) & strcmpi(varargin{1}, 'clear'),     
    Cmd = lower(varargin{1}); Narg = length(varargin);
    if (Narg == 1), Arg = 'all'; Pidx = 2;
    elseif (Narg == 2) & ischar(varargin{2}), Arg = lower(varargin{2}); Pidx = 3; 
    elseif (Narg >= 3) & ischar(varargin{2}) & any(strcmpi(fieldnames(DefParam), varargin{2})),
        Arg = 'all'; Pidx = 2; 
    elseif (Narg >= 4) & ischar(varargin{2}), Arg = lower(varargin{2}); Pidx = 3; 
    else, error('Invalid syntax'); end
elseif ischar(varargin{1}) & strcmpi(varargin{1}, 'fields'),
    Cmd = lower(varargin{1}); Narg = length(varargin);
    if (Narg == 1), Arg = 'common'; Pidx = 2;
    elseif (Narg == 2) & ischar(varargin{2}), Arg = lower(varargin{2}); Pidx = 3; 
    elseif (Narg >= 3) & ischar(varargin{2}) & any(strcmpi(fieldnames(DefParam), varargin{2})),
        Arg = 'common'; Pidx = 2; 
    elseif (Narg >= 4) & ischar(varargin{2}), Arg = lower(varargin{2}); Pidx = 3; 
    else, error('Invalid syntax'); end
elseif ischar(varargin{1}) & any(strcmpi(fieldnames(DefParam), varargin{1})),
    Cmd = 'search'; Arg = ''; Pidx = 1;
elseif ischar(varargin{1}), 
    Cmd = 'search'; Arg = varargin{1}; Pidx = 2;
else, error('Invalid syntax.'); end

Param = checkproplist(DefParam, varargin{Pidx:end});
Param = CheckParam(Param);

%-----------------------------------------------------------------------------
function Param = CheckParam(Param)

if ~exist(Param.datadir, 'dir'), error('Property datadir should be an existing directory.'); end
if ~exist(Param.initdir, 'dir'), error('Property initdir should be an existing directory.'); end
if ~exist(Param.unzipprog, 'file'), error('Cannot find WinZip® Command Line Support Add-On.'); end
if ~isnumeric(Param.maxntables) | (length(Param.maxntables) ~= 1) | mod(Param.maxntables, 1) | (Param.maxntables <= 0),
    error('Property maxntables must be positive integer.');
end
if ~isnumeric(Param.maxnentries) | (length(Param.maxnentries) ~= 1) | mod(Param.maxnentries, 1) | (Param.maxnentries <= 0),
    error('Property maxnentries must be positive integer.');
end
if ~ischar(Param.srchalgortm) | ~any(strcmpi(Param.srchalgortm, {'fast', 'caching'})),
    error('Property srchalgortm must be ''fast'' or ''caching''.');
end
if ~isnumeric(Param.maxncache) | (length(Param.maxncache) ~= 1) | mod(Param.maxncache, 1) | (Param.maxncache <= 0),
    error('Property maxncache must be positive integer.');
end
if ~ischar(Param.rootbranch) | ~any(strcmp(Param.rootbranch, {'ID', 'Common', 'Specific'})),
    error('Property rootbranch must be ''ID'', ''Common'' or ''Specific''.');
end    
if ~ischar(Param.outfields) & ~iscellstr(Param.outfields), 
    error('Property outfields must be character string or cell-array of strings.');
else, Param.outfields = cellstr(Param.outfields); end

if ~ischar(Param.outmode) | ~any(strcmpi(Param.outmode, {'cli', 'table'})),
    error('Property outmode must be ''cli'' or ''table''.');
end

%-----------------------------------------------------------------------------
function BuildDataBase(Param)

%Open a log file to record all warnings ...
LogFileName = fullfile(Param.datadir, [mfilename, '.errorlog']); %Do not use '.log' extension ...
LogFile('open', LogFileName, sprintf('- Building database for <''%s''>', Param.datadir));

%Database name ...
DBFileName = fullfile(Param.datadir, [mfilename, '.db']);

%Set up dialog box with progression bar ...
PBHdl = ProgBar(upper(mfilename), {'Scanning directory hierarchy ...', ''}, [0, 0]);

if ~exist(DBFileName, 'file') %Initialization ...
    %Make listing datafiles in directory hierarchy ...
    DBSchedule = MakeDBSchedule(Param.datadir, Param);
    %Information on maximum number of entries per table and data directory ...
    DBParam = getfields(Param, {'datadir', 'maxnentries'});
else %Resume initialization or update database ...
    load(DBFileName, '-mat');
    if ~exist('DBSchedule', 'var') | ~exist('DBParam', 'var'), 
        ErrMsg = sprintf('''%s'' does not contain a valid database.', Param.datadir); 
        LogFile('add', ErrMsg); 
        LogFile('close'); 
        if ishandle(PBHdl)
            delete(PBHdl); 
        end
        error(ErrMsg);
    end

    %Checking database parameters with current settings. Making sure that initialisation
    %and updating of database can only be done from the same computer in the network ...
    if ~strcmpi(deblank(DBParam.datadir), deblank(Param.datadir)),
        ErrMsg = sprintf('Information stored in database doesn''t correspond with location of database.'); 
        LogFile('add', ErrMsg); LogFile('close'); 
        if ishandle(PBHdl)
            delete(PBHdl); 
        end
        error(ErrMsg);
    elseif ~isequal(DBParam.maxnentries, Param.maxnentries),
        WarnMsg = sprintf('Maximum number of entries in a table for the database in ''%s'' is different from\nthe current setting. Current setting is ignored.', Param.datadir); 
        LogFile('add', WarnMsg); 
        warning(WarnMsg);
        %Stored parameters overrule the current parameter settings ...
        Param.maxnentries = DBParam.maxnentries;
    end
    
    %Make listing of datafiles in directory hierarchy ...
    UpdatedDBSchedule = MakeDBSchedule(Param.datadir, Param);
    
    %Check if datafiles have been removed from the directory hierarchy. Datafiles
    %that aren't present anymore must be removed from the schedule, because these
    %datafiles might not have been fully processed in the previous session and now
    %these files are not accessable anymore ...
    idx = find(~ismember({DBSchedule.name}, {UpdatedDBSchedule.name}));
    if ~isempty(idx),
        WarnMsg = 'Some datafiles where removed from the data directory.'; 
        warning(WarnMsg); 
        LogFile('add', WarnMsg);
        DBSchedule(idx) = [];
    end
    
    %New datafiles are always included ...
    idx = find(~ismember({UpdatedDBSchedule.name}, {DBSchedule.name}));
    DBSchedule = [DBSchedule; UpdatedDBSchedule(idx)];
    UpdatedDBSchedule(idx) = []; %Remove entries for new datafiles ...
    
    %Checking for datafiles that have now an unarchived version present
    %in the directory hierarchy but prevoiusly not, is not necessary
    %because these datafiles are already in the database in so need not
    %be considered for update ...
    
    %Check for datafiles that are already in the list but have a more
    %recent date. Datafiles for which this is true and for which now an
    %unarchived version is present where previously there wasn't, are
    %included but now using the unarchived version ...
    idx = find(ismember({DBSchedule.name}, {UpdatedDBSchedule.name}));
    %Because both list are still sorted by name, the dates match up ...
    UpdatedDBSchedule = UpdatedDBSchedule(find(datenum(char(DBSchedule(idx).date)) < datenum(char(UpdatedDBSchedule.date))));
    if ~isempty(UpdatedDBSchedule)
        WarnMsg = [sprintf('Newer version of some datafiles present in directory hierarchy. This\n'), ...
            sprintf('may introduce duplicate entries in database.')];
        warning(WarnMsg); 
        LogFile('add', WarnMsg);
        
        idx = find(ismember({DBSchedule.name}, {UpdatedDBSchedule.name}));
        DBSchedule(idx) = UpdatedDBSchedule;
    end
end

%User cancelled initialization ...
if ~ishandle(PBHdl)
    DBDiskMap = CreateDiskMap;
    save(DBFileName, 'DBParam', 'DBSchedule', 'DBDiskMap', '-mat'); %Create database ...
    LogFile('close'); %Close log file ...
    return
end

%Using the current schedule to traverse all datafiles ...
GetLUT('reset'); %Resetting list of already extracted archives ...
Buffer('reset', Param.datadir, Param.maxntables, Param.maxnentries);
idx = find(~[DBSchedule.processed]); 
N = length(idx);
for n = 1:N,
    if ~ishandle(PBHdl)
        break;
    else
        ProgBar(PBHdl, [(n-1)/N, 0], {sprintf('Processing %s ...', upper(DBSchedule(idx(n)).name)), ''}); 
    end
    DBSchedule(idx(n)) = ProcessScheduleEntry(DBSchedule(idx(n)), PBHdl, (n-1)/N, 1/N, Param);
end
if ishandle(PBHdl)
    ProgBar(PBHdl, [1, 1], {'Flushing memory buffer ...', ''}); 
end;
Buffer('flush');

%Create diskmap for searching the database. Attention! This must be done after
%flushing the buffer ...
if ishandle(PBHdl)
    ProgBar(PBHdl, [1, 1], {'Creating map of disk ...', ''}); 
end
DBDiskMap = CreateDiskMap(Param.datadir);

%Remove dialog box with progression bar ...
if ishandle(PBHdl)
    delete(PBHdl); 
end

%Create database ...
save(DBFileName, 'DBParam', 'DBSchedule', 'DBDiskMap', '-mat');

%Close log file ...
LogFile('close');

%-----------------------------------------------------------------------------
function S = MakeDBSchedule(DirName, Param)

%Scanning directory for datafiles. Datafiles can be recognized by their
%extension ('.LOG' or '.ZIP') ...
S = ScanDir(DirName, '*.log', '*.zip');
%When no datafiles are present in the directory hierarchy return the empty
%structure with valid fieldnames ...
if isempty(S), 
    S = struct('filename', '', 'date', '', 'path', '', 'name', '', 'type', '', ...
        'processed', [], 'iseqs', [], 'schemaids', []);
    S(1) = [];
    return;
end

%Reorganize datafile listing ...
S = rmfield(S, 'bytes'); %Bytes field is not informative ...
S = rnfield(S, 'name', 'filename');
[Name, Type] = UnRavelFileName({S.filename});
[S.name] = deal(Name{:});
[S.type] = deal(Type{:});
[S.processed] = deal(0);
[S.iseqs]     = deal([]);
[S.schemaids] = deal({});

%If archives are present in the directory hierarchy, these archives
%must be scanned for presence of datafiles ...
idx = find(strcmpi({S.type}, 'zip')); NZips = length(idx);
for n = 1:NZips,
    ZipName = fullfile(S(idx(n)).path, [S(idx(n)).name, '.zip']);
    Szip = ListZip(ZipName);
    Szip = Szip(strfindcell(lower({Szip.name}), '.log'));
    
    if ~isempty(Szip),
        Szip = rmfield(Szip, {'bytes', 'ratio', 'path'});
        Szip = rnfield(Szip, 'name', 'filename');
        [Szip.path] = deal(ZipName);
        [Name, Type] = UnRavelFileName({Szip.filename});
        [Szip.name] = deal(Name{:});
        [Szip.type] = deal('zip');
        [Szip.processed] = deal(0);
        [Szip.iseqs]     = deal([]);
        [Szip.schemaids] = deal({});
        
        S(idx(n)) = Szip(1); S = [S; Szip(2:end)];
    else, S(idx(n)).filename = ''; end %Mark for removal ...
end
S(find(cellfun('isempty', {S.filename}))) = [];

%For datafiles with multiple copies in the datafile directory hierarchy,
%the last encountered copy is used. And if an extracted version of a datafile
%is present then this is always used instead of the archived version ...
[dummy, idx] = sortrows(char(S.type)); S = S(idx(end:-1:1));
[dummy, idx] = unique(char(S.name), 'rows'); S = S(idx);

%-----------------------------------------------------------------------------
function [Name, Ext] = UnRavelFileName(FileName)

CA = [char(FileName), repmat(sprintf(' \n'), length(cellstr(FileName)), 1)];
CA = CA'; CA = CA(:)';
[Name, Ext] = strread(CA, '%[^.].%[^ ]', 'endofline', sprintf('\n'), 'whitespace', ' ', 'delimiter', 'none');
Name = lower(Name);
Ext  = lower(Ext);

%-----------------------------------------------------------------------------
function Entry = ProcessScheduleEntry(Entry, PBHdl, Frac, FracSize, Param)

%Retrieving lookup table for datafile ...
[DataFile, LUT] = GetLUT(Entry, Param);
if isempty(LUT), return; end

%Reducing lookup table to entries which weren't processed before ...
if ~isempty(Entry.iseqs),
    idx = find(ismember(cat(2, LUT.iSeq), Entry.iseqs));
    LUT(idx) = [];
end

%Cycle through all datasets of the datafile ...
N = length(LUT); BadDataSet = logical(0);
for n = 1:N,
    FileName = Entry.name;
    iSeq     = LUT(n).iSeq;
    SeqID    = lower(LUT(n).IDstr);
        
    if ~ishandle(PBHdl), return; %Datafile is not recorded as being processed ...
    else, ProgBar(PBHdl, [Frac+((n-1)*FracSize/N), (n-1)/N], ... 
            {sprintf('Processing %s ...', upper(FileName)); sprintf('%s', upper(SeqID))}); end
    
    try,
        %Warnings generated while loading a dataset are also stored in the logfile ...
        lastwarn('');
        ds = dataset(DataFile, iSeq);
        ds = emptydataset(ds);
        if ~isempty(lastwarn), LogFile('add', lastwarn); end
    catch,
        %Dataset and datafile are not recorded as being processed ...
        WarnMsg = sprintf('Could not load dataset %s <%s>(#%d).', FileName, SeqID, iSeq);
        warning(WarnMsg); LogFile('add', WarnMsg);
        BadDataSet = logical(1); continue;
    end
        
    try, 
        TableEntry = DS2TableEntry(ds, Param); 
        %Dataset and datafile are not recorded as being processed ...
        if isempty(TableEntry), BadDataSet = logical(1); continue; end
    catch,    
        %Dataset and datafile are not recorded as being processed ...
        WarnMsg = sprintf('Could not create table entry for dataset %s <%s>(#%d).', FileName, SeqID, iSeq);
        warning(WarnMsg); LogFile('add', WarnMsg);
        BadDataSet = logical(1); continue;
    end
    
    SchemaID = GetSchemaID(ds);
    Status = Buffer(SchemaID, TableEntry);
    if Status, 
        %Dataset and datafile are not recorded as being processed ...
        WarnMsg = sprintf('Could not add stimulus parameters of dataset %s <%s>(#%d) to table.', FileName, SeqID, iSeq);
        warning(WarnMsg); LogFile('add', WarnMsg);
        BadDataSet = logical(1);
        continue;
    end
    
    Entry.iseqs     = [Entry.iseqs, iSeq];
    Entry.schemaids = [Entry.schemaids, {SchemaID}];
end

if ~BadDataSet, Entry.processed = 1; end

%-----------------------------------------------------------------------------
function [FileName, LUT] = GetLUT(varargin)

persistent ExtractedArchives;

%GETLUT('reset') reset list of already extracted archives during this session ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'reset'),
    ExtractedArchives = cell(0);
%[FileName, LUT] = GETLUT(Entry, Param)
elseif (nargin == 2) & all(cellfun('isclass', varargin, 'struct')),
    [Entry, Param] = deal(varargin{1:2});
    %Attention! If only an archive is present for the datafile, then this archive
    %is completely extracted in the temporary directory. This may cause unnecessary
    %wasting of disk space if the user doesn't clear his temporary directory often
    %enough. An archive is only extracted once during an initialisation or update
    %session, even if the archive contains many different datafiles ...
    if strcmpi(Entry.type, 'zip'),
        ZipFileName = lower(Entry.path);
        DestDir     = tempdir; %Extract datafile in temporary directory ...
        FileName    = fullfile(DestDir, Entry.name);
        if ~ismember(ZipFileName, ExtractedArchives),
            %Arguments for the WinZip Command Line utility ...
            % -o : overwrite existing files without prompting
            %Do not use -d argument (recreate the folder structure that is stored within the Zip file) ...
            UnZipOpts   = '-o';
            
            WarnMsg = sprintf('Extracting archive ''%s'' in temporary directory ''%s''.', ZipFileName, DestDir);
            warning(WarnMsg); LogFile('add', WarnMsg);
            
            Cmd = ['"' Param.unzipprog '" ' UnZipOpts  ' ' ZipFileName ' ' DestDir ];
            [Status, dummy] = dos(Cmd);
            if Status, 
                LUT = struct([]);
                WarnMsg = sprintf('Could not extract archive ''%s''.', ZipFileName)
                warning(WarnMsg); LogFile('add', WarnMsg);
                return;
            else
                ExtractedArchives = [ExtractedArchives, {ZipFileName}]; 
            end
        end
    else
        FileName = fullfile(Entry.path, Entry.name); 
    end %Datafile already extracted ...
    
    try 
        LUT = log2lut(FileName);
        if isInvalidLUT(LUT)
            error('To catch block ...'); 
        end
    catch
        %Datafile propably doesn't exist because '.LOG' extension is commonly used for 
        %other file types (e.g. WS_FTP.LOG) ...
        LUT = struct([]);
        WarnMsg = sprintf('Could not load LUT for %s.', FileName); 
        warning(WarnMsg); LogFile('add', WarnMsg);
    end
else
    error('Wrong number of input arguments.'); 
end

%-----------------------------------------------------------------------------
function boolean = isInvalidLUT(LUT)
%Checks if LUT is valid ... Necessary for Harris datafiles ...

%List of ASCII characters which are invalid for dataset IDs ...
InvalidChars = [char(1:7), char(14:31)];

IDs = char(LUT.IDstr);
boolean = any(ismember(IDs(:), InvalidChars(:)));

%-----------------------------------------------------------------------------
function Map = CreateDiskMap(varargin)

Map = struct('path', '', 'filename', '', 'schema', '', 'filenr', 0, 'nentries', 0, 'idx', [], ...
    'memidx', 0, 'naccess', 0);

%CREATEDISKMAP creates empty diskmap ...
if (nargin == 0), Map(1) = []; return;
%CREATEDISKMAP(DirName) creates new diskmap ...    
elseif ischar(varargin{1}),
    DirName = varargin{1};
    S = dir(fullfile(DirName, [mfilename, '_*.db']));
    if isempty(S), Map(1) = []; return;
    else,
        N = length(S); Map = repmat(Map, N, 1);
        
        %Add filename ...
        [Map.filename] = deal(S.name);
        
        %Add path ...
        if (DirName(end) ~= filesep), DirName = [DirName, filesep]; end
        Path = cellstr([repmat(DirName, N, 1), char(S.name)]);
        [Map.path] = deal(Path{:});
        
        %Extract stimulus type and file number ...
        CA = [char(S.name), repmat(sprintf(' \n'), N, 1)]; CA = CA'; CA = CA(:)';
        [Schemata, FileNr] = strread(CA, '%*[^_]_%[^_]_%d%*s', 'endofline', sprintf('\n'), ...
            'whitespace', ' ');
        Schemata = lower(Schemata); [Map.schema] = deal(Schemata{:});
        FileNr = num2cell(FileNr); [Map.filenr] = deal(FileNr{:});
        
        %Read number of entries in file ...
        for n = 1:N,
            S = load(fullfile(DirName, sprintf('%s_%s_%d.db', mfilename, Map(n).schema, Map(n).filenr)), '-mat');
            Map(n).nentries = length(S.Table);
            Map(n).idx      = 1:Map(n).nentries;
        end
    end
%CREATEDISKMAP(DiskMap, DirName) updates given diskmap with new directory name ...    
elseif (nargin == 2) & isstruct(varargin{1}) & all(ismember(fieldnames(varargin{1}), fieldnames(Map))) & ...
        ischar(varargin{2}),
    [Map, DirName] = deal(varargin{1:2}); N = length(Map);
    %Update path ...
    if (DirName(end) ~= filesep), DirName = [DirName, filesep]; end
    Path = cellstr([repmat(DirName, N, 1), char(Map.filename)]);
    [Map.path] = deal(Path{:});
else, error('Wrong input arguments.'); end

%-----------------------------------------------------------------------------
function Status = Buffer(varargin)

persistent DirName MaxNTables MaxNEntries DiskMap Buffer;

Status = 0; %Return status. Zero means normal return status ...

if (nargin < 0), error('Wrong number of input arguments.'); end

%Peform requested action ...
if ischar(varargin{1}) & strcmpi(varargin{1}, 'reset'),
    %BUFFER('RESET', DirName, MaxNTables, MaxNEntries)
    if (nargin ~= 4), error('Wrong number of input arguments.');
    else, [DirName, MaxNTables, MaxNEntries] = deal(varargin{2:4}); end
    DiskMap = getfields(CreateDiskMap(DirName), {'path', 'schema', 'filenr', 'nentries', 'memidx', 'naccess'});
    %If multiple entries with the same schema ID are present in the disk map
    %then only the one with the largest file number is kept ...
    [dummy, idx] = sort(cat(2, DiskMap.filenr)); DiskMap = DiskMap(idx);
    [dummy, idx] = unique({DiskMap.schema}); DiskMap = DiskMap(idx);
    Buffer  = [];
elseif ischar(varargin{1}) & strcmpi(varargin{1}, 'flush'),
    %BUFFER('FLUSH')
    %Write all data currently in memory to disk ...
    idx = find(cat(2, DiskMap.memidx) > 0); idx = idx(:)';
    for n = idx,
        Table = Buffer{DiskMap(n).memidx};
        save(DiskMap(n).path, 'Table', '-mat');
    end
    %Clear memory ...
    [DirName, MaxNTables, MaxNEntries, DiskMap, Buffer] = deal([]);
else,    
    %BUFFER(TableSchema, TableEntry)
    if (nargin == 2) & ischar(varargin{1}) & isstruct(varargin{2}), 
        [Schema, TableEntry] = deal(varargin{1:2}); 
        Schema = lower(Schema);
    else, error('Wrong input arguments.'); end

    idx = find(strcmpi({DiskMap.schema}, Schema));
    if isempty(idx), %New kind of stimulus type ...
        [DiskMap, Buffer, MemIdx] = GetBufferIdx(DiskMap, Buffer, MaxNTables);
        
        %Use buffer space to store table entry ...
        Buffer{MemIdx} = TableEntry;
            
        %Add new entry to disk map ...
        Path = fullfile(DirName, sprintf('%s_%s_%d.db', mfilename, Schema, 1));
        MapEntry = struct('path', Path, 'schema', Schema, 'filenr', 1, 'nentries', 1, ...
            'memidx', MemIdx, 'naccess', 1);
        DiskMap = [DiskMap; MapEntry];
    else,
        MemIdx = DiskMap(idx).memidx;
        if MemIdx, %Memory buffer already present ...
            %Fieldnames of TableEntry can be incompatible ...
            try, Buffer{MemIdx} = [Buffer{MemIdx}; TableEntry];
            catch, 
                DiskMap(idx).naccess = DiskMap(idx).naccess+1; 
                Status = 1; return;
            end
            
            %Adjust map entry ...
            DiskMap(idx).nentries = DiskMap(idx).nentries+1;
            DiskMap(idx).naccess  = DiskMap(idx).naccess+1;
        else,
            %Only load table for this stimulus type if some entries are already present ...
            if (DiskMap(idx).nentries > 0), load(DiskMap(idx).path, 'Table', '-mat');
            else, Table = []; end
            
            %Use buffer space to store table entry ...
            [DiskMap, Buffer, MemIdx] = GetBufferIdx(DiskMap, Buffer, MaxNTables);
            %Fieldnames of TableEntry can be incompatible ...
            try,
                Buffer{MemIdx} = [Table; TableEntry];
                NEntries = length(Table)+1;
            catch, 
                Buffer{MemIdx} = Table;
                NEntries = length(Table);
                Status = 1;
            end
            clear('Table');
            
            %Adjust map entry ...
            if (NEntries == 0), DiskMap(idx).memidx = 0; else, DiskMap(idx).memidx = MemIdx; end
            DiskMap(idx).nentries = NEntries;
            DiskMap(idx).naccess  = DiskMap(idx).naccess+1;
        end
        %Check of map entry didn't reach the maximum number of entries ...
        [DiskMap, Buffer] = CheckDiskMapEntry(DiskMap, Buffer, idx, MaxNEntries, DirName);
    end
end

%-----------------------------------------------------------------------------
function [DiskMap, Buffer] = CheckDiskMapEntry(DiskMap, Buffer, idx, MaxNEntries, DirName)

if (DiskMap(idx).nentries >= MaxNEntries),
    %Write buffer to disk ...
    MemIdx = DiskMap(idx).memidx;
    Table = Buffer{MemIdx}; save(DiskMap(idx).path, 'Table', '-mat'); clear('Table');
    Buffer{MemIdx} = [];
    
    %Adjust map entry ...
    DiskMap(idx).filenr   = DiskMap(idx).filenr+1;
    DiskMap(idx).path     = fullfile(DirName, sprintf('%s_%s_%d.db', mfilename, ...
        DiskMap(idx).schema, DiskMap(idx).filenr));
    DiskMap(idx).nentries = 0;
    DiskMap(idx).memidx   = 0;
end

%-----------------------------------------------------------------------------
function [DiskMap, Buffer, MemIdx] = GetBufferIdx(DiskMap, Buffer, MaxNTables)

InMemMap = DiskMap(find(cat(2, DiskMap.memidx) > 0));
NTablesInMem = length(InMemMap);

if (NTablesInMem >= MaxNTables),
    %Making place in memory by flushing the least accessed table ...
    [dummy, idx] = min(cat(2, InMemMap.naccess));   
    idx = find(strcmpi({DiskMap.schema}, InMemMap(idx).schema));
    MemIdx = DiskMap(idx).memidx; DiskMap(idx).memidx = 0;
    Table = Buffer{MemIdx}; save(DiskMap(idx).path, 'Table', '-mat'); Buffer{MemIdx} = [];
else, MemIdx = min(setdiff(1:MaxNTables, cat(2, InMemMap.memidx))); end

%-----------------------------------------------------------------------------
function S = DS2TableEntry(ds, Param)

%Find out what kind of dataset is given ...
if strcmpi(ds.FileFormat, 'IDF/SPK') | (strcmpi(ds.FileFormat, 'MDF') & strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK')),
    isIDF_SPKds = logical(1);
else, isIDF_SPKds = logical(0); end

%Extract identification and common stimulus parameters ...
[S, WarnMsg] = CommonParam(ds);
if ~isempty(WarnMsg),
    %The dataset is not included in the database ...
    warning(WarnMsg); LogFile('add', WarnMsg);
    S = struct([]); return;
end

%Stimulus specific parameters (different for each stimulus type) ...
%For farmington(IDF/SPK) datasets, FARMSLEDGE.M will make the StimParam structure of
%a farmington dataset flat without cell-array's per individual playback channels. For
%these kind of datasets the stimulus specific parameters will be this flattened structure
%and no script needs to be run ...
%For other datasets this is defined by the user in different schemata. Each schemata is
%a MATLAB function which returns a structure array S and must accept a dataset as first
%and only input argument. The structure returned must always have the same fieldnames and
%in the same order. For each SGSR stimulus type and for each EDF schema number their must
%be a corresponding function otherwise a warning will be given and no extra parameters
%will be saved in the table for that kind of stimulus.
%Attention! For SGSR datasets, there are sometimes multiple versions of the same stimulus
%type. The script for an SGSR stimulus type will have to make sure that whatever the version
%the returned structure is the same (mostly by adding extra fields for older versions of
%the stimulus). But when a new version of a stimulus type is created and extra fields are
%added, the database has to be remade for that stimulus type.
if isIDF_SPKds, S.Specific = FarmSledge(ds.StimParam);
else,
    ScriptID = GetSchemaID(ds);
    ScriptFileName = fullfile(Param.initdir, [mfilename '_' ScriptID '.m']);
    
    if exist(ScriptFileName, 'file'),
        %Warning's during a script are captured and only after the script
        %has been executed are they displayed and stored in the logfile ...
        CurWarnSetting = warning; warning off; lastwarn('');
        %If the script returns an empty structure then no Specific field
        %is added to S. The Specific field cannot be the empty structure
        %because this would result in an invalid structure-array ...
        [Sscript, ErrMsg] = ExecuteScript(ScriptFileName, ds);
        if ~isempty(ErrMsg),
            %The dataset is not included in the database ...
            WarnMsg = sprintf('While evaluating dataset %s, the schema function ''%s'' generated an error: %s', ds.title, ...
                ScriptFileName, ErrMsg); 
            S = struct([]);
        else,
            if ~isempty(Sscript), S.Specific = Sscript; end
            WarnMsg = lastwarn;
        end
        warning(CurWarnSetting); if ~isempty(WarnMsg), warning(WarnMsg); LogFile('add', WarnMsg); end
    else, 
        %The dataset is included in the database, but no specific stimulus parameters
        %can be requested for datasets with this schema identifier ...
        WarnMsg = sprintf('For dataset %s their is no corresponding schema function.', ds.title); 
        warning(WarnMsg); LogFile('add', WarnMsg);
    end
end

%-----------------------------------------------------------------------------
function SchemaID = GetSchemaID(ds)

FileFormat = ds.FileFormat;
if strcmpi(FileFormat, 'EDF'), SchemaID = ds.SchName;
elseif strcmpi(FileFormat, 'MDF'),
    if strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'), SchemaID = ds.SchName;
    else, SchemaID = ds.StimType; end
else, SchemaID = ds.StimType; end    

%-----------------------------------------------------------------------------
function [S, ErrMsg] = ExecuteScript(ScriptFileName, ds)

S = struct([]); lasterr('');

[ScriptPath, ScriptName] = fileparts(ScriptFileName);
PathEntries = which(ScriptName, '-all');
if ~isempty(PathEntries) & strcmpi(PathEntries{1}, ScriptPath),
    try, S = feval(ScriptName, ds); end
else,
    CurDir = pwd; cd(ScriptPath);
    try, S = feval(ScriptName, ds); end
    cd(CurDir);
end    
ErrMsg = lasterr;

%-----------------------------------------------------------------------------
function LogFile(Cmd, varargin)

persistent FID;

%Checking input arguments ...
if ~ischar(Cmd) | ~any(strcmpi(Cmd, {'open', 'close', 'add'})),
    error('First argument should be requested command.');
end

%Peforming requested action ...
switch lower(Cmd)
case 'open',
    if (nargin < 2) | ~ischar(varargin{1}), error('Syntax error.'); end
    if (nargin > 2) & ischar(varargin{2}), TitleStr = varargin{2}; else, TitleStr = ''; end

    %Open text-file for appending ...
    FileName = varargin{1};
    FID = fopen(FileName, 'at');
    if (FID < 0), error(sprintf('Couldn''t open logfile ''%s''.', FileName)); end
    
    %Write header for the current session ...
    fprintf(FID, '\n----------------------------\n');
    fprintf(FID, 'Created by %s @ %s %s\n', upper(mfilename), datestr(now), TitleStr);
    fprintf(FID, '----------------------------\n');
case 'close',
    if ~isempty(fopen(FID)), fclose(FID);
    else, error('No logfile open.'); end
case 'add',
    if (nargin < 2) | ~ischar(varargin{1}), error('Syntax error.'); end
    if isempty(fopen(FID)), error('No logfile open.'); end
    
    Message = varargin{1};
    fprintf(FID, '%s - %s\n', datestr(now), Message);
end

%-----------------------------------------------------------------------------
function FNames = DataBaseFields(SchemaID, Param)

FNames = cell(0);

if strcmpi(SchemaID, 'common'),
    DBFileName = fullfile(Param.datadir, [mfilename, '.db']);
    if exist(DBFileName), 
        PS = CommonParam; FNames = CommonParam(PS);
        FNames(find(cellfun('isempty', FNames))) = [];
    end
else,
    DBFileName = fullfile(Param.datadir, [mfilename, '_', SchemaID, '_1.db']);
    if exist(DBFileName),
        load(DBFileName, '-mat'); %Read variable Table in memory ...
        [dummy, FNames] = destruct(Table);
    end
end

%-----------------------------------------------------------------------------
function ClearDataBase(Task, Param)

CacheFileName = fullfile(Param.datadir, [mfilename, '.cache']);
LogFileName   = fullfile(Param.datadir, [mfilename, '.errorlog']);

switch Task
case 'all', %Deleting all files associated with DATAQUEST in the current working directory ...
    %Deleting database files, including the database task schedule ...
    Pattern = fullfile(Param.datadir, [mfilename, '*.db']); S = dir(Pattern);
    if ~isempty(S),
        N = length(S); for n = 1:N, delete(fullfile(Param.datadir, S(n).name)); end
    else, warning(sprintf('No database present for ''%s''.', Param.datadir)); end
    if exist(LogFileName, 'file'), delete(LogFileName); end     %Delete logfile ...
    if exist(CacheFileName, 'file'), EmptyCacheFile(CacheFileName); end %Delete cachefile ...
case 'cache', %Delete caching system ...
    if exist(CacheFileName, 'file'), EmptyCacheFile(CacheFileName); 
    else, warning(sprintf('No caching file present for ''%s''.', Param.datadir)); end
otherwise, %Delete tables with specified SchemaID ...
    SchemaID = Task;
    LogFile('open', LogFileName, sprintf('- Removing tables with ID ''%s'' from <''%s''>', SchemaID, Param.datadir));
    Pattern = fullfile(Param.datadir, [mfilename, '_', lower(SchemaID), '_*.db']); S = dir(Pattern);
    if ~isempty(S),
        %Delete tables ...
        N = length(S); for n = 1:N, delete(fullfile(Param.datadir, S(n).name)); end
        %Actualize task schedule and diskmap. When there aren't tables present with the
        %requested schema ID then there aren't entries in the task schedule or in the disk
        %map with that schema ID ...
        DBFileName = fullfile(Param.datadir, [mfilename, '.db']);
        if exist(DBFileName),
            try, load(DBFileName, 'DBSchedule', 'DBDiskMap', '-mat'); %Read variable DBSchedule and DBDiskMap in memory ...
            catch,
                ErrMsg = sprintf('''%s'' does not contain a valid database.', Param.datadir); 
                LogFile('add', ErrMsg); LogFile('close'); error(ErrMsg);
            end
            
            N = length(DBSchedule);
            for n = 1:N,
                idx = find(strcmpi(DBSchedule(n).schemaids, SchemaID));
                if isempty(idx), continue; end
                DBSchedule(n).processed      = logical(0);
                DBSchedule(n).iseqs(idx)     = [];
                DBSchedule(n).schemaids(idx) = [];
            end    
            idx = find(cellfun('isempty', {DBSchedule.iseqs})); DBSchedule(idx) = [];
            
            idx = find(ismember({DBDiskMap.schema}, lower(SchemaID)));
            DBDiskMap(idx) = [];
            
            save(DBFileName, 'DBSchedule', 'DBDiskMap', '-mat', '-append');
        end
        %Delete cachefile ...
        if exist(CacheFileName, 'file'), EmptyCacheFile(CacheFileName); end 
    else, 
        WarnMsg = sprintf('No database tables with schema ID ''%s'' present for ''%s''.', lower(SchemaID), Param.datadir);
        warning(WarnMsg); LogFile('add', WarnMsg);
    end
    LogFile('close');
end

%-----------------------------------------------------------------------------
function DB = ReadAliasDB(DirName)

persistent Mem;
if isempty(Mem),
    Mem.DB       = struct('aliasname', {}, 'fieldname', {});
    Mem.FileName = '';
    Mem.Date     = 0;
end

FileName = fullfile(DirName, [mfilename, '.aliasdb']);
if exist(FileName, 'file'), FileDate = datenum(getfield(dir(FileName), 'date'));
else, 
    DB = struct('aliasname', {}, 'fieldname', {});
    warning(sprintf('Alias database ''%s'' doesn''t exist.', FileName));
    return; 
end

%Check if alias database in memory is still up to date ...
if (FileDate > Mem.Date) | ~strcmpi(FileName, Mem.FileName),
    try, [ANames, FNames] = textread(FileName, '%s%s', 'commentstyle', 'matlab', 'endofline', sprintf('\n'));
    catch, 
        DB = struct('aliasname', {}, 'fieldname', {});
        warning(sprintf('Alias database ''%s'' doesn''t have the right format.', FileName)); 
        return;
    end
    
    %Check for duplicate aliases, and sort database according to alias name ...
    [dummy, idx] = unique(ANames);
    N = length(ANames); dupidx = setdiff(1:N, idx);
    if ~isempty(dupidx),
        warning(sprintf('Alias database ''%s'' has multiple entries for the aliases: %s.', FileName, ...
            cellstr2str(ANames(dupidx), ','))); 
    end    
    ANames = deblank(ANames(idx));
    FNames = deblank(FNames(idx));
    N = length(ANames);
    
    DB = repmat(struct('aliasname', '', 'fieldname', ''), N, 1);
    [DB.aliasname] = deal(ANames{:});
    [DB.fieldname] = deal(FNames{:});
    
    [Mem.DB, Mem.FileName, Mem.Date] = deal(DB, FileName, FileDate);
else, DB = Mem.DB; end

%-----------------------------------------------------------------------------
function T = SearchDataBase(Expr, Param)

%Parse expression using a recursive descent parser. The parse tree is returned
%as a structure ...
PTree = ParseLogicExpr(Expr);

%Reduce branches which contain no reference to a fieldname. The degrees of 
%freedom with commutative and associative operators are removed by ordering the
%nodes via a hashtable. Expand aliases on fieldnames ...
AliasDB = ReadAliasDB(Param.initdir); PTree = ReOrganizePTree(PTree, AliasDB, Param);

%Initialize parse tree evaluator(load table of known schema ID's into memory
%and initialize caching system) and evaluate tree ...
EvalPTree('init', Param); STrace = EvalPTree(PTree);

%Using search trace to return requested fields ...
T = RetrieveReqFields(STrace, Param);

%-----------------------------------------------------------------------------
function [Tree, Nfname, Nschemaid] = ReOrganizePTree(Tree, AliasDB, Param)
%The parse tree should be reorganized in the following ways:
%   1)Expand aliases on fieldnames in the parse tree and add default root branch
%     if necessary ...
%   2)Detect tree branches which lend themselve for fast evaluation ...
%   3)Sorting of parse tree in a fixed order ...
%   4)Reduce branches which contain no reference to a fieldname ...

if isempty(Tree.edges), %Leaf ...
    Nfname = strcmpi(Tree.type, 'fieldname'); %Check if leaf is a fieldname ...
    if Nfname, 
        %Expand aliases and add default root branch ...
        [Tree.value, FieldName, Suffix] = ExpandFieldName(Tree.value, AliasDB, Param.rootbranch);
        if strcmp(FieldName, 'ID.SchName'), %A little bit of semantics ...
            if ~isempty(Suffix), error(sprintf('A fieldname suffix can never be used on ''%s''.', FieldName));
            else, Nschemaid = 1; end
        else, Nschemaid = 0; end
    else, Nschemaid = 0; end
    Tree.fasteval = ~Nfname | Nschemaid;  %Add information on how to evaluate tree branches ...
    Tree.hash     = HashTreeBranch(Tree); %Add hash element to leaf (needed further on for sorting) ...
else, %Multiway nodes ...
    N = length(Tree.edges);
    for n = 1:N, [Edges(n), Nfname(n), Nschemaid(n)] = ReOrganizePTree(Tree.edges(n), AliasDB, Param); end %Use recursion ...
    Tree.edges = reshape(Edges, size(Tree.edges)); Nfname = sum(Nfname); Nschemaid = sum(Nschemaid);
    
    %Add extra information to the node on how to evaluate the tree branch originating from
    %this node and add hash element. Reduce branch of parse tree if it doesn't contain a leaf
    %with a fieldname ... 
    if ~Nfname & ~isempty(Tree.edges),
        Val = eval(PTree2Str(Tree)); %Using MATLAB interpreter ...
        if isnumeric(Val) & (length(Val) > 1), Type = 'matrix';
        elseif isnumeric(Val), Type = 'scalar'; 
        elseif iscell(Val), Type = 'cell'; end    
        Tree.value    = Val;
        Tree.type     = Type;
        Tree.edges    = struct([]);
        Tree.fasteval = logical(1);
        Tree.hash     = HashTreeBranch(Tree);
    else, 
        Tree.fasteval = (Nfname == Nschemaid);
        Tree.hash     = HashTreeBranch(Tree); 
    end
    
    %Sorting of parse tree in predefined order. The branches which can be evaluated
    %in a fast way should always come first if this can be arranged by the commutativity
    %and associativity of the operators. The degrees of freedom with commutative
    %and associative operators are removed by ordering the nodes via a hashtable ...
    if strcmpi(Tree.type, 'operator'),
        %Sort edges in alphabetical order for commutative operators. These
        %operators are the logical operators & and | ...
        if any(strcmpi(Tree.value, {'&', '|'})),
            %Classify edges according to fast evaluation feature ...
            N = length(Tree.edges); idx = find(cat(2, Tree.edges.fasteval) == 1);
            [FEedges, NFEedges] = deal(Tree.edges(idx), Tree.edges(setdiff(1:N, idx)));
            %And sort each group via the hash number ...
            [dummy, idx] = sort(cat(2, FEedges.hash)); FEedges = FEedges(idx);
            [dummy, idx] = sort(cat(2, NFEedges.hash)); NFEedges = NFEedges(idx);
            Tree.edges = [FEedges; NFEedges];
        %Sort edges in alphabetical order for other commutative operators. These
        %operators are  ==, ~=, +, *, .* ...
        elseif any(strcmpi(Tree.value, {'==', '~=', '+', '*', '.*'})),
            [dummy, idx] = sort(cat(2, Tree.edges.hash)); 
            Tree.edges = Tree.edges(idx);
        %Operators >=, <=, <, > can also be sorted ...
        elseif strcmpi(Tree.value, '>') & (diff(cat(2, Tree.edges.hash)) < 0),
            Tree.value = '<';
            [Tree.edges(1), Tree.edges(2)] = swap(Tree.edges(1), Tree.edges(2));
        elseif strcmpi(Tree.value, '<') & (diff(cat(2, Tree.edges.hash)) < 0),
            Tree.value = '>';
            [Tree.edges(1), Tree.edges(2)] = swap(Tree.edges(1), Tree.edges(2));
        elseif strcmpi(Tree.value, '>=') & (diff(cat(2, Tree.edges.hash)) < 0),
            Tree.value = '<=';
            [Tree.edges(1), Tree.edges(2)] = swap(Tree.edges(1), Tree.edges(2));
        elseif strcmpi(Tree.value, '<=') & (diff(cat(2, Tree.edges.hash)) < 0), 
            Tree.value = '>=';
            [Tree.edges(1), Tree.edges(2)] = swap(Tree.edges(1), Tree.edges(2));
        end
    end    
end

%-----------------------------------------------------------------------------
function [FullFieldName, FieldName, Suffix] = ExpandFieldName(FullFieldName, AliasDB, DefRootBranch)

[FieldName, Suffix] = ParseFieldName(FullFieldName);
%Expand aliases ...
idx = find(strcmpi({AliasDB.aliasname}, FieldName));
if ~isempty(idx),
    [FieldName, AliasSuffix] = ParseFieldName(AliasDB(idx).fieldname);
    if ~isempty(Suffix) & ~isempty(AliasSuffix), error('Fieldname suffix used with alias that has already a suffix in its expansion.');
    elseif ~isempty(AliasSuffix), Suffix = AliasSuffix; end
end
%Add default root branch. This is done after expanding aliases, so in the alias
%database the default root branch expansion can be used in specifying the fieldname
%associated with an alias ... 
Tokens = Words2Cell(FieldName, '.'); N = length(Tokens); boolean = logical(zeros(1, N));
for n = 1:N, boolean(n) = isvarname(Tokens{n}); end
if (N == 0) | ~all(boolean), error(sprintf('''%s'' is an invalid fieldname.', FullFieldName)); end
if ~any(strcmp(Tokens{1}, {'ID', 'Common', 'Specific'})), FieldName = cellstr2str([{DefRootBranch}, Tokens], '.'); end    
%Reassemble full fieldname ...
if ~isempty(Suffix), FullFieldName = [FieldName, '#', num2str(Suffix)]; 
else, FullFieldName = FieldName; end

%-----------------------------------------------------------------------------
function Hash = HashTreeBranch(PTree)

if isnumeric(PTree.value) | ischar(PTree.value),
    Hash = sum([double(PTree.value(:)); double(PTree.type(:))]);
elseif iscell(PTree.value), 
    Hash = cellfun('prodofsize', PTree.value);
    Hash = sum(Hash(:));
end    
if ~isempty(PTree.edges), HashNr = sum(cat(1, Hash, PTree.edges.hash)); end

%-----------------------------------------------------------------------------
function [FieldName, Suffix] = ParseFieldName(FieldName)

idx = strfind(FieldName, '#');
if isempty(idx), Suffix = '';
elseif (length(idx) > 1) | (idx == 1) | (idx == length(FieldName)), 
    error(sprintf('Invalid syntax for fieldname suffix in ''%s''.', FieldName));
else,     
    Suffix = FieldName(idx+1:end); FieldName = FieldName(1:idx-1); %Fieldnames are case-sensitive ...
    Idx = num2str(Suffix); if ~isempty(Idx) & (Idx > 0) & ~mod(Idx, 1), Suffix = Idx; end
    if ~isnumeric(Suffix) & ~isvarname(Suffix), 
        error(sprintf('''%s'' is not a valid fieldname suffix.', Suffix)); 
    end
end

%-----------------------------------------------------------------------------
function Str = PTree2Str(Tree)

if isempty(Tree.edges), %Leaf ...
    switch Tree.type
    case 'string', Str = sprintf('''%s''', Tree.value);
    case 'fieldname', Str = sprintf('$%s$', Tree.value);
    case 'scalar', Str = sprintf('%d', Tree.value);
    %Values of matrix or cell-array can already be calulated ...
    case 'matrix', Str = mat2str(Tree.value);
    case 'cell', Str = cell2str(Tree.value); end
else,
    switch Tree.type,
    case 'operator',
        N = length(Tree.edges);
        %Unary operators ...
        if any(strcmpi(Tree.value, {'.''', ''''})), 
            Str = ['(' PTree2Str(Tree.edges), ')', Tree.value];
        elseif any(strcmpi(Tree.value, {'+', '-', '~'})) & (N == 1),
            Str = [Tree.value, '(' PTree2Str(Tree.edges), ')'];
        %Other operators ...    
        else,
            Str = ['(' PTree2Str(Tree.edges(1)) ')'];
            for n = 2:N, Str = [Str, Tree.value, '(', PTree2Str(Tree.edges(n)), ')']; end 
        end
    case 'fnc/var',
        Str = Tree.value; N = length(Tree.edges);
        if (N > 0),
            Str = [Str, '(', PTree2Str(Tree.edges(1))];
            for n = 2:N, Str = [Str, ',', PTree2Str(Tree.edges(n))]; end    
            Str = [Str, ')'];
        end    
    case {'matrix', 'cell'},
        if strcmpi(Tree.type, 'matrix'), BgnSep = '['; EndSep = ']';
        else, BgnSep = '{';  EndSep = '}'; end
        [R, C] = size(Tree.edges); Str = BgnSep;
        for r = 1:R,
            Str = [Str, PTree2Str(Tree.edges(r, 1))];
            for c = 2:C, Str = [Str, ',', PTree2Str(Tree.edges(r, c))]; end    
            Str = [Str, ';'];
        end
        Str(end) = EndSep;
    end
end

%-----------------------------------------------------------------------------
function Str = cell2str(CA)

if isempty(CA), Str = '{}';
else,
    [R, C] = size(CA); Str = '{';
    for r = 1:R,
        Str = [Str, cellentry2str(CA(r, 1))];
        for c = 2:C, Str = [Str, ',', cellentry2str(CA(r, c))]; end
        Str = [Str, ';'];
    end
    Str(end) = '}';
end

%-----------------------------------------------------------------------------
function Str = cellentry2str(C)

switch class(C{1})
case 'char', Str = ['''', C{1}, ''''];
case 'double', Str = mat2str(C{1}); 
otherwise,
    error(sprintf('Cell-arrays with entries of type ''%s'' not supported in expressions.', class(C{1}))); 
end

%-----------------------------------------------------------------------------
function STrace = EvalPTree(varargin)

%Initialisation ...
persistent AlgoRithmType CacheFileName CacheNmax DBDate DiskMap DMFileName DMDate;
if ischar(varargin{1}) & strcmpi(varargin{1}, 'init'),
    Param = varargin{2};
    
    %Type of algorithm to use ...
    AlgoRithmType = Param.srchalgortm;
    
    %Initialize caching system. The cache file is saved in the same location as the
    %initialization files because the caching is closely related to the current status
    %of the database ...
    CacheFileName = fullfile(Param.datadir, [mfilename, '.cache']);
    CacheNmax     = Param.maxncache;
    
    %Get building date of database ...
    DBFileName = fullfile(Param.datadir, [mfilename, '.db']);
    if ~exist(DBFileName), error(sprintf('No database present in ''%s''.', Param.datadir));
    else, DBDate = datenum(getfield(dir(DBFileName), 'date')); end
    
    %Make memory map of disk information. Using this map in association with a memory
    %buffer for table chuncks doesn't increase performance, because in searching the
    %database different chuncks with the same schema ID need to be loaded and not only
    %the last chunck ...
    %Attention! Loading of this memory map takes a while and can seriously slow down
    %searching, especially when working over the network. Therefore the diskmap is stored
    %in a persistent variable and only loaded the first time during a MATLAB session,
    %when the database was changed or when another data directory is set by the user ...
    if isempty(DMDate) | ~strcmpi(DBFileName, DMFileName) | (DBDate > DMDate), %Persistent variable must be updated ...
        try, load(DBFileName, 'DBDiskMap', '-mat');
        catch, error(sprintf('''%s'' does not contain a valid database.', Param.datadir)); end
        %A database task schedule can be present without the database actually created ... 
        if isempty(DBDiskMap), error(sprintf('Database present in ''%s'' is empty.', Param.datadir)); end
        DiskMap = getfields(CreateDiskMap(DBDiskMap, Param.datadir), {'path', 'filename', 'schema', 'filenr', 'nentries', 'idx'});
        %Setting directory and date of map in memory ...
        [DMFileName, DMDate] = deal(DBFileName, DBDate);
    end
    return;
elseif (nargin == 2), [Tree, STraceIn] = deal(varargin{:}); 
else, Tree = varargin{1}; STraceIn = struct([]); end

%Evaluate logical operators on logical units of the parse tree, i.e. union, intersection
%and complement of search traces ...
ErrMsg = char('Invalid expression. Logical units must be relational expressions or function', ...
    'calls returning a boolean vector.');
if strcmpi(Tree.type, 'fnc/var'), 
    if ~isempty(STraceIn), STrace = LogicUnit2STrace(Tree, DiskMap, STraceIn);
    else, STrace = LogicUnit2STrace(Tree, DiskMap, CacheFileName, CacheNmax); end
elseif strcmpi(Tree.type, 'operator'),
    switch Tree.value
    case '&',
        if ~isempty(STraceIn),
            %Only activated when intersection is done via downsizing ...
            %Attention! This implementation is only possible because logical
            %and is associative and commutative, i.e. T1 & (T2 & T3) <=> T1 & T2 & T3
            %Attention! Checking for emptyness of search trace is not only done for
            %performance reasons but also to avoid the ambiguity that arises when
            %an empty search trace is part of an intersection and downsizing is used
            %to perform the intersection ...
            N = length(Tree.edges); STrace = STraceIn;
            for n = 1:N,
                STrace = EvalPTree(Tree.edges(n), STrace); 
                if isempty(STrace), break; end
            end
        elseif strcmpi(AlgoRithmType, 'fast'),
            %The caching is done for the tree branch at a whole and search trace
            %intersection is done by downsizing ...
            %Attention! Both search algorithms use the same cache file, but this
            %can't give problems because the key for retrieval of the data is
            %different. The cache for both algorithms is also entirely different,
            %the fast algorithm uses a non-updatable caching system whereas the
            %other has an updatable one ...
            Key = CollectInStruct(Tree, DBDate);
            STrace = FromCacheFile(CacheFileName, Key);
            if isempty(STrace),
                N = length(Tree.edges); STrace = struct([]);
                for n = 1:N, 
                    STrace = EvalPTree(Tree.edges(n), STrace); 
                    if isempty(STrace), break; end
                end
                %Always use direct storage for caching system, because different users
                %will be working with the same cache using mapped network drives. This
                %results in different paths for the cache entries ...
                ToCacheFile(CacheFileName, -CacheNmax, Key, STrace);
            end
        else,
            %The caching is done for each logical unit separatly and the logical operators
            %are performed explicitly on the search traces ... Attention! Checking for empty
            %search traces is only done for performance reason ...
            N = length(Tree.edges); STrace = EvalPTree(Tree.edges(1));
            if ~isempty(STrace),
                for n = 2:N,
                    STrace = STraceInterSect(STrace, EvalPTree(Tree.edges(n))); 
                    if isempty(STrace), break; end
                end
            end    
        end
    case '|',
        %Attention! This implementation is only possible because logical AND
        %is distributive for logical OR, i.e. T1 & (T2 | T3) <=> (T1 & T2) | (T1 & T3)
        N = length(Tree.edges); STrace = EvalPTree(Tree.edges(1), STraceIn);
        for n = 2:N, STrace = STraceUnion(STrace, EvalPTree(Tree.edges(n), STraceIn)); end
    case '~',
        %Attention! This implementation evaluates the expression T1 & ~T2 directly instead
        %of using the equivalent expression ~(~T1 | T2) because this last form doesn't
        %result in a faster evaluation ... 
        %Attention! T1 & ~T2 is not equivalent with ~(~T1 & T2) which would result in a
        %faster evaluation ...
        if ~isempty(STraceIn), STrace = STraceInterSect(STraceIn, STraceComplement(DiskMap, EvalPTree(Tree.edges)));
        else, STrace = STraceComplement(DiskMap, EvalPTree(Tree.edges)); end
    case {'==', '<', '>', '<=', '>=', '~='},
        if ~isempty(STraceIn), STrace = LogicUnit2STrace(Tree, DiskMap, STraceIn);
        else, STrace = LogicUnit2STrace(Tree, DiskMap, CacheFileName, CacheNmax); end
    otherwise, error(ErrMsg); end
else, error(ErrMsg); end    

%-----------------------------------------------------------------------------    
function STrace = STraceUnion(varargin)

STrace = cat(2, varargin{:}); FileNames = {STrace.filename}; N = length(FileNames);
[dummy, idx] = unique(FileNames); CommonFileNames = unique(FileNames(setdiff(1:N, idx)));
RemIdx = [];
for FN = CommonFileNames,
    idx = find(ismember(FileNames, FN));
    STrace(idx(1)).idx = unique(cat(2, STrace(idx).idx));
    RemIdx = [RemIdx, idx(2:end)];
end    
STrace(RemIdx) = [];

%-----------------------------------------------------------------------------
function STrace = STraceInterSect(varargin)

N = nargin; C = struct2cell(varargin{1});
for n = 2:N, 
    [dummy, idx1, idx2] = intersect(C(1, :), {varargin{n}.filename}); C = C(:, idx1);
    Nidx = length(idx1); for i = 1:Nidx, C{2, i} = intersect(C{2, i}, varargin{n}(idx2(i)).idx); end
end
C(:, find(cellfun('isempty', C(2, :)))) = [];
STrace = cell2struct(C, {'filename', 'idx', 'n'});

%-----------------------------------------------------------------------------
function STraceOut = STraceComplement(DiskMap, STraceIn)

STraceOut = struct('filename', {DiskMap.filename}, 'idx', {DiskMap.idx}, 'n', {DiskMap.nentries});
N = length(STraceOut); 
for n = 1:N,
    idx = find(ismember({STraceIn.filename}, STraceOut(n).filename));
    if ~isempty(idx), STraceOut(n).idx = setdiff(STraceOut(n).idx, STraceIn(idx).idx); end
end
STraceOut(find(cellfun('isempty', {STraceOut.idx}))) = [];

%-----------------------------------------------------------------------------
function STrace = LogicUnit2STrace(Tree, DiskMap, varargin)
%The logical unit translater allows for different kind of search time
%improvements which can be controlled by the type of input arguments ...

if Tree.fasteval,
    %Logical units that only contain references to ID.SchName can be evaluated in a
    %fast way. These units are never cached ...
    SchemaIDs = {DiskMap.schema}; N = length(SchemaIDs);
    idx = find(CheckIdx(EvalLogicUnit(Tree, SchemaIDs), N))';
    STrace = struct('filename', {DiskMap(idx).filename}, 'idx', {DiskMap(idx).idx}, 'n', {DiskMap(idx).nentries}); 
elseif (nargin == 4) & ischar(varargin{1}) & isnumeric(varargin{2}),
    %Caching is done on individual logical units. Only the indices for a given table
    %chunck are saved and if update was performed only add logical indices on new
    %part of the table. Attention! When removing a specific table from the database
    %the cache is also cleared in order to avoid problems in the following code ...
    CacheFileName = varargin{1}; CacheNmax = varargin{2};
    STrace = FromCacheFile(CacheFileName, Tree);
    N = length(DiskMap); Ndone = length(STrace);
    for n = 1:Ndone,
        idx = find(strcmpi({DiskMap.filename}, STrace(n).filename));
        if (DiskMap(idx).nentries > STrace(n).n),
            STrace(n).idx = [STrace(n).idx, STrace(n).n+find(CheckIdx(EvalLogicUnit(Tree, DiskMap(idx), (STrace(n).n+1):DiskMap(idx).nentries), DiskMap(idx).nentries-STrace(n).n))']; 
            STrace(n).n   = DiskMap(idx).nentries;
        end
    end
    if ~isempty(STrace), idx = find(~ismember({DiskMap.filename}, {STrace.filename}));
    else, idx = 1:N; end
    for n = 1:(N-Ndone),
        STrace(Ndone+n).filename = DiskMap(idx(n)).filename;
        STrace(Ndone+n).idx      = find(CheckIdx(EvalLogicUnit(Tree, DiskMap(idx(n)), 1:DiskMap(idx(n)).nentries), DiskMap(idx(n)).nentries))'; 
        STrace(Ndone+n).n        = DiskMap(idx(n)).nentries;
    end
    %Always use direct storage for caching system, because different users will be working
    %with the same cache using mapped network drives. This results in different paths for
    %the cache entries ...
    ToCacheFile(CacheFileName, -CacheNmax, Tree, STrace);
    %Removal of database chunks in searchtrace that have no indices must be done after saving
    %the trace to the cachefile ...
    STrace(find(cellfun('isempty', {STrace.idx}))) = [];
elseif (nargin == 3) & isstruct(varargin{1}) & ~isempty(varargin{1}),
    %The given search trace is reduced by the supplied logical unit. This eliminates
    %the need for search trace intersection (logical AND) and makes the search time
    %for logical units connected with and considerably shorter, but makes caching of 
    %individual units impossible ...
    STrace = varargin{1}; N = length(STrace);
    for n = 1:N, 
        idx = find(ismember({DiskMap.filename}, STrace(n).filename));
        STrace(n).idx = STrace(n).idx(find(CheckIdx(EvalLogicUnit(Tree, DiskMap(idx), STrace(n).idx), length(STrace(n).idx)))'); 
    end
    STrace(find(cellfun('isempty', {STrace.idx}))) = [];
else,
    %Translate logical unit to a search trace without caching ...
    N = length(DiskMap);
    for n = 1:N, 
        STrace(n).filename = DiskMap(n).filename;
        STrace(n).idx      = find(CheckIdx(EvalLogicUnit(Tree, DiskMap(n), 1:DiskMap(n).nentries), DiskMap(n).nentries))'; 
        STrace(n).n        = DiskMap(n).nentries;
    end
    STrace(find(cellfun('isempty', {STrace.idx}))) = [];
end

%-----------------------------------------------------------------------------
function idx = CheckIdx(idx, Nmax)

if ~isnumeric(idx) | (length(idx) ~= Nmax) | ~all(ismember(idx, [0, 1])),
    error('Invalid expression. Logical units should translate to a boolean vector.');
end

%-----------------------------------------------------------------------------
function Result = EvalLogicUnit(Tree, varargin)

%Checking input arguments ...
if (nargin == 2), SchemaIDs = varargin{1}; %Fast evaluation of tree branch ...
else, [DiskMapEntry, idx] = deal(varargin{:}); end

%Evaluating operators ...
if strcmpi(Tree.type, 'operator'),
    switch Tree.value
    %Relational and arithmetic operators ...
    case {'==', '<', '>', '<=', '>=', '~=', '+', '-', '*', '/', '^', '.*', './', '.^'},
        N = length(Tree.edges); Operands = cell(1, N);
        for n = 1:N, Operands{n} = EvalLogicUnit(Tree.edges(n), varargin{:}); end    
        Result = PerformOperator(Tree.value, Operands{:});
    %Logical operators are not allowed ...    
    case {'&', '|', '~'}, error('Invalid expression. Relational expressions connat contain logical operators.');
    otherwise, error(sprintf('Operator ''%s'' not supported on fieldnames.', Tree.value)); end
%Evaluating function calls ...    
elseif strcmpi(Tree.type, 'fnc/var'),
    N = length(Tree.edges); Args = cell(1, N);
    for n = 1:N, Args{n} = EvalLogicUnit(Tree.edges(n), varargin{:}); end    
    try, Result = feval(Tree.value, Args{:});
    catch, error(sprintf('Invalid syntax for function ''%s''.', Tree.value)); end
%Evaluating fieldnames ...
elseif strcmpi(Tree.type, 'fieldname'),
    if exist('SchemaIDs', 'var'), Result = SchemaIDs; %Fast evaluation, fieldname must be ID.SchName ...
    elseif strcmpi(Tree.value, 'ID.SchName'),
        NEntries = length(idx);
        Result = repmat({DiskMapEntry.schema}, NEntries, 1);
    else, 
        load(DiskMapEntry.path, '-mat'); %Load variable Table into memory ...
        Result = GetTableColumn(Table, Tree.value, idx);
    end
%Evaluating scalars and strings ...
elseif any(strcmpi(Tree.type, {'scalar', 'string'})), Result = Tree.value;
%Evaluating matrices and cells ...    
elseif any(strcmpi(Tree.type, {'matrix', 'cell'})),    
    if isempty(Tree.edges), Result = Tree.value; %Value already calulated while reducing parse tree ...
    else,
        [R, C] = size(Tree.edges); Result = [];
        for r = 1:R,
            TmpCol = [];
            for c = 1:C,
                TmpElem = EvalLogicUnit(Tree.edges(r, c), varargin{:});
                TmpCol = [TmpCol, TmpElem];
            end;
            Result = [Result; TmpCol];
        end;
    end
end

%-----------------------------------------------------------------------------
function Result = PerformOperator(Op, varargin)

Operands = varargin; N = length(varargin);

%Commutative and associative operators have multiway nodes ...
switch Op
case {'==', '~=', '+', '*', '.*'}, 
    Args = [repmat(' Operands{', N, 1), num2str((1:N)'), repmat('} ', N, 1)];
    Args = vectorzip(cellstr(Args), repmat({Op}, N, 1)); Args(end) = [];
    Result = eval(cat(2, Args{:}));
%Make distinction between binary and unary minus operator ...
case '-',
    if (N == 1), Result = eval('-Operands{1};'); %Unary minus ...
    else, Result = eval('Operands{1} - Operands{2};'); end
otherwise, Result = eval(sprintf('Operands{1} %s Operands{2};', Op)); end

%-----------------------------------------------------------------------------
function Col = GetTableColumn(Table, FieldName, Ridx)

[FieldName, Suffix] = ParseFieldName(FieldName);
[C, FNames] = destruct(Table);
N = length(Ridx);

Cidx = find(ismember(FNames, FieldName));
%If fieldname doesn't exist, a numerical columnvector with all NaN's is
%returned. If the logical unit has numerical operands, the result will
%be an all zero boolean vector. Attention! For a logical unit with cell-
%array of strings as operands this will result in an invalid logical
%expression ...
if isempty(Cidx), Col = repmat(NaN, N, 1); return; else, Tmp = C(Ridx, Cidx); end

%Numerical column ...
if all(cellfun('isclass', Tmp, 'double')),
    Col = repmat(NaN, size(Tmp));
    idx = find(cellfun('length', Tmp) == 1);
    Col(idx) = cat(2, Tmp{idx});
    if ~isempty(Suffix) & ischar(Suffix), 
        for idx = setdiff(1:N, idx), 
            try, Col(idx) = feval(Suffix, Tmp{idx}(:)); 
            catch, error(sprintf('Invalid fieldname suffix ''%s''.', Suffix)); end
        end
    elseif ~isempty(Suffix) & isnumeric(Suffix),
        for idx = setdiff(1:N, idx), 
            try, Col(idx) = Tmp{idx}(Suffix); end;
        end
    end
%Column with character strings or cell-array of strings ...    
else,
    Col = repmat({''}, size(Tmp));
    idx = find(cellfun('isclass', Tmp, 'char'));
    Col(idx) = Tmp(idx);
    if ~isempty(Suffix) & ischar(Suffix),
        for idx = setdiff(1:N, idx),
            try, Col(idx) = feval(Suffix, Tmp{idx}(:)); 
            catch, error(sprintf('Invalid fieldname suffix ''%s''.', Suffix)); end
        end
    elseif ~isempty(Suffix) & isnumeric(Suffix),
        for idx = setdiff(1:N, idx), 
            try, Col(idx) = Tmp{idx}(Suffix); end;
        end
    end
    if ~iscellstr(Col),
        error(sprintf('Entries of fieldname ''%s'' have unsupported type or the entries have different types.', FieldName));
    end
end

%-----------------------------------------------------------------------------
function T = RetrieveReqFields(STrace, Param)

%Allocate space ...
Nfields = length(Param.outfields); Nentries = cellfun('length', {STrace.idx});
C = repmat({''}, sum(Nentries), Nfields);

%Data directory ...
DirName = Param.datadir; if (DirName(end) ~= filesep), DirName = [DirName, filesep]; end

%Follow search trace ...
N = length(STrace);
for n = 1:N,
    load([DirName, STrace(n).filename], '-mat'); %Variable Table is created ...
    Sidx = sum(Nentries(1:n-1))+1; Eidx = Sidx+Nentries(n)-1;
    C(Sidx:Eidx, :) = ExtractFields(Table(STrace(n).idx), Param.outfields); 
end

%Reconstruct table ...
T = construct(C, Param.outfields);

%-----------------------------------------------------------------------------
function Cout = ExtractFields(Sin, ReqFNames)

[Cin, FNames] = destruct(Sin); Nentries = size(Cin, 1); Nfields = length(ReqFNames);
Cout = repmat({'N/A'}, Nentries, Nfields);
%Always return the fieldnames in the same order ...
for n = 1:Nfields,
    idx = find(strcmpi(FNames, ReqFNames{n}));
    if ~isempty(idx), Cout(:, n) = Cin(:, idx); end
end

%-----------------------------------------------------------------------------