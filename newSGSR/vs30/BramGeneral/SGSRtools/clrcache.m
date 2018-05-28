function clrcache
%CLRCACHE   clear temporary directory of current user
%   CLRCACHE clears the temporary directory of the current user
%   which also includes all the SGSR caches.

%B. Van de Sande 10-11-2003

TmpDir = tempdir;

if exist(TmpDir), clearDir(TmpDir); end %Recursion ...

%--------------------------local functions---------------------------
function clearDir(DirName)

S = dir(DirName); IsDir = cat(2, S.isdir);
idx = find(~IsDir);
for n = idx, delete(fullfile(DirName, S(n).name)); end

idx = find(IsDir & ~ismember({S.name}, {'.', '..'}));
for n = idx, 
    SubDirName = fullfile(DirName, S(n).name);
    clearDir(SubDirName); 
end