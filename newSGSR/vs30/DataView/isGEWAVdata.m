function boolean = isGEWAVdata(ds);
% isGEWAVdata - returns 1 if dataset contains GeneralWaveForm data

if strcmpi(ds.fileformat, 'edf') & strcmpi(ds.schname, 'sch005'), boolean = logical(1);
else, boolean = logical(0); end