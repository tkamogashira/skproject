function [DataFile, Cell] = CheckMadisondsID(FileName, dsID, DataType)

%------------------------------------------------%
% Oorspronkelijk behorende bij het OSCOR-project %
%------------------------------------------------%

[DataFile, Cell] = deal([]);

%Parameters nagaan ..
if nargin ~= 3, error('Wrong number of input parameters'); end

DataFile = CheckMadisonDataFile(FileName);

TableObj = OpenTable(fullfile(DataFile.Path, [DataFile.FileName DataFile.TableExt]));

if ~ischar(DataType) | ~any(strcmpi(DataType, {'NSPL', 'NITD', 'OSCR', 'OSCRCTL', 'OSCRTD', 'BB'})), error('DataType should be ''NSPL'', ''NITD'', ''OSCR'', ''OSCRCTL'', ''OSCRTD'' or ''BB'''); end
DataType = upper(DataType);

switch class(dsID)
case 'char'    
    dsID = upper(dsID);
    [CellNr, TestNr] = unraveldsID(dsID);
case 'double'
    CellNr = dsID; TestNr = [];
    dsID = '';
otherwise
    error('Dataset can only be specified with dsID or CellNumber');
end

Record = GetRecord(TableObj, CellNr);
if isempty(Record), error(sprintf('<%d> doesn''t exist in %s', CellNr, FileName)); end

dsIDs = getfield(Record, 'dsIDs', DataType);
if isempty(dsIDs), error(sprintf('No %s for %s <%d>', DataType, FileName, CellNr)); end 

NElem = size(dsIDs, 2);
if (NElem > 1) & isempty(TestNr), error(sprintf('Multiple %s IDs for %s <%d>', DataType, FileName, CellNr)); 
elseif (NElem == 1) & isempty(TestNr)
    n = 1;
else
    Found = 0;
    for n = 1:NElem
        [CNr, TNr] = unraveldsID(dsIDs(n).dsID);
        if TestNr == TNr, Found = 1; break; end
    end
    if ~Found, error(sprintf('%s <%d-%d> doesn''t contain %s data or doesn''t exist', FileName, CellNr, TestNr, DataType)); end
end

Cell.dsID        = dsIDs(n).dsID;
[Dummy, TestNr]  = unraveldsID(Cell.dsID);
Cell.CellNr      = CellNr;
Cell.TestNr      = TestNr;
Cell.ExtraInfo   = dsIDs(n).ExtraInfo;
