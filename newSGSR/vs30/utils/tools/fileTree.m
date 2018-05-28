function S = fileTree(RootDir);
% fileTree - recursive directory list in struct array
%   fileTree(RootDir) returns a struct array with info on all 
%   files in RootDir and recursive sub folders.
%   The fields are those returned by dir.
%
%   See also dir, StructView, StaComp

% if nargin<2, folder=RootDir; end

S = [];
RootDir = lower(RootDir);

if iscellstr(RootDir), % visit elements recusrsively
   for ii=1:length(RootDir),
      S = [S; fileTree(RootDir{ii})];
   end
   return
end

% single RootDir char string from here
S = dir(RootDir);
if length(S)>0, [S.folder] = deal(RootDir); end
idots = strmatch('.', {S.name}); % .\ and ..\ dir
S(idots) = []; % kick 'm out
% select subdirectories, remove them from list, and visit them recursively
idir = find([S.isdir]);
S = rmfield(S,'isdir'); % not informative: only true files survive in the listing
if isempty(idir), return; end
subdirs = {S(idir).name};
S(idir) = [];
S = [S; filetree(strcat([RootDir '\'], subdirs))];




