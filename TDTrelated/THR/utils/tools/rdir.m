function S = rdir(D, ignorehead);
% rdir - recursive directory listing
%   S = rdir('Foo') returns a struct array containing file information (like dir)
%   of all non-directory files in directory Foo and in all its subdirectories.
%   Foo may be a partial path.
%   S contains the following fields:
%        name: file name
%         ext: file name extension (part following last period)
%        date: date string as in '25-Sep-2006 23:10:24'
%       bytes: file size in bytes
%       isdir: 0
%      folder: folder in which the file resides
%      attrib: file attributes as returned by fileattr
%    fullname: full path of the file (directory + filename)
%
%   S = rdir('Foo', 'Prefix') removes 'Prefix' from the beginning of the 
%   folder and fullname fields.
%
%   Examples 
%    rdir('elmat')
%      ans = 
%      201x1 struct array with fields:
%          name
%          date
%          bytes
%          datenum
%          folder
%          attrib
%          fullname
%      ans(34)
%      ans = 
%              name: 'isinf.m'
%              date: '21-Jun-2005 15:28:30'
%             bytes: 381
%           datenum: 7.3248e+005
%            folder: 'C:\Program Files\MATLAB\R2007a\toolbox\matlab\elmat\'
%            attrib: [1x1 struct]
%          fullname: 'c:\program files\matlab\r2007a\toolbox\matlab\elmat\isinf.m'
%
%   rdir('elmat', 'C:\Program Files\MATLAB\R2007a\toolbox\');
%      ans(34)
%      ans = 
%              name: 'isinf.m'
%              date: '21-Jun-2005 15:28:30'
%             bytes: 381
%           datenum: 7.3248e+005
%            folder: 'matlab\elmat\'
%          fullname: 'matlab\elmat\isinf.m'
%
% See also DIR, spacemap.

if nargin<1, D = '.'; end
if nargin<2, ignorehead = ''; end
ignorehead = lower(ignorehead);

% expand partial paths
qq = dir(D);
if isempty(qq) || ~exist(D,'dir'),
    qq=what(D);
    if ~isempty(qq),
        D = qq(1).path;
    end
end
if ~exist(D,'dir'),
    error(['Directory ''' D ''' not found.']);
end

% replace '.' etc by their full name
switch D,
case {'.', '.\'},
    D = pwd;
case {'..', '..\'};
    D = fileparts(pwd)
case {'..\..', '..\..\'};
    D = fileparts(fileparts(pwd));
case {'..\..\..', '..\..\..\'};
    D = fileparts(fileparts(fileparts(pwd)));
case {'..\..\..\..', '..\..\..\..\'};
    D = fileparts(fileparts(fileparts(fileparts(pwd))));
case {'..\..\..\..\..', '..\..\..\..\..\'};
    D = fileparts(fileparts(fileparts(fileparts(fileparts(pwd)))));
end
% remove disk
DISK = '';
% if length(D)>1,
%     DISK = D(1:3);
%     if isequal(':', D(2)), D = D(3:end); end
% end
% remove trailing '\'
if isequal('\', D(end)),
    D = D(1:end-1);
end
% add trailing '\'
D = [D '\'];
% check if ignorehead is indeed the head of D
if ~isempty(ignorehead),
    ihLen = length(ignorehead);
    if ~isequal(ignorehead, lower(D(1:ihLen))),
        error(['''' D ''' does not start with ''' ignorehead '''.']);
    end
else, ihLen = 0;
end

S = dir([DISK D]);
[S.folder] = deal(D);
[S.attrib] = deal([]);

for ii=1:length(S),
    s = S(ii);
    fn = lower(fullfile(s.folder, s.name));
    fn = fn(ihLen+1:end);
    [S(ii).fullname] = fn;
    S(ii).folder = S(ii).folder(ihLen+1:end);
    [dum S(ii).attrib] = fileattrib(fullfile(s.folder, s.name));
    S(ii).ext = local_extension(S(ii).name);
end

% remove standard .\ and ..\ folders from dir output
idot = strmatch('.', {S.name},'exact');
idotdot = strmatch('..', {S.name},'exact');
S([idot idotdot]) = [];

if isempty(S), S = []; return; end

% find directories among the files
idir = find([S.isdir]); % indices of directory in list D
subS = S(idir);
% remove dirs from listing ...
S(idir) = []; 
% remove isdir field as is it is void
S = rmfield(S,'isdir');
% .. but add their listings
for ii=1:length(subS),
    subdir = fullfile(DISK, ignorehead, subS(ii).fullname);
    S = [S; rdir(subdir, ignorehead)];
end


% =================
function ext = local_extension(fn);
iper = strfind(fn,'.');
if isempty(iper), ext = '';
else,
    ext = fn(iper(end):end); % extension, including period, so Foo and Foo. have different extensions
end


