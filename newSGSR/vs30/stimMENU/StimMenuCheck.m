function OK = StimMenuCheck(ClearCheckFunction, varargin);

% generic parameter checking for stimulus menus
% delegates to stim-specific functions
% ClearCheckFunction will clear the stim-specific
% check function XXcheck prior to calling it
% (this removes persistent variables resulting from
% previous calls to XXcheck).

if nargin<1, ClearCheckFunction=0; end;
global StimMenuStatus PRPstatus
hh = StimMenuStatus.handles;

if PRPstatus.Checking, 
   % recursive call due to warning, i.e., user has hit check/update ...
   % ... button in order to resume checking after a warning
   PRPresumeChecking;
   return;
end

PRPsetButtons('checking');

% the stimmenu-specific check function
MenuName = StimMenuStatus.MenuName;
% different versions use same check functions, e.g., NTD and NTD-BW
% so stript off the version name
ShortMenuName = strtok(MenuName,'-');
CheckFcnName = [ShortMenuName 'Check'];

% clear the check function if asked to do so
if ClearCheckFunction,
   clear(CheckFcnName);
end

PRPstatus.Checking = 1;

if isdeveloper, OK = feval(CheckFcnName, varargin{:});
else, % do the same thing, but now catch errors
   try
      OK = feval(CheckFcnName, varargin{:});
   catch
      mess = strvcat('Unexpected error during parameter check.',...
         'MatLab error message:',lasterr);
      errordlg(mess, 'Unexpected Error','modal');
   end
end   
if OK, 
   % menu-specific defaults
   UpdateMenuDefaultValues(MenuName); 
   % sessio-specific, across-menu default values
   storeSessionDefaults(MenuName);
end
PRPstatus.Checking = 0;
PRPsetButtons('waiting');
