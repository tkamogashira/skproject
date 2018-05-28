function inituserdata(ExpName)
%INITUSERDATA   initialize userdata
%   INITUSERDATA(ExpName) initializes userdata script on server for a specified experiment
%
%   See also GETUSERDATA, EDITUSERDATA

%B. Van de Sande 21-10-2003

%Parameters nagaan ...
if nargin ~= 1 | ~ischar(ExpName), error('Wrong input arguments.'); end

%Localisatie van userdata nagaan ...
ServerName    = strrep(servername, ':', '');
ServerDirInfo = serverdir;
if isempty(ServerName), error('Cannot get the name of the SGSR server. SGSR should be reconfigured.'); end
usrdataURL = sprintf('file://%s/%s/%s%s.m', ServerName, strrep(ServerDirInfo.UsrData(2:end), '\', '/'), ExpName, UsrDFPostFix);
expdataURL = sprintf('file://%s/%s/%s.zip', ServerName, strrep(ServerDirInfo.ExpDataBackup(2:end), '\', '/'), ExpName);

%Nagaan of experimentnaam wel bestaat ...
if isempty(ProbeNetFile(expdataURL)), warning(sprintf('Experiment with name %s doesn''t exist or is not yet backuped to SGSR server.', ExpName)); end

%Nagaan of script niet al eerder is aangemaakt op server voor dit experiment ...
if ~isempty(ProbeNetFile(usrdataURL)), error(sprintf('There is already a script on the SGSR server for experiment %s.', ExpName)); end

%Bestand aanmaken op servercomputer en naam van experiment reeds in script invoegen ...
LocalPath = fileparts(which(mfilename)); LocalFullFileName = [LocalPath '\UDtemplate.m'];
URL = parseURL(usrdataURL); ServerFullFileName = [URL.CompName ':\' URL.Dir '\' ExpName UsrDFPostFix '.m'];

fid_local  = fopen(LocalFullFileName, 'rt'); if fid_local < 0, error(sprintf('Cannot open %s.', LocalFullFileName)); end
fid_server = fopen(ServerFullFileName, 'wt'); if fid_server < 0, error(sprintf('Cannot open %s.', ServerFullFileName)); end

Text = '';
while 1,
    Line = fgetl(fid_local); if ~ischar(Line), break; end
    Text = [Text Line char(13)];
end    

Text = strrep(Text, 'Experiment.Name = '''';', ['Experiment.Name = ''' ExpName ''';' ]);
fprintf(fid_server, '%s', Text);

fclose(fid_local);
fclose(fid_server);