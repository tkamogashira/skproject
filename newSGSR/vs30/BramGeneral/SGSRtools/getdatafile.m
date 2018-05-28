function GetDataFile(FileName, varargin) 
%GETDATAFILE    retrieve datafile(s) from SGSR server.
%   GETDATAFILE(FileName) retrieves archive of the requested datafile from
%   the SGSR server and extracts the contents in the user's current data
%   directory. When a cell-array of strings is supplied multiple datafiles
%   can be installed at once.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 22-09-2004

%----------------------------default parameters-----------------------------
DefParam.unzipprog    = 'c:\program files\winzip\wzunzip.exe';
DefParam.serverdir    = 's:\expdata';
DefParam.experimenter = 'bulan';
DefParam.datadir      = datadir;
DefParam.zipdir       = [datadir '\Zips'];

%---------------------------------------------------------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(FileName) & strcmpi(FileName, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
elseif ~ischar(FileName) & ~iscellstr(FileName), error('First argument should be string or cell-array of strings.'); end
Param = CheckPropList(DefParam, varargin{:});
Param = CheckParam(Param);

if iscellstr(FileName), %Recursion ...
    N = prod(size(FileName)); for n = 1:N, GetDataFile(FileName{n}, Param); end
else,
    FileName = ParseFileName(FileName);
    MkLocalCopy(FileName, Param); %Make local copy of archive ...
    ExtracteArchive(FileName, Param); %Extract archive in user's data directory ...
end

%---------------------------------------------------------------------------    
function FileName = ParseFileName(FileName)

[Path, FileName, FileExt] = fileparts(FileName);
if ~isempty(Path), error('Path information cannot be given in filename.'); end
if isempty(FileName), error('Invalid filename supplied.'); else, FileName = lower(FileName); end
if isempty(FileExt), FileExt = '.zip'; end
FileName = [FileName, FileExt];

%---------------------------------------------------------------------------    
function Param = CheckParam(Param)

if ~exist(Param.unzipprog, 'file'), error('Cannot find WinZip® Command Line Support Add-On.'); end
Param.unzipprog = lower(Param.unzipprog);

if ~exist(Param.serverdir, 'dir'), error('Property serverdir should be an existing directory.'); end
if (Param.serverdir(end) ~= filesep), Param.serverdir = [Param.serverdir, filesep]; end
Param.serverdir = lower(Param.serverdir);

if ~ischar(Param.experimenter) | ~any(size(Param.experimenter) == 1), error('Property experimenter must be character string.'); end
Param.experimenter = lower(Param.experimenter(:)');

if ~exist(Param.datadir, 'dir'), error('Property datadir should be an existing directory.'); end
if (Param.datadir(end) ~= filesep), Param.datadir = [Param.datadir, filesep]; end
Param.datadir = lower(Param.datadir);

if ~exist(Param.zipdir, 'dir'), error('Property zipdir should be an existing directory.'); end
if (Param.zipdir(end) ~= filesep), Param.zipdir = [Param.zipdir, filesep]; end
Param.zipdir = lower(Param.zipdir);

%---------------------------------------------------------------------------    
function MkLocalCopy(FileName, Param)

SrcFile = [Param.serverdir, Param.experimenter, '\', FileName];
DestDir = Param.zipdir; 
try,
    fprintf('Copying ''%s'' to ''%s'' ...\n', SrcFile, DestDir); 
    copyfile(SrcFile, DestDir);
catch, error(sprintf('Could not copy archive ''%s'' to local directory ''%s''.', SrcFile, DestDir)); end 

%---------------------------------------------------------------------------    
function ExtracteArchive(FileName, Param)

%Command line options for WinZip:
%   -o : overwrite existing files without prompting
UnZipOpt = '-o';

FullZipFileName = [Param.zipdir, FileName];
DestDir         = Param.datadir;
cmd = ['!"' Param.unzipprog '" ' UnZipOpt  ' ' FullZipFileName ' ' DestDir ];
try eval(cmd); catch error(sprintf('Couldn''t extract archive ''%s''.', FullZipFileName)); end

%---------------------------------------------------------------------------