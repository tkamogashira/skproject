function stat = NTPsync(flag);
% NTPsync - adjust windows clock using NTP net server
%     NTPsync synchronizes the Windows clock using one guy's
%     automachron software (see source code for location of executable). 
%     That program's settings can be viewed & changed by opening
%     WindowsStart| Programs | Automachron | Automachron 
%     Note: current settings make the program disappear after synchronzing
%     the clock. To disable this, start the program by holding down the
%     CRTL button while opening the program. Make sure to re-check the
%     "Close after sync" option as it is unchecke by CRTL-opening the program ...
%     Current settings: 
%          Hosts 134.58.255.1 (=KUleuven NTP server; the URL is ntp.kuleuven.be ...
%                                but it is notOn top used to avoid DNS hangups!!); 
%          Checked boxes: "Sync at Startup", "Close after sync", "On Top" and "Systray icon".
%
%     On normal operation, the Automachron window will briefly appear and disappear.
%     When the network is down, the program will hang; end it by clicking Exit.
%
%     NTPsync Disable disables NTPsync during this MatLab session.
%
%     NTPsync Enable (re-)enables NTPsync.
%
%     stat = NTPsync returns the enable status; 0 = disabled; 1 = enabled.


persistent Enabled;
if isempty(Enabled), Enabled=1; end

if nargin>0,
   switch lower(flag),
   case 'enable',
      Enabled = 1;
   case 'disable',
      Enabled = 0;
   otherwise,
      error(['Invalid flag ''' flag '''.']);
   end
   return;
end
%
stat = Enabled;
if ~Enabled, return; end

% if isempty(NetAccess),
%    checkNet = 1;
% elseif isequal(1, NetAccess),
%    checkNet = 1;
% end
% 
% if isequal('check', flag), checkNet=1;
%    checkNet = 1;
% elseif isempty(flag),
% else, error(['unkonown command option ''' flag '''.']);
% end
% 
% if checkNet,
%    NetAccess = netcheck;
% end
% 
% stat = NetAccess; % must copy; cannot use persistent variable as argout
% 
%NetAccess
% 
% if ~stat, return; end

if exist('c:\program files\one guy coding\automachron\achron.exe','file'),
   !"c:\program files\one guy coding\automachron\achron.exe"
   stat = 1;
else,
   error('achron.exe not installed or path unknown on this PC');
   stat = 0;
end





