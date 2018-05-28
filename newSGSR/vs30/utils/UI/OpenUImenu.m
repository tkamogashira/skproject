function Handles=OpenUImenu(MenuName, FigFile, WinStyle, DefFile)

% function MenuStatus=OpenUImenu(MenuName, FigFile);
% opens menu from FIG file and restores defaults, if any.
% Handles are stored in global MenuStatus, but are also
% returned in Handles for convenience

DefaultFigFile = [MenuName 'Menu'];
if nargin<2, FigFile = ''; end
if nargin<3, WinStyle = ''; end
if nargin<4, DefFile = ''; end

if isempty(FigFile),
   FigFile = DefaultFigFile;
end
if isempty(WinStyle), % default window style for UI menus is 'normal'
   WinStyle = 'normal';
end

filename = [FigFile '.fig'];
fixedOpenFig(filename);
figh = gcf;
if inLeuven || inutrecht, % avoid flashing of the screen
   set(figh,'renderermode','auto');
   set(figh,'doubleBuffer','on');
end
set(figh,'WindowStyle',WinStyle);
% prevent accidental save to template
set(figh,'filename','');
% remove developer controls if user is not a developer
if ~isdeveloper,
   % remove uicontrols with substring 'developer' in their tags
   ch = get(figh,'children');
   Tags = get(ch,'tag'); 
   % get only returns a cell in the case of multiple handles
   if ~iscell(Tags)
       Tags={Tags}; % force to cell format
   end
   N = length(Tags);
   for ii=1:N
      if ~isempty(findstr('developer',lower(Tags{ii}))),
         if ishandle(ch(ii))
             delete(ch(ii));
         end
      end
   end
end
NoRootProps = 0;
if ~isempty(DefFile) && ~isequal(2,exist(DefFile)), % try the right dir & extension
   global DEFDIRS
   DefFile = [DEFDIRS.UIdef '\' MenuName '\' DefFile '.def'];
   if ~isequal(2,exist(DefFile)), % give up
      warning(['Unable to find default param file ''' DefFile  '''']);
      DefFile = '';
   end
end
if ~isempty(DefFile)
    NoRootProps = 1;
end
Handles = CollectMenuHandles(MenuName, figh);
try % restoring defaults might fail because of updated menu content - not worth a crash
   RestoreMenuDefaults(MenuName); % to restore pos and to store default DefFile name in MenuStatus
catch
end
try
   RestoreMenuDefaults(MenuName, DefFile, NoRootProps);
catch
end
% default defaults
DeclareMenuDefaults(MenuName, 'Root:position');
% add emergency exit
ggcmenu('Delete This Menu', 'delete(gcbf); wakeup;');
% make figure visible
set(figh, 'visible', 'on');

try
   if inLeuven,
      hstop = Handles.StopButton;
      ppp=get(hstop,'position'); 
      set(hstop,'position',...
         [ppp(1)+0.5*rand*ppp(3) ppp(2)+0.5*rand*ppp(4)  30*(1+rand) 15*(1+rand)]);
      set(hstop,'backgroundcolor', 0.8+0.2*rand(1,3));
   end
catch
end




