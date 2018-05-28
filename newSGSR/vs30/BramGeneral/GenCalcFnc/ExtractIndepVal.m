function [IndepVal, ConstIndepNr, ConstVal] = ExtractIndepVal(ds, iSubSeqs)
%EXTRACTINDEPVAL    extract values of the independent variable of a dataset
%   IndepVal = EXTRACTINDEPVAL(DS, iSubSeqs) extracts values of the independent
%   variable of the dataset DS. If the dataset has multiple independent variables
%   and the included subsequences list represents a one-dimensional restriction
%   then only the values of the varying variable are returned. Otherwise for a 
%   dataset with multiple independent variables only the index of the subsequences
%   is returned.
%
%   [IndepVal, ConstIndepNr, ConstVal] = EXTRACTINDEPVAL(DS, iSubSeqs) also returns
%   the number and th value of the independent variable that is held constant in a 
%   one-dimensional restriction of a multi-variate dataset. In all other cases NaN
%   is returned.

%B. Van de Sande 25-03-2004

[ConstIndepNr, ConstVal] = deal(NaN);

if strcmpi(ds.fileformat, 'EDF') && (ds.indepnr == 2)
    [X, Y] = deal(ds.xval(iSubSeqs)', ds.yval(iSubSeqs)');
    NX = length(unique(X)); 
    NY = length(unique(Y));
    if all([NX, NY] == 1)
        IndepVal = iSubSeqs(:)';
    elseif (NX == 1)
        IndepVal = Y; 
        ConstIndepNr = 1; 
        ConstVal = unique(X);
    elseif (NY == 1)
        IndepVal = X; 
        ConstIndepNr = 2; 
        ConstVal = unique(Y);
    else
        IndepVal = iSubSeqs(:)'; 
    end
else
    IndepVal = ds.indepval(iSubSeqs)'; 
end