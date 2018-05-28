function CellParam = LoadCellParam(DataFile, dsIDs, DirInfo)

for i = 1:length(dsIDs)
    dsID = dsIDs{i}; index = findstr(dsID, '-');
    CellNr = str2num(dsID(1:index(1)-1));
    if length(index) == 1, TestNr = str2num(dsID(index(1)+1:end));
    else TestNr = str2num(dsID(index(1)+1:index(2)-1)); end    
    DataFile = upper(DataFile);
    SParam = CollectInStruct(DataFile, CellNr, TestNr);
    Data   = FromCacheFile(DirInfo.TableFile, SParam);
    
    CellParam(i).CF = Data.CF;
    CellParam(i).CD = Data.CD;
    CellParam(i).SA = Data.SA;
end
