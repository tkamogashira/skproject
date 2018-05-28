function RmMkDistr(varargin)
%RMMKDISTR make distribution archive of SGSR software (remotely)
%   RMMKDISTR(I) makes a distribution archive of the SGSR software. This
%   program can only be run on a computer with a permanent mapped network
%   drive to BIGSCREEN. The optional input argument I gives the maximum
%   interval in days between oldest file in full backup and newest file
%   in incremental backup that is allowed. By default this is 31 days. 
%   If the interval is set to zero or a negative value, then the generation
%   of a full backup is forced.
%   
%   Attention! This program not only makes an archive on BIGSCREEN, but
%   also a duplicate on the SGSR server from which the distribution to
%   other computers in the workgroup is accomplished.
% 
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also MAKEDISTR, UPDATESGSR

%B. Van de Sande 25-07-2005

%----------------------------default parameters-------------------------
%Location of the WinZip® Command Line Support Add-On and the standard
%options used for this utility ...
%   -ex : maximum compression
%   -p  : store directory information in zip-file
%   -r  : recurse into subfolders 
%   -o  : change the zip-file's date to the same as the newest file in the zip
%   -u  : updating, new and changed files are archived
DefParam.unzipprog   = 'c:\program files\winzip\wzzip.exe';
DefParam.unzipopt    = '-ex -p -r -o -u';
%Location of copy utility to be used and the necessary command line 
%options ...
%   /Y  : overwrite files without asking for confirmation
%   /F  : displays full source and destination file names while copying
DefParam.copyprog    = 'c:\windows\system32\xcopy.exe';
DefParam.copyopt     = '/Y /F';
%Directories and archive names ...
DefParam.srcdir      = 'b:\sgsrdevelop\sgsr';
DefParam.destdir     = 'b:\distr';
DefParam.srvdir      = [servername , getfield(serverdir, 'SGSRDistr')];
DefParam.fullzipname = 'sgsrdistr_full.zip';
DefParam.inczipname  = 'sgsrdistr_inc.zip';
%File-extensions to include in archive ...
DefParam.fileexts    = {'*.m', '*.p', '*.c', '*.h', '*.dll', '*.fig', '*.doc', ...
        '*.mco', '*.lng', '*.cdf', '*.aliasdb', '*.data', '*.lst', '*.java', '*.class', ...
        '*.dlm'};

%-----------------------------------------------------------------------
%Check input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); 
    disp(DefParam);
    return;
elseif (nargin == 1) & isnumeric(varargin{1}), Interval = varargin{1}; Pidx = 2;
else, Interval = 31; Pidx = 1; end %Interval given in days ...

if (length(Interval) ~= 1) | mod(Interval, 1), error('Interval must be a given as a scalar integer.'); end
if (Interval <= 0), ForceFull = logical(1); else ForceFull = logical(0); end

Param = CheckPropList(DefParam, varargin{Pidx:end});
Param = CheckParam(Param);

%Disable paging of the output in the MATLAB command window, because this
%interrupts the archiving and copying process ...
CurMoreSetting = get(0, 'More'); more off;

%Archiving using two backups, a full and an incremental backup ...
FullZipFileName    = fullfile(Param.destdir, Param.fullzipname);
IncZipFileName     = fullfile(Param.destdir, Param.inczipname);
SrvFullZipFileName = fullfile(Param.srvdir,  Param.fullzipname);
SrvIncZipFileName  = fullfile(Param.srvdir,  Param.inczipname);
NFileExts          = length(Param.fileexts);

IncNewestFile = getNewestFile(Param.srcdir);
if exist(FullZipFileName), FullNewestFile = getFileDate(FullZipFileName);
else, FullNewestFile = -Inf; end

if ForceFull | ((IncNewestFile - FullNewestFile) > Interval), 
    %Erase previous archives ... Another possibility is updating the full
    %archive, but then (re)moved files stay in the archive ...
    if exist(FullZipFileName), delete(FullZipFileName); end
    if exist(IncZipFileName), delete(IncZipFileName); end
    
    %Update full backup ...
    dirinc = vectorzip(repmat({Param.srcdir}, 1, NFileExts), Param.fileexts, repmat({' '}, 1, NFileExts));
    cmd = ['!"' Param.unzipprog '" ' Param.unzipopt ' ' FullZipFileName ' ' dirinc{:}];
    try eval(cmd); catch error('Couldn''t make archive.'); end
else,
    %Update incremental backup and leave full backup as is ... To make sure
    %everything gets archived, there is an overlap between full and incremental
    %backup of one day ... 
    vecDate = datevec(FullNewestFile);
    ExOpt = ['-tf' num2str(vecDate(1)) '-' num2str(vecDate(2)) '-' num2str(vecDate(3)) ];
    
    dirinc = vectorzip(repmat({Param.srcdir}, 1, NFileExts), Param.fileexts, repmat({' '}, 1, NFileExts));
    cmd = ['!"' Param.unzipprog '" ' Param.unzipopt ' ' ExOpt ' ' IncZipFileName ' ' dirinc{:}];
    try eval(cmd); catch error('Couldn''t make archive.'); end
end

%Synchronize with SGSR server ...
if (exist(SrvFullZipFileName) & (getFileDate(SrvFullZipFileName) < getFileDate(FullZipFileName))) | ...
    ~exist(SrvFullZipFileName),
    cmd = ['!"' Param.copyprog '" ' FullZipFileName ' ' Param.srvdir '\ ' Param.copyopt];    
    try, eval(cmd); catch error('Could not synchronize archives with SGSR server.'); end
end

if exist(IncZipFileName),
    cmd = ['!"' Param.copyprog '" ' IncZipFileName ' ' Param.srvdir '\ ' Param.copyopt];    
    try, eval(cmd); catch error('Could not synchronize archives with SGSR server.'); end
elseif exist(SrvIncZipFileName), delete(SrvIncZipFileName); end

%Reset paging of the output in the MATLAB command window to its previous
%setting ...
set(0, 'More', CurMoreSetting);

%------------------------------local functions--------------------------
function Param = CheckParam(Param)

if ~exist(Param.unzipprog, 'file'), error('Cannot find WinZip® Command Line Support Add-On.'); end
Param.unzipprog = lower(Param.unzipprog);
if ~ischar(Param.unzipopt), error('Extra command-line options for the zip utility must be given as a string.'); end

if ~exist(Param.copyprog, 'file'), error('Cannot find copy utility.'); end
Param.copyprog = lower(Param.copyprog);
if ~ischar(Param.copyopt), error('Extra command-line options for the copy utility must be given as a string.'); end

if ~exist(Param.srcdir, 'dir'), error('Property srcdir should be an existing directory.'); end
if (Param.srcdir(end) ~= filesep), Param.srcdir = [Param.srcdir, filesep]; end
Param.srcdir = lower(Param.srcdir);

if ~exist(Param.destdir, 'dir'), error('Property destdir should be an existing directory.'); end
if (Param.destdir(end) ~= filesep), Param.destdir = [Param.destdir, filesep]; end
Param.destdir = lower(Param.destdir);

if ~exist(Param.srvdir, 'dir'), error('Property srvdir should be an existing directory.'); end
if (Param.srvdir(end) ~= filesep), Param.srvdir = [Param.srvdir, filesep]; end
Param.srvdir = lower(Param.srvdir);

[Path, FileName, FileExt] = fileparts(Param.fullzipname);
if ~isempty(Path), error('Property fullzipfilename cannot contain path information.'); end
if isempty(FileName), error('Property fullzipname should be a valid filename.'); end
if isempty(FileExt), FileExt = '.zip'; end
Param.fullzipname = lower(fullfile('', [FileName, FileExt]));

[Path, FileName, FileExt] = fileparts(Param.inczipname);
if ~isempty(Path), error('Property inczipfilename cannot contain path information.'); end
if isempty(FileName), error('Property inczipname should be a valid filename.'); end
if isempty(FileExt), FileExt = '.zip'; end
Param.inczipname = lower(fullfile('', [FileName, FileExt]));

if ~iscellstr(Param.fileexts) & ~ischar(Param.fileexts), 
    error('Property fileexts should be cell-array with file extensions to include in archive.');
end

%-----------------------------------------------------------------------
function DateNum = getNewestFile(Dir)

S = dir(Dir);
DateNum = max(datenum(char(S.date)));

DirIdx = find(cat(2, S.isdir));
for n = DirIdx,
    if any(strcmp(S(n).name, {'.', '..'})), continue; end
    DateNum = max([DateNum, getNewestFile(S(n).name)]); 
end    

%-----------------------------------------------------------------------