function convertToAscii(directory)
% CONVERTTOASCII
%
% convertToAscii(directory) goes recursively through all files and
% directories below the given directory and searches for files and
% directories with non-ASCII characters in their names. If such files of
% directories are found, they can be renamed.
%
% A backup of each renamed object is stored in C:\nonascii_backup, this
% permits the restoring of files in the case of an unexpected error. You
% can afterwards remove this directory if you are sure everything went
% correctly.

% Ramses de Norre 16/02/2010

if ~exist(directory, 'dir')
    error('The given input is not a directory.');
end

files = rdir([directory '\**\*']);
cellfun(@toAscii, {files(:).name}, 'UniformOutput', false);

%%
function toAscii(name)
backupDir = 'C:\nonascii_backup';
if ~exist(backupDir, 'dir')
    mkdir(backupDir);
end

new_name = name(arrayfun((@(x) double(x)<=128), name));

if ~strcmp(name, new_name)
    copyfile(name, [backupDir '\' basename(name)]);
    moveFile(name, new_name);
end

%%
function moveFile(old, new)
if exist(old, 'dir')
    type = 'directory';
else
    type = 'file';
end
disp(['Detected a non-ascii ' type ', ' old]);
if ~isempty(basename(new)) && ~exist(new) %#ok<EXIST>
    accept = input(['rename to ' regexprep(new, '\\', '\\\\') '? [y/n] '], 's');
else
    accept = 'n';
end
if strcmpi(accept, 'y')
    movefile(old, new);
else
    dir = dirname(new);
    new = input('What should I rename the file to? ', 's');
    moveFile(old, [dir new]);
end

%%
function b = basename(path)
b = path(find(path=='\', 1, 'last')+1:end);

%%
function d = dirname(path)
d = path(1:find(path=='\', 1, 'last'));
