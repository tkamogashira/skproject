function CellList = GetMadisonCellList(DataFile, DataType)

CellList = cell(0);

TableObj = OpenTable(fullfile(DataFile.Path, [DataFile.FileName DataFile.TableExt]));

CellNrs = GetTableField(TableObj, 'CellNr'); CellNrs = cat(2, CellNrs{:});
NCells = length(CellNrs);
dsIDs   = GetTableField(TableObj, ['dsIDs.' DataType]);

for C = 1:NCells
    if isempty(dsIDs{C}), continue; end
    NTests = length(dsIDs{C});
    for T = 1:NTests
        [Dummy, TestNr] = unraveldsID(dsIDs{C}(T).dsID);
        CellList = cat(2, CellList,{ sprintf('%d-%d', CellNrs(C), TestNr) });
    end
end    
