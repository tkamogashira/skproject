function SetKMailAlias(compName, alias)
% SetKMailAlias - set an alias at the KMail server
%   SetKMailAlias(compName, alias)
%     Sets an alias at the KMail server. This can be helpful to prevent
%     the need to hardcode the name of a certain computer in a project.
%
%     Parameters:
%        - compName : name of the computer we are creating an alias for
%                     This parameter can be omitted; in that case, the name
%                     of the current computer is used.
%        - alias    : the alias we are creating
%
%     See also: Kmail, GetKMailCompName, DeleteKMailAlias

% Check params
if isequal(1, nargin)
    alias = compName;
    compName = strrep(CompuName, '-', '_');
elseif ~isequal(2, nargin)
    error('SetKMailAlias two strings as arguments'); 
end
if ~ischar(compName) | ~ischar(alias)
    error('SetKMailAlias two strings as arguments'); 
end

if str2num(version('-release')) > 12.1
   if ~(length(regexp(alias, '[A-Za-z0-9_]')) == length(alias))
      error('The alias should only alphanumeric characters and underscores.');
   end
   if ~(length(regexp(compName, '[A-Za-z0-9_]')) == length(compName))
      error('The computer name should only alphanumeric characters and underscores. Replace dashes by underscores.');
   end
end

% Check KMail Status
if isequal(0, KMailStatus)
    error 'Network error!'; 
end

% Try to write alias
aliasFullPath = [KMailServer '_Alias\' alias '.alias'];
fid = fopen(aliasFullPath,'w');
fprintf(fid, '%s', compName);
fclose(fid);

if ~exist(aliasFullPath, 'file')
    error('Could not set the requested alias.');
end