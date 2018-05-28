function updatesgsr
%UPDATESGSR get and install latest distribution of SGSR software

%B. Van de Sande 12-02-2004

global SGSRDIR;

CurMoreSetting = get(0, 'More'); more off;

%WinZip® Command Line Support Add-On ...
UnZipProg = 'c:\program files\winzip\wzunzip.exe';
%   -d : create directory structure
%   -o : overwrite existing files without prompting
%   -n : only extract newer files
UnZipOpt = '-d -o -n';

%Directories and archive names ...
DestDir     = SGSRDIR;
SrvDir      = [servername , getfield(serverdir, 'SGSRDistr')];
LogName     = [mfilename '.log'];
FullZipName = 'SGSRdistr_Full.zip';
IncZipName  = 'SGSRdistr_Inc.zip';

LogFileName     = fullfile(SGSRDIR, LogName);
FullZipFileName = fullfile(SrvDir, FullZipName);
IncZipFileName  = fullfile(SrvDir, IncZipName);


if nargin ~= 0, error('Wrong number of input arguments.'); end
if ~exist(UnZipProg), error('WinZip® Command Line Support Add-On is not installed.'); end
if ~exist(SrvDir), error('Mapped Network Drive with SGSR server dysfunctional.'); end


%-----------------------------Implementation details-----------------------------------
%   The clock of BIGCREEN is used to synchronize all backup operations. The clock of
%   the receiving computer cannot be used because BIGSCREEN's clock is running slow.
%   So, this means that every client computer must keep track of the date of the zipfile
%   that was most recently extracted. This date was created on BIGSCREEN and therefore 
%   has a date according to BIGSCREEN's clock.
%--------------------------------------------------------------------------------------

LatestUpDate = readLog(LogFileName);

MostRecentZipFile = 0;
if exist(FullZipFileName) & (getFileDate(FullZipFileName) > LatestUpDate),
    cmd = ['!"' UnZipProg '" ' UnZipOpt  ' ' FullZipFileName ' ' DestDir ];
    try eval(cmd); catch error('Couldn''t extract archive.'); end
    MostRecentZipFile = getFileDate(FullZipFileName);
end    
if exist(IncZipFileName) & (getFileDate(IncZipFileName) > LatestUpDate),
    cmd = ['!"' UnZipProg '" ' UnZipOpt  ' ' IncZipFileName ' ' DestDir ];
    try eval(cmd); catch error('Couldn''t extract archive.'); end
    MostRecentZipFile = getFileDate(IncZipFileName);
end

writeLog(LogFileName, MostRecentZipFile);

set(0, 'More', CurMoreSetting);

%--------------------------------------------local functions-----------------------------------------------------
function Date = readLog(FileName)

if exist(FileName), 
    fid = fopen(FileName, 'rt'); if fid < 0, error(sprintf('Couldn''t open %s.', FileName)); end
    Line = fgetl(fid); [dummy, Date] = strtok(Line, '='); Date = datenum(Date(2:end));
    fclose(fid);
else, Date = -Inf; end

function writeLog(FileName, Date)

fid = fopen(FileName, 'wt'); if fid < 0, error(sprintf('Couldn''t open %s.', FileName)); end
fprintf(fid, 'Latest Update = %s', datestr(Date, 0));
fclose(fid);