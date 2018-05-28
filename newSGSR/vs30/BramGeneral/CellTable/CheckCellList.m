function [ErrText, CellsCellArray] = CheckCellList(DataFile, CellsCellArray, StimType, DirInfo);
%CHECKCELLLIST  checks a cellarray containing dsIDs/CellNrs
%   [ErrText, CellList] = CHECKCELLARRAY(DataFile, CellList, StimType, DirInfo)

ErrText = [];

for i = 1:length(CellsCellArray)
    switch upper(class(CellsCellArray{i}))
    case 'CHAR'
        dsID = CellsCellArray{i};
        Err = ExistID(DataFile, dsID, StimType, DirInfo);
        switch Err
        case 1
            ErrText = [ '<' dsID '> doesn''t exist in ' DataFile '.'];
            break;
        case 2
            ErrText = [ 'No ' StimType '-data present for ' DataFile ' <' int2str(dsIDs) '>.'];
            break;
        end    
    case 'DOUBLE'
        [ErrText, dsID] = GetID(DataFile, CellsCellArray{i}, StimType, DirInfo);
        if isempty(ErrText)
            CellsCellArray{i} = dsID;
        else
            break;
        end    
    otherwise
        ErrText = 'CellArray of Cells should only contain variabeles of type char or double.';
        break;
    end
end
