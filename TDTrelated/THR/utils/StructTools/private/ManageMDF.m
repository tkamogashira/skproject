function ArgOut = ManageMDF(varargin)
%MANAGEMDF   manage datafile with merged datasets
%   MANAGEMDF(DFName, 'add', DS)
%   DS = MANAGEMDF(DFName, 'get', SeqID)
%   DS = MANAGEMDF(DFName, 'get', SeqNr)
%   MANAGEMDF(DFName, 'rm', SeqID)
%   MANAGEMDF(DFName, 'rm', SeqNr)
%   LUT = MANAGEMDF(DFName, 'list')
%   MANAGEMDF(DS1, SubSeqs1, DS2, SubSeqs2, ..., DSN, SubSeqsN)
%   MANAGEMDF(DS1, DS2, ..., DSN)
%
%   See also MERGEDS, MDF2LUT and ISMDF

%B. Van de Sande 07-04-2004

%--------------------------------------------------------------------------
%Parsing input arguments ...
[FullFileName, Mode, Data] = ParseArgs(varargin{:});

%Performing actual operations on a datafile ...
if strcmpi(Mode, 'add'), AddEntry(FullFileName, Data);   
elseif strcmpi(Mode, 'rm'), RmEntry(FullFileName, Data); 
elseif strcmpi(Mode, 'get'), ArgOut = GetEntry(FullFileName, Data); 
else, 
    if (nargout > 0), ArgOut = GetEntries(FullFileName);
    else, 
        LUT = getfields(GetEntries(FullFileName), {'iSeq', 'IDstr'});
        if ~isempty(LUT), disp(cv2str(LUT));
        else, disp('Datafile is empty.'); end    
    end
end

%-----------------------------local functions------------------------------
function [FullFileName, Mode, Data] = ParseArgs(varargin)

if (nargin > 0) & ischar(varargin{1}),
    FullFileName = ParseFileName(varargin{1});
    if ~any(nargin == [2, 3]), error('Wrong number of input arguments.');
    elseif ~ischar(varargin{2}) | ~any(strcmpi(varargin{2}, {'add', 'rm', 'get', 'list'})),
        error(sprintf('Unknown operation ''%s''for a MDF datafile.', varargin{2}));
    end
    Mode = varargin{2};
    if (nargin == 2) & strcmpi(Mode, 'list'), Data = [];
    elseif (nargin == 3) & strcmpi(Mode, 'add') & isa(varargin{3}, 'dataset'), Data = varargin{3};
    elseif (nargin == 3) & any(strcmpi(Mode, {'rm', 'get'})) & (isnumeric(varargin{3}) | ischar(varargin{3})),
        Data = varargin{3};
    else, error('Wrong input arguments.'); end    
elseif (nargin > 0) & isa(varargin{1}, 'dataset'),
    FullFileName = ParseFileName([varargin{1}.FileName '-MERGE']);
    Mode = 'add';
    iSeq = GetLastSeqNr(FullFileName) + 1;
    Data = mergeds(varargin{:}, 'iseq', iSeq);
else, error('Syntax error.'); end    

%--------------------------------------------------------------------------
function FullFileName = ParseFileName(FName)

[Path, FileName, FileExt] = fileparts(FName);
if isempty(Path), Path = datadir; end
if isempty(FileName), error('Invalid datafile name.'); end
if strcmpi(FileExt, '.LOG') | isempty(FileExt), FileExt = '.MDF'; end
FullFileName = fullfile(Path, [FileName, FileExt]);

%--------------------------------------------------------------------------
function Directory = GetDirectory(FileName, MkDF)

if ~exist(FileName), 
    Directory = struct('dsID', [], 'FulldsID', [], 'HashNr', []);
    Directory(1) = [];
    if MkDF, 
        save(FileName, 'Directory', '-mat'); 
        CreateLogFile(FileName);
    end
else,
    try load(FileName, 'Directory', '-mat');
    catch error(sprintf('''%s'' is not a valid MDF filename.')); end
end

%--------------------------------------------------------------------------
function CreateLogFile(FileName)

[Path, FileName] = fileparts(FileName);
FullFileName = fullfile(Path, [FileName, '.LOG']);
fclose(fopen(FullFileName, 'wt+'));

%--------------------------------------------------------------------------
function SeqNr = GetLastSeqNr(FileName)

Directory = GetDirectory(FileName, 0);
SeqNr = length(Directory);

%--------------------------------------------------------------------------
function AddEntry(FileName, DataSet)

Directory = GetDirectory(FileName, 1);

[CellNr, TestNr] = UnRaveldsID(DataSet.SeqID); 
dsID = sprintf('%d-%d', CellNr, TestNr); FulldsID = DataSet.SeqID;

dsIDs = {Directory.dsID};
if any(strcmpi(dsID, dsIDs)), error('Dataset with same sequence ID is already in the datafile.'); end

%Simple hash function. There will never be collision because the combination of a cell-
%number and a testnumber must uniquely identify an entry in the datafile ...
HashNr = sum(double(dsID)); 

DirEntry = CollectInStruct(dsID, FulldsID, HashNr);
Directory = [Directory, DirEntry];

VarName = sprintf('Entry%d', HashNr);
eval(sprintf('%s = DataSet;', VarName));
eval(sprintf('save(FileName, ''Directory'', ''%s'', ''-mat'', ''-append'');', VarName));

%--------------------------------------------------------------------------
function DataSet = GetEntry(FileName, EntryInfo)

Directory = GetDirectory(FileName, 0);
if isempty(Directory), error('Datafile is empty.'); end

if ischar(EntryInfo),
    dsID = EntryInfo; iSeq = strfindcell({Directory.dsID}, dsID);
    if isempty(iSeq) | (length(iSeq) > 1), 
        error(sprintf('Dataset with ID ''%s'' is not in the datafile.', dsID)); 
    else, VarName = sprintf('Entry%d', Directory(iSeq).HashNr); end
else,
    iSeq = EntryInfo;
    if (iSeq > GetLastSeqNr(FileName)), 
        error(sprintf('Sequence number %d is not present in datafile.', iSeq)); 
    else, VarName = sprintf('Entry%d', Directory(iSeq).HashNr); end
end    

load(FileName, VarName, '-mat');
eval(sprintf('DataSet = %s;', VarName));

%--------------------------------------------------------------------------
function RmEntry(FileName, EntryInfo)

Directory = GetDirectory(FileName, 0);

if ischar(EntryInfo),
    dsID = EntryInfo; iSeq = strfindcell({Directory.dsID}, dsID);
    if isempty(iSeq) | (length(iSeq) > 1), 
        error(sprintf('Dataset with ID ''%s'' is not in the datafile.', dsID)); 
    end
else,
    iSeq = EntryInfo;
    if (iSeq > GetLastSeqNr(FileName)), 
        error(sprintf('Sequence number %d is not present in datafile.', iSeq)); 
    end
end    

VarName = sprintf('Entry%d', Directory(iSeq).HashNr);
eval(sprintf('%s = [];', VarName));

Directory(iSeq) = [];
eval(sprintf('save(FileName, ''Directory'', ''%s'', ''-mat'', ''-append'');', VarName));

%--------------------------------------------------------------------------
function LUT = GetEntries(FileName)

LUT = struct('iSeq', [], 'iSeqStr', [], 'IDstr', []);

Directory = GetDirectory(FileName, 0); NEntries = length(Directory);
if (NEntries > 0),
    LUT = repmat(LUT, 1, NEntries);
    iSeq = num2cell(1:NEntries); [LUT.iSeq] = deal(iSeq{:});
    iSeqStr = cellstr(num2str((1:NEntries)')); [LUT.iSeqStr] = deal(iSeqStr{:});
    [LUT.IDstr] = deal(Directory.FulldsID);
else, LUT(1) = []; end    

%--------------------------------------------------------------------------