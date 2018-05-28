function [ThrCurveParam, Localisation] = GetMadisonCellParam(DataFile, CellNr)

%------------------------------------------------%
% Oorspronkelijk behorende bij het OSCOR-project %
%------------------------------------------------%

[ThrCurveParam, Localisation] = deal([]);

%Parameters nagaan ...
if ~isstruct(DataFile) | ~isfield(DataFile, 'Path') | ~isfield(DataFile, 'FileName') | ...
   ~isfield(DataFile, 'FileExt') | ~isfield(DataFile, 'TableExt')
    error('First argument should be structure with fields Path, FileName, FileExt and TableExt');
end

if ~isnumeric(CellNr) | (ndims(CellNr) ~= 2) | (length(CellNr) ~= 1)
    error('Second argument should be cell number');
end

TableObj = OpenTable(fullfile(DataFile.Path, [DataFile.FileName DataFile.TableExt]));
Record   = GetRecord(TableObj, CellNr);

ThrCurveParam = Record.CellParam;
Localisation  = Record.Localisation;


