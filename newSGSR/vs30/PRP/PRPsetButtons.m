function PRPsetButtons(Mode);

% sets standard collection of buttons&menus/handles of stimulus
% menu to enable/disable according to Mode
% disable all other edits & buttons while performing a play/record action

if ~stimmenuActive, return; end

prph = prpHandles;

% return;
global PRPstatus StimMenuStatus
MenuHandles = StimMenuHandles;
PlayButtonColor = [0.76 0.76 0.76]; % grey = default color of Play button
RecButtonColor = [0.76 0.76 0.76]; % grey = default color of PlayRec button

switch Mode,
case 'waiting' % idle mode
   DefaultEnable = 'on'; % menu params may be edited
   PlayRec = 1;
   Play = 1;
   Stop = 0;
   Close = 1;
   CheckUpdate = 1;
   Action = 'on'; StopMenu = 'off';
   Defaults = 'on';
   Search = 'on';
case 'checking' % checking params of stimMenu: don't disturb
   DefaultEnable = 'off'; % menu params may not be edited
   PlayRec = 0;
   Play = 0;
   Stop = 0;
   Close = 0;
   CheckUpdate = 0;
   Action = 'off'; StopMenu = 'off';
   Defaults = 'off';
   Search = 'off';
case 'warning' % warning occurred during checking params of stimMenu
   DefaultEnable = 'off'; % menu params may not be edited
   PlayRec = 0;
   Play = 0;
   Stop = 1;
   Close = 0;
   CheckUpdate = 1;
   Action = 'off'; StopMenu = 'on';
   Defaults = 'off';
   Search = 'off';
case {'generating', 'stopping'} % generating stimuli/ handling stop interrupt: don't disturb
   DefaultEnable = 'off'; % menu params may not be edited
   PlayRec = 0;
   Play = 0;
   Stop = 0;
   Close = 0;
   CheckUpdate = 0;
   Action = 'off'; StopMenu = 'off';
   Defaults = 'off';
   Search = 'off';
   if isequal('stopping', Mode),
      RecButtonColor = [1 0.5 0.5];
   end
case {'playing','playing/recording'} 
   % D/A with or without data collection: disable everything save stop button&menu
   DefaultEnable = 'off'; % menu params may not be edited
   PlayRec = 0;
   Play = 0;
   Stop = 1;
   Close = 0;
   CheckUpdate = 0;
   Action = 'off'; StopMenu = 'on';
   Defaults = 'off';
   Search = 'off';
   if isequal('playing/recording', Mode),
      RecButtonColor = [1 0 0];
   end
   if isequal('playing', Mode),
      PlayButtonColor = [0.6 1 0.6];
   end
otherwise,
   error(['unknown PRPbutton mode ' Mode]);
end % switch

% first enable/disable all buttons and edits
local_enableAll(prph, DefaultEnable);
% disp(['enable all: ' DefaultEnable]);
% find handles to PRP buttons
hPlay = prph.PlayButton;
hPlayRec = prph.PlayRecordButton;
hStop = prph.StopButton;
hClose = prph.CloseButton;
hCheck = prph.CheckUpdateButton;
% Action menu
hAction = prph.ActionMenu;
hStopMenu = prph.StopMenu;
hDefaultsMenu = prph.DefaultsMenu;
hSearchMenu = prph.SearchMenu;

LocalPRPenableButton(hPlayRec, PlayRec, RecButtonColor);
LocalPRPenableButton(hPlay, Play, PlayButtonColor);
LocalPRPenableButton(hStop, Stop);
LocalPRPenableButton(hClose, Close);
LocalPRPenableButton(hCheck, CheckUpdate);
LocalPRPenableMenu(hAction, Action);
LocalPRPenableMenu(hStopMenu, StopMenu);
LocalPRPenableMenu(hDefaultsMenu, Defaults);
LocalPRPenableMenu(hSearchMenu, Search);

% set flag
PRPstatus.action = Mode;
% make sure window is updated
drawnow;

% --local---
function LocalPRPenableButton(h, enable, bcolor);
% localPRPenableButton - enable/disable PRPmenu pushbuttons
global PRPstatus
textcolors;
eas = {'off', 'on'};
ena = eas{enable+1};
set(h, 'Enable', ena);
if nargin>2,
   set(h, 'backgroundcolor', bcolor);
end

function LocalPRPenableMenu(h, enable);
% localPRPenableMenu - enable/disable PRPmenu menus
% check what current enable state is
if ~ishandle(h), return; end;
CurrentState = get(h, 'enable');
if isequal(CurrentState, enable), return; end; % no change needed
set(h, 'enable', enable);
drawnow;

function local_enableAll(hh, enable);
FNS = fieldnames(hh);
for ii=1:length(FNS),
   h = getfield(hh, FNS{ii});
   if ishandle(h),
      TAG = get(h, 'tag'); if iscell(TAG), TAG = TAG{1}; end;
      TAG = lower(TAG);
      N = length(TAG);
      % check if tag belongs button or edit
      if isequal(TAG((N-5):N),'button') | isequal(TAG((N-3):N),'edit'),
         % check what current enable state is
         CurrentState = get(h, 'enable');
         % only change when needed
         if ~isequal(CurrentState, enable), 
            set(h,'enable',enable)
         end; % no change needed
      end
   end
end

