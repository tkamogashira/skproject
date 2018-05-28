mym('open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
mym('use ExpData');

[fileName, iCell, THRSeq] = ...
    mym('select FileName, iCell, THRSeq from UserData_CellCF');

for ii= 5000:length(iCell)
    if ~(isnan(iCell(ii) || isnan(fileName(ii))))
        if ~isnan(THRSeq(ii))
            try
                [CF, SR, minTHR, BW, Q10] = evalTHR(dataset(fileName{ii}, THRSeq(ii)), 'plot', 'no');
            catch
                minTHR = -1;
                Q10 = -1;
            end
        else % THRSeq(ii) is NaN
            try
                THR = getThr4DS(dataset(fileName{ii}, iCell(ii)));
                minTHR = THR.Thr;
                Q10 = THR.Q10;
            catch
                minTHR = -1;
                Q10 = -1;
            end
        end
        
        if isnan(Q10)
            Q10 = -1;
        end
        if isnan(minTHR)
            minTHR = -1;
        end
        
        mym('update UserData_CellCF set minTHR = {S}, Q10 = {S} where FileName = ''{S}'' and iCell = {S}', ...
            minTHR, Q10, fileName{ii}, iCell(ii));
    end
end
