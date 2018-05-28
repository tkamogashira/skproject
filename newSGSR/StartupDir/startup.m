% generic SGSR startup file
% this script directs initialization to the most 
% recent version installed on the current system

curdir = pwd;
% Find sgsrdir
cd ..
sgsrdir = cd;
% Return to our original dir
cd(curdir);

% javaclasspath clears all vars and globals for some dumbass reason. So we have to
% set the java classpath before we start collecting globals...
setJavaPath(sgsrdir);

global Versions StartupDir ... % Versions variable is adapted by the declaration files
    SGSRDIR VERSIONDIR MATLABONLYPATH

fileList = what; % fileList.m is cell array containing m-files in current dir
% now check for files named versionxxx.m ("version declaration files")
% and run them all one by one

StartupDir = pwd;
origDir = pwd;
%------------find out about versions-------------
Versions.numbers = [];
Versions.patches = [];
Versions.Dirs = cell(1024,1);
Versions.mostRecent = 0; % index of most recent version detected
Versions.Developer = ~isempty(fileList.mdl); % mdl file serves as flag
for ii=1:length(fileList.m),
   [dummy, fname] = fileparts(lower(fileList.m{ii})); % m-files only
   if isequal(1,strfind(fname,'version')), % only files named version*.m
      eval(fname);
   end
end
Versions.patches = 0.01*unique(round(100*Versions.patches));
% find most recent version (highest version number)
[dummy, Versions.mostRecent] = max(Versions.numbers);
% remove junk variables
clear fileList ii pp fname rv

% launch most recent version by running <SGSRroot>\<versiondir>\init\startup.m

MATLABONLYPATH = path; %#ok<NASGU> % path prior to adding SGSR specifics
cd ..
SGSRDIR = cd; % default location of mfiles
try % finding the SGSRROOT DIR from a setup file in the startupdir
   rootdirInfo = [StartupDir filesep 'SGSRrootdir.SGSRsetup'];
   if exist(rootdirInfo, 'file'),
      dummy = load(rootdirInfo,'-mat');
      dummy = dummy.RootDir;
      if exist(dummy, 'dir'),
         SGSRDIR = dummy;
      end
      clear dummy rootDirInfo
   end
catch e %#ok<SNASGU>
    disp('No setup file for SGSR root dir found');
end

VERSIONDIR = [SGSRDIR filesep Versions.Dirs{Versions.mostRecent}];
addpath([VERSIONDIR filesep 'init']); % so we can start calling SGSR mfiles

% Remove globals from the workspace
clear SGSRDIR VERSIONDIR MATLABONLYPATH Versions StartupDir

startSGSR; % local m-files have priority over other files in path

cd(origDir);
