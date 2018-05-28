function DateNum = getFileDate(FileName)
%GETFILEDATE    returns date of file as date number

%B. Van de Sande 25-08-1003

if exist(FileName), DateNum = datenum(getfield(dir(FileName), 'date'));
else DateNum = NaN; end