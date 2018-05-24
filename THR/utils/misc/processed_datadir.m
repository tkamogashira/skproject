function D = processed_datadir(D);
% processed_datadir - get mother dir of all processed data dirs.
%   processed_datadir returns the parent folder of all folders containing 
%   processed experimental data. This is typically D:\processed_data, but 
%   might be different on some PCs, e.g. when there is no D:\ disk. 
%   This is hardcoded in the processed_datadir code.
%
%   See also Rawdatadir.

Disk  = 'D:\';
switch compuname,
    case 'Cel',
        Disk = 'C:\D_Drive\';
end % switch

D = fullfile(Disk, 'processed_data');






