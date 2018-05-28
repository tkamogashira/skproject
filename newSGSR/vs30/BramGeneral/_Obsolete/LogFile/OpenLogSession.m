function OpenLogSession(FileName, SessionName)
%OPENLOGSESSION opens a logfile 
%   OPENLOGSESSION(FileName, SessionName)   
%   Input parameters
%   FileName    : name of logfile. If no path is given the current working directory is assumed. The 
%                 default extension is .log.
%   SessionName : character string that serves as ID for this session
%
%   Caution : only one logsession can be open at a time.
%
%   See also WRITELOGITEM, CLOSELOGSESSION

ErrText = '';

%Globale variable aanmaken ...
global LOGFILE_FID LOGFILE_SESSION

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end

[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path), Path = pwd; end
if isempty(FileName), error('A valid filename should be given as the first argument'); end
if isempty(FileExt), FileExt = '.log'; end

if ~ischar(SessionName), error('Name of session should be a character string'); end

%LogFile openen ...
if ~isempty(LOGFILE_SESSION), error(['Other session already open (' LOGFILE_SESSION ')']); end

fid = fopen(fullfile(Path, [FileName, FileExt]), 'at');
if fid == -1, error(['Couldn''t open ' fullfile(Path, [FileName, FileExt])]); end

%Session Header wegschrijven ...
time = clock;
fprintf(fid, '----------------------------------------------------------------------------------------------------\n');
fprintf(fid, '%s %dh%d %s\n', SessionName, time(4:5), date);
fprintf(fid, '----------------------------------------------------------------------------------------------------\n\n');

LOGFILE_FID     = fid;
LOGFILE_SESSION = SessionName;