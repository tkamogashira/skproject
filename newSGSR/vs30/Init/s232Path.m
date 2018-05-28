function S232DIR = s232Path(DefPath,ForcePrompt);

% tries to find the location of the TDT s232.dll driver
% Steps in this search:
%  1. previously stored path (in StartupDir\S232DIR.SGSRsetup)
%  2. try default TDT installation dir (C:\TDT\S232\MATLAB\s232.DLL)
%  (this default value can be overruled by the first arg of s232Path)
%  3. prompt the user via uigetfile
% Once the DLL is found, its location is stored in 
% StartupDir\S232DIR.SGSRsetup

if nargin<2, ForcePrompt=0; end;

global StartupDir
StoreFile = setupFile('S232DIR');
fname = 'S232.DLL';

if ~ForcePrompt,
   % 1. try to retrieve from StoreFile
   S232DIR = CheckInDir(fname, LoadPreviousPath(StoreFile));
   if ~isempty(S232DIR), return; end;
   % 2. if this doesn't work, try DefaultPath
   if nargin<1, DefPath = 'C:\TDT\S232\MATLAB'; end;
   S232DIR = CheckInDir(fname, DefPath, StoreFile);
   if ~isempty(S232DIR), return; end;
   %3. if this doesn't work, ask the user
end
while isempty(S232DIR),
   [fn fp] = uigetfile([DefPath '\' fname],...
      'Locate the TDT 32-bit driver ''S232.DLL'' ');
   UserDir = RemoveLastSlash(fp)
   S232DIR = CheckInDir(fname, UserDir, StoreFile);
   if isempty(S232DIR),
      choice = warnchoice1('S232.DLL driver not found','WARNING',...
         '|Cannot start SGSR without S232.DLL driver|What to do?',...
         'Cancel Startup', 'Search Again');
      if isequal(choice, 'Cancel Startup'), return; end;
   end
end

% ------locals---------
function Dir = CheckInDir(fname, ThisDir, StoreFile);
% checks existence of fname in ThisDir; if found, it stores the
% directory in StoreFile
Dir = '';
if ~isstr(ThisDir), return; end;
try % avoid crashing due to non-string values of ThisDir
   if exist([ThisDir '\' fname], 'file'), 
      Dir = ThisDir;
      % save in StoreFile as 'S232DIR'
      if nargin>2, S232DIR = Dir; save(StoreFile, 'S232DIR'); end;
   end;
end

function p = LoadPreviousPath(StoreFile);
global SGSRDIR
p = ''; fname = 'S232.DLL';
try
   load(StoreFile, '-MAT'); % loads variable S232DIR
   % check if the stored value makes sense
	if exist([S232DIR '\' fname]),
	   p = S232DIR;
	end
catch, return; 
end % try/catch



