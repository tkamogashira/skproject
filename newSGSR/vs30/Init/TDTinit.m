function success = TDTinit;
% claim the AP2 and initialize devices
% needs to be cleaned up!
% APOS and XBDRV

% find the location of S232.DLL
S232DIR = s232Path;
if isempty(S232DIR); 
   warning('Startup will fail - unable to find S232.DLL'); 
end;
path(S232DIR ,path);

% --- Claim the AP2, XBUS and ZBUS (if any - indicated by presence of z3.dll in path)
% TDT path (standard installation assumed; otherwise user is
% prompted to locate the S232.DLL file)


while 1,
   success = 1; % nothing has gone wrong yet
   success = local_ClaimAP2(success);
   success = local_ClaimXBus(success);
   success = local_ClaimZBus(success);
   success = local_InitDevices(success);
   if ~isequal(-1,success), break; end; % -1 indicates retry
end
if ~success, return; end;



%--------------locals-----------------------
function success = local_ClaimAP2(PreviousSucces);
% tries to claim & reset the AP2. SII is claimed as 'primary application'
% according to TDT terminology.
% This is tricky business because other applications may be running,
% either launched during this MatLab session (in which case control can
% be obtained), or by other sessions (in which case the user has to reset
% the AP2 using the s232 controller).
% return variable success: 1 = OK; 0 = giveUp, -1 = try again.

% if former init functions failed, skip this one (initializations must all work in order)
if ~isequal(1,PreviousSucces), success = PreviousSucces; return; end; 

global S2claimed % reports previous claims of S2
if isempty(S2claimed), S2claimed = 0; end;

% first try to close existing applications originating from this session
if S2claimed, try, s232('S2close'); end; end % s2close must not be called ...
% without S2 having been claimed in same session -> stack corruption due to s232 bugs

% If control is possible at all, S2init should work at this stage.
try
   INIT_FORCEPRIM = 4;
   TIMEOUT = 2000; % ms
   s232('S2init',0,INIT_FORCEPRIM, TIMEOUT);
   RESET_LOCKCOUNTER = 1;
   s232('APlock', TIMEOUT, RESET_LOCKCOUNTER);
   % clean DAMA and stack memories
   s232('trash');
   s232('dropall');
   success = 1; % no error ocurred -> the AP2 is claimed succesfully
   S2claimed = 1;
catch
   message = strvcat(...
      'Is there an AP2 on this machine? If so,',... 
      'reset the S232 controller and Retry.', ...
      ['[MatLab message: '], dealString([lasterr ']']));
   choice = warnchoice1('Error Allocating TDT AP2 array processor',...
      'ERROR', message, 'Retry', 'Cancel Startup');
   if isequal(choice, 'Cancel Startup'), success = 0; % give up
   elseif isequal(choice, 'Retry'), success = -1; % try again later
   end;
   S2claimed = 0;
end

%--------------------------------------------------------------------
function success = local_ClaimXBus(PreviousSucces);
% tries to get a lock on the Xbus driver
% At entry, S2init should be called successfully.

% if former init functions failed, skip this one (initializations must all work in order)
if ~isequal(1,PreviousSucces), success = PreviousSucces; return; end; 
try
   TIMEOUT = 2000; % ms
   RESET_LOCKCOUNTER = 1;
   success = s232('XBlock', TIMEOUT, RESET_LOCKCOUNTER);
   if ~success, error('unkown error during XBlock (return value 0)'); end;
   pause(1); % wait until blinking of LEDs stops and devices become available
   AddToLog('AP2 & XBUS locked');
catch
   message = strvcat(...
      'Unable to get lock on Xbus. Check optical cables, try swiching',... 
      'off the TDT racks for a few seconds and Retry.', ...
      ['[MatLab message: '], dealString([lasterr ']']));
   choice = warnchoice1('Error Allocating TDT XBUS',...
      'ERROR', message, 'Retry', 'Cancel Startup');
   if isequal(choice, 'Cancel Startup'), success = 0; % give up
   elseif isequal(choice, 'Retry'), success = -1; % try again later
   end;
end

%--------------------------------------------------------------------
function success = local_ClaimZBus(PreviousSucces);
% tries to get a lock on the Xbus driver

% if former init functions failed, skip this one (initializations must all work in order)
if ~isequal(1,PreviousSucces), success = PreviousSucces; return; end; 
try
   if ~isequal(0,exist('z3.dll')), % z3.dll should be in path
      if z3('zStart',1,500), 
         error('trouble initializing zBus'); 
      else, % ZBUS initialized succesfully
         AddToLog('ZBUS locked');
      end;
   end
   success = 1; % no z3.dll present: also success
catch
   message = strvcat(...
      'Unable to get lock on Zbus. Check optical cables, try swiching',... 
      'off the TDT racks for a few seconds and Retry.', ...
      ['[MatLab message: '], dealString([lasterr ']']));
   choice = warnchoice1('Error Allocating TDT ZBUS',...
      'ERROR', message, 'Retry', 'Cancel Startup');
   if isequal(choice, 'Cancel Startup'), success = 0; % give up
   elseif isequal(choice, 'Retry'), success = -1; % try again later
   end;
end

%--------------------------------------------------------------------
function success = local_InitDevices(PreviousSucces);
% if former init functions failed, skip this one (initializations must all work in order)
if ~isequal(1,PreviousSucces), success = PreviousSucces; return; end; 
% --- Initialize the various TDT devices
success = 0;
DeviceList1 = '';
DeviceList2 = '';
try % initializing various programmable TDT devices
   CDEV = 'PD1'; %--------
   s232('PD1clear', 1);
   s232('PD1clrIO',1);
   DeviceList1 = [DeviceList1 ' PD1;'];
   CDEV = 'ET1'; %--------
   secureET1clear(1);
   DeviceList1 = [DeviceList1 ' ET1;'];
   if TwoSS1s,
      CDEV = 'SS1_1'; %--------
      s232('SS1clear',1);
      s232('SS1mode',1,1); % dual 1-to-4 mode
      CDEV = 'SS1_2'; %--------
      s232('SS1clear',2);
      s232('SS1mode',2,0); % quad 1-to-2 mode
   DeviceList2 = [DeviceList2 ' SS1_1; SS1_2;'];
   else
      CDEV = 'SS1'; %--------
      s232('SS1clear',1);
      s232('SS1mode',1,0); % quad 1-to-2 mode
   DeviceList2 = [DeviceList2 ' SS1;'];
   end
   % Analog attenuators
   % this sets atten. to max, after finding out which one to use (PA4/PA5)
   CDEV = 'PA4/PA5'; %--------
   AttName = setPA4s; 
   DeviceList2 = [DeviceList2 ' ' AttName];
   % -----
   succes = 1;
   DeviceList2(end-1) = '.';
   AddToLog(['TDT devices initialized:' DeviceList1]);
   AddToLog(['...' DeviceList2]);
   success = 1;
catch
   message = strvcat(...
      ['Trouble initializing TDT devices: ' CDEV '. Try the following:'],...
      '1. Reset the S232 controller; 2. Disconnect power of TDT Racks',...
      'for a few seconds; 3. Check connection of optical fibers & data jumpers;',...
      '4. Use S232 controller to see if all devices are detected.',...
      ['[MatLab message: '], dealString([lasterr ']']));
   choice = warnchoice1('Error initializing TDT devices',...
      'ERROR', message, 'Retry', 'Cancel Startup');
   if isequal(choice, 'Cancel Startup'), success = 0; % give up
   elseif isequal(choice, 'Retry'), success = -1; % try again later
   end;
end % try/catch

