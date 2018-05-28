function [CellNr, TestNr, DataType, ExtraInfo] = ConvMadisonOrgdsID(DataFile, OrgdsID)

[CellNr, TestNr, DataType, ExtraInfo] = deal([]);

%Parameters nagaan ...
if ~isstruct(DataFile) | ~isfield(DataFile, 'Path') | ~isfield(DataFile, 'FileName') | ...
   ~isfield(DataFile, 'FileExt') | ~isfield(DataFile, 'TableExt')
    error('First argument should be structure with fields Path, FileName, FileExt and TableExt');
end

if ~ischar(OrgdsID), error('Second argument should be original dataset ID.'); end

ConvObj = OpenTable(fullfile(DataFile.Path, [DataFile.FileName DataFile.ConvExt]));
Record   = GetRecord(ConvObj, OrgdsID);

if ~isempty(Record),
    CellNr = Record.CellNr;
    TestNr = Record.TestNr;
    DataType = Record.StimType;
    ExtraInfo = Record.ExtraInfo;
end