function S = XLS2Struct(varargin)
%XLS2STRUCT convert Excel spreadsheet to structure-array.
%   S = XLS2STRUCT('FOO.XLS') converts the Excel spreadsheet FOO.XLS to the
%   structure-array S.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 21-05-2005

%------------------------------default parameters---------------------------
%The sheet to be converted from the spreadsheet. The empty string designates
%the first sheet in the spreadsheet ...
DefParam.sheetname         = ''; 
%Remove the cells containing alphanumeric information in a column which 
%contains more numerical than alphanumerical cells ...
DefParam.rmalphanum        = 'y';
%The numeric value used for replacing empty cells in a dominantly numerical
%column ...
DefParam.emptynumeric      = NaN;
%The character string used for replacing empty cells in a dominantly alpha-
%numerical column ...
DefParam.emptyalphanum     = '';

%--------------------------------main program-------------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
end
if (nargin == 0), error('Wrong number of input arguments.'); end

if ~ischar(varargin{1}), error('First argument should be the name of the spreadsheet to convert.'); end
[Path, FileName, FileExt] = fileparts(lower(varargin{1}));
if isempty(FileName), error('First argument should be the name of the spreadsheet to convert.'); end
if isempty(Path), Path = pwd; end
if isempty(FileExt), FileExt = '.xls'; end
FullFileName = fullfile(Path, [FileName, FileExt]);
if ~exist(FullFileName, 'file'), error(sprintf('''%s'' doesn''t exist.', FullFileName)); end
[Status, SheetNames] = xlsfinfo(FullFileName);
if isempty(Status), error(sprintf('''%s'' is not a valid Excel spreadsheet.', FullFileName)); end

Param = checkproplist(DefParam, varargin{2:end});
if ~ischar(Param.sheetname), error('Property sheetname must have a character string as value.');
elseif isempty(Param.sheetname), Param.sheetname = SheetNames{1};
elseif ~ismember(Param.sheetname, SheetNames),
    error(sprintf('Sheet with name ''%s'' is not present in ''%s''.', FullFileName, Param.sheetname));
end
if ~ischar(Param.rmalphanum) | ~strncmpi(Param.rmalphanum, {'y', 'n'}, 1),
    error('Value for property rmalphanum must be ''y'' or ''n''.');
end

%Peforming actual conversion ...
[NumData, TextData] = xlsread(FullFileName, Param.sheetname);

%Extract header names ...
if ~all(cellfun('isclass', TextData(1, :), 'char')), 
    error('First row of spreadsheet must contain header names.');
else, FieldNames = TextData(1, :); TextData(1, :) = []; end
NFields = length(FieldNames);
for n = 1:NFields, if ~isvarname(FieldNames{n}), 
        error('One of the header names is not a MATLAB variable name.'); 
end; end

if isempty(TextData), %All numerical data ...
    %Every NaN in the spreadsheet can be interpreted as an empty cell and
    %all columns are dominantly numerical ...
    idxEmpty = find(isnan(NumData)); Data = num2cell(NumData);
    if ~isempty(idxEmpty), [Data{idxEmpty}] = deal(Param.emptynumeric); end   
    S = cell2struct(Data, FieldNames, 2);
else,
    %Make sure the size of numerical and alphanumerical data matches ...
    [NRow, NCol] = size(NumData); [NRowText, NColText] = size(TextData);
    if (NRow ~= NRowText), error('Invalid format of spreadsheet.'); end
    if (NCol < NColText), NumData = [repmat(NaN, NRow, NColText-NCol), NumData]; 
    elseif (NCol > NColText), TextData = [repmat({[]}, NRow, NCol-NColText), TextData]; end
    
    %Deal with empty cells in the Excel spreadsheet. Empty cells are noticeable
    %because they are both NaN in the numerical data section and the empty matrix
    %in the textual data section ...
    idxEmpty = intersect(find(isnan(NumData)), find(cellfun('isempty', TextData))); 

    %Interleave alphanumeric and numeric data ...
    idx = setdiff(find(cellfun('isclass', TextData, 'double')), idxEmpty);
    Data = TextData; Data(idx) = num2cell(denan(NumData));
    
    %NaN is converted to the character string 'NaN' by XLSREAD. Occurences of the
    %character string 'NaN' or 'nan' are converted to the numerical value NaN. This
    %must be done before interpreting empty cells ...
    idxChar = find(cellfun('isclass', Data, 'char'));
    idxNaN = idxChar(find(ismember(Data(idxChar), {'NaN', 'nan'})));
    if ~isempty(idxNaN), Data{idxNaN} = NaN; end
    
    %If requested, cells containing alphanumerical information in columns with
    %dominantly numerical cells should be made empty. Thereafter, empty cells
    %must be given the right type in the MATLAB structure-array, depending
    %on the dominant type of the column in which the empty cell is located ...
    NCol = size(Data, 2);
    for ColNr = 1:NCol,
        idxEmpty = find(cellfun('isempty', Data(:, ColNr)));
        idxChar = find(cellfun('isclass', Data(:, ColNr), 'char')); 
        idxDouble = find(cellfun('isclass', Data(:, ColNr), 'double'));
        
        Nchar = length(idxChar); Ndouble = length(idxDouble)-length(idxEmpty);
        if (Nchar <= Ndouble),
            if strncmpi(Param.rmalphanum, 'y', 1), idxEmpty = union(idxEmpty, idxChar); end
            if ~isempty(idxEmpty), [Data{idxEmpty, ColNr}] = deal(Param.emptynumeric); end
        elseif ~isempty(idxEmpty), [Data{idxEmpty, ColNr}] = deal(Param.emptyalphanum); end
    end

    S = cell2struct(Data, FieldNames, 2);
end