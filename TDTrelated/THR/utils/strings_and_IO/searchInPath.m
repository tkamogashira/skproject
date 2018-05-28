function F = searchInPath(fn, Path, ftype);
% searchInPath - search named file in path
%    searchInPath('FOO.EXT', Path) returns the full filename of the first 
%    instance of a file named FOO.EXT in semicolon-separated path P.
%    Both files and directories are located; there is no distinction, but note
%    that a folder and a file can never have the same full name.
%    An empty string is returned if no match is found.
%
%    searchInPath('FOO', Path, 'directory') only searches for directories
%    named FOO.
%
%    searchInPath('FOO.EXT', Path, 'file') only searches for proper files 
%    (i.e., not directories) named FOO.
%
%    See also genpath.

% distribute path components over cellstr

ftype = arginDefaults('ftype', '');
Dir_okay = isempty(ftype) || ~isempty(strmatch(lower(ftype), 'directory'));
File_okay = isempty(ftype) || ~isempty(strmatch(lower(ftype), 'file'));

F = ''; % default return value
P = words2cell(Path, ';');
for ii=1:length(P);
    D = P{ii};
    FullName = fullfile(D, fn);
    if Dir_okay && exist(FullName, 'dir'),
        F = FullName;
        return;
    end
    qq = dir(FullName); 
    if ~isempty(qq),
        if (File_okay && ~qq(1).isdir),
            F = fullfile(D, qq(1).name);
            return
        end
    end
end





