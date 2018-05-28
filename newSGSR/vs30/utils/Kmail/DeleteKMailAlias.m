function DeleteKMailAlias(alias)
% DeleteKMailAlias - delete an alias from the KMail server
%   DeleteKMailAlias(alias)
%     Delete an alias from the KMail server
%
%     Parameters:
%        - alias    : the alias we want to delete
%
%     See also: Kmail, SetKMailAlias, GetKMailCompName

% Check params
if ~isequal(1, nargin) | ~ischar(alias) %#ok<OR2>
    error('DeleteKMailAlias one strings as argument');
end

if str2num(version('-release')) > 12.1
   if ~(length(regexp(alias, '[A-Za-z0-9_]')) == length(alias))
      error('The alias should only alphanumeric characters and underscores.');
   end
end

% Check KMail Status
if isequal(0, KMailStatus)
    error 'Network error!';
end

% Does alias exist?
if ~exist([KMailServer '_Alias\' alias '.alias'], 'file')
    error('The given alias does not exist!');
else
    % Try to delete alias
    delete([KMailServer '_Alias\' alias '.alias']);
end