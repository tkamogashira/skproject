function initStimMenu(MenuName, DefFile, Wait);

if nargin<2, 
   DefFile = '';
end
if nargin<3,
   DoWait=1;
else
   DoWait = isequal('wait',lower(Wait)); 
end

% MenuName, DefFile

MenuName = upper(MenuName);
global StimMenuStatus;
StimMenuStatus = [];
StimMenuStatus.MenuName = MenuName;
StimMenuStatus.paramsOK = 0;
hf = openUImenu(MenuName, '', '', DefFile);
RetrieveSessionDefaults(MenuName, hf); % sessio-specific, across-menu defaults
evalifexist([MenuName 'Extra']);
DeclareMenuDefaults(MenuName,...
   'Root:position', ...
   '*Edit:String', ...
   '*Button:String',...
   '*Button:Userdata', ...
   '*VarMenuItem:Visible', ...
   '*VarMenuItem:Label');

StimMenuStatus.paramsOK = 0;

global SESSION
SESSION.CurrentStimMenu = MenuName;
UpdateStimMenuHeader; % menu header contains present session info
clear SMS2PRP; % clears persistent prevSMS -> always build SD the first time

% initialize global PRPstatus, which defines the status of
% D/A-related features
InitPRPstatus(MenuName);
% remove global accumulating data buffers before the current menu will generate another one
markbuffer del all; 
% update info in dark red and check current params
OK = StimMenuCheck(1); % clear previous XXcheck functions
if DoWait,
   % wait for menu to be deleted
   uiwait(hf.Root);
elseif isequal(Wait,'31'),
   % delete(messagehandle);
   if ~OK, error('Error while reading StimMenu parameters'); end;
   set(hf.Root, 'Visible', 'off');
else,
   if ~OK, error('Error while reading StimMenu parameters'); end;
   delete(hf.Root);
end
