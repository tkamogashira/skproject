function [ErrText, Cell] = GetCellInfo(Param, DataFile, StimType, DirInfo)
%GETCELLINFO    gets cell information out of tablefile.
%   [ErrText, Cell] = GETCELLINFO(Param, DataFile, StimType, DirInfo)

ErrText = []; Cell = [];

switch upper(class(Param))
case 'CHAR'
    dsID = Param;
    switch ExistID(DataFile, dsID, StimType, DirInfo)
    case 1    
        ErrText = [DataFile ' <' dsID '> doesn''t exist.'];
        return
    case 2    
        ErrText = ['No ' StimType '-data for ' DataFile ' <' dsID '>.'];
        return
    end
    n = findstr(dsID,'-');
    CellNr = str2num(dsID(1:n(1)-1));
    TestNr = str2num(dsID(n(1)+1:end));
case 'DOUBLE'
    CellNr = Param;
    [ErrText, dsID] = GetID(DataFile, CellNr, StimType, DirInfo);
    if ~isempty(ErrText), return; end
    n = findstr(dsID, '-');
    TestNr = str2num(dsID(n(1)+1:end));
otherwise
    ErrText = 'Cell must be given by its cell number or its dsID.';
    return
end
Cell = CollectInStruct(dsID, CellNr, TestNr);
