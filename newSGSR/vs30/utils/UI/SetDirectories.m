function SetDirectories(kw, varargin);
% SetDirectories
global DEFDIRS
persistent UIgetFolderLaunched figh hh
if isempty(UIgetFolderLaunched),
   UIgetFolderLaunched = 0;
end

if UIgetFolderLaunched, 
   % as long as UIgetfolder is open (see below),
   % nothing may be done. Note that SetDirectories
   % is also the closerequest fnc of the SetDirs window; 
   % so that UIgetFolder is made "quasimodal."
   % Stupid 3rd party software..
   return;
end

if nargin<1, % retrieve tag of gco
   if isempty(gco), return; end
   kw = get(gco,'tag');
end
if isempty(kw), return; end;

switch lower(kw),
case 'init',
   dirName = varargin{1};
   curDir = varargin{2};
   dirDescr = varargin{3};
   hh = openuimenu('setdirs','','modal');
   setstring(hh.OldDirEdit,curDir);
   setstring(hh.NewDirEdit,curDir);
   figh = hh.Root;
   set(figh,'userdata',CollectInstruct(dirName, curDir, dirDescr));
   set(figh, 'name', ['Select ' dirDescr]);
   repaintWait(figh); % wait for figh to be deleted, refresh when moved
case 'cancelbutton',
   close(figh);
case 'close', % closereq
   savemenudefaults('setdirs');
   delete(figh);
   repaint; % repaint previous figure
case 'browsebutton'
   ud = get(figh,'userdata');
   ndh = findobj(figh,'tag','NewDirEdit');
   UIgetFolderLaunched = 1; % hack to make UIgetFolder quasi modal
   set(hh.SaveDirCheckbox,'enable','off'); % idem
   dd = uigetfolder_win32(['Select ' ud.dirDescr ':'], ud.curDir);
   UIgetFolderLaunched = 0; set(hh.SaveDirCheckbox,'enable','on');
   if ~ishandle(ndh), return; end; % avoid crashed due to non-modal uigetfolder
   if isempty(dd), return; end;
   if exist(dd,'dir'), setstring(ndh, dd); end
case 'okbutton',
   ud = get(figh,'userdata');
   odh = findobj(figh,'tag','OldDirEdit');
   olddir = trimspace(getstring(odh));
   ndh = findobj(figh,'tag','NewDirEdit');
   newdir = trimspace(getstring(ndh));
   isnew = ~isequal(lower(olddir),lower(newdir));
   if isnew, % change to newdir
      if ~local_setDir(ud.dirName, ud.dirDescr, newdir), return; end;
   end
   % save?
   ch = findobj(figh,'tag','SaveDirCheckbox');
   saveit = get(ch,'value');
   if saveit,
      saveFieldsInSetupFile(DEFDIRS, 'defaultDirs', ud.dirName);
      addtolog(['New setting of ' ud.dirDescr ' saved'],...
         [ud.dirName ' = ' newdir]);
   end
   close(figh);
case 'external', % noncallback call
   local_setDir(varargin{:});
otherwise,
   error(['Invalid keyword ''' kw '''']);
end
drawnow

%--------------------
function OK = local_setDir(dirName, dirDescr, newdir);
global DEFDIRS
OK = 0;
if exist(newdir,'dir'), 
   DEFDIRS = setfield(DEFDIRS, dirName, newdir);
   % add this feat to log string
   maxW = addtolog('getLogWidth');
   pref = [dirDescr ' set to: '];
   Nrem = maxW - length(pref);
   addtolog([pref StrLeftLim(newdir,Nrem)], [dirName ' = ' newdir]);
else, % newdir non-existing
   eh = errordlg(strvcat(['Directory: ''' newdir ''''], 'not found.'),...
      'Error setting directory', 'modal');
   uiwait(eh);
   return;
end % if exist
OK = 1;



