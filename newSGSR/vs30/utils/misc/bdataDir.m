function [sd, ic]=bdatadir(D);
% BDATADIR - returns browse-data directory as char string
%   BD = BDATADIR returns current browsedatadir.
%   
%   BDATADIR('default') sets it to the default value, i.e., datadir
%
%   BDATADIR(D) sets it to D. The folder D must exist.
%
%   [BD IC] =BDATADIR('prompt') asks the user to specify one. 
%   IC reports if the browse-data dir has been changed
%
%   See also DATADIR

global DEFDIRS
if nargin<1,
elseif isequal('prompt',lower(D)),
   osd = bdatadir;
   sd=uigetfolder_win32('Select folder for browsing data', osd);
   if ~isempty(sd), 
      DEFDIRS.BrowseData = sd;
   end;
   ic = ~isequal(lower(osd),lower(sd)) & ~isempty(sd);
elseif isequal('default',lower(D)), DEFDIRS.BrowseData = '';
else, 
   if exist(D,'dir'), DEFDIRS.BrowseData = D;
   else, error(['Cannot find folder ''' D ''''])
   end
end
sd = DEFDIRS.BrowseData;
saveFieldsInSetupFile(DEFDIRS, 'defaultDirs', 'BrowseData');
if isempty(sd),
   sd = dataDir;
end

