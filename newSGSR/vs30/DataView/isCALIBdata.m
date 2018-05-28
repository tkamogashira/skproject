function boolean = isCALIBdata(ds)
% isCALIBdata - returns 1 if dataset contains calibration data

if strcmpi(ds.fileformat, 'edf') && strcmpi(ds.schname, 'calib')
    boolean = true;
else
    boolean = false;
end
