function SGSRmainCallback(TAG);

% generic callback function for  all SGSRmainMenu uicontrols

global SGSRmainMenuStatus;
hh = SGSRmainMenuStatus.handles;

if nargin<1,
   uih = gcbo;
   TAG = get(gcbo,'tag');
end

switch TAG
%----------------------QUIT or DATA ANALYSIS---------
case 'QuitButton', localQuitAndLaunch('',1);
   WakeUp; % resume control via MatLab commandline
case 'AnaDataButton', localQuitAndLaunch('databrowse', 0, 'init');
%------------------NEW SESSIO---------
case 'NewSessionButton',     localQuitAndLaunch('newSession');
case 'TestSessionMenuItem',  localQuitAndLaunch('testSession');
case 'LookAtDataMenuItem',   localQuitAndLaunch('LookAtDataSession');
% ------------MENU BAR-------------------   
%
% ------------------------------------------------------   
   %-------CALIBRATION MENU---------------
case 'PRLmenuItem',           localQuitAndLaunch('PRL');
case 'MicDefMenuItem',        localQuitAndLaunch('MicDef');
case 'ViewERCmenuItem',       localQuitAndLaunch('CDplot',0,'ERC');   
case 'ViewPRLmenuItem',       localQuitAndLaunch('CDplot',0,'*');
case 'ShowCalPlotsMenuItem',  localQuitAndLaunch('CDplot',0,'noInputArgs');
case 'CalibParamMenuItem',    localQuitAndLaunch('CalibParam');
   %-------SYSTEM MENU------ ---------
case 'WiringMenuItem',        localQuitAndLaunch('Wiring');
case 'LocalSysParamMenuItem', localQuitAndLaunch('LocalSysParam');
case 'SetDirsMenuItem',       localQuitAndLaunch('viewdirectories');
% -------------S T I M U L U S    M E N U S---------------   
otherwise, % try to launch stimulus menu
   if ~localLaunchStimMenu(TAG),
      eh = errordlg(['unknown callback object ' TAG],...
         'SGSR Main Menu Error','modal');
      uiwait(eh);
   end;
end % switch TAG

%-------locals-------------
function varargout = localQuitAndLaunch(MenuName, noReturn, varargin);
% save SGSRmain defaults, close SGSRmain Menu, launch new Menu & restart SGSRmain
if nargin<2, noReturn=0; end;
if nargin<3, varargin = {'init'}; end;
if isequal(varargin{1},'noInputArgs'), varargin = {}; end
global SGSRmainMenuStatus;
hh = SGSRmainMenuStatus.handles;
SaveMenuDefaults('SGSRmain');
delete(hh.Root); % this will resume initSGSRmainMenu
OldLaunch = ['init' MenuName 'Menu'];
if isempty(MenuName), % tell user how to return to SGSR
   disp(blanks(3)');
   disp(' ----type ''SGSR'' to return to SGSR----');
   disp(blanks(3)');
elseif exist(OldLaunch,'file'),
   if nargout==0, feval(OldLaunch);
   else, varargout{1} = feval(OldLaunch); end;
elseif exist([MenuName],'file'),
   if nargout==0, feval(MenuName, varargin{:});
   else, varargout{1} = feval(MenuName, varargin{:});
   end
else,
   eh = errordlg(['Invalid MenuName ''' MenuName '''']);
   uiwait(eh);
   return;
end
if ~noReturn, 
   InitSGSRmainMenu;
end
%----------------------------
function OK = localLaunchStimMenu(TAG);
OK = 0;
MenuName = local_StimButtonTag(TAG);
if isempty(MenuName), 
   MenuName = local_StimMenuTag(TAG);
end;
if isempty(MenuName), return; end;
global SGSRmainMenuStatus;
hh = SGSRmainMenuStatus.handles;
SaveMenuDefaults('SGSRmain');
delete(hh.Root); 
initStimMenu(MenuName);
InitSGSRmainMenu;
OK = 1;
%----------------------------

function MenuName = local_StimButtonTag(TAG);
% checks if tag belongs to stimulus menu button; 
% if so returns name of stim menu; if not returns empty string
% all of these buttons have standard name of the form Stim*button
MenuName = ''; % default: not found
N = length(TAG);
% TAG must end with 'button'
if ~isequal(findstr('button', TAG),N-5), return; end;
% TAG must start with 'Stim'
if ~isequal(findstr('Stim', TAG),1), return; end;
% if we survived this, return what's between the 'Stim' and the 'button'
MenuName = TAG(5:N-6);
% lowercase 'x' must be replaced by '-' as in NSPLxBW -> NSPL-BW
MenuName(find(MenuName=='x')) = '-';
%----------------------------

function MenuName = local_StimMenuTag(TAG);
% checks if tag belongs to stimulus menu menu item; 
% if so returns name of stim menu; if not returns empty string
% all of these buttons have standard name of the form Stim*button
MenuName = ''; % default: not found
N = length(TAG);
% TAG must end with 'menuItem'
if ~isequal(findstr('menuItem', TAG),N-7), return; end;
% TAG must start with 'Stim'
if ~isequal(findstr('Stim', TAG),1), return; end;
% if we survived this, return what's between the 'Stim' and the 'button'
MenuName = TAG(5:N-8);
% lowercase 'x' must be replaced by '-' as in NSPLxBW -> NSPL-BW
MenuName(find(MenuName=='x')) = '-';

