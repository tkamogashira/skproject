function TableObject = OpenTable(FileName, ExtraHeaderItems, KeyField, varargin)
%OPENTABLE   open or create a table object
%   TableObject = OPENTABLE(FileName, {ExtraHeaderItems, KeyField, FieldNames...})
%   Input parameters
%   FileName         : name of file where the data is stored on disk. If no path is specified, the current working
%                      working directory is assumed. The default extension is .table.
%   ExtraHeaderItems : structure containing extra items that distinguish this table object
%   KeyField         : name of field that uniquely identifies a record
%   FieldNames       : comma separated list of names of fields in a record
%   Creation of table objects can only be done of all parameters are given, afterwards only the filename can be
%   given. If the table object already exists on disk the data is read from disk and stored in memory. 
%
%   Output parameters
%   TableObject      : datatype containing all the necessary information of the table, including all records.
%
%   See also WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

TableObject = struct([]);

ID      = 'ListFile';
Version = 1;

%Argumenten nagaan ...
if any(nargin == [0,2,3]), error('Wrong number of input arguments'); 
elseif nargin == 1, ExtraHeaderItems = struct([]); KeyField = ''; end

[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path), Path = pwd; end
if isempty(FileExt), FileExt = '.table'; end
if isempty(FileName), error('A valid filename should be given as the first argument'); end

if ~isa(ExtraHeaderItems, 'struct'), error('Extra header items for table object should be given as a struct'); end
if isfield(ExtraHeaderItems, 'ID') | isfield(ExtraHeaderItems, 'Version') | ...
   isfield(ExtraHeaderItems, 'Path') | isfield(ExtraHeaderItems, 'FullFileName') | ...
   isfield(ExtraHeaderItems, 'KeyField') | isfield(ExtraHeaderItems, 'NItems')
    error('Struct to specify additional header items cannot contain ID, Version, KeyField, NItems, Path or FullFileName as fieldnames');
end

if ~ischar(KeyField), error('KeyField should be fieldname that uniquely identifies record in a table'); end

if ~isempty(varargin)
    if (length(varargin) == 1) & isa(varargin{1}, 'struct')
        RecordLayout = struct(varargin{1});
    elseif iscellstr(varargin)
        RecordLayout = VectorZip(varargin, repmat({[]}, 1, length(varargin)));
        RecordLayout = struct(RecordLayout{:});
    else
        error('Fields of record should be given as a comma separated list of fieldnames or as a struct');
    end
    
    if ~isfield(RecordLayout, KeyField), error('KeyField is not a valid fieldname'); end
else
    RecordLayout = struct([]);
end    

%Nagaan of ListObject reeds op schijf bestaat ...
if exist(fullfile(Path,[FileName FileExt]), 'file')
    try
        load(fullfile(Path,[FileName FileExt]), 'Header', 'Data', '-mat');
    catch
        error(['Could not open ' fullfile(Path,[FileName FileExt])]);
    end
    
    if ~isempty(RecordLayout)
        if (Header.ID ~= ID) | (Header.Version ~= Version) | ~strcmp(Header.KeyField, KeyField), error([fullfile(Path,[FileName FileExt]) ' is not a valid file']);end
        FNames  = fieldnames(ExtraHeaderItems);
        NFields = length(FNames);
        for FieldNr = 1:NFields
            Value = getfield(ExtraHeaderItems, FNames{FieldNr});
            if ~isfield(Header, FNames{FieldNr}) | (Value ~= getfield(Header, FNames{FieldNr})), error([fullfile(Path,[FileName FileExt]) ' is not a valid file']); end
        end    
            
        if ~compfields(Data, RecordLayout), error(['Layout of record given differs from records in ' fullfile(Path,[FileName FileExt])]); end
    else %Indien geen argumenten meegegeven ...
        if (Header.ID ~= ID) | (Header.Version ~= Version), error([fullfile(Path,[FileName FileExt]) ' is not a valid file']); end
    end    
else    
    if isempty(RecordLayout), error('If table object is created for the first time, the field specification of a record should be given.'); end
    NItems = 0;
    
    Header = CollectInStruct(ID, Version, KeyField, NItems);
    Header = structcat(Header, ExtraHeaderItems);
    
    Data = RecordLayout;
end 

%ListObject samenstellen ...
Header = setfield(Header, 'Path', Path);
Header = setfield(Header, 'FullFileName', [FileName FileExt]);

TableObject = CollectInstruct(Header, Data);
