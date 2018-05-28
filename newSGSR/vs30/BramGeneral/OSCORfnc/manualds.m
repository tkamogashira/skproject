echo on

%SCRIPT puts dataset objects, that had to be loaded manually, in CACHE-system ... These dataset objects should be
%in the MAT-file manualds.mat, located in the current directory.

%Overview of datasets ...
%R95057: 9-20-OSCR, 20-4-OSCR, 20-17-OSCR
%R95060: 4-6-OSCR, 28-5-OSCR
%I95101: 1-18-OSCR
%R95106: 7-14-OSCR, 10-6-OSCR
%R95110: 4-4-OSCR, 5-4-OSCR
%R96078: 7-6-OSCR
%R99069: 43-2-OSCR (merging of 43-2-ANAB and 43-6-ANAB)

echo off

DirInfo = getdirinfo;
CacheFileName = fullfile(DirInfo.MadDataDir, 'CACHE\MADDATASET.CACHE');

D = load('manualds.data', '-mat');
FNames = fieldnames(D);
N = length(FNames);
C = struct2cell(D);

for n = 1:N
    idx = findstr(FNames{n}, '_');
    
    SearchParam.DataFile = [FNames{n}(3:idx(1)-1) '.DAT'];
    SearchParam.CellNr   = str2num(FNames{n}(idx(1)+1:idx(2)-1));
    SearchParam.TestNr   = str2num(FNames{n}(idx(2)+1:idx(3)-1));
    SearchParam.DataType = FNames{n}(idx(3)+1:end);
    Data = C{n};
    
    PutInHashFile(CacheFileName, SearchParam, Data, +1009);
end
