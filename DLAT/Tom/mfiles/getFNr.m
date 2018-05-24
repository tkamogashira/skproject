function fnrs = getFNr(DataFiles, dsnrs)

% getFNr(DataFile, dataset)
% This function returns the fibre numbers for a vector of datasetnrs and 
% a one-dimensional cell array of corresponding datafile names
%
% TF 01/09/05

nd=numel(dsnrs);
fnrs = zeros(nd,1);

for i=1:nd
    ds=dataset(DataFiles{i}, dsnrs(i));
    fnrs(i)=ds.id.iCell;
end





