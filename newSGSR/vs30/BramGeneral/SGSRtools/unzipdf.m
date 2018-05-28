echo on;

%WinZip® Command Line Support Add-On ...
UnZipProg = 'c:\program files\winzip\wzunzip.exe';
if ~exist(UnZipProg), error('WinZip® Command Line Support Add-On is not installed.'); end
%   -o : overwrite existing files without prompting
UnZipOpt = '-o';

%Directories ...
SrcDir  = [datadir '\Zips\'];
DestDir = datadir;

%Finding files ...
List = dir([SrcDir '*.zip']);
disp(cv2str(List));

%Extracting files ...
N = length(List);
for n = 1:N,
    FullZipFileName = [SrcDir List(n).name];
    cmd = ['!"' UnZipProg '" ' UnZipOpt  ' ' FullZipFileName ' ' DestDir ];
    try eval(cmd); catch error('Couldn''t extract archive.'); end
end

echo off;