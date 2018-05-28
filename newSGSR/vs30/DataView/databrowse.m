function databrowse(keyword, xarg, varargin)
% databrowse - generic callback of databrowse dialog

global DataBrowseMenuStatus
global BrowseData
persistent logname

try
  hh = DataBrowseMenuStatus.handles;
catch
end

if nargin<1
   keyword = get(gcbo, 'tag');
   if isempty(keyword),
      % not a known callback--default action is launching databrowser
      keyword = 'init';
   end
end
doReturn = (nargin==0); % default: do not return after init
if nargin<2,
   xarg = '';
elseif isequal('return', xarg)
   xarg = '';
   doReturn = 1; 
end

switch keyword,
case 'init',
   DataBrowseMenuStatus = [];
   [dummy,name]=system('hostname');
   if strncmpi(name, 'neu-wrk-0130', 12)
       % Damir's PC has problems with the original fig file because of his
       % strange resolution
       hh = OpenUImenu('DataBrowse', 'DataBrowseMenu_damir');
   else
       hh = OpenUImenu('DataBrowse', 'DataBrowseMenu');
   end
   if atSnail, % correct screwed-up format
      dbpos = get(hh.Root,'position');
      set(gcf, 'pos', [dbpos(1) dbpos(2)  958   487]);
   elseif atKiwi || atEe1285a, % enlarge
      localEnlarge(hh,130,100);
   end
   DeclareMenuDefaults('DataBrowse', 'Root:position', ...
       'ExperimentPopup:Value', '*Button:userdata', '*Button:string');
   if ~isempty(xarg)
       databrowse('chdir', xarg);
   end
   BrowseDataBase('clear');
   DataBrowseMenuStatus.showMode = get(hh.showModeButton, 'userdata');
   databrowse collectlogs;
   if doReturn
       return; % debug option: return to command line
   end
   uiwait(hh.Root);
case 'close',
   localSaveCurrentList(hh); % save position in current seqlist
   SaveMenuDefaults DataBrowse;
   localBlackList('kill'); % delete plots launched through databrowse dialog
   browseDataBase save; % save current BrowseDataBase, if any
   browseDataBase clear; % clear current BrowseDataBase
   try
       delete(hh.Root);
   catch
   end
case 'update',
   Nseq = BrowseData.DFinfo.Nseq;
   watchon; drawnow;
   localSaveCurrentList(hh); % save position in current seqlist
   browseDataBase('update');
   NseqNew = BrowseData.DFinfo.Nseq;
   localRetrieveLastList(hh, logname);
   if NseqNew>Nseq, % new data have been added, show them & select first new dataset
      browseDataBase('show', hh.SeqListBox);
      set(hh.SeqListBox, 'Value', Nseq+1);
      set(hh.SeqListBox, 'ListboxTop', max(1, Nseq-3));
   end
   watchoff;
   drawnow;
case 'collectlogs',
   set(hh.Root, 'name', ['Browsing ' bdataDir]);
   qq = dir([bdatadir '\*.log']);
   if isempty(qq), 
      localEnableUI(hh, 0); % disable listbox
      return; 
   end
   localEnableUI(hh, 1); % enable listbox
   LogName = cell(1,length(qq));
   for ii=1:length(qq)
       LogName{ii} = strtok(qq(ii).name,'.');
   end
   % disp('try to retrieve the previous browse "position"')
   DataBrowseMenuStatus.LogName = LogName;
   localRetrieveLastLog(hh, LogName);
   databrowse ExperimentPopup;
case 'ExperimentPopup',
   localSaveCurrentList(hh); % save position in current seqlist
   iexp = get(hh.ExperimentPopup, 'value');
   if iexp > length(DataBrowseMenuStatus.LogName)
      iexp = 1;
      set(hh.ExperimentPopup, 'value', iexp);
   end
   logname = DataBrowseMenuStatus.LogName{iexp};
   watchon;
   drawnow;
   browseDataBase('save'); % save previous BrowseDataBase, if any
   browseDataBase('load', logname, DataBrowseMenuStatus.showMode);
   localRetrieveLastList(hh, logname);
   localSaveCurrentLog(hh);
   watchoff;
   drawnow;
case 'SeqListBox',
   if isequal('open', get(hh.Root, 'SelectionType')) % doubleclick or <return>
      localSelectDataset(hh);
   end
case 'showModeButton',
   showModes = {'classic' 'spiffy'};
   buttStrings = {'essentials' 'details'};
   % toggle 1<->2
   if isequal('classic', get(hh.showModeButton, 'userdata'))
       imode = 2;
   else
       imode = 1;
   end
   DataBrowseMenuStatus.showMode = showModes{imode};
   set(hh.showModeButton, 'userdata', showModes{imode}, 'string', buttStrings{imode});
   drawnow;
   databrowse close;
   databrowse init;
case 'ShowAllMenuItem',
   Nset = browsedatabase('count');
   for iset=1:Nset,
      try
         localSelectDataset(hh, iset); 
         set(hh.SeqListBox, 'Value', iset);
         set(hh.SeqListBox, 'ListboxTop', max(1,iset-5));
      catch
      end
      drawnow;
   end
 
%==============VIEW PARAMS====================================================   
case 'ViewParamsButton',
   localSelectDataset(hh); % define current dataset (see curDS)
   showstimparam([],1); % show current ds in NotePad
%==============MENUS====================================================   
case {'FileMenu'}, % no action, but no error either
case {'chdir', 'SetBdirMenuItem', 'ChangeDirButton'},
   newdir = xarg;
   if isempty(newdir), % interactive
      localSaveCurrentList(hh); % save position in current seqlist
      [dum, dirchanged] = bdatadir('prompt');
      if ~dirchanged, return; end;
   else bdatadir(newdir);
   end
   browseDataBase save; % save current BrowseDataBase, if any
   browseDataBase('clear');
   databrowse collectlogs;
case 'ExportExplistMenuItem',
   localExportCurrentList(hh, logname);
case 'CurrentExpMenuItem',
   bdatadir(datadir);
   browseDataBase save; % save current BrowseDataBase, if any
   browseDataBase('clear');
   databrowse collectlogs;
case 'EmptyCachefilesMenuItem'
   emptycachefile databrowse;
   browsedatabase emptycache;
   browsedatabase clear;
   databrowse close;
   databrowse init;
%==============PLOTS==========================================================   
otherwise, % try if a plot button is hit
   if StrEndsWith(lower(keyword), 'plotbutton'),
      localSelectDataset(hh);
      ds = curds; 
      if isTHRdata(ds), % simply plot threshold curve
         ph = ucthr(ds);
         localBlackList(ph);
      elseif isCALIBdata(ds), EvalCALIB(ds); % delegate to BramWare
      elseif isGEWAVdata(ds), EvalGEWAV(ds); % delegate to BramWare
      else % make specified plot
         plotFnc = ['UC' lower(keyword(1:end-length('plotbutton')))];
         ph = eval([plotFnc '(curDS)']);
         localBlackList(ph);
      end;
      databrowse('update');
      %set(hh.SeqListBox, 'fontsize',10);
   else % give up
      error(['unknown keyword '''  keyword  '''']);
   end
end

%-------------------------------------------
function fs = localFormatSeqinfo(logname)
% format sequence info
LogInfo = ParseLogFile(logname);
fs = fromCacheFile('localFormatSeqinfo', LogInfo);
if ~isempty(fs)
    return;
end
Seqs = LogInfo.Seqs;
N = length(Seqs);
fs = cell(1,N);
for ii=1:N
   iseq = fixlenstr(num2str(Seqs(ii).iseq),5,1);
   id = fixlenstr(Seqs(ii).ID,18);
   fs{ii} = [iseq ' ' id];
end
ToCacheFile('localFormatSeqinfo', 1e3, LogInfo, fs);

function localEnableUI(hh, en)
if en
    ev='on';
else
    ev='off';
end;
set(hh.ExperimentPopup, 'enable', ev);
set(hh.updateExpButton, 'enable', ev);
set(hh.SeqListBox, 'enable', ev);
set(hh.ExperimentPopup, 'value', 1);
set(hh.SeqListBox, 'value', 1);
if ~en,
   set(hh.ExperimentPopup, 'string', 'no log files found'); 
   setstring(hh.SeqListBox, {['No log files in ' bdatadir]});
end

function localSelectDataset(hh, iset)
if nargin<2, iset = get(hh.SeqListBox, 'Value'); end % index in listbox of current set
lbt = get(hh.SeqListBox, 'ListboxTop'); % remember current pos as it will be screwed up by display update
watchon; drawnow;
browseDataBase('getset', iset);
browsedatabase('show', hh.SeqListBox);
set(hh.SeqListBox, 'ListboxTop', lbt);
watchoff; drawnow;

function localBlackList(ph)
% manage black list of figures that will die with databrowse dialog
global DataBrowseMenuStatus
if ~isfield(DataBrowseMenuStatus, 'BlackList'), % initialize
   DataBrowseMenuStatus.BlackList = [];
end
if ishandle(ph), % add ph to list
   DataBrowseMenuStatus.BlackList = [DataBrowseMenuStatus.BlackList ph];
elseif isequal('kill',ph), % delete each member if extant
   for h=fliplr(DataBrowseMenuStatus.BlackList), % youngest go first
      if ishandle(h), 
         try 
            figure(h); % h must be current for closereq to know which figure to close
            close(h); 
         catch 
            delete(h); 
         end
      end;
   end
end

function logname = localPopUpLogname(hh)
% returns currently displayed logname
iexp = get(hh.ExperimentPopup, 'value');
logname = getstring(hh.ExperimentPopup);
logname = nospace(logname{iexp});

function localSaveCurrentLog(hh)
logname = localPopUpLogname(hh);
ToCacheFile('DbrowseDirSettings', -1e3, bdatadir, logname); % direct storage

function localRetrieveLastLog(hh, LogName)
% retrieves the logname (experiment name) used the last time when browsing bdatadir
set(hh.ExperimentPopup, 'string', LogName);
lastLogname = FromCacheFile('DbrowseDirSettings', bdatadir);
iexp = 1; % default: first Experiment in list
if ~isempty(lastLogname), % make the retrieved experiment the current one, if still present
   for ii=1:length(LogName),
      ln = lower(LogName{ii});
      if isequal(lower(lastLogname), ln),
         iexp = ii;
         break;
      end
   end
end
set(hh.ExperimentPopup, 'value', iexp);

function localSaveCurrentList(hh)
global BrowseData; 
if isempty(BrowseData), return; end;
logname = BrowseData.Experiment;
LB.value = get(hh.SeqListBox, 'Value');
LB.listTop = get(hh.SeqListBox, 'ListboxTop');
ToCacheFile('DbrowseLogSettings', -1e3, logname, LB);

function localRetrieveLastList(hh, logname)
% retrieves the listbox settings used the last time when browsing logname
global BrowseData; 
Nseq = BrowseData.DFinfo.Nseq;
set(hh.SeqListBox, 'Value', 1);
set(hh.SeqListBox, 'ListboxTop', 1);
browseDataBase('show', hh.SeqListBox);
LB = FromCacheFile('DbrowseLogSettings', logname);
if ~isempty(LB),
   if LB.value<=Nseq, set(hh.SeqListBox, 'Value', LB.value); end
   if LB.listTop<=Nseq, set(hh.SeqListBox, 'ListboxTop', LB.listTop); end
end

function localExportCurrentList(hh, logname)
listText  = char(get(hh.SeqListBox, 'String'));
[FN, FP]=uiputfile([exportdir '\' logname '_SeqList' '.txt']);
if isequal(0,FN), return; end % user cancelled
Fname = [FP FN];
try
   fid = fopen(Fname,'wt');
      fprintf(fid, 'Experiment %s\n', logname);
   for ii = 1:size(listText,1),
      fprintf(fid, '%s\n',listText(ii,:)');
   end
   fclose(fid);
catch
   errordlg(lasterr, 'Error (databrowse/localExportCurrentList)', 'modal');
end

function localEnlarge(hh,dW, dX)
% enlarge figure 
dbpos = get(hh.Root,'position'); set(hh.Root, 'pos', dbpos+[0 0 dW 0]);
fnames = fieldnames(hh);
N = length(fnames);
% enlarge seqlistbox 
dbpos = get(hh.SeqListBox,'position'); set(hh.SeqListBox, 'pos', dbpos+[0 0 dX 0]);
% move everything except menu stuff & root
imenu = find(strendswith(fnames,'Menu'));
imenuitem = find(strendswith(fnames,'MenuItem'));
iSeqListBox = find(strendswith(fnames,'SeqListBox'));
iroot = find(strendswith(fnames,'Root'));

imove = setdiff(1:N,[imenu imenuitem iroot iSeqListBox]);
hmove = struct2cell(hh);
hmove = [hmove{:}]; % cell - double
hmove = hmove(imove);
for ii=1:length(hmove),
   h = hmove(ii);
   dbpos = get(h,'position');
   if length(dbpos)==4,
      set(h, 'pos', dbpos + [dX 0 0 0]);
   end
end
