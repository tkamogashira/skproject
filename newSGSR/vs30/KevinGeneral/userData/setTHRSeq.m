function setTHRSeq( filename, iCell, thrSeqNr )
%SETTHRSEQ Set the THR sequence for a given cell in the userdata
%   Usage: setTHRSeq( filename, iCell, thrSeqNr )
%   Parameters:  filename: The experiment being changed
%                iCell: The cell number
%                thrSeqNr: Which sequence contains the correct THR data?
%   Example: setTHRSeq('a0242', 93, 377)

if mym(10,'status')
    mym(10,'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
    mym(10,'use ExpData');
end


mym(10,'start transaction;');
try
    existing = mym(10, ['SELECT CF FROM UserData_CellCF WHERE FileName="' filename '" AND iCell=' num2str(iCell) ';']);
    
    % set THR in database
    if isempty(existing)
        CFQuery = ['INSERT INTO UserData_CellCF (FileName, iCell, THRSeq, CF, SR, ManuallyAdjusted) VALUES ("' filename '", ' num2str(iCell) ', ' num2str(thrSeqNr) ', NULL, NULL, 1);']
    else
        CFQuery = ['UPDATE UserData_CellCF SET THRSeq=' num2str(thrSeqNr) ', CF=NULL, SR=NULL, ManuallyAdjusted=1 WHERE FileName="' filename '" AND iCell=' num2str(iCell)];
    end
    CFQuery = strrep(CFQuery, 'NaN', 'NULL');
    mym(10,CFQuery);
    % set CF
    ignoreUserData = 1;
    THR = getThr4Cell(filename, iCell, ignoreUserData, thrSeqNr);
    CF = THR.CF;
    SR = THR.SR;
    CFQuery = ['UPDATE UserData_CellCF SET CF = ' num2str(CF) ', SR = ' num2str(SR) ' WHERE FileName="' filename '" AND iCell=' num2str(iCell)];
    CFQuery = strrep(CFQuery, 'NaN', 'NULL');
    mym(10,CFQuery);
    mym(10,'commit;');
catch
    mym(10,'rollback;');
    error(lasterr);
end