function DefaultDirs(factory)
% defaultdirs - stores important, version-independent directories in global DEFDIRS
%   call default dirs after SGSRpath.
%   
%   Conventions: startupdir has sister dir called "setupInfo"
%   In this setupInfo directory a file defaultDirs.SGSRsetup
%   will determine the other default dirs. If no such setup file
%   is found, factory settings are used.
%
% See also Setdirectories.

global DEFDIRS StartupDir

if nargin<1
    factory = 0;
end

% get parent dir of StartupDir without changing working dir
curdir = cd;
cd(StartupDir);
cd ..;
ParentDir = cd;
cd(curdir);

% empty previous versions if any
DEFDIRS = [];

%------UNCHANGEABLE SETTINGS---------------
% startup dir: version management, etc
DEFDIRS.Startup = StartupDir;  
% setup info: hardware, directries, anything.
DEFDIRS.Setup = [ParentDir '\SetupInfo'];
DEFDIRS.DataBrowse = [ParentDir '\DataBrowse'];

%------VARIABLE SETTINGS------------------
%--------factory values-------------
% experimental data (saving them): SPK, IDF, ERCx files
DEFDIRS.IdfSpk = [ParentDir '\expdata'];  
% experimental data (browsing them)
DEFDIRS.BrowseData = ['']; % see bdatadir function
% system calibration data: MIC, CAV, PRB, PRL
DEFDIRS.Calib = [ParentDir '\calibdata']; % 
% exported files (TXT etc)
DEFDIRS.Export = [ParentDir '\export'];
% User interface defaults (DEF files)
DEFDIRS.UIdef = [ParentDir '\UIdefaults'];
% wavlist files
DEFDIRS.Wavlist = [ParentDir '\WavLists'];

if factory
    return;
end

% try to retrieve user settings from setup file
try
   DEFDIRS = getFieldsFromSetupFile(DEFDIRS, 'defaultDirs');
catch
   error(lasterr);
end
