function vd = versiondir;
% versiondir - grand parent dir of Early path
%     Versiondir returns the parent folder of all EARLY-specific directories
%     in the path. 
%
%     See also EarlyPath, startup.

persistent VD

% by convention EarlyPath.m is unique and resides in <versiondir>\init
if isempty(VD),
    kvp = which('EarlyPath');
    if iscellstr(kvp) & length(kvp)>1, error('Invalid shadowed versions of EarlyPath in path.'); end
    VD = fileparts(fileparts(kvp)); % parent folder of folder in which kvp resides.
end

vd = VD;


