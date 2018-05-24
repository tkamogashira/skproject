function ZipWork(Project, Ndays, ToStick);
% ZipWork - put recent files in zip file
%    ZipWork(Project, Ndays, ToStick);
%    Type "Fromsetupfile backup" to  view backup settings
%   
%    Zipwork Foo -editXfile edits excude list of project Foo
%
%    Zipwork -newproject Foo RootDir  defines new project Foo having roo
%    directory RootDir.
%
%    Zipwork -list lists the zipwork project taht were previously defined
%
%    Zipwork -deleteproject Foo deletes the project Foo from setup file
%    root directory RootDir.
%   
%    To change the drive letter of the USB stick:  
%     ToSetupFile('backup', '-propval', 'USBstickDrive', 'I:\')
%
%    See also SetupList, earlyver.


if nargin<3, ToStick = 0; end;

Project = upper(Project);

switch Project
    case '-NEWPROJECT'
        % juggle input params; check args
        Project = Ndays;
        RootDir = ToStick;
        if ~isvarname(Project),
            error(['Invalid projectname ''' Project '''. Project names must be Matlab identifiers.']);
        end
        if ~exist(RootDir, 'dir'),
            error(['Non-existent directory ''' RootDir '''.']);
        end
        toSetupFile('Backup', '-propval', [upper(Project) '_root'], RootDir);
        disp(['Zipwork project ''' Project ''' defined.']);
        return
    case '-DELETEPROJECT'
        % juggle input params; check args
        Project = Ndays;
        if ~isvarname(Project),
            error(['Invalid projectname ''' Project '''. Project names must be Matlab identifiers.']);
        end
        toSetupFile('Backup', '-delete', [upper(Project) '_root']);
        disp(['Zipwork project ''' Project ''' deleted.']);
        return
    case '-LIST'
        disp(' ');
        disp('   ===Zipwork projects & their root directories====');
        BU = Fromsetupfile('backup');
        Pnames = fieldnames(BU);
        for ii=1:numel(Pnames),
            pn = Pnames{ii};
            if ~isempty(strfind(pn, '_root')),
                disp(['   Project ' pn(1:end-5) ': ' BU.(pn)]);
            end
        end
        disp('   ================================================');
        disp(' ');
        return;
end

ExcludeFileDir = fromSetupFile('Backup', 'ExcludeFileDir');
Xfile = fullfile(ExcludeFileDir, [Project '_DontZip.txt']);

if isequal('-editxfile', lower(Ndays)),
    if ~exist(Xfile, 'file'),
        textwrite(Xfile, {[';ZipWork exclude list for project ' Project '.'] '' '' ''});
    end
    edit(Xfile);
    return;
end

% allow the specification by the user of numbers as strings
if ischar(Ndays), Ndays = str2double(Ndays); end
if ischar(ToStick), ToStick = str2double(ToStick); end

if ToStick, 
    StickDir = FromSetupFile('Backup', 'USBstickDrive');
    if ~exist(StickDir, 'dir'), error(['USB stick not found in drive ''' StickDir '.']); end
    USBdir = 'ZippedWork';
    fullUSBdir = [StickDir filesep USBdir];
    if ~exist(fullUSBdir,'dir'),
        mkdir(StickDir, USBdir);
        disp(['Directory ''' fullUSBdir ''' created.']);
    end
end

% retrieve the local project directory
ProjectDir = FromSetupFile('Backup',[Project '_root'], '-default', '');
if isempty(ProjectDir),
    error(['Unkown project ''' Project '''. Use    Zipwork -newproject    to define it.']);
end

% where to put the zip file?
zipfiledir = FromSetupFile('Backup','ZipOutDir');
nowstr = strrep(strrep(datestr(now), ' ', '_'), ':', '=');
Name = [Where '{' Compuname '}' Project '_' nowstr '.zip'];
ZipName = fullfile(zipfiledir, Name);

% ---basic WZZIP cmd + options
exe = '"C:\Program Files\WinZip\wzzip" -rp '; 

% compute ndays string
dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

% ---include exclude file if any
if exist(Xfile, 'file'),
    Xoption = [' -x@' Xfile ' '];
else,
    Xoption = '';
end

if ToStick, % zipfile must be copied to memorystick
    copycmd = ['copy "' ZipName '"  "' fullUSBdir '"']
else,
    copycmd = '';
end

% patch together the WZZIP command
wzzcmd = [exe dateArg Xoption ZipName ' "' ProjectDir '\*.*"']

% Write the commands to a batch file (this is the only way to suppress ...
% ... the annoying WZZIP output, which causes the Matlab interpreter headaches)
BatchDir = fullfile(earlyRootDir, 'sandbox');
delete(fullfile(BatchDir, [Project '_wzz*.bat'])); % delete any previous wzz batch files
BatchFile = fullfile(earlyRootDir, 'sandbox', [Project '_wzz' num2str(randomint(99999)) '.bat']);
textwrite(BatchFile, {'color C0' wzzcmd copycmd 'pause' 'exit'});
eval(['!"' BatchFile '" &']); % the trailing & causes the Wzzip output to go to the console, not Matlab window


% quote from WZZIP helptext:
% (Note: same format is uswed for file lists and exclude lists)
%
% @listfile is the name of a text file that contains a list of the files 
% to be added to the Zip file.  Each line of the listfile can contain 
% one filename.  This may include a drive letter and full or partial path.
% If no drive letter is provided, the current drive is assumed.  
% If no path is provided, the current directory in the specified or 
% current drive is assumed.  If a partial path is provided, it is assumed 
% to be relative to the current directory of the specified or current drive.
% 
% Filenames may also include wildcards.  The wildcard specification "*" 
% is assumed to mean "*.*", i.e., all files.  The wildcard specification 
% "*." means "all files that have no extension."
% 
% Filenames containing spaces may be quoted, but this is not required in 
% a listfile.
% 
% Listfiles can also contain comments: any text following a semicolon (';')
% is ignored, up to the end of the line.
% 
% Here is an example of the contents of a listfile:
% 
% ; List of files to zip
% 	info.doc
% 	*.txt  ; Zip up all .txt files
% 


    