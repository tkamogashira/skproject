function compName = GetKMailCompName(alias)
% GetKMailCompName - get a computer name corresponding to an alias at the KMail server
%   compName = GetKMailCompName(alias)
%     Get the computer name corresponding to the given alias at the KMail 
%     server. 
%
%     Parameters:
%        - alias    : the alias we want to look up
%
%     See also: Kmail, SetKMailAlias, DeleteKMailAlias

% Check params
if ~isequal(1, nargin) | ~ischar(alias) %#ok<OR2>
    error('GetKMailCompName expects one strings as argument');
end
if str2num(version('-release')) > 12.1
   if ~(length(regexp(alias, '[A-Za-z0-9_]')) == length(alias))
      error('The alias should only alphanumeric characters and underscores.');
   end
end

alias = strrep(alias, '-', '_');

% Check KMail Status
if isequal(0, KMailStatus)
    error 'Network error!';
end

% Does alias exist?
if ~exist([KMailServer '_Alias\' alias '.alias'], 'file')
    compName = alias;
else
    % Try to read alias
    tic;
    fid = fopen([KMailServer '_Alias\' alias '.alias'],'r');
    while (fid == -1) & (toc < 3) %#ok<AND2>
        pause(0.5);
        fid = fopen([KMailServer '_Alias\' alias '.alias'],'r');
    end
    if toc > 3
        error('File reading time-out');
    end
    aliasFile = fread(fid);
    compName = char(aliasFile');
    fclose(fid);
end