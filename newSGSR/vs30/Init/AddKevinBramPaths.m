function AddKevinBramPaths
% AddKevinBramPaths - add paths for Kevin's & Bram's SGSR software

global VERSIONDIR
% path(path, genPathFromDir([VERSIONDIR '\KevinGeneral\']));
path(local_genPathFromDir([VERSIONDIR '\KevinGeneral\']), path);
path(local_genPathFromDir([VERSIONDIR '\BramGeneral\']), path);
path(local_genPathFromDir([VERSIONDIR '\ramsesGeneral\']), path);
path(local_genPathFromDir([VERSIONDIR '\AbelGeneral\']), path);

%==============================================

function p = local_genPathFromDir(d)

% created 2007/03/14 by Kevin
% happily stolen from genpath.m
% ignore .svn directories

% initialise variables
methodsep = '@';  % qualifier for overloaded method directories
p = '';           % path to be returned

% Generate path based on given root directory
files = dir(d);
if isempty(files)
  return
end

% Add d to the path even if it is empty.
p = [p d pathsep];

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing

for i=1:length(dirs)
   dirname = dirs(i).name;
   if    ~strcmp( dirname,'.')         && ...
         ~strcmp( dirname,'..')        && ...
         ~strcmp( dirname,'.svn')      && ...
         ~strncmp( dirname,methodsep,1)&& ...
         ~strcmp( dirname,'private')
      p = [p local_genPathFromDir(fullfile(d,dirname))]; % recursive calling of this function.
   end
end

%------------------------------------------------------------------------------
