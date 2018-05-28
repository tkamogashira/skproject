function addToPath(pdir, parent)
global VERSIONDIR SGSRDIR

if nargin<2
    parent=0;
end

prepend = true;
if isequal('append', parent),
   parent = 0;
   prepend = false;
end

if parent
    ROOT = SGSRDIR; 
else
    ROOT = VERSIONDIR;
end
if isempty(pdir)
   fullPath = ROOT;
else
   fullPath = [ROOT '\' pdir];
end

if prepend
   path(fullPath, path);
else
   path(path , fullPath);
end
