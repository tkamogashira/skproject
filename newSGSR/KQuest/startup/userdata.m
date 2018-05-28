function userdata

global SGSRDIR;
sgsrdir = SGSRDIR; % Don't spill the global
oldPath = pwd;

% Create the folder where the persistent Java data is stored
kquestDir = 'C:\kquest_data';
if ~exist(kquestDir, 'dir')
	mkdir(kquestDir);
end
cd(kquestDir);

jarLocation = sprintf('%s\\KQuest\\dist\\KQuest.jar', sgsrdir);
command = ...
	'system(sprintf(''java -Xmx1024M -Xms512M -jar "%s" && exit &'', jarLocation));';
eval(command);

% Start the JaMal server
com.jamal.server.MatlabServer;

cd(oldPath);
