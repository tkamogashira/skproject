function ViewDirectories(kw, varargin)
% ViewDirectories
global DEFDIRS 
persistent hh

if nargin<1, % retrieve tag of gco
   if isempty(gco), return; end
   kw = get(gco,'tag');
end
if isempty(kw), return; end;

figh = gcbf;

switch lower(kw),
case 'init',
   hh = OpenUImenu('viewdirs','','modal');
   figh = hh.Root;
   localUpdateDirDisplay(hh);
   repaintWait(figh); % wait for figh to be deleted, refresh when moved
case 'datadirbutton',
   setdirectories('init', 'IdfSpk', datadir, 'Data directory');
case 'calibdirbutton',
   setdirectories('init', 'Calib', calibdir, 'Calib directory');
case 'exportdirbutton',
   setdirectories('init', 'Export', exportdir, 'Export directory');
case 'wavlistdirbutton',
   setdirectories('init', 'Wavlist', wavlistdir, 'Wavlist directory');
case 'okbutton',
   SaveMenuDefaults('viewdirs');
   close(figh);
   repaint; % repaint previous figure
end
localUpdateDirDisplay(hh);

%---------------------
function localUpdateDirDisplay(hh)
drawnow;
try % window might be closed, etc
   setstring(hh.DatadirEdit,datadir);
   setstring(hh.CalibdirEdit,calibdir);
   setstring(hh.ExportdirEdit,exportdir);
   setstring(hh.WavlistdirEdit,wavlistdir);
   drawnow;
end

