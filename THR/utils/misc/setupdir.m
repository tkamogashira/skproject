function d = setupdir;
% setupdir - folder containing setup info
%     Setupdir returns the folder in which setup files reside.
%
%     See also SetupInfo

persistent D

if isempty(D),
    D = fullfile(EarlyRootDir, 'SetupInfo');
end

d = D;


