function [ds, ErrTxt] = LoadRAPDataset(RAPStat)
%LoadRAPDataset loads dataset currently specified by RAP status structure
%   [ds, ErrTxt] = LoadRAPDataset(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 17-10-2003

ds = [];
ErrTxt = '';

DataFile = RAPStat.GenParam.DataFile;
if isempty(DataFile)
    ErrTxt = 'Cannot load dataset because datafile is not yet specified';
    return;
end

SeqNr = RAPStat.GenParam.SeqNr;
if isempty(DataFile)
    ErrTxt = 'Cannot load dataset because sequence number is not yet specified';
    return;
end

try
    ds = dataset(DataFile, SeqNr);
catch
    ErrTxt = 'Cannot load dataset';
    return;
end
