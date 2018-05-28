function backup(Prefix)
% BACKUP - data backup for Leuven lab
%   BACKUP FOO  generates a zip archive C:\Data\SGSRbackup\FOO.zip
%   to which all data files named FOO*.* from the datadir are stored.
%   Usually this includes data files with extensions:
%     IDF, SPK, SGSR, LOG, ERC.
%
%   BACKUP with no arguments tries to retrieve the correct Prefix from
%   the current session. Please check if this Prefix, which is
%   displayed, is correct!
%
%   BACKUP FOO puts the archive in C:\Data\SGSRbackup\FOO.zip.
%
% example of "advanced" usage:
%   backup M0416

%% Use the hostname to check on which computer we are
% For some reason the hostname is returned with a newline following it,
% the strncmpi() takes care of this
[status hostname] = system('hostname');
if strncmpi(hostname, 'neu-wrk-0129',12) % 7th floor
    sessionPath = 'B:\SGSRwork\export\NowRecording.mat';
    zipDir = 'C:\SGSRServer\expdata\Spikes';
elseif strncmpi(hostname, 'sikio',5) % 10th floor
    zipDir = 'C:\SGSRServer\expdata\Spikes';
    host = '';
    if exist('B:', 'dir') && exist('G:', 'dir')
        disp(['Both oido and oido-clone appear to be running and ' ...
            'connected to the network.']);
        while ~isequal(host,'oido') && ~isequal(host,'oido-clone') ...
                && ~isequal(host,'abort')
            host = lower(input(['Should I use oido, oido-clone or should ' ...
                'I abort? [oido/oido-clone/abort] ', 's']));
        end
    end
    if isequal(host, 'abort')
        error('Aborted by user');
    elseif exist('B:', 'dir') || isequal(host, 'oido')
        sessionPath = 'B:\SGSRwork\export\NowRecording.mat';
    elseif exist('G:', 'dir') || isequal(host, 'oido-clone')
        sessionPath = 'G:\SGSRwork\export\NowRecording.mat';
    else
        error(['No aquisition computer found! Make sure either Sikio or' ...
            'Sikio-clone is running and connected to the network.']);
    end
        
else
    error('The backup commando is not configured to work on this computer');
end

%% Determine prefix for this experiment (e.g. 'a0242')
if (nargin == 0)
    %take prefix from SESSION on experiment computer
    S = load(sessionPath);
    SESSION = S.SESSION;
    [dummy fileName] = fileparts(SESSION.dataFile);
    if isempty(fileName)
        error('Cannot retrieve datafile name from current Session'); 
    end

    % Convention: experiment names are like this: a0234
    % Sometimes a letter is added: a0234a, a0234b
    % This is e.g. due to recalibration
    % These files should be grouped in one zip file, in this case a0234
    lettertail = find(isdigit(fileName),1,'last'); % newer syntax, does not work on matlab6.1 though
    if ~isempty(lettertail)
        fileName = fileName(1:lettertail); % A0234b -> A0234; CH0431abc -> CH0431 etc
    end
    Prefix = fileName;
end

disp('***************')
disp(Prefix);
disp('***************')
pause(0.1);

%% check if any datafiles exist for the given prefix
% P: dir returns the files in the current data directory in a list
dataFiles = dir([datadir '\' Prefix '*.spk']);
if isequal(0, length(dataFiles))
    error(['No files ''' Prefix '*.*'' found in data directory. Check your datadir. ']);
end

%% Create zip file with all experiment files for this prefix
% construct wzzip command line and execute it via DOS call
zipName = [zipDir '\' Prefix '.zip'];
cmd = ['!"c:\program files\winzip\wzzip" -o ' zipName ' ' datadir '\' Prefix '*.*'];
disp(['-----> Creating zip: ' Prefix '.zip in directory: ' zipDir]);
eval(cmd)

%% Copy zip-file to L-drive
disp('-----> Copying zipped data to LAN server...');
try
   servBUdir = 'L:\Spikes';
   [stat, mess] = copyfile(zipName, [servBUdir '\' Prefix '.zip']);
   if (stat == 1)
       disp(['-----> Data successfully copied to ' servBUdir]);
   else
       error(mess);
   end
   if ~isempty(mess)
       error(mess); %#ok<WNTAG>
   end
catch
   error(['-----> Error while copying backup zipfile to LAN server over the network. Matlab error: ' lasterr]); %#ok<WNTAG>
end

%% Copy experiment information to KQuest, mym does not work on matlab versions less then 7.3
disp('-----> Copying data to KQuest...');   
for i=1:length(dataFiles)
    addToKQuest(dataFiles(i).name(1:end-4)); % cut off extension
end
disp('Backup finished.');
