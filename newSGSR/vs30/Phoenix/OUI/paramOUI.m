function [OUIinfo, mess] = paramOUI(S, figpos);
% paramOUI - create GIU for parameter retrieval
%   ParamOUI(S), where S is a paramset object, creates a OUI 
%   for retrieval of parameters and returns a struct containing all 
%   there is to know about the OUI. S may be a paramset vector,
%   in which case the elements of S realized one by one.
%
%   ParamOUI(S, [X, Y]) open the OUI at specified X and Y position
%   on the screen. X and Y are in points. If [X,Y] is not specified, 
%   the OUI is opened at the default figure position.
%
%   [h, mess] = ParamOUI, without any input arguments, returns the graphics 
%   handle of the OUI most recently opened by paramOUI - if it is still open. 
%   If no OUI is open, [] is returned and mess contains the 
%   message 'No active OUI found.' Otherwise, mess is empty.
%
%   ParamOUI(figh), where figh is the figure handle of an existing
%   OUI, makes that OUI the active OUI (puts it on top of the stack).
%
%   ParamOUI('disp') displays an overview of the parameter queries 
%   and other items contained in the OUI.
%
%   See also OUIdata, Paramset/InitOUIgroup, Paramset/AddQuery, Paramset/DefineReporter.

% disp(['paramOUI ' num2str(nargin)])
mess = '';
% display existing OUI or create one?
if nargin==0, displayOUI = 1;
elseif nargin==1, 
   displayOUI = isequal('disp',S);
   if isnumeric(S), % make OUI with figure handle S the active one
      [OUIinfo, mess] = localLastOUIhandle(S, 'check'); 
      error(mess);
      return;
   end
else, displayOUI = 0;
end

if displayOUI, % return OUIinfo of most recently opened OUI, if any
   [OUIinfo, mess] = localLastOUIhandle;
   if nargin==1, % display list
      OUIinfo = OUIdata;
      dp = '';
      for ii=1:length(OUIinfo.ParamData),
         dp = strvcat(dp, ['====' OUIinfo.ParamData(ii).Name '====' ]);
         dp = strvcat(dp, OUIinfo.ParamData(ii).qlist);
         dp = strvcat(dp, OUIinfo.ParamData(ii).ouilist);
      end
      if nargout<1, 
         disp(dp);
         clear OUIinfo
      else, OUIinfo = dp;
      end
   end
   return
end

%------------create new OUI from here--------------------

figh = figure('visible', 'off', 'integerhandle','off'); 
if nargin<2, 
   figpos = OUIpos(S); % from defaults file
   figpos = figpos(1:2);
end

% figure size is dictated by fattest S dimensions
FigSize = [0 0]; FigName = '';
for ii=1:numel(S),
   Sii = S(ii); % circumvent problems with overloaded subsref
   FigSize = max(FigSize, Sii.OUI.minFigSize);
end
% figpos, FigSize
% set figure position and size and default properties of OUIs. Clear figure.
set(figh, 'name', [S(1).Name ' - ' S(1).description], ...
   'visible', 'off', ...
   'units', 'points', ...
   'pos', [figpos FigSize], ...
   'CloseRequestFcn', 'paramOUIcallback close;', ...
   'KeyPressFcn', 'paramOUIcallback keypress;', ...
   'MenuBar', 'none', ...
   'numbertitle', 'off'); 
set(figh, 'resize', 'off');
clf(figh);

% handles of figure itself and all uicontrols are stored in struct tree 'handles'
handles = struct('Root', figh, 'groups', [], 'items', []);

%-------------------------------------------------------
% -----insert any generic figure properties here--------
%-------------------------------------------------------

% prepend tabbing button to correct MatLab's tabbing misbehavior in the presence of frames, etc
uicontrol('tag', 'StartTabbingButton', 'position', [-10 0 0.1 0.1]);

% add parameter sets one by one
InitCmd = {}; % will contain initialization commands to be executed after all OUI are created
for ii=1:numel(S),
   [handles, InitCmd] = localAddParamSet(handles, FigSize, S(ii), InitCmd);
end

% append tabbing button to correct MatLab's tabbing misbehavior in the presence of frames, etc
uicontrol('tag', 'EndTabbingButton', 'position', [-10 0 0.1 0.1]);

% Store handle of current OUI in stack (see localLastOUIhandle)
localLastOUIhandle(figh);
% localLastOUIhandle

% collect all relevant info in struct and store it 
% .. in a hidden uicontrol of the OUI itself ...
OUIinfo = struct('ParamData', S, 'handles', handles);
OUIdata(OUIinfo);

% run initialization stored in S
for ii = 1:length(InitCmd),
   cmd = InitCmd{ii};
   feval(cmd{:});
end


% show figure
RepositionFig(figh); % make sure menubar of figure is visible on screen
set(figh, 'visible', 'on'); 
figure(figh);

% now that te whole thing is ready, refill the OUI items to see if there ...
% ... are any errors like mismatching toggle values, etc.
OUIfill(S);

%-------locals-----------------------------
function [handles, InitCmd] = localAddParamSet(handles, FigSize, S, InitCmd);
% draw Oui elements of single paramset S.
figh = handles.Root; % figure handle
% ----groups: each group has its own frame, draw these first
for ii=1:length(S.OUI.group),
   g = S.OUI.group(ii);
   [gname, h] = localDrawframe(g, figh, FigSize);
   error(localNameExistComplaint(handles, 'Group', gname)); % name must be unique across paramsets
   handles = setfield(handles, 'groups', gname, h);
end
% ----items: visit all items, look what their class is and call the right function to realize them
NI = length(S.OUI.item);
Nquery = 0; % need to count them (see warning after for loop)
for ii=1:NI,
   it = S.OUI.item(ii);
   G = S.OUI.group(it.igroup);
   pos = localRepos2Abspos(it.spec.uipos, G.Pos, FigSize); % position of uicontrol is expressed re left-upper corner of frame
   switch it.class,
   case 'query',
      newq = query(S.Stimparam(it.spec.iparam), it.spec.spec{:});
      h = qdraw(newq, figh, pos);
      Nquery = Nquery + 1;
   case 'reporter',
      h = localDrawreporter(it, figh, pos, G); % need group for "margin-1e6" specifications of x-width
   case 'actionbutton',
      h = localDrawaction(it, figh, pos); 
   case 'menu',
      h = localDrawmenu(it, figh); 
   case 'menuitem',
      h = localDrawmenuitem(it, figh); 
   otherwise,
      error(['Do not know how to create OUIitem of class ''' it.class '''.']);
   end % switch/case
   error(localNameExistComplaint(handles, 'item', it.name)); % name must be unique across paramsets
   handles = setfield(handles, 'items', it.name, h);
end

if Nquery<length(S.Stimparam),
   warning(['Not all parameters in paramset ''' S.name ''' have queries associated with them.' ]);
end
% init commands: append to commands from previous paramsets. Do not execute yet.
InitCmd = [InitCmd S.OUI.init];

function    [gname, h] = localDrawframe(g, figh, figSize);
figcolor = get(figh, 'color');
framepos = g.Pos; 
if framepos(3)<-1e5, % M-1e6 means M points from right figure border
   RightMargin = 1e6+framepos(3);
   framepos(3) = figSize(1) - RightMargin - framepos(1);
end
framepos(2) = figSize(2) - framepos(2) - framepos(4); % measure Y-position from top of figure&frame
frame = uicontrol(figh, ...
   'tag', [g.Name 'Frame'], ...
   'style', 'frame', ...
   'Units', 'points', ...
   'visible', 'on', ...
   'position', framepos, ...
   'HorizontalAlignment', 'center', ...
   'backgroundcolor', figcolor, ...
   'foregroundcolor', [0 0 0]);
title = uicontrol(figh, ...
   'tag', [g.Name 'FrameTitle'], ...
   'style', 'text', ...
   'visible', 'off', ...
   'Units', 'points', ...
   'FontWeight', 'bold', ...
   'String', g.Title, ...
   'HorizontalAlignment', 'center', ...
   'backgroundcolor', figcolor, ...
   'foregroundcolor', [0 0 0]);
oldpos =  get(title, 'position'); 
extent =  get(title, 'extent'); % boldfaced text doesn't get the space it needs from MatLab ...
oldpos(3) = extent(3); % ... use the extent property to fix that.
% keep height of title, but set position and width
titlePos = framepos(1:2)+ framepos(4)*[0 1] + g.TitlePos; % titlePos is re left-upper corner of frame
set(title, 'position', [titlePos oldpos(3:4)]);
% visibilities depend on title
if isempty(g.Title), set(title, 'visible', 'off'); % don't show if nothing to show
elseif isequal('invisible', g.Title), % special case: invisible frame
   set([frame title], 'visible', 'off');
else, set(title, 'visible', 'on');
end 
h = collectInStruct(frame, title);
gname = g.Name;

function  h = localDrawreporter(item, figh, uipos, G);
figcolor = get(figh, 'color');
r = item.spec;
if isnumeric(r.Ustring),
   extent = [0 0 r.Ustring];
   if extent(3)<-1e5, % DX = M-1e6 means: M points from right margin of group frame
      Margin = extent(3)+1e6;
      % must find *true* position of group frame - frame pos can also have negative fake values
      hg = findobj(figh, 'tag', [G.Name 'Frame']);
      framepos = get(hg, 'position');
      extent(3) = framepos(3)+framepos(1)-uipos(1)-Margin;
   end
   fitString = '';
else, % string that must fit
   fitString = char(r.Ustring); height = size(fitString,1);
   fitString =[fitString repmat('X', [height 1])];
   extent = [];
end
text = uicontrol(figh, ...
   'tag', [item.name 'Text'], ...
   'style', 'text', ...
   'visible', 'off', ...
   'Units', 'points', ...
   'Tooltip', r.tooltip, ...
   'HorizontalAlignment', 'left', ...
   'backgroundcolor', figcolor, ...
   'foregroundcolor', [0 0 0], ...
   'string', fitString);
if isempty(extent), extent = get(text, 'extent'); end;
set(text, 'position', [uipos-[0 1].*extent(4)+[0 25], extent(3:4)], 'string', '---', 'visible', 'on');
% set(text, 'position', [uipos-[0 1].*extent(4)+[0 25], extent(3:4)], 'visible', 'on');
set(text, r.props);
h = collectInStruct(text);

function h = localDrawaction(item, figh, pos); 
a = item.spec;
figcolor = get(figh, 'color');
button = uicontrol(figh, ...
   'tag', [item.name 'Button'], ...
   'style', a.style, ...
   'visible', 'on', ...
   'Units', 'points', ...
   'position', pos, ...
   'Tooltip', a.tooltip, ...
   'HorizontalAlignment', 'center', ...
   'backgroundcolor', figcolor, ...
   'foregroundcolor', [0 0 0], ...
   'tooltip', a.tooltip, ...
   'callback', [a.callback ';'], ...
   'fontweight', 'bold', ...
   'string', a.string);
h = collectInStruct(button);

function h = localDrawmenu(item, figh); 
m = item.spec;
menu = uimenu(figh, ...
   'tag', [item.name 'Menu'], ...
   'visible', 'on', ...
   'foregroundcolor', [0 0 0], ...
   'callback', [m.callback ';'], ...
   'label', m.label);
h = collectInStruct(menu);
if ~isempty(m.props), set(menu, m.props); end

function h = localDrawmenuitem(item, figh); 
m = item.spec;
sepaMode = 'off';
if m.label(1)=='_', % means separator on
   sepaMode = 'on';
   m.label = m.label(2:end);
end
% try to find handle of parent
hParent = findobj(figh, 'tag', [m.parent 'Menu']);
if isempty(hParent),
   hParent = findobj(figh, 'tag', [m.parent 'MenuItem']);
end
if isempty(hParent),
   error(['Cannot find parent menu named ''' m.parent '''.']);
end
menu = uimenu(hParent, ...
   'tag', [item.name 'MenuItem'], ...
   'visible', 'on', ...
   'foregroundcolor', [0 0 0], ...
   'callback', [m.callback ';'], ...
   'separator', sepaMode, ...
   'accelerator', m.acc, ...
   'label', m.label);
h = collectInStruct(menu);
if ~isempty(m.props), set(menu, m.props); end

%=======AUX==========================================

function mess = localNameExistComplaint(handles, category, name, plural);
% error message for non-unique names of queries, etc, across paramsets
if nargin<4, plural = lower([category 's']); end % Reporter -> reporters, etc. Query is exception
hh = getfield(handles, plural);
if isfield(hh, name), % names must be unique or OUIhandle will fail
   mess = [category ' name ''' name ''' occurs in two different paramsets of OUI.'];
else, mess = '';
end

function pos = localRepos2Abspos(repos, framepos, figSiz);
if isnan(repos), pos=nan; return; end
if length(repos)==4, SZ = repos(3:4); repos = repos(1:2); else, SZ = []; end
framepos(2) = figSiz(2) - framepos(2);  % frame pos re upper fig edge
% measure Y-position from top of frame, move -25 downward for reasonable 0=upper convention
pos = [1 -1].*repos + framepos(1:2) + [0 -25]; 
pos = [pos SZ];

function [h, mess] = localLastOUIhandle(h, Flag);
% get or set last OUIhandle on stack
if nargin<2, Flag = ''; end
mess = ''; 
persistent LastOUIhandle
% purge stacked handles
[dum, LastOUIhandle] = areHandles(LastOUIhandle);
if nargin==0, % get most recent handle
   h = LastOUIhandle; 
   if isempty(h), mess = 'No active OUI found.';
   else, h = h(end); 
   end % top of stack
else, % add input argument h to stack
   genmess = 'Numeric first argument to paramOUI must be figure handle of OUI.';
   if ~isOneHandle(h), mess = genmess; return;
   elseif ~isequal('figure', get(h,'type')),
      mess = genmess; return;
   end
   if isequal('check', Flag), % check if h is a OUI figure handle
      udh = findobj(h, 'tag', 'OUIinfo');
      if isempty(udh) | isequal(0,h), 
         mess = 'Non-OUI figure handle referenced.'; 
         return;
      end
   end
   % if h is already in the handle stack, just move it to the top of he stack
   if isempty(LastOUIhandle), ipres = []; else, ipres = find(LastOUIhandle==h); end;
   if isempty(ipres), LastOUIhandle = [LastOUIhandle h]; % new -> add on top
   else, LastOUIhandle = LastOUIhandle([1:ipres-1 ipres+1:end ipres]);
   end
end












