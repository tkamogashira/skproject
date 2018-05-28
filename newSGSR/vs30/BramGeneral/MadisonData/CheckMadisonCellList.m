function CellList = CheckMadisonCellList(DataFile, CellList, DataType)

NCells = length(CellList);

for Nr = 1:NCells
    [Dummy, CellList] = CheckMadisondsID(fullfile(DataFile.Path, [DataFile.FileName DataFile.TableExt]), CellList{Nr}, DataType);
    if isnumeric(CellList{Nr}), CellList{Nr} = sprintf('%d-%d', Cell.CellNr, Cell.TestNr); end
end    