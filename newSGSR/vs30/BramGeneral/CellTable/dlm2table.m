function dlm2table(DLMFile)
%DLM2TABLE  convert TAB-delimited text-conversion of an Excel spreadsheet to MATLAB table and index file.
%   DLM2TABLE(DLMFile)
%   Input parameter:
%   DlmFile : text file, this should be TAB-delimited text-conversion of Excel spreadsheet.
%   Output: MAT-files with same name as DLMFile and extensions .table and .index. These files are located 
%   in the same directory as the TAB-delimited textfile. 

CR    = char(13);
TAB   = char(9);
SPACE = char(32);

%Check input parameters ...
if nargin ~= 1, error('Wrong number of input parameters.'); end

[DLMPath, DLMFileName, DLMExt] = fileparts(DLMFile);
if isempty(DLMPath), DLMPath = pwd; end
if isempty(DLMExt), DLMExt = '.txt'; end
if isempty(DLMFileName), error('Argument should be name of TAB-delimited text file to convert.'); end

DLMFile = fullfile(DLMPath, [DLMFileName DLMExt]);
TABLEFile = fullfile(DLMPath, [DLMFileName '.table']);
INDEXFile = fullfile(DLMPath, [DLMFileName '.index']);

[DataFile, CellNr, TestNr, StimType, CF, SA] = textread(DLMFile,'\n%s%d%d%s%f%f', 'headerlines', 1, 'delimiter', TAB, 'endofline', CR, 'whitespace', SPACE, 'emptyvalue', NaN, 'commentstyle', 'matlab');
CD = greenwood(CF); %Greenwood-formula for cochlear distance ...

N = length(DataFile);

[dummy, i] = unique([char(DataFile) int2str(CellNr) int2str(TestNr)], 'rows');
if ~all(ismember(1:N, i)), warning('Duplicate entries present.'); end

[dummy, i] = sortrows([char(DataFile) int2str(CellNr)]);
[DataFile, CellNr, TestNr, StimType, CF, CD, SA] = deal(DataFile(i), CellNr(i), TestNr(i), StimType(i), CF(i), CD(i), SA(i));

DirectStorage = logical(1);
Pars = localStructArray2Cell(struct('DataFile', DataFile, 'CellNr', num2cell(CellNr), 'TestNr', num2cell(TestNr)));
Data = localStructArray2Cell(struct('StimType', StimType, 'CF', num2cell(CF), 'CD', num2cell(CD), 'SA', num2cell(SA)));
save(TABLEFile, 'DirectStorage', 'N', 'Pars', 'Data');

[dummy, idx] = unique([char(DataFile) int2str(CellNr)], 'rows');
[DataFile, CellNr] = deal(DataFile(idx), CellNr(idx));
NTestNrs = [idx(1); diff(idx)];
for n = 1:length(idx), TestNrs{n} = TestNr(idx(n)-NTestNrs(n)+1:idx(n)); end

N = length(DataFile);
Pars = localStructArray2Cell(struct('DataFile', DataFile, 'CellNr', num2cell(CellNr)));
Data = TestNrs;
save(INDEXFile, 'DirectStorage', 'N', 'Pars', 'Data');

%-----------------locals---------------------
function c = localStructArray2Cell(s)

for i = 1:prod(size(s)), c{i} = s(i); end
