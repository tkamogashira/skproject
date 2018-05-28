function D = calibrationdir(D);
% calibrationdir - default dir for calibration data
%   Used by transfer/save. Ugly; should be replaced by method.


D = fullfile(rawdatadir,  'EARLY\calibrationdata');


