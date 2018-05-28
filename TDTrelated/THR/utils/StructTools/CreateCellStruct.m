function CellStruct = CreateCellStruct(dsID)

Cellstruct = struct([]);

if ischar(dsID)
    [CellNr, TestNr] = unraveldsID(dsID);
    CellStruct = CollectInstruct(dsID, CellNr, TestNr);
elseif iscellstr(dsID)
    for n = 1:length(dsID)
        CellStruct(n) = CreateCellStruct(dsID{n});
    end
end
