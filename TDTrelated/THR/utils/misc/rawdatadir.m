function D = rawDataDir(D);
% Rawdatadir - get mother dir of all raw data dirs.
%   Rawdatadir returns the parent folder of all folders containing raw
%   data. This is typically D:\Rawdata, but might be different on some PCs,
%   e.g. when there is no D:\ disk. This is hardcoded in the Rawdatadir
%   code.
%
%   See also Experiment, KnownExperimenters, setuplist.

Disk  = 'D:\';
switch compuname,
    case 'Cel',
        Disk = 'C:\D_Drive\';
end % switch

D = fullfile(Disk, 'rawdata');






