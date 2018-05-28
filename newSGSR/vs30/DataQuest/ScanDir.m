function S = ScanDir(DirName, varargin)
%SCANDIR    scan directory hierarchy.
%   S = SCANDIR(DirName) scans the directory hierarchy starting
%   from the specified path. Multiple hierarchies originating from
%   different paths can be supplied by a cell-array.
%   S = SCANDIR(DirName, Pattern1, Pattern2, ..., PatternN) only
%   lists those files in the hierarchy which filenames corresponds
%   to the supplied patterns.

%B. Van de Sande 23-07-2004
%Used FILETREE.M by MVDH as template ...

S = zeros(0, 1);

%Check input arguments ...
if (nargin < 1) | (~ischar(DirName) & ~iscellstr(DirName)), 
    error('First argument should be directory name.'); 
end
DirName = lower(DirName);
if ~iscellstr(varargin), error('Extra arguments should be filename patterns.'); end

if iscellstr(DirName), %Use recursion to visit all directories ...
    N = length(DirName);
    for n = 1:N, S = [S; ScanDir(DirName{n}, varargin{:})]; end
else,
    %Removing trailing separator from directory name if present ...
    if (DirName(end) == filesep), DirName(end) = []; end
    if (nargin == 1), S = dir(DirName); 
    else, 
        Args = [varargin, {'*.'}]; N = length(Args); %Include directories ...
        for n = 1:N, S = [S; dir(fullfile(DirName, Args{n}))]; end
    end
    if (length(S) > 0), [S.path] = deal(DirName); end
    idx = strmatch('.', char(S.name)); S(idx) = []; %Remove . and ..
    idx = find([S.isdir]); 
    %Removing fields with RMFIELD.M removes all fieldnames when the structure
    %is empty ...
    if ~isempty(S), S = rmfield(S, 'isdir');
    else, S = struct('name', '', 'date', '', 'bytes', [], 'path', ''); S(1) = []; end
    if isempty(idx), return; end
    SubDirs = {S(idx).name}; S(idx) = [];
    S = [S; ScanDir(strcat([DirName filesep], SubDirs), varargin{:})];
end