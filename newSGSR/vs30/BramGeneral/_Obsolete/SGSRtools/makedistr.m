function makedistr(Interval)
%MAKEDISTR make distribution archive of SGSR software
%   MAKEDISTR(I) makes a distribution archive of the SGSR software. This program can only be run on BIGSCREEN.
%   The optional input argument I gives the maximum interval in days between oldest file in full backup and newest
%   file in incremental backup that is allowed. By default this is 31 days. 
%   If the interval is set to zero or a negative value, then the generation of a full backup is forced.
%   
%   Attention! This program not only makes an archive on BIGSCREEN, but also a duplicate on the SGSR server from
%   which the distribution to other computers in the workgroup is accomplished.
%
%   See also UPDATESGSR

%B. Van de Sande 25-07-2005

global SGSRDIR;

CurMoreSetting = get(0, 'More'); more off;

%WinZip Command Line Support Add-On ...
ZipProg = 'c:\program files\winzip\wzzip.exe';
%   -ex : maximum compression
%   -p  : store directory information in zip-file
%   -r  : recurse into subfolders 
%   -o  : change the zip-file's date to the same as the newest file in the zip
%   -u  : updating, new and changed files are archived
ZipOpt = '-ex -p -r -o -u';

%XCopy utility ...
CopyProg = 'xcopy';
%   /Y  : overwrite files without asking for confirmation
%   /F  : displays full source and destination file names while copying
CopyOpt  = '/Y /F';

%Directories and archive names ...
SourceDir   = SGSRDIR;
DestDir     = 'C:\Distr';
SrvDir      = [servername , getfield(serverdir, 'SGSRDistr')];
FullZipName = 'SGSRdistr_Full.zip';
IncZipName  = 'SGSRdistr_Inc.zip';

FullZipFileName    = fullfile(DestDir, FullZipName);
IncZipFileName     = fullfile(DestDir, IncZipName);
SrvFullZipFileName = fullfile(SrvDir, FullZipName);
SrvIncZipFileName  = fullfile(SrvDir, IncZipName);

%File-extensions to include in archive ...
FileExts = {'*.m', '*.p', '*.c', '*.h', '*.dll', '*.fig', '*.doc', '*.mco', '*.lng', '*.cdf', '*.aliasdb', '*.data', '*.lst', '*.java', '*.class', '*.dlm'};
NFileExts = length(FileExts);

%Checking parameters and system configuration ...
if nargin == 0, Interval = 31; elseif nargin ~= 1, error('Wrong number of input arguments.'); end
if Interval <= 0, Force = 1; else Force = 0; end

if ~atbigscreen, error('This program can only be run on BIGSCREEN.'); end
if ~exist(ZipProg), error('WinZip® Command Line Support Add-On is not installed.'); end
if ~exist(SrvDir), error('Mapped Network Drive with SGSR server dysfunctional.'); end

%Archiving over two backups, a full and an incremental backup ...
IncNewestFile = getNewestFile(SourceDir);
if exist(FullZipFileName), FullNewestFile = getFileDate(FullZipFileName);
else, FullNewestFile = -Inf; end

if Force | ((IncNewestFile - FullNewestFile) > Interval), 
    %Erase previous archives ... Another possibility is updating the full archive, but then (re)moved files stay in
    %the archive ...
    if exist(FullZipFileName), delete(FullZipFileName); end
    if exist(IncZipFileName), delete(IncZipFileName); end
    
    %Update full backup ...
    dirinc = vectorzip(repmat({[SourceDir '\']}, 1, NFileExts), FileExts, repmat({' '}, 1, NFileExts));
    cmd = ['!"' ZipProg '" ' ZipOpt ' ' FullZipFileName ' ' dirinc{:}];
    try eval(cmd); catch error('Couldn''t make archive.'); end
else,
    %Update incremental backup and leave full backup as is ... To make sure everything gets archived, there is an overlap between full 
    %and incremental backup of one day ... 
    vecDate = datevec(FullNewestFile);
    ExOpt = ['-tf' num2str(vecDate(1)) '-' num2str(vecDate(2)) '-' num2str(vecDate(3)) ];
    
    dirinc = vectorzip(repmat({[SourceDir '\']}, 1, NFileExts), FileExts, repmat({' '}, 1, NFileExts));
    cmd = ['!"' ZipProg '" ' ZipOpt ' ' ExOpt ' ' IncZipFileName ' ' dirinc{:}];
    try eval(cmd); catch error('Couldn''t make archive.'); end
end

%Synchronize with SGSR server ...
if (exist(SrvFullZipFileName) & (getFileDate(SrvFullZipFileName) < getFileDate(FullZipFileName))) | ...
    ~exist(SrvFullZipFileName),
    cmd = ['!' CopyProg ' ' FullZipFileName ' ' SrvDir '\ ' CopyOpt];    
    try, eval(cmd); catch error('Could not synchronize archives with SGSR server.'); end
end

if exist(IncZipFileName),
    cmd = ['!' CopyProg ' ' IncZipFileName ' ' SrvDir '\ ' CopyOpt];    
    try, eval(cmd); catch error('Could not synchronize archives with SGSR server.'); end
elseif exist(SrvIncZipFileName), delete(SrvIncZipFileName); end

set(0, 'More', CurMoreSetting);

%---------------------------------------------local functions----------------------------------------------------
function DateNum = getNewestFile(Dir)

S = dir(Dir);
DateNum = max(datenum(char(S.date)));

DirIdx = find(cat(2, S.isdir));
for n = DirIdx, 
    if any(strcmp(S(n).name, {'.', '..'})), continue; end
    DateNum = max([DateNum, getNewestFile(S(n).name)]); 
end    