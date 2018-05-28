function edituserdata(ExpName)
%EDITUSERDATA   edit userdata
%   EDITUSERDATA(ExpName) edits userdata script on server for a specified experiment
%
%   See also GETUSERDATA, INITUSERDATA

%B. Van de Sande 21-10-2003

%Parameters nagaan ...
if nargin ~= 1 | ~ischar(ExpName), error('Wrong input arguments.'); end

%Localisatie van userdata nagaan ...
ServerName    = strrep(servername, ':', ''); 
ServerDirInfo = serverdir;
if isempty(ServerName), error('Cannot get SGSR servername. SGSR should be reconfigured.'); end
sURL = sprintf(['file://%s/%s/%s' UsrDFPostFix '.m'], ServerName, strrep(ServerDirInfo.UsrData(2:end), '\', '/'), ExpName);

if isempty(ProbeNetFile(sURL)), error(sprintf('No userdata present for experiment %s.', ExpName)); end

%Bestand editeren op servercomputer ...
URL = parseURL(sURL);
FileName = [URL.CompName ':\' URL.Dir '\' URL.FileName];
edit(FileName);
