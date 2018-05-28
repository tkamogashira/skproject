function zipproject(projectName)
%ZIPPROJECT archive project
%   ZIPPROJECT(ProjectName)

%B. Van de Sande 14-07-2003

if nargin < 1, error('Wrong number of input arguments.'); end
if ~strcmpi(compuname, 'oto') | ~strcmpi(username, 'bram'), error('This program can only be run on sikio by user bram.'); end

usrDir = ['C:\USR\' username];
projectDir = ['mfiles\' projectName];
zipName = [lower(projectName) '.zip'];
%Opties voor WinZip :
%   -ex     : maximum compressie
%   -u      : de zip-file wordt upgedate, nieuwe en gewijzigde gegevens worden aangepast in zip-file
%   -P      : volledig opgegeven path wordt in zip-file bewaard
zipOpt = '-ex -P -u';
wzzipCmd = ['c:\program files\winzip\wzzip.exe'];

if ~exist([usrDir '\' projectDir]), error('Requested project doesn''t exist.'); end
if ~exist(wzzipCmd), error('WinZip command line extensions not installed.'); end

cwd = pwd; cd(usrDir);

%Archiveren van project specifieke M-FILES directory ...
%Extra optie voor WinZip:
%   -x*.mat : alles archiveren, behalve mat-files
cmd = ['!"' wzzipCmd '" ' zipOpt ' -x*.mat ' zipName ' ' projectDir '\'];
try eval(cmd); catch error('Couldn''t make project archive.'); end

switch lower(projectName)
case 'oscor',
    %MANUALDS.MAT toevoegen ...
    cmd = ['!"' wzzipCmd '" ' zipOpt ' ' zipName ' ' projectDir '\manualds.mat'];
    try eval(cmd); catch error('Couldn''t make project archive.'); end
    %Archiveren van MADISONDATA directory, behalve de cache files ...
    cmd = ['!"' wzzipCmd '" ' zipOpt ' -xMadisonData\CACHE\ ' zipName ' MadisonData\'];
    try eval(cmd); catch error('Couldn''t make project archive.'); end
    %Archiveren van MADISONSTIM directory ...
    cmd = ['!"' wzzipCmd '" ' zipOpt ' -r ' zipName ' MadisonStim\'];
    try eval(cmd); catch error('Couldn''t make project archive.'); end
case 'stereausis',
    %Extra directory toevoegen, nl. STEREAUSISDATA ...
    cmd = ['!"' wzzipCmd '" ' zipOpt ' -x*.cache* ' zipName ' StereausisData\'];
    try eval(cmd); catch error('Couldn''t make project archive.'); end
end

cd(cwd);