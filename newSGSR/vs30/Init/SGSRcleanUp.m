function y=SGSRcleanUp;
% SGSRcleanUp - remove/rename obsolete files from SGSR directories
%   must be called *before* setting SGSR path, but after
%   DEFDIRS has been set

global DEFDIRS

%-------------MAT files in Setup dir------------
% *.mat files in setup dir must be renamed to *.SGSRsetup
%
sdir = [DEFDIRS.Setup '\'];
matFiles = dir([sdir '*.mat' ]);
for ii=1:length(matFiles),
   fn = matFiles(ii).name;
   newName = [local_rm_ext(fn) '.SGSRsetup'];
   evalstr = ['!rename ' sdir fn ' ' newName];
   eval(evalstr);
end

%------local ----------
function rfn = local_rm_ext(fn);
% removes extension from filename (need local version 'cause path isn't defined yet)
Dot = max(find(fn=='.'));
if isempty(Dot), Dot=length(fn)+1; end; 
rfn = fn(1:Dot-1);


